from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import User, UserProfile, db
from datetime import datetime

users_bp = Blueprint('users', __name__)

@users_bp.route('/profile', methods=['GET'])
@jwt_required()
def get_profile():
    """Get user profile"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    return jsonify({
        'user': user.to_dict(),
        'profile': user.profile.to_dict() if user.profile else None
    }), 200

@users_bp.route('/profile', methods=['PUT'])
@jwt_required()
def update_profile():
    """Update user profile"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    data = request.get_json()
    
    # Update user fields
    if 'first_name' in data:
        user.first_name = data['first_name']
    if 'last_name' in data:
        user.last_name = data['last_name']
    
    # Update or create profile
    if not user.profile:
        user.profile = UserProfile(user_id=user.id)
    
    profile = user.profile
    
    # Update profile fields
    if 'skin_type' in data:
        from models import SkinType
        try:
            profile.skin_type = SkinType(data['skin_type'])
        except ValueError:
            return jsonify({'error': 'Invalid skin type'}), 400
    
    if 'date_of_birth' in data:
        try:
            profile.date_of_birth = datetime.strptime(data['date_of_birth'], '%Y-%m-%d').date()
        except ValueError:
            return jsonify({'error': 'Invalid date format. Use YYYY-MM-DD'}), 400
    
    if 'phone' in data:
        profile.phone = data['phone']
    
    # Update address
    if 'address' in data:
        address = data['address']
        profile.address_line1 = address.get('line1')
        profile.address_line2 = address.get('line2')
        profile.city = address.get('city')
        profile.state = address.get('state')
        profile.postal_code = address.get('postal_code')
        profile.country = address.get('country')
    
    # Update preferences
    if 'preferences' in data:
        current_prefs = profile.preferences or {}
        current_prefs.update(data['preferences'])
        profile.preferences = current_prefs
    
    db.session.commit()
    
    return jsonify({
        'message': 'Profile updated successfully',
        'user': user.to_dict(),
        'profile': profile.to_dict()
    }), 200

@users_bp.route('/preferences', methods=['PUT'])
@jwt_required()
def update_preferences():
    """Update user preferences (skin concerns, ingredients to avoid, etc.)"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user or not user.profile:
        return jsonify({'error': 'User profile not found'}), 404
    
    data = request.get_json()
    
    profile = user.profile
    current_prefs = profile.preferences or {}
    
    # Update specific preference fields
    if 'concerns' in data:
        current_prefs['concerns'] = data['concerns']
    
    if 'ingredients_to_avoid' in data:
        current_prefs['ingredients_to_avoid'] = data['ingredients_to_avoid']
    
    if 'preferred_brands' in data:
        current_prefs['preferred_brands'] = data['preferred_brands']
    
    profile.preferences = current_prefs
    db.session.commit()
    
    return jsonify({
        'message': 'Preferences updated successfully',
        'preferences': current_prefs
    }), 200

@users_bp.route('/stats', methods=['GET'])
@jwt_required()
def get_user_stats():
    """Get user statistics"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    # Calculate stats
    total_orders = user.orders.count()
    total_scans = user.scans.count()
    total_reviews = user.reviews.count()
    
    completed_orders = user.orders.filter_by(payment_status='completed').count()
    
    # Calculate total spent
    from models import Order
    total_spent = db.session.query(db.func.sum(Order.total)).filter(
        Order.user_id == current_user_id,
        Order.payment_status == 'completed'
    ).scalar() or 0
    
    return jsonify({
        'total_orders': total_orders,
        'completed_orders': completed_orders,
        'total_scans': total_scans,
        'total_reviews': total_reviews,
        'total_spent': float(total_spent)
    }), 200
