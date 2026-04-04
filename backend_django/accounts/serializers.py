"""
Custom API serializers for web frontend
"""
from rest_framework import serializers
from oscar.core.loading import get_model
Product = get_model('catalogue', 'Product')


class WebProductSerializer(serializers.ModelSerializer):
    """Full product serializer for web frontend"""
    
    # Computed fields
    price = serializers.SerializerMethodField()
    stock = serializers.SerializerMethodField()
    category = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()
    brand = serializers.SerializerMethodField()
    
    class Meta:
        model = Product
        fields = ['id', 'title', 'description', 'price', 'stock', 'category', 'image', 'brand']
    
    def get_price(self, obj):
        """Get price from stockrecord"""
        stockrecord = obj.stockrecords.first()
        if stockrecord:
            return str(stockrecord.price)
        return "0.00"
    
    def get_stock(self, obj):
        """Get stock quantity from stockrecord"""
        stockrecord = obj.stockrecords.first()
        if stockrecord:
            return stockrecord.num_in_stock
        return 0
    
    def get_category(self, obj):
        """Get primary category name"""
        category = obj.categories.first()
        if category:
            return category.name
        return "Uncategorized"
    
    def get_image(self, obj):
        """Get primary image URL"""
        try:
            primary_image = obj.primary_image()
            if primary_image:
                return self.context['request'].build_absolute_uri(primary_image.original.url)
        except:
            pass
        return None
    
    def get_brand(self, obj):
        """Get brand from database"""
        return obj.brand or "SkinTech"


class OrderLineSerializer(serializers.Serializer):
    """Serializer for order items in create request"""
    product_id = serializers.IntegerField()
    quantity = serializers.IntegerField()
    price = serializers.DecimalField(max_digits=12, decimal_places=2)


class CreateOrderSerializer(serializers.Serializer):
    """Serializer for creating an order"""
    items = OrderLineSerializer(many=True)
    total = serializers.DecimalField(max_digits=12, decimal_places=2)
    
    # Shipping info
    full_name = serializers.CharField(max_length=255)
    email = serializers.EmailField()
    phone = serializers.CharField(max_length=50)
    address = serializers.CharField(max_length=500)
    city = serializers.CharField(max_length=100)
    zip_code = serializers.CharField(max_length=20)
    country = serializers.CharField(max_length=100, default='Albania')
    payment_method = serializers.CharField(max_length=50, required=False, default='card')


class WebOrderSerializer(serializers.ModelSerializer):
    """Serializer for listing user orders"""
    status = serializers.SerializerMethodField()
    total = serializers.SerializerMethodField()
    number = serializers.CharField(required=False, allow_null=True)
    date = serializers.SerializerMethodField()
    items = serializers.SerializerMethodField()
    
    class Meta:
        model = get_model('order', 'Order')
        fields = ['id', 'number', 'status', 'total', 'date', 'items']
    
    def get_status(self, obj):
        return getattr(obj, 'status', 'Pending') or 'Pending'
        
    def get_total(self, obj):
        total = getattr(obj, 'total_incl_tax', 0)
        return str(total) if total is not None else "0.00"
        
    def get_date(self, obj):
        date = getattr(obj, 'date_placed', None)
        if date:
            return date.isoformat()
        return None
        
    def get_items(self, obj):
        try:
            lines = obj.lines.all()
            result = []
            for line in lines:
                image_url = None
                try:
                    if line.product:
                        primary = line.product.primary_image()
                        if primary and primary.original:
                            request = self.context.get('request')
                            if request:
                                image_url = request.build_absolute_uri(primary.original.url)
                            else:
                                image_url = primary.original.url
                except Exception:
                    pass
                
                # Safe price calculation
                price = "0.00"
                if line.quantity and line.line_price_incl_tax is not None:
                    price = str(round(line.line_price_incl_tax / line.quantity, 2))
                elif line.unit_price_incl_tax is not None:
                    price = str(line.unit_price_incl_tax)
                
                result.append({
                    'title': line.title or "Product",
                    'quantity': line.quantity or 1,
                    'price': price,
                    'image': image_url or '/api/placeholder/150/150'
                })
            return result
        except Exception as e:
            print(f">>> ERROR in WebOrderSerializer.get_items: {str(e)}")
            return []
