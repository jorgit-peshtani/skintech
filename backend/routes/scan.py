from flask import Blueprint, request, jsonify, current_app
from flask_jwt_extended import jwt_required, get_jwt_identity
from werkzeug.utils import secure_filename
from models import ProductScan, User, db
from services.ocr_service import OCRService
from services.ingredient_analyzer import IngredientAnalyzer
import os
from datetime import datetime

scan_bp = Blueprint('scan', __name__)

def allowed_file(filename):
    """Check if file extension is allowed"""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in current_app.config['ALLOWED_EXTENSIONS']

@scan_bp.route('/upload', methods=['POST'])
@jwt_required()
def upload_and_scan():
    """Upload product image and scan ingredients"""
    current_user_id = get_jwt_identity()
    
    # Check if file is present
    if 'image' not in request.files:
        return jsonify({'error': 'No image file provided'}), 400
    
    file = request.files['image']
    
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if not allowed_file(file.filename):
        return jsonify({'error': 'Invalid file type. Allowed: png, jpg, jpeg, gif'}), 400
    
    # Save file
    filename = secure_filename(file.filename)
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    filename = f"{current_user_id}_{timestamp}_{filename}"
    filepath = os.path.join(current_app.config['UPLOAD_FOLDER'], filename)
    file.save(filepath)
    
    try:
        # Initialize OCR service
        ocr = OCRService(
            engine=current_app.config['OCR_ENGINE'],
            languages=current_app.config['OCR_LANGUAGES']
        )
        
        # Extract text
        ocr_result = ocr.extract_text(filepath)
        
        if not ocr_result['success']:
            return jsonify({
                'error': 'Failed to extract text from image',
                'details': ocr_result.get('error')
            }), 500
        
        extracted_text = ocr_result['text']
        
        # Extract ingredient list
        ingredients = ocr.extract_ingredient_list(extracted_text)
        
        # Analyze ingredients
        user = User.query.get(current_user_id)
        skin_type = user.profile.skin_type.value if user.profile and user.profile.skin_type else None
        
        analyzer = IngredientAnalyzer()
        analysis = analyzer.analyze_ingredients(ingredients, skin_type=skin_type)
        
        # Get recommendations
        recommendations = analyzer.get_recommendations(analysis, skin_type=skin_type)
        
        # Save scan to database
        scan = ProductScan(
            user_id=current_user_id,
            image_path=filepath,
            extracted_text=extracted_text,
            identified_ingredients=[ing['name'] for ing in analysis['identified_ingredients']],
            analysis_result=analysis,
            overall_rating=int(10 - analysis['overall_safety_score'])  # Invert score (higher is better)
        )
        
        db.session.add(scan)
        db.session.commit()
        
        return jsonify({
            'message': 'Scan completed successfully',
            'scan_id': scan.id,
            'extracted_text': extracted_text,
            'ingredients': ingredients,
            'analysis': analysis,
            'recommendations': recommendations,
            'overall_rating': scan.overall_rating
        }), 200
        
    except Exception as e:
        # Clean up uploaded file on error
        if os.path.exists(filepath):
            os.remove(filepath)
        
        return jsonify({
            'error': 'Failed to process image',
            'details': str(e)
        }), 500

@scan_bp.route('/history', methods=['GET'])
@jwt_required()
def get_scan_history():
    """Get user's scan history"""
    current_user_id = get_jwt_identity()
    
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    scans = ProductScan.query.filter_by(user_id=current_user_id).order_by(
        ProductScan.created_at.desc()
    ).paginate(page=page, per_page=per_page, error_out=False)
    
    return jsonify({
        'scans': [s.to_dict() for s in scans.items],
        'total': scans.total,
        'pages': scans.pages,
        'current_page': page
    }), 200

@scan_bp.route('/<int:scan_id>', methods=['GET'])
@jwt_required()
def get_scan(scan_id):
    """Get a specific scan by ID"""
    current_user_id = get_jwt_identity()
    
    scan = ProductScan.query.filter_by(
        id=scan_id,
        user_id=current_user_id
    ).first()
    
    if not scan:
        return jsonify({'error': 'Scan not found'}), 404
    
    return jsonify(scan.to_dict()), 200

@scan_bp.route('/<int:scan_id>', methods=['DELETE'])
@jwt_required()
def delete_scan(scan_id):
    """Delete a scan"""
    current_user_id = get_jwt_identity()
    
    scan = ProductScan.query.filter_by(
        id=scan_id,
        user_id=current_user_id
    ).first()
    
    if not scan:
        return jsonify({'error': 'Scan not found'}), 404
    
    # Delete image file
    if scan.image_path and os.path.exists(scan.image_path):
        os.remove(scan.image_path)
    
    db.session.delete(scan)
    db.session.commit()
    
    return jsonify({'message': 'Scan deleted successfully'}), 200

@scan_bp.route('/analyze-text', methods=['POST'])
@jwt_required()
def analyze_text():
    """Analyze ingredient text without image upload"""
    current_user_id = get_jwt_identity()
    data = request.get_json()
    
    if 'text' not in data:
        return jsonify({'error': 'Text is required'}), 400
    
    text = data['text']
    
    # Extract ingredients
    ocr = OCRService()
    ingredients = ocr.extract_ingredient_list(text)
    
    # Analyze
    user = User.query.get(current_user_id)
    skin_type = user.profile.skin_type.value if user.profile and user.profile.skin_type else None
    
    analyzer = IngredientAnalyzer()
    analysis = analyzer.analyze_ingredients(ingredients, skin_type=skin_type)
    recommendations = analyzer.get_recommendations(analysis, skin_type=skin_type)
    
    return jsonify({
        'ingredients': ingredients,
        'analysis': analysis,
        'recommendations': recommendations
    }), 200
