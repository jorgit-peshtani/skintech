import os
from flask import Flask, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from config import config
from extensions import db, bcrypt, jwt, migrate

# Load environment variables
load_dotenv()

def create_app(config_name='development'):
    """Application factory pattern"""
    app = Flask(__name__)
    
    # Load configuration
    app.config.from_object(config[config_name])
    
    # Initialize extensions
    db.init_app(app)
    bcrypt.init_app(app)
    jwt.init_app(app)
    migrate.init_app(app, db)
    
    # CORS - Use config for production deployment
    cors_origins = app.config.get('CORS_ORIGINS', '*')
    CORS(app, resources={
        r"/api/*": {
            "origins": cors_origins,
            "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
            "allow_headers": ["Content-Type", "Authorization"],
            "supports_credentials": True
        }
    })
    
    # Create upload folder
    os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
    os.makedirs(app.config['MODEL_PATH'], exist_ok=True)
    
    # Register blueprints - ALL ROUTES NOW ENABLED
    from routes.auth import auth_bp
    from routes.products import products_bp
    from routes.users import users_bp
    from routes.scan import scan_bp
    from routes.recommendations import recommendations_bp
    from routes.orders import orders_bp
    
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    app.register_blueprint(products_bp, url_prefix='/api/products')
    app.register_blueprint(users_bp, url_prefix='/api/users')
    app.register_blueprint(scan_bp, url_prefix='/api/scan')
    app.register_blueprint(recommendations_bp, url_prefix='/api/recommendations')
    app.register_blueprint(orders_bp, url_prefix='/api/orders')
    
    # Error handlers
    @app.errorhandler(404)
    def not_found(error):
        return jsonify({'error': 'Not found'}), 404
    
    @app.errorhandler(500)
    def internal_error(error):
        db.session.rollback()
        return jsonify({'error': 'Internal server error'}), 500
    
    # Health check endpoint
    @app.route('/api/health')
    def health_check():
        return jsonify({
            'status': 'healthy',
            'version': '1.0.0',
            'features': {
                'ai_scanning': True,
                'recommendations': True,
                'e_commerce': True
            }
        })
    
    # Root endpoint
    @app.route('/')
    def index():
        return jsonify({
            'message': 'SkinTech API',
            'version': '1.0.0',
            'endpoints': {
                'auth': '/api/auth',
                'products': '/api/products',
                'users': '/api/users',
                'scan': '/api/scan',
                'recommendations': '/api/recommendations',
                'orders': '/api/orders',
                'health': '/api/health'
            },
            'features': [
                'AI-powered ingredient scanning (OCR)',
                'Personalized product recommendations',
                'Secure e-commerce platform',
                'User profile management'
            ]
        })
    
    return app

# Create the application instance for Gunicorn
app = create_app(os.getenv('FLASK_CONFIG', 'default'))

if __name__ == '__main__':
    # Create tables
    with app.app_context():
        db.create_all()
        print("Database tables created successfully!")
    
    # Run the app
    print("\n" + "="*60)
    print("🚀 SkinTech Backend Server Starting...")
    print("="*60)
    print("📍 Server: http://localhost:5000")
    print("📍 API Docs: http://localhost:5000/")
    print("📍 Health: http://localhost:5000/api/health")
    print("="*60)
    print("\n✅ ALL FEATURES ENABLED:")
    print("   - Authentication (/api/auth)")
    print("   - Products (/api/products)")
    print("   - User profiles (/api/users)")
    print("   - AI Scanning (/api/scan) ✨ NEW")
    print("   - Recommendations (/api/recommendations) ✨ NEW")
    print("   - Orders & Payments (/api/orders)")
    print("="*60)
    print("\nPress Ctrl+C to stop the server\n")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
