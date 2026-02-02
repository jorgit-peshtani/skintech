from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.routers import DefaultRouter
from accounts.simple_views import simple_stats, simple_users, simple_login, simple_orders, simple_products
from accounts.web_views import WebProductViewSet, WebOrderViewSet
from accounts.auth_views import CustomTokenObtainPairView, RegisterView, UserView
from rest_framework_simplejwt.views import TokenRefreshView

# Router for web API
router = DefaultRouter()
router.register(r'products', WebProductViewSet, basename='web-product')
router.register(r'orders', WebOrderViewSet, basename='web-order')

urlpatterns = [
    # Django admin
    path('admin/', admin.site.urls),
    
    # Web API (for React frontend) - custom endpoints with full data
    path('api/web/', include(router.urls)),
    path('api/scan/', include('apps.scanner.urls')),
    
    # OSCAR APIimple endpoints for desktop app (bypass Oscar)
    path('simple/stats/', simple_stats, name='simple-stats'),
    path('simple/users/', simple_users, name='simple-users-list'),
    path('simple/users/<int:user_id>/', simple_users, name='simple-users-detail'),
    path('simple/login/', simple_login, name='simple-login'),
    path('simple/orders/', simple_orders, name='simple-orders'),
    path('simple/products/', simple_products, name='simple-products-list'),
    path('simple/products/<int:product_id>/', simple_products, name='simple-products-detail'),
    
    # Oscar API endpoints
    path('api/', include('oscarapi.urls')),
    
    # Custom Web Auth (JWT)
    path('api/auth/login', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/auth/register', RegisterView.as_view(), name='auth_register'),
    path('api/auth/refresh', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/auth/me', UserView.as_view(), name='auth_me'),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
