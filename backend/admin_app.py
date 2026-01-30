"""
Admin Backend Server for Desktop Application
Runs on port 5001
Separate from main backend to isolate admin operations
"""

import os
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_jwt_extended import JWTManager, jwt_required, get_jwt_identity
from dotenv import load_dotenv
import sys

# Add parent directory to path to import from main backend
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from extensions import db, bcrypt, migrate
from models import User, Product, Order, ProductScan, Ingredient
from sqlalchemy import func

# Load environment variables
load_dotenv()

app = Flask(__name__)

# Configuration - SAME database as main app
basedir = os.path.abspath(os.path.dirname(__file__))
instance_path = os.path.join(basedir, 'instance')
os.makedirs(instance_path, exist_ok=True)

app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'admin-secret-key-change-in-production')

# HARDCODED: Always use instance/skintech.db (same as main app)
app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{os.path.join(instance_path, "skintech.db")}'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] = os.environ.get('JWT_SECRET_KEY', 'admin-jwt-secret-key')

print(f"💻 Admin using: {app.config['SQLALCHEMY_DATABASE_URI']}")

# Initialize extensions
db.init_app(app)
bcrypt.init_app(app)
jwt = JWTManager(app)
migrate.init_app(app, db)

# CORS - Only allow admin frontend
CORS(app, resources={
    r"/api/*": {
        "origins": ["http://localhost:5174"],  # Electron dev server
        "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        "allow_headers": ["Content-Type", "Authorization"],
        "supports_credentials": True
    }
})

# ============= AUTH ROUTES =============

@app.route('/api/auth/login', methods=['POST'])
def admin_login():
    """Admin-only login"""
    data = request.get_json()
    
    if 'email' not in data or 'password' not in data:
        return jsonify({'error': 'Email and password required'}), 400
    
    user = User.query.filter_by(email=data['email']).first()
    
    if not user or not user.check_password(data['password']):
        return jsonify({'error': 'Invalid email or password'}), 401
    
    # Check if user is admin
    if not user.is_admin:
        return jsonify({'error': 'Access denied. Admin privileges required.'}), 403
    
    if not user.is_active:
        return jsonify({'error': 'Account is deactivated'}), 403
    
    from flask_jwt_extended import create_access_token, create_refresh_token
    access_token = create_access_token(identity=user.id)
    refresh_token = create_refresh_token(identity=user.id)
    
    return jsonify({
        'message': 'Admin login successful',
        'user': user.to_dict(),
        'access_token': access_token,
        'refresh_token': refresh_token
    }), 200

# ============= DASHBOARD STATS =============

@app.route('/api/admin/stats/dashboard', methods=['GET'])
def get_dashboard_stats():
    """Get dashboard statistics"""
    try:
        # Get statistics
        total_users = User.query.count()
        new_users = User.query.filter(
            func.date(User.created_at) == func.current_date()
        ).count()
        active_users = User.query.filter_by(is_active=True).count()
        
        total_products = Product.query.count()
        categories = db.session.query(Product.category).distinct().count()
        out_of_stock = Product.query.filter(Product.stock_quantity == 0).count()
        
        total_orders = Order.query.count()
        pending_orders = Order.query.filter_by(status='pending').count()
        completed_orders = Order.query.filter(
            Order.status.in_(['delivered', 'completed'])
        ).count()
        total_revenue = db.session.query(func.sum(Order.total)).scalar() or 0
        
        total_scans = ProductScan.query.count()
        today_scans = ProductScan.query.filter(
            func.date(ProductScan.created_at) == func.current_date()
        ).count()
        positive_scans = ProductScan.query.filter(ProductScan.overall_rating >= 7).count()
        negative_scans = ProductScan.query.filter(ProductScan.overall_rating < 7).count()
        
        return jsonify({
            'users': {
                'total': total_users,
                'new': new_users,
                'active': active_users
            },
            'products': {
                'total': total_products,
                'categories': categories,
                'outOfStock': out_of_stock
            },
            'orders': {
                'total': total_orders,
                'pending': pending_orders,
                'completed': completed_orders,
                'revenue': float(total_revenue)
            },
            'scans': {
                'total': total_scans,
                'today': today_scans,
                'positive': positive_scans,
                'negative': negative_scans
            }
        }), 200
    except Exception as e:
        print(f"Dashboard stats error: {str(e)}")  # Log to console
        import traceback
        traceback.print_exc()
        return jsonify({'error': str(e), 'details': traceback.format_exc()}), 500

# ============= USER MANAGEMENT =============

@app.route('/api/admin/users', methods=['GET'])
def get_users():
    """Get all users"""
    users = User.query.all()
    return jsonify([user.to_dict() for user in users]), 200

@app.route('/api/admin/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    """Get single user details"""
    user = User.query.get_or_404(user_id)
    return jsonify(user.to_dict()), 200

@app.route('/api/admin/users/<int:user_id>/toggle', methods=['POST'])
def toggle_user_status(user_id):
    """Activate/deactivate user"""
    user = User.query.get_or_404(user_id)
    user.is_active = not user.is_active
    db.session.commit()
    
    return jsonify({
        'message': f"User {'activated' if user.is_active else 'deactivated'}",
        'user': user.to_dict()
    }), 200

@app.route('/api/admin/users', methods=['POST'])
def create_user():
    """Create a new user"""
    try:
        data = request.get_json()
        
        if not all(k in data for k in ['email', 'username', 'password']):
            return jsonify({'error': 'Missing required fields'}), 400
        
        if User.query.filter_by(email=data['email']).first():
            return jsonify({'error': 'Email already registered'}), 400
        
        if User.query.filter_by(username=data['username']).first():
            return jsonify({'error': 'Username already taken'}), 400
        
        new_user = User(
            email=data['email'],
            username=data['username'],
            is_admin=data.get('is_admin', False),
            is_active=data.get('is_active', True)
        )
        new_user.set_password(data['password'])
        
        db.session.add(new_user)
        db.session.commit()
        
        return jsonify({
            'message': 'User created successfully',
            'user': new_user.to_dict()
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/api/admin/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    """Update user details"""
    try:
        user = User.query.get_or_404(user_id)
        data = request.get_json()
        
        if 'email' in data and data['email'] != user.email:
            if User.query.filter_by(email=data['email']).first():
                return jsonify({'error': 'Email already in use'}), 400
            user.email = data['email']
        
        if 'username' in data and data['username'] != user.username:
            if User.query.filter_by(username=data['username']).first():
                return jsonify({'error': 'Username already taken'}), 400
            user.username = data['username']
        
        if 'is_admin' in data:
            user.is_admin = data['is_admin']
        
        if 'is_active' in data:
            user.is_active = data['is_active']
        
        if 'password' in data and data['password']:
            user.set_password(data['password'])
        
        db.session.commit()
        
        return jsonify({
            'message': 'User updated successfully',
            'user': user.to_dict()
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/api/admin/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    """Delete a user"""
    try:
        user = User.query.get_or_404(user_id)
        db.session.delete(user)
        db.session.commit()
        return jsonify({'message': 'User deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

# ============= PRODUCT MANAGEMENT =============

@app.route('/api/admin/products', methods=['GET'])
def get_all_products():
    """Get all products for admin"""
    products = Product.query.all()
    return jsonify([product.to_dict() for product in products]), 200

@app.route('/api/admin/products', methods=['POST'])
def create_product():
    """Create a new product"""
    try:
        data = request.get_json()
        
        if not all(k in data for k in ['name', 'brand', 'price']):
            return jsonify({'error': 'Missing required fields'}), 400
        
        new_product = Product(
            name=data['name'],
            brand=data['brand'],
            description=data.get('description', ''),
            category=data.get('category', ''),
            price=float(data['price']),
            stock_quantity=int(data.get('stock_quantity', 0)),
            image_url=data.get('image_url', ''),
            ingredients=data.get('ingredients', ''),
            is_certified=data.get('is_certified', False),
            suitable_for_skin_types=data.get('suitable_for_skin_types', []),
            target_concerns=data.get('target_concerns', [])
        )
        
        db.session.add(new_product)
        db.session.commit()
        
        return jsonify({
            'message': 'Product created successfully',
            'product': new_product.to_dict()
        }), 201
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/api/admin/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    """Update a product"""
    try:
        product = Product.query.get_or_404(product_id)
        data = request.get_json()
        
        # Update fields
        if 'name' in data:
            product.name = data['name']
        if 'brand' in data:
            product.brand = data['brand']
        if 'description' in data:
            product.description = data['description']
        if 'category' in data:
            product.category = data['category']
        if 'price' in data:
            product.price = float(data['price'])
        if 'stock_quantity' in data:
            product.stock_quantity = int(data['stock_quantity'])
        if 'image_url' in data:
            product.image_url = data['image_url']
        if 'ingredients' in data:
            product.ingredients = data['ingredients']
        if 'is_certified' in data:
            product.is_certified = data['is_certified']
        if 'is_active' in data:
            product.is_active = data['is_active']
        if 'suitable_for_skin_types' in data:
            product.suitable_for_skin_types = data['suitable_for_skin_types']
        if 'target_concerns' in data:
            product.target_concerns = data['target_concerns']
        
        db.session.commit()
        
        return jsonify({
            'message': 'Product updated successfully',
            'product': product.to_dict()
        }), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

@app.route('/api/admin/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    """Delete a product"""
    try:
        product = Product.query.get_or_404(product_id)
        db.session.delete(product)
        db.session.commit()
        return jsonify({'message': 'Product deleted successfully'}), 200
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500


# ============= ORDER MANAGEMENT =============

@app.route('/api/admin/orders', methods=['GET'])
def get_all_orders():
    """Get all orders for admin"""
    orders = Order.query.order_by(Order.created_at.desc()).all()
    return jsonify([order.to_dict() for order in orders]), 200

@app.route('/api/admin/orders/<int:order_id>', methods=['GET'])
def get_order(order_id):
    """Get single order details"""
    order = Order.query.get_or_404(order_id)
    return jsonify(order.to_dict()), 200

@app.route('/api/admin/orders/<int:order_id>', methods=['PUT'])
def update_order_status(order_id):
    """Update order status"""
    try:
        order = Order.query.get_or_404(order_id)
        data = request.get_json()
        
        if 'status' in data:
            order.status = data['status']
            db.session.commit()
            return jsonify({
                'message': 'Order status updated',
                'order': order.to_dict()
            }), 200
        
        return jsonify({'error': 'No status provided'}), 400
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500

# ============= INGREDIENT MANAGEMENT =============

@app.route('/api/admin/ingredients', methods=['GET'])
@jwt_required()
def get_all_ingredients():
    """Get all ingredients"""
    current_user = User.query.get(get_jwt_identity())
    if not current_user or not current_user.is_admin:
        return jsonify({'error': 'Admin access required'}), 403
    
    ingredients = Ingredient.query.all()
    return jsonify([ing.to_dict(detailed=True) for ing in ingredients]), 200

# ============= LOGS =============

@app.route('/api/admin/logs', methods=['GET'])
@jwt_required()
def get_logs():
    """Get system logs (placeholder)"""
    current_user = User.query.get(get_jwt_identity())
    if not current_user or not current_user.is_admin:
        return jsonify({'error': 'Admin access required'}), 403
    
    # Placeholder - would integrate with actual logging system
    return jsonify({
        'logs': [
            {'level': 'INFO', 'message': 'Admin backend started', 'timestamp': '2026-01-28T02:00:00'},
            {'level': 'INFO', 'message': 'Admin user logged in', 'timestamp': '2026-01-28T02:30:00'},
        ]
    }), 200

# ============= ERROR HANDLERS =============

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500

# ============= STARTUP =============

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    
    print("=" * 60)
    print("🔐 SkinTech ADMIN Backend Server Starting...")
    print("=" * 60)
    print(f"📍 Admin Server: http://localhost:3001")
    print(f"🎯 Purpose: Desktop Admin Panel Only")
    print(f"🔒 Security: Admin-only endpoints")
    print("=" * 60)
    
    app.run(host='0.0.0.0', port=3001, debug=True)
