"""
Simplified database initialization without AI dependencies
"""

from app import create_app
from extensions import db
from models import User, UserProfile, Product, Ingredient, SkinType
from datetime import date

def init_database():
    """Initialize database with sample data"""
    app = create_app()
    
    with app.app_context():
        # Drop all tables and recreate
        print("Creating database tables...")
        db.create_all()
        
        # Create admin user
        print("Creating admin user...")
        admin = User(
            email='admin@skintech.com',
            username='admin',
            first_name='Admin',
            last_name='User',
            is_admin=True
        )
        admin.set_password('admin123')
        
        admin_profile = UserProfile(
            user=admin,
            skin_type=SkinType.NORMAL
        )
        
        db.session.add(admin)
        db.session.add(admin_profile)
        
        # Create sample user
        print("Creating sample user...")
        user = User(
            email='user@example.com',
            username='testuser',
            first_name='Test',
            last_name='User'
        )
        user.set_password('password123')
        
        user_profile = UserProfile(
            user=user,
            skin_type=SkinType.DRY,
            preferences={
                'concerns': ['aging', 'dryness'],
                'ingredients_to_avoid': []
            }
        )
        
        db.session.add(user)
        db.session.add(user_profile)
        
        # Create sample products
        print("Creating sample products...")
        products_data = [
            {
                'name': 'Hydrating Facial Cleanser',
                'brand': 'SkinTech',
                'description': 'Gentle, hydrating cleanser suitable for all skin types',
                'category': 'Cleanser',
                'price': 24.99,
                'stock_quantity': 100,
                'image_url': '/images/products/cleanser.jpg',
                'ingredients': 'Aqua, Glycerin, Niacinamide, Ceramide NP',
                'is_certified': True,
                'suitable_for_skin_types': ['normal', 'dry', 'combination', 'sensitive'],
                'target_concerns': ['dryness', 'sensitivity']
            },
            {
                'name': 'Anti-Aging Serum',
                'brand': 'SkinTech Pro',
                'description': 'Powerful anti-aging serum with retinol and vitamin C',
                'category': 'Serum',
                'price': 49.99,
                'stock_quantity': 75,
                'image_url': '/images/products/serum.jpg',
                'ingredients': 'Aqua, Retinol, Ascorbic Acid, Hyaluronic Acid, Niacinamide',
                'is_certified': True,
                'suitable_for_skin_types': ['normal', 'oily', 'combination'],
                'target_concerns': ['aging', 'wrinkles', 'dark_spots']
            },
            {
                'name': 'Acne Treatment Gel',
                'brand': 'ClearSkin',
                'description': 'Effective acne treatment with salicylic acid',
                'category': 'Treatment',
                'price': 19.99,
                'stock_quantity': 120,
                'image_url': '/images/products/acne-gel.jpg',
                'ingredients': 'Aqua, Salicylic Acid, Niacinamide, Glycerin',
                'is_certified': True,
                'suitable_for_skin_types': ['oily', 'combination'],
                'target_concerns': ['acne', 'oiliness']
            },
        ]
        
        for prod_data in products_data:
            product = Product(**prod_data)
            db.session.add(product)
        
        # Commit all changes
        db.session.commit()
        
        print("\n" + "="*50)
        print("Database initialized successfully!")
        print("="*50)
        print("\nSample Accounts:")
        print("-" * 50)
        print("Admin Account:")
        print("  Email: admin@skintech.com")
        print("  Password: admin123")
        print("\nUser Account:")
        print("  Email: user@example.com")
        print("  Password: password123")
        print("="*50)
        print(f"\nCreated:")
        print(f"  - {len(products_data)} products")
        print(f"  - 2 users (1 admin, 1 regular)")
        print("="*50)

if __name__ == '__main__':
    init_database()
