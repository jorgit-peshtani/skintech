"""
Simple API views that bypass Oscar - for desktop app only
"""
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
from oscar.core.loading import get_model
Product = get_model('catalogue', 'Product')
from oscar.apps.order.models import Order
from django.contrib.auth import get_user_model, authenticate
from django.db.models import Sum
from decimal import Decimal
import json

User = get_user_model()

@csrf_exempt
@require_http_methods(["GET"])
def simple_stats(request):
    """Simple stats endpoint - no authentication"""
    try:
        total_products = Product.objects.count()
        products_in_stock = Product.objects.filter(stockrecords__num_in_stock__gt=0).distinct().count()
        total_orders = Order.objects.count()
        total_revenue = Order.objects.aggregate(total=Sum('total_incl_tax'))['total'] or Decimal('0.00')
        total_users = User.objects.count()
        
        return JsonResponse({
            'users': {
                'total': total_users,
                'new': 0,
                'active': total_users
            },
            'products': {
                'total': total_products,
                'categories': 0,
                'outOfStock': total_products - products_in_stock
            },
            'orders': {
                'total': total_orders,
                'pending': 0,
                'completed': total_orders,
                'revenue': float(total_revenue)
            },
            'scans': {
                'total': 0,
                'today': 0,
                'positive': 0,
                'negative': 0
            }
        })
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@csrf_exempt  
@require_http_methods(["GET", "POST", "PUT", "DELETE", "PATCH"])
def simple_users(request, user_id=None):
    """Simple users endpoint - full CRUD with admin support"""
    try:
        if request.method == 'GET':
            if user_id:
                user = User.objects.get(id=user_id)
                return JsonResponse({
                    'id': user.id,
                    'username': user.username,
                    'email': user.email,
                    'is_active': user.is_active,
                    'is_admin': user.is_staff or user.is_superuser,
                    'date_joined': user.date_joined.isoformat()
                })
            else:
                users_data = []
                for user in User.objects.all():
                    users_data.append({
                        'id': user.id,
                        'username': user.username,
                        'email': user.email,
                        'is_active': user.is_active,
                        'is_admin': user.is_staff or user.is_superuser,
                        'date_joined': user.date_joined.isoformat()
                    })
                return JsonResponse(users_data, safe=False)
        
        elif request.method == 'POST':
            data = json.loads(request.body)
            user = User.objects.create_user(
                username=data.get('username'),
                email=data.get('email'),
                password=data.get('password', 'changeme123')
            )
            # Set admin status if requested
            if data.get('is_admin'):
                user.is_staff = True
                user.is_superuser = True
            user.is_active = data.get('is_active', True)
            user.save()
            
            return JsonResponse({
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'is_admin': user.is_staff or user.is_superuser,
                'is_active': user.is_active
            })
        
        elif request.method in ['PUT', 'PATCH']:
            if not user_id:
                return JsonResponse({'error': 'User ID required for update'}, status=400)
            
            user = User.objects.get(id=user_id)
            data = json.loads(request.body)
            
            # Update fields if provided
            if 'username' in data:
                user.username = data['username']
            if 'email' in data:
                user.email = data['email']
            if 'password' in data and data['password']:
                user.set_password(data['password'])
            if 'is_active' in data:
                user.is_active = data['is_active']
            if 'is_admin' in data:
                user.is_staff = data['is_admin']
                user.is_superuser = data['is_admin']
            
            user.save()
            
            return JsonResponse({
                'id': user.id,
                'username': user.username,
                'email': user.email,
                'is_admin': user.is_staff or user.is_superuser,
                'is_active': user.is_active
            })
        
        elif request.method == 'DELETE':
            user = User.objects.get(id=user_id)
            user.delete()
            return JsonResponse({'success': True})
            
    except User.DoesNotExist:
        return JsonResponse({'error': 'User not found'}, status=404)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["POST"])
def simple_login(request):
    """Simple login endpoint - accepts email or username"""
    try:
        data = json.loads(request.body)
        email = data.get('email')
        password = data.get('password')
        
        # Try to find user by email or username
        user = None
        if email:
            if '@' in email:
                # It's an email
                try:
                    user = User.objects.get(email=email)
                    username = user.username
                except User.DoesNotExist:
                    pass
            else:
                # It's a username
                username = email
        
        if user is None and username:
            user = authenticate(username=username, password=password)
        
        if user:
            return JsonResponse({
                'success': True,
                'user': {
                    'id': user.id,
                    'username': user.username,
                    'email': user.email,
                    'is_admin': user.is_staff or user.is_superuser  # Admin check
                },
                'access_token': 'desktop-token-' + str(user.id)  # Dummy token
            })
        else:
            return JsonResponse({'error': 'Invalid credentials'}, status=401)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["GET"])
def simple_orders(request):
    """Simple orders endpoint - returns Oscar orders in desktop-friendly format"""
    try:
        orders = Order.objects.all().order_by('-date_placed')
        
        orders_data = []
        for order in orders:
            orders_data.append({
                'id': order.id,
                'order_number': order.number,
                'created_at': order.date_placed.isoformat() if order.date_placed else None,
                'user_id': order.user_id,
                'items': [],  # Could populate from order.lines if needed
                'total': str(order.total_incl_tax or 0),
                'status': order.status.lower() if order.status else 'pending'
            })
        
        return JsonResponse(orders_data, safe=False)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)


@csrf_exempt
@require_http_methods(["GET", "POST", "PUT", "PATCH", "DELETE"])
def simple_products(request, product_id=None):
    """Simple products endpoint - returns Oscar products in desktop-friendly format"""
    
    # Manually parse multipart/form-data for PUT/PATCH
    if request.method in ['PUT', 'PATCH'] and request.content_type.startswith('multipart'):
        try:
            from django.http.multipartparser import MultiPartParser
            request.upload_handlers = request.upload_handlers # Trigger access
            post, files = MultiPartParser(request.META, request, request.upload_handlers).parse()
            request.POST = post
            request.FILES = files
        except Exception as e:
            print(f"DEBUG Parsing Failed: {e}")
            pass

    with open('debug_log.txt', 'a') as f:
        f.write(f"\n--- REQUEST {request.method} ---\n")
        f.write(f"Content-Type: {request.content_type}\n")
        f.write(f"FILES Keys: {list(request.FILES.keys())}\n")
    try:
        if request.method == 'GET':
            if product_id:
                product = Product.objects.get(id=product_id)
                stockrecord = product.stockrecords.first()
                
                # Get image safely
                image_url = None
                try:
                    if hasattr(product, 'primary_image') and product.primary_image():
                        image_url = product.primary_image().original.url
                except:
                    pass
                
                return JsonResponse({
                    'id': product.id,
                    'title': product.title,
                    'description': product.description or '',
                    'price': str(stockrecord.price) if stockrecord else '0.00',
                    'stock': stockrecord.num_in_stock if stockrecord else 0,
                    'category': product.categories.first().name if product.categories.exists() else 'Uncategorized',
                    'brand': product.brand or '',
                    'image': image_url
                })
            else:
                products = Product.objects.all()
                products_data = []
                for product in products:
                    stockrecord = product.stockrecords.first()
                    
                    # Get image safely
                    image_url = None
                    try:
                        if hasattr(product, 'primary_image') and product.primary_image():
                            image_url = product.primary_image().original.url
                    except:
                        pass
                    
                    products_data.append({
                        'id': product.id,
                        'title': product.title,
                        'description': product.description or '',
                        'price': str(stockrecord.price) if stockrecord else '0.00',
                        'stock': stockrecord.num_in_stock if stockrecord else 0,
                        'category': product.categories.first().name if product.categories.exists() else 'Uncategorized',
                        'brand': product.brand or '',
                        'image': image_url
                    })
                return JsonResponse(products_data, safe=False)
        
        elif request.method in ['POST', 'PUT', 'PATCH']:
            # DETERMINE MODE: CREATE vs UPDATE
            is_update = product_id is not None
            
            # For pure POST without ID, it's a create.
            # For POST with ID (or PUT/PATCH), it's an update.
            if not is_update and request.method == 'POST':
                # Create Mode
                product = None
            elif is_update:
                # Update Mode
                if not product_id:
                    return JsonResponse({'error': 'Product ID required for update'}, status=400)
                product = Product.objects.get(id=product_id)
            else:
                 # PUT/PATCH without ID is invalid for this logic or should be create...
                 # But sticking to REST, PUT usually needs ID. 
                 # If we are here, it's likely a misrouted request, but let's assume CREATE if no ID.
                 product = None

            # Handle parsing
            if request.content_type == 'application/json':
                data = json.loads(request.body)
                image_file = None
            else:
                # Native Django parsing works perfectly for POST.
                # For PUT, we rely on the client sending POST (method tunneling)
                # or simpler multipart if available.
                data = request.POST
                image_file = request.FILES.get('image')

            # EXECUTE LOGIC
            if not product:
                # --- CREATE ---
                product_data = {
                    'title': data.get('title'),
                    'description': data.get('description', ''),
                    'structure': 'standalone',
                    'brand': data.get('brand', '')
                }
                
                # Create product with Oscar
                product = Product.objects.create(**product_data)
                
                from oscar.apps.partner.models import Partner, StockRecord
                partner = Partner.objects.first()
                if not partner:
                    partner = Partner.objects.create(name='Default Partner', code='default')
                
                StockRecord.objects.create(
                    product=product,
                    partner=partner,
                    partner_sku=f'SKU-{product.id}',
                    price=data.get('price', '0.00'),
                    num_in_stock=data.get('stock', 0)
                )
            else:
                # --- UPDATE ---
                if 'title' in data:
                    product.title = data['title']
                if 'description' in data:
                    product.description = data['description']
                if 'brand' in data:
                    product.brand = data['brand']
                product.save()
                
                from oscar.apps.partner.models import StockRecord
                stockrecord = product.stockrecords.first()
                if stockrecord:
                    if 'price' in data:
                        stockrecord.price = data['price']
                    if 'stock' in data:
                        stockrecord.num_in_stock = data['stock']
                    stockrecord.save()
            
            # Common Logic: Category & Image
            if 'category' in data:
                from oscar.core.loading import get_model
                Category = get_model('catalogue', 'Category')
                if product.categories.exists():
                     product.categories.clear() # Clear for update, or just add for create (doesn't hurt)
                category, created = Category.objects.get_or_create(name=data['category'])
                product.categories.add(category)
            
            image_url = None
            if image_file:
                from oscar.core.loading import get_model
                ProductImage = get_model('catalogue', 'ProductImage')
                product.images.all().delete() # Clear old images
                img = ProductImage.objects.create(
                    product=product,
                    original=image_file,
                    display_order=0
                )
                image_url = request.build_absolute_uri(img.original.url)
            elif 'image_url' in data:
                # If specifically cleared or set to URL
                if data['image_url'] == '':
                    product.images.all().delete()
                else:
                    # Keep existing or set new URL (less common now with file uploads)
                    image_url = data['image_url']
            else:
                # Existing image for response
                existing_image = product.images.first()
                if existing_image:
                    image_url = request.build_absolute_uri(existing_image.original.url) if existing_image.original else None

            # Get final values for response
            stockrecord = product.stockrecords.first()
            return JsonResponse({
                'id': product.id,
                'title': product.title,
                'description': product.description,
                'price': str(stockrecord.price) if stockrecord else '0.00',
                'stock': stockrecord.num_in_stock if stockrecord else 0,
                'category': product.categories.first().name if product.categories.exists() else 'Uncategorized',
                'brand': product.brand or '',
                'image': image_url
            })
        
        elif request.method == 'DELETE':
            product = Product.objects.get(id=product_id)
            product.delete()
            return JsonResponse({'success': True})
            
    except Product.DoesNotExist:
        return JsonResponse({'error': 'Product not found'}, status=404)
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
