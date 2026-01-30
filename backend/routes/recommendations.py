from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from services.recommendation_engine import RecommendationEngine

recommendations_bp = Blueprint('recommendations', __name__)

@recommendations_bp.route('/', methods=['GET'])
@jwt_required()
def get_recommendations():
    """Get personalized product recommendations"""
    current_user_id = get_jwt_identity()
    
    limit = request.args.get('limit', 10, type=int)
    
    engine = RecommendationEngine()
    recommendations = engine.get_personalized_recommendations(current_user_id, limit=limit)
    
    return jsonify({
        'recommendations': recommendations,
        'count': len(recommendations)
    }), 200

@recommendations_bp.route('/popular', methods=['GET'])
def get_popular():
    """Get popular products (no authentication required)"""
    limit = request.args.get('limit', 10, type=int)
    
    engine = RecommendationEngine()
    products = engine.get_popular_products(limit=limit)
    
    return jsonify({
        'products': products,
        'count': len(products)
    }), 200
