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
