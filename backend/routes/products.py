from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required, get_jwt_identity
from models import Product, Review, User, db
from sqlalchemy import or_

products_bp = Blueprint('products', __name__)

@products_bp.route('/', methods=['GET'])
def get_products():
    """Get all products with filtering and pagination"""
    # Pagination
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 20, type=int)
    
    # Filters
    category = request.args.get('category')
    brand = request.args.get('brand')
    skin_type = request.args.get('skin_type')
    min_price = request.args.get('min_price', type=float)
    max_price = request.args.get('max_price', type=float)
    search = request.args.get('search')
    
    # Build query
    query = Product.query.filter_by(is_active=True)
    
    if category:
        query = query.filter_by(category=category)
    
    if brand:
        query = query.filter_by(brand=brand)
    
    if skin_type:
        query = query.filter(Product.suitable_for_skin_types.contains([skin_type]))
    
    if min_price is not None:
        query = query.filter(Product.price >= min_price)
    
    if max_price is not None:
        query = query.filter(Product.price <= max_price)
    
    if search:
        search_term = f'%{search}%'
        query = query.filter(
            or_(
                Product.name.ilike(search_term),
                Product.brand.ilike(search_term),
                Product.description.ilike(search_term)
            )
        )
    
    # Execute query with pagination
    pagination = query.paginate(page=page, per_page=per_page, error_out=False)
    
    return jsonify({
        'products': [p.to_dict() for p in pagination.items],
        'total': pagination.total,
        'pages': pagination.pages,
        'current_page': page,
        'per_page': per_page
    }), 200

@products_bp.route('/<int:product_id>', methods=['GET'])
def get_product(product_id):
    """Get a single product by ID"""
    product = Product.query.get(product_id)
    
    if not product or not product.is_active:
        return jsonify({'error': 'Product not found'}), 404
    
    return jsonify(product.to_dict()), 200

@products_bp.route('/<int:product_id>/reviews', methods=['GET'])
def get_product_reviews(product_id):
    """Get reviews for a product"""
    product = Product.query.get(product_id)
    
    if not product:
        return jsonify({'error': 'Product not found'}), 404
    
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    pagination = product.reviews.paginate(page=page, per_page=per_page, error_out=False)
    
    return jsonify({
        'reviews': [r.to_dict() for r in pagination.items],
        'total': pagination.total,
        'pages': pagination.pages,
        'average_rating': product.get_average_rating()
    }), 200

@products_bp.route('/<int:product_id>/reviews', methods=['POST'])
@jwt_required()
def create_review(product_id):
    """Create a review for a product"""
    current_user_id = get_jwt_identity()
    product = Product.query.get(product_id)
    
    if not product:
        return jsonify({'error': 'Product not found'}), 404
    
    data = request.get_json()
    
    if 'rating' not in data:
        return jsonify({'error': 'Rating is required'}), 400
    
    rating = data['rating']
    if not isinstance(rating, int) or rating < 1 or rating > 5:
        return jsonify({'error': 'Rating must be between 1 and 5'}), 400
    
    # Check if user already reviewed this product
    existing_review = Review.query.filter_by(
        user_id=current_user_id,
        product_id=product_id
    ).first()
    
    if existing_review:
        return jsonify({'error': 'You have already reviewed this product'}), 400
    
    # Create review
    review = Review(
        user_id=current_user_id,
        product_id=product_id,
        rating=rating,
        title=data.get('title'),
        comment=data.get('comment')
    )
    
    db.session.add(review)
    db.session.commit()
    
    return jsonify({
        'message': 'Review created successfully',
        'review': review.to_dict()
    }), 201

@products_bp.route('/categories', methods=['GET'])
def get_categories():
    """Get all product categories"""
    categories = db.session.query(Product.category).filter(
        Product.is_active == True
    ).distinct().all()
    
    return jsonify({
        'categories': [c[0] for c in categories if c[0]]
    }), 200

@products_bp.route('/brands', methods=['GET'])
def get_brands():
    """Get all product brands"""
    brands = db.session.query(Product.brand).filter(
        Product.is_active == True
    ).distinct().all()
    
    return jsonify({
        'brands': [b[0] for b in brands if b[0]]
    }), 200

# Admin routes
@products_bp.route('/', methods=['POST'])
@jwt_required()
def create_product():
    """Create a new product (admin only)"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user or not user.is_admin:
        return jsonify({'error': 'Unauthorized'}), 403
    
    data = request.get_json()
    
    required_fields = ['name', 'brand', 'price']
    for field in required_fields:
        if field not in data:
            return jsonify({'error': f'Missing required field: {field}'}), 400
    
    product = Product(
        name=data['name'],
        brand=data['brand'],
        description=data.get('description'),
        category=data.get('category'),
        price=data['price'],
        stock_quantity=data.get('stock_quantity', 0),
        image_url=data.get('image_url'),
        ingredients=data.get('ingredients'),
        is_certified=data.get('is_certified', False),
        suitable_for_skin_types=data.get('suitable_for_skin_types', []),
        target_concerns=data.get('target_concerns', [])
    )
    
    db.session.add(product)
    db.session.commit()
    
    return jsonify({
        'message': 'Product created successfully',
        'product': product.to_dict()
    }), 201

@products_bp.route('/<int:product_id>', methods=['PUT'])
@jwt_required()
def update_product(product_id):
    """Update a product (admin only)"""
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    
    if not user or not user.is_admin:
        return jsonify({'error': 'Unauthorized'}), 403
    
    product = Product.query.get(product_id)
    
    if not product:
        return jsonify({'error': 'Product not found'}), 404
    
    data = request.get_json()
    
    # Update fields
    updatable_fields = [
        'name', 'brand', 'description', 'category', 'price',
        'stock_quantity', 'image_url', 'ingredients', 'is_certified',
        'suitable_for_skin_types', 'target_concerns', 'is_active'
    ]
    
    for field in updatable_fields:
        if field in data:
            setattr(product, field, data[field])
    
    db.session.commit()
    
    return jsonify({
        'message': 'Product updated successfully',
        'product': product.to_dict()
    }), 200
