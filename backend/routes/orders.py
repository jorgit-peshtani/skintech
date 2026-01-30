from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import Order, OrderItem, Product, User, db
from datetime import datetime
import uuid

orders_bp = Blueprint('orders', __name__)

@orders_bp.route('/', methods=['POST'])
@jwt_required()
def create_order():
    """Create a new order"""
    current_user_id = get_jwt_identity()
    data = request.get_json()
    
    if 'items' not in data or not data['items']:
        return jsonify({'error': 'Order items are required'}), 400
    
    # Validate items and calculate total
    items = []
    subtotal = 0
    
    for item_data in data['items']:
        if 'product_id' not in item_data or 'quantity' not in item_data:
            return jsonify({'error': 'Each item must have product_id and quantity'}), 400
        
        product = Product.query.get(item_data['product_id'])
        
        if not product or not product.is_active:
            return jsonify({'error': f'Product {item_data["product_id"]} not found'}), 404
        
        quantity = item_data['quantity']
        
        if quantity <= 0:
            return jsonify({'error': 'Quantity must be positive'}), 400
        
        if product.stock_quantity < quantity:
            return jsonify({'error': f'Insufficient stock for {product.name}'}), 400
        
        items.append({
            'product': product,
            'quantity': quantity,
            'price': product.price
        })
        
        subtotal += product.price * quantity
    
    # Calculate tax and shipping
    tax = subtotal * 0.1  # 10% tax (adjust as needed)
    shipping_cost = data.get('shipping_cost', 5.00)  # Default shipping
    total = subtotal + tax + shipping_cost
    
    # Create order
    order = Order(
        user_id=current_user_id,
        order_number=f'ORD-{uuid.uuid4().hex[:8].upper()}',
        subtotal=subtotal,
        tax=tax,
        shipping_cost=shipping_cost,
        total=total,
        shipping_address=data.get('shipping_address'),
        payment_method=data.get('payment_method', 'pending')
    )
    
    db.session.add(order)
    db.session.flush()  # Get order ID
    
    # Create order items and update stock
    for item in items:
        order_item = OrderItem(
            order_id=order.id,
            product_id=item['product'].id,
            quantity=item['quantity'],
            price=item['price']
        )
        db.session.add(order_item)
        
        # Update stock
        item['product'].stock_quantity -= item['quantity']
    
    db.session.commit()
    
    return jsonify({
        'message': 'Order created successfully',
        'order': order.to_dict()
    }), 201

@orders_bp.route('/', methods=['GET'])
@jwt_required()
def get_orders():
    """Get user's orders"""
    current_user_id = get_jwt_identity()
    
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    orders = Order.query.filter_by(user_id=current_user_id).order_by(
        Order.created_at.desc()
    ).paginate(page=page, per_page=per_page, error_out=False)
    
    return jsonify({
        'orders': [o.to_dict() for o in orders.items],
        'total': orders.total,
        'pages': orders.pages,
        'current_page': page
    }), 200

@orders_bp.route('/<int:order_id>', methods=['GET'])
@jwt_required()
def get_order(order_id):
    """Get a specific order"""
    current_user_id = get_jwt_identity()
    
    order = Order.query.filter_by(
        id=order_id,
        user_id=current_user_id
    ).first()
    
    if not order:
        return jsonify({'error': 'Order not found'}), 404
    
    return jsonify(order.to_dict()), 200

@orders_bp.route('/<int:order_id>/payment', methods=['POST'])
@jwt_required()
def process_payment(order_id):
    """Process payment for an order"""
    current_user_id = get_jwt_identity()
    
    order = Order.query.filter_by(
        id=order_id,
        user_id=current_user_id
    ).first()
    
    if not order:
        return jsonify({'error': 'Order not found'}), 404
    
    if order.payment_status == 'completed':
        return jsonify({'error': 'Order already paid'}), 400
    
    data = request.get_json()
    
    if 'payment_method' not in data:
        return jsonify({'error': 'Payment method is required'}), 400
    
    payment_method = data['payment_method']
    
    # Here you would integrate with actual payment gateways
    # For now, we'll simulate payment processing
    
    if payment_method == 'stripe':
        # Stripe integration would go here
        payment_id = f'stripe_{uuid.uuid4().hex[:16]}'
    elif payment_method == 'paypal':
        # PayPal integration would go here
        payment_id = f'paypal_{uuid.uuid4().hex[:16]}'
    else:
        return jsonify({'error': 'Invalid payment method'}), 400
    
    # Update order
    order.payment_method = payment_method
    order.payment_id = payment_id
    order.payment_status = 'completed'
    order.status = 'paid'
    
    db.session.commit()
    
    return jsonify({
        'message': 'Payment processed successfully',
        'order': order.to_dict()
    }), 200

@orders_bp.route('/<int:order_id>/cancel', methods=['POST'])
@jwt_required()
def cancel_order(order_id):
    """Cancel an order"""
    current_user_id = get_jwt_identity()
    
    order = Order.query.filter_by(
        id=order_id,
        user_id=current_user_id
    ).first()
    
    if not order:
        return jsonify({'error': 'Order not found'}), 404
    
    if order.status in ['shipped', 'delivered']:
        return jsonify({'error': 'Cannot cancel shipped or delivered orders'}), 400
    
    if order.status == 'cancelled':
        return jsonify({'error': 'Order already cancelled'}), 400
    
    # Restore stock
    for item in order.items:
        item.product.stock_quantity += item.quantity
    
    order.status = 'cancelled'
    db.session.commit()
    
    return jsonify({
        'message': 'Order cancelled successfully',
        'order': order.to_dict()
    }), 200

# Admin routes
@orders_bp.route('/all', methods=['GET'])
@jwt_required()
def get_all_orders():
    """Get all orders (admin only)"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user or not user.is_admin:
        return jsonify({'error': 'Unauthorized'}), 403
    
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    status = request.args.get('status')
    
    query = Order.query
    
    if status:
        query = query.filter_by(status=status)
    
    orders = query.order_by(Order.created_at.desc()).paginate(
        page=page, per_page=per_page, error_out=False
    )
    
    return jsonify({
        'orders': [o.to_dict() for o in orders.items],
        'total': orders.total,
        'pages': orders.pages,
        'current_page': page
    }), 200

@orders_bp.route('/<int:order_id>/status', methods=['PUT'])
@jwt_required()
def update_order_status(order_id):
    """Update order status (admin only)"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user or not user.is_admin:
        return jsonify({'error': 'Unauthorized'}), 403
    
    order = Order.query.get(order_id)
    
    if not order:
        return jsonify({'error': 'Order not found'}), 404
    
    data = request.get_json()
    
    if 'status' not in data:
        return jsonify({'error': 'Status is required'}), 400
    
    valid_statuses = ['pending', 'paid', 'shipped', 'delivered', 'cancelled']
    
    if data['status'] not in valid_statuses:
        return jsonify({'error': f'Invalid status. Must be one of: {", ".join(valid_statuses)}'}), 400
    
    order.status = data['status']
    db.session.commit()
    
    return jsonify({
        'message': 'Order status updated successfully',
        'order': order.to_dict()
    }), 200
