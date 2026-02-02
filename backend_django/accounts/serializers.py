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


class WebOrderSerializer(serializers.ModelSerializer):
    """Serializer for listing user orders"""
    status = serializers.CharField(source='status')
    total = serializers.DecimalField(source='total_incl_tax', max_digits=12, decimal_places=2)
    number = serializers.CharField()
    date = serializers.DateTimeField(source='date_placed')
    
    class Meta:
        model = get_model('order', 'Order')
        fields = ['id', 'number', 'status', 'total', 'date']

