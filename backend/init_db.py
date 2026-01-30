"""
Database initialization script with sample data
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
        
        # Create sample ingredients
        print("Creating ingredient database...")
        ingredients_data = [
            {
                'name': 'Water',
                'inci_name': 'Aqua',
                'description': 'The most common cosmetic ingredient, used as a solvent',
                'function': 'Solvent',
                'safety_rating': 1,
                'comedogenic_rating': 0,
                'effects': {'dry': 'neutral', 'oily': 'neutral', 'combination': 'neutral', 'sensitive': 'neutral'},
                'is_allergen': False,
                'is_irritant': False,
                'pregnancy_safe': True
            },
            {
                'name': 'Glycerin',
                'inci_name': 'Glycerin',
                'description': 'A humectant that draws moisture into the skin',
                'function': 'Moisturizer, Humectant',
                'safety_rating': 1,
                'comedogenic_rating': 0,
                'effects': {'dry': 'beneficial', 'oily': 'neutral', 'combination': 'beneficial', 'sensitive': 'beneficial'},
                'is_allergen': False,
                'is_irritant': False,
                'pregnancy_safe': True
            },
            {
                'name': 'Niacinamide',
                'inci_name': 'Niacinamide',
                'description': 'Vitamin B3, helps reduce inflammation and hyperpigmentation',
                'function': 'Antioxidant, Anti-aging, Brightening',
                'safety_rating': 1,
                'comedogenic_rating': 0,
                'effects': {'dry': 'beneficial', 'oily': 'beneficial', 'combination': 'beneficial', 'sensitive': 'beneficial'},
                'is_allergen': False,
                'is_irritant': False,
                'pregnancy_safe': True
            },
            {
                'name': 'Hyaluronic Acid',
                'inci_name': 'Sodium Hyaluronate',
                'description': 'Powerful humectant that can hold up to 1000x its weight in water',
                'function': 'Moisturizer, Humectant',
                'safety_rating': 1,
                'comedogenic_rating': 0,
                'effects': {'dry': 'beneficial', 'oily': 'beneficial', 'combination': 'beneficial', 'sensitive': 'beneficial'},
                'is_allergen': False,
                'is_irritant': False,
                'pregnancy_safe': True
            },
            {
                'name': 'Retinol',
                'inci_name': 'Retinol',
                'description': 'Vitamin A derivative, powerful anti-aging ingredient',
                'function': 'Anti-aging, Cell turnover',
                'safety_rating': 3,
                'comedogenic_rating': 2,
                'effects': {'dry': 'neutral', 'oily': 'beneficial', 'combination': 'beneficial', 'sensitive': 'avoid'},
                'is_allergen': False,
                'is_irritant': True,
                'pregnancy_safe': False
            },
            {
                'name': 'Salicylic Acid',
                'inci_name': 'Salicylic Acid',
                'description': 'BHA that exfoliates and unclogs pores',
                'function': 'Exfoliant, Anti-acne',
                'safety_rating': 2,
                'comedogenic_rating': 0,
                'effects': {'dry': 'avoid', 'oily': 'beneficial', 'combination': 'beneficial', 'sensitive': 'avoid'},
                'is_allergen': False,
                'is_irritant': True,
                'pregnancy_safe': True
            },
            {
                'name': 'Vitamin C',
                'inci_name': 'Ascorbic Acid',
                'description': 'Powerful antioxidant that brightens skin',
                'function': 'Antioxidant, Brightening',
                'safety_rating': 2,
                'comedogenic_rating': 0,
                'effects': {'dry': 'beneficial', 'oily': 'beneficial', 'combination': 'beneficial', 'sensitive': 'neutral'},
                'is_allergen': False,
                'is_irritant': True,
                'pregnancy_safe': True
            },
            {
                'name': 'Ceramides',
                'inci_name': 'Ceramide NP',
                'description': 'Lipids that help restore and maintain skin barrier',
                'function': 'Moisturizer, Barrier repair',
                'safety_rating': 1,
                'comedogenic_rating': 0,
                'effects': {'dry': 'beneficial', 'oily': 'neutral', 'combination': 'beneficial', 'sensitive': 'beneficial'},
                'is_allergen': False,
                'is_irritant': False,
                'pregnancy_safe': True
            },
            {
                'name': 'Fragrance',
                'inci_name': 'Parfum',
                'description': 'Added for scent, can be irritating',
                'function': 'Fragrance',
                'safety_rating': 6,
                'comedogenic_rating': 0,
                'effects': {'dry': 'avoid', 'oily': 'neutral', 'combination': 'neutral', 'sensitive': 'avoid'},
                'is_allergen': True,
                'is_irritant': True,
                'pregnancy_safe': True
            },
            {
                'name': 'Parabens',
                'inci_name': 'Methylparaben',
                'description': 'Preservative, controversial ingredient',
                'function': 'Preservative',
                'safety_rating': 5,
                'comedogenic_rating': 0,
                'effects': {'dry': 'neutral', 'oily': 'neutral', 'combination': 'neutral', 'sensitive': 'avoid'},
                'is_allergen': True,
                'is_irritant': False,
                'pregnancy_safe': False
            }
        ]
        
        for ing_data in ingredients_data:
            ingredient = Ingredient(**ing_data)
            db.session.add(ingredient)
        
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
            {
                'name': 'Intensive Moisturizer',
                'brand': 'HydraLux',
                'description': 'Rich moisturizer for dry and sensitive skin',
                'category': 'Moisturizer',
                'price': 34.99,
                'stock_quantity': 90,
                'image_url': '/images/products/moisturizer.jpg',
                'ingredients': 'Aqua, Glycerin, Ceramide NP, Hyaluronic Acid, Niacinamide',
                'is_certified': True,
                'suitable_for_skin_types': ['dry', 'sensitive'],
                'target_concerns': ['dryness', 'sensitivity']
            },
            {
                'name': 'Brightening Face Mask',
                'brand': 'GlowUp',
                'description': 'Weekly brightening mask with vitamin C',
                'category': 'Mask',
                'price': 29.99,
                'stock_quantity': 60,
                'image_url': '/images/products/mask.jpg',
                'ingredients': 'Aqua, Ascorbic Acid, Niacinamide, Glycerin, Hyaluronic Acid',
                'is_certified': True,
                'suitable_for_skin_types': ['normal', 'dry', 'combination', 'oily'],
                'target_concerns': ['dark_spots', 'dullness']
            },
            {
                'name': 'Gentle Exfoliating Toner',
                'brand': 'SkinTech',
                'description': 'Daily toner with gentle exfoliants',
                'category': 'Toner',
                'price': 22.99,
                'stock_quantity': 110,
                'image_url': '/images/products/toner.jpg',
                'ingredients': 'Aqua, Glycerin, Niacinamide, Hyaluronic Acid',
                'is_certified': True,
                'suitable_for_skin_types': ['normal', 'oily', 'combination'],
                'target_concerns': ['oiliness', 'texture']
            }
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
        print(f"  - {len(ingredients_data)} ingredients")
        print(f"  - {len(products_data)} products")
        print(f"  - 2 users (1 admin, 1 regular)")
        print("="*50)

if __name__ == '__main__':
    init_database()
