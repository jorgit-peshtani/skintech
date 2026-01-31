"""
Custom API views for web frontend
"""
from rest_framework import viewsets, filters
from rest_framework.permissions import AllowAny
from oscar.core.loading import get_model
Product = get_model('catalogue', 'Product')
from .serializers import WebProductSerializer


class WebProductViewSet(viewsets.ReadOnlyModelViewSet):
    """
    Web-friendly product API with full details
    GET /api/web/products/ - List all products
    GET /api/web/products/{id}/ - Get single product
    """
    queryset = Product.objects.all()
    serializer_class = WebProductSerializer
    permission_classes = [AllowAny]
    filter_backends = [filters.SearchFilter]
    search_fields = ['title', 'description']
    
    def get_queryset(self):
        """Filter products by category if provided"""
        queryset = super().get_queryset()
        category = self.request.query_params.get('category', None)
        
        if category and category != 'All':
            queryset = queryset.filter(categories__name=category)
        
        return queryset
