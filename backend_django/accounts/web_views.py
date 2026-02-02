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


class WebOrderViewSet(viewsets.ModelViewSet):
    """
    API for Key Checkout & Order History
    """
    permission_classes = [AllowAny] # Ideally IsAuthenticated, but AllowAny for prototype testing if needed
    
    def get_queryset(self):
        Order = get_model('order', 'Order')
        if self.request.user.is_authenticated:
            return Order.objects.filter(user=self.request.user).order_by('-date_placed')
        return Order.objects.none()
    
    def get_serializer_class(self):
        from .serializers import WebOrderSerializer, CreateOrderSerializer
        if self.action == 'create':
            return CreateOrderSerializer
        return WebOrderSerializer

    def create(self, request, *args, **kwargs):
        """
        Create a simple order directly from POST data (Prototype)
        """
        from .serializers import CreateOrderSerializer
        from rest_framework.response import Response
        from rest_framework import status
        import uuid
        from decimal import Decimal
        from django.utils import timezone
        
        serializer = CreateOrderSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data
        
        # Models
        Order = get_model('order', 'Order')
        Line = get_model('order', 'Line')
        Product = get_model('catalogue', 'Product')
        
        # 1. Create Order
        order_number = f"ORD-{uuid.uuid4().hex[:8].upper()}"
        
        user = request.user if request.user.is_authenticated else None
        
        order = Order.objects.create(
            number=order_number,
            user=user,
            total_incl_tax=data['total'],
            total_excl_tax=data['total'] / Decimal('1.2'), # Approx tax
            currency='EUR',
            status='Pending',
            date_placed=timezone.now(),
            shipping_incl_tax=Decimal('0.00'),
            shipping_excl_tax=Decimal('0.00'),
            # Guest info if needed, but we rely on simple fields for now
        )
        
        # 2. Create Lines
        for item in data['items']:
            try:
                product = Product.objects.get(id=item['product_id'])
                Line.objects.create(
                    order=order,
                    product=product,
                    partner_sku=f"SKU-{product.id}",
                    quantity=item['quantity'],
                    line_price_incl_tax=item['price'] * item['quantity'],
                    line_price_excl_tax=(item['price'] * item['quantity']) / Decimal('1.2'),
                    unit_price_incl_tax=item['price'],
                    unit_price_excl_tax=item['price'] / Decimal('1.2'),
                    title=product.title
                )
                
                # Update stock (Simple)
                stockrecord = product.stockrecords.first()
                if stockrecord and stockrecord.num_in_stock >= item['quantity']:
                    stockrecord.num_in_stock -= item['quantity']
                    stockrecord.save()
                    
            except Product.DoesNotExist:
                continue
                
        return Response({
            'success': True,
            'order_id': order.id,
            'order_number': order.number
        }, status=status.HTTP_201_CREATED)

