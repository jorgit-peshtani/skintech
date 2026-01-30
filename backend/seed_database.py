"""
Database Seeding Script for SkinTech
Populates the database with sample data for testing
"""

import sys
import os
from datetime import datetime, timedelta
import random

# Add parent directory to path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app import create_app
from extensions import db
from models import User, Product, Order, OrderItem, ProductScan, Ingredient, Review

def seed_database():
    """Seed the database with sample data"""
    app = create_app()
    
    with app.app_context():
        print("=" * 60)
        print("🌱 Seeding SkinTech Database")
        print("=" * 60)
        
        # Clear existing data (optional - comment out to keep existing data)
        print("\n⚠️  Clearing existing data...")
        db.drop_all()
        db.create_all()
        print("✅ Tables recreated")
        
        # 1. Create Users
        print("\n👥 Creating users...")
        users = []
        
        # Admin user
        admin = User(
            email='admin@skintech.com',
            username='admin',
            is_admin=True,
            is_active=True
        )
        admin.set_password('admin123')
        users.append(admin)
        
        # Regular users
        user_data = [
            ('john@example.com', 'john_doe', 'password123'),
            ('sarah@example.com', 'sarah_wilson', 'password123'),
            ('mike@example.com', 'mike_jones', 'password123'),
            ('user@example.com', 'demo_user', 'password123'),
            ('emily@example.com', 'emily_brown', 'password123'),
        ]
        
        for email, username, password in user_data:
            user = User(
                email=email,
                username=username,
                is_admin=False,
                is_active=True
            )
            user.set_password(password)
            users.append(user)
        
        db.session.add_all(users)
        db.session.commit()
        print(f"✅ Created {len(users)} users")
        
        # 2. Create Ingredients
        print("\n🧪 Creating ingredients...")
        ingredients_data = [
            ('Hyaluronic Acid', 'Hydration powerhouse', 'safe', 9),
            ('Retinol', 'Anti-aging vitamin A', 'caution', 8),
            ('Niacinamide', 'Brightening B vitamin', 'safe', 9),
            ('Vitamin C', 'Antioxidant brightener', 'safe', 9),
            ('Salicylic Acid', 'Acne-fighting BHA', 'caution', 7),
            ('Glycolic Acid', 'Exfoliating AHA', 'caution', 7),
            ('Ceramides', 'Skin barrier support', 'safe', 9),
            ('Peptides', 'Collagen builders', 'safe', 8),
            ('Parabens', 'Controversial preservative', 'avoid', 3),
            ('Fragrance', 'Potential irritant', 'caution', 5),
        ]
        
        ingredients = []
        for name, desc, safety, rating in ingredients_data:
            ing = Ingredient(
                name=name,
                description=desc,
                safety_rating=safety,
                benefits=desc,
                concerns='None' if safety == 'safe' else 'May cause irritation',
                overall_rating=rating
            )
            ingredients.append(ing)
        
        db.session.add_all(ingredients)
        db.session.commit()
        print(f"✅ Created {len(ingredients)} ingredients")
        
        # 3. Create Products
        print("\n🛍️  Creating products...")
        products_data = [
            ('CeraVe Hydrating Cleanser', 'CeraVe', 'cleanser', 14.99, 50),
            ('The Ordinary Niacinamide', 'The Ordinary', 'serum', 5.99, 100),
            ('La Roche-Posay Sunscreen', 'La Roche-Posay', 'sunscreen', 29.99, 75),
            ('Neutrogena Oil-Free Moisturizer', 'Neutrogena', 'moisturizer', 12.99, 60),
            ('Paula\'s Choice BHA', 'Paula\'s Choice', 'exfoliant', 29.50, 40),
            ('Drunk Elephant C-Firma', 'Drunk Elephant', 'serum', 80.00, 25),
            ('Cetaphil Gentle Cleanser', 'Cetaphil', 'cleanser', 9.99, 80),
            ('Kiehl\'s Ultra Facial Cream', 'Kiehl\'s', 'moisturizer', 32.00, 45),
            ('Glossier Solution', 'Glossier', 'toner', 24.00, 55),
            ('Laneige Sleeping Mask', 'Laneige', 'mask', 25.00, 30),
        ]
        
        products = []
        for name, brand, category, price, stock in products_data:
            product = Product(
                name=name,
                brand=brand,
                category=category,
                price=price,
                stock_quantity=stock,
                description=f'Premium {category} from {brand}',
                is_active=True
            )
            products.append(product)
        
        db.session.add_all(products)
        db.session.commit()
        print(f"✅ Created {len(products)} products")
        
        # 4. Create Orders
        print("\n📦 Creating orders...")
        statuses = ['pending', 'paid', 'shipped', 'delivered']
        orders = []
        
        for i, user in enumerate(users[1:4]):  # Skip admin, use first 3 regular users
            for j in range(random.randint(1, 3)):  # 1-3 orders per user
                order = Order(
                    user_id=user.id,
                    order_number=f'ORD-{1000 + i * 10 + j}',
                    status=random.choice(statuses),
                    total=random.uniform(20, 150),
                    created_at=datetime.utcnow() - timedelta(days=random.randint(0, 30))
                )
                
                # Add order items
                num_items = random.randint(1, 3)
                selected_products = random.sample(products, num_items)
                
                for product in selected_products:
                    order_item = OrderItem(
                        order=order,
                        product_id=product.id,
                        quantity=random.randint(1, 2),
                        price=product.price
                    )
                    db.session.add(order_item)
                
                orders.append(order)
        
        db.session.add_all(orders)
        db.session.commit()
        print(f"✅ Created {len(orders)} orders")
        
        # 5. Create Product Scans
        print("\n🔬 Creating product scans...")
        scans = []
        
        for i, user in enumerate(users[1:]):  # All regular users
            for _ in range(random.randint(2, 5)):  # 2-5 scans per user
                scan = ProductScan(
                    user_id=user.id,
                    product_name=random.choice(products).name,
                    overall_rating=random.randint(5, 10),
                    ingredient_count=random.randint(10, 25),
                    safe_ingredients=random.randint(8, 20),
                    caution_ingredients=random.randint(0, 5),
                    avoid_ingredients=random.randint(0, 2),
                    created_at=datetime.utcnow() - timedelta(days=random.randint(0, 60))
                )
                scans.append(scan)
        
        db.session.add_all(scans)
        db.session.commit()
        print(f"✅ Created {len(scans)} product scans")
        
        # 6. Create Reviews
        print("\n⭐ Creating reviews...")
        reviews = []
        review_texts = [
            "Great product! Really improved my skin.",
            "Love this! Will buy again.",
            "Good value for money.",
            "Works well, but takes time to see results.",
            "Amazing! Highly recommend.",
        ]
        
        for product in products[:5]:  # Reviews for first 5 products
            for user in random.sample(users[1:], random.randint(2, 4)):
                review = Review(
                    user_id=user.id,
                    product_id=product.id,
                    rating=random.randint(3, 5),
                    comment=random.choice(review_texts)
                )
                reviews.append(review)
        
        db.session.add_all(reviews)
        db.session.commit()
        print(f"✅ Created {len(reviews)} reviews")
        
        # Summary
        print("\n" + "=" * 60)
        print("✅ Database Seeding Complete!")
        print("=" * 60)
        print(f"📊 Summary:")
        print(f"   Users: {len(users)}")
        print(f"   Products: {len(products)}")
        print(f"   Ingredients: {len(ingredients)}")
        print(f"   Orders: {len(orders)}")
        print(f"   Scans: {len(scans)}")
        print(f"   Reviews: {len(reviews)}")
        print("=" * 60)
        print("\n🎯 Test Accounts:")
        print("   Admin:  admin@skintech.com / admin123")
        print("   User:   user@example.com / password123")
        print("=" * 60)

if __name__ == '__main__':
    seed_database()
