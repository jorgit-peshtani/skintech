"""
Custom views for desktop admin stats and user management
"""
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from oscar.apps.catalogue.models import Product
from oscar.apps.order.models import Order
from django.contrib.auth import get_user_model
from django.db.models import Sum
from decimal import Decimal

User = get_user_model()

@api_view(['GET'])
@permission_classes([AllowAny])  # Allow access without authentication
def dashboard_stats(request):
    """
    Get dashboard statistics for admin panel
    """
    # Product stats
    total_products = Product.objects.count()
    products_in_stock = Product.objects.filter(
        stockrecords__num_in_stock__gt=0
    ).distinct().count()
    
    # Order stats
    total_orders = Order.objects.count()
    pending_orders = Order.objects.filter(status='Pending').count()
    
    # Calculate total revenue
    total_revenue = Order.objects.aggregate(
        total=Sum('total_incl_tax')
    )['total'] or Decimal('0.00')
    
    # User stats
    total_users = User.objects.count()
    active_users = User.objects.filter(is_active=True).count()
    
    # Recent orders (last 5)
    recent_orders = Order.objects.order_by('-date_placed')[:5].values(
        'id', 'number', 'status', 'total_incl_tax', 'date_placed'
    )
    
    return Response({
        'products': {
            'total': total_products,
            'in_stock': products_in_stock,
            'out_of_stock': total_products - products_in_stock
        },
        'orders': {
            'total': total_orders,
            'pending': pending_orders,
            'completed': total_orders - pending_orders
        },
        'revenue': {
            'total': str(total_revenue),
            'currency': 'USD'
        },
        'users': {
            'total': total_users,
            'active': active_users,
            'inactive': total_users - active_users
        },
        'recent_orders': list(recent_orders)
    })


@api_view(['GET', 'POST', 'PUT', 'DELETE'])
@permission_classes([AllowAny])  # Allow access without authentication
def admin_users(request, user_id=None):
    """
    User management endpoint for desktop admin
    """
    if request.method == 'GET':
        if user_id:
            # Get single user
            try:
                user = User.objects.get(id=user_id)
                return Response({
                    'id': user.id,
                    'username': user.username,
                    'email': user.email,
                    'is_active': user.is_active,
                    'is_staff': user.is_staff,
                    'date_joined': user.date_joined
                })
            except User.DoesNotExist:
                return Response({'error': 'User not found'}, status=404)
        else:
            # Get all users
            users = User.objects.all().values(
                'id', 'username', 'email', 'is_active', 'is_staff', 'date_joined'
            )
            return Response(list(users))
    
    elif request.method == 'POST':
        # Create user
        data = request.data
        user = User.objects.create_user(
            username=data.get('username'),
            email=data.get('email'),
            password=data.get('password', 'changeme123')
        )
        return Response({
            'id': user.id,
            'username': user.username,
            'email': user.email
        }, status=201)
    
    elif request.method == 'PUT':
        # Update user
        try:
            user = User.objects.get(id=user_id)
            data = request.data
            if 'username' in data:
                user.username = data['username']
            if 'email' in data:
                user.email = data['email']
            if 'is_active' in data:
                user.is_active = data['is_active']
            user.save()
            return Response({'success': True})
        except User.DoesNotExist:
            return Response({'error': 'User not found'}, status=404)
    
    elif request.method == 'DELETE':
        # Delete user
        try:
            user = User.objects.get(id=user_id)
            user.delete()
            return Response({'success': True})
        except User.DoesNotExist:
            return Response({'error': 'User not found'}, status=404)
