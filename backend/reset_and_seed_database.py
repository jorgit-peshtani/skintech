"""
Complete database cleanup and reseed script
This will ensure both APIs use the SAME database with ALL 16 products
"""

import os
import sys
import shutil

# Step 1: Clean up all database files
print("=" * 70)
print("   STEP 1: Cleaning up database files")
print("=" * 70)

backend_dir = os.path.dirname(os.path.abspath(__file__))

# Remove any database files
db_files = [
    os.path.join(backend_dir, 'skintech.db'),
    os.path.join(backend_dir, 'instance', 'skintech.db'),
]

for db_file in db_files:
    if os.path.exists(db_file):
        os.remove(db_file)
        print(f"✅ Deleted: {db_file}")
    else:
        print(f"⏭️  Not found: {db_file}")

# Ensure instance directory exists
instance_dir = os.path.join(backend_dir, 'instance')
os.makedirs(instance_dir, exist_ok=True)
print(f"\n✅ Instance directory ready: {instance_dir}\n")

# Step 2: Create fresh database and seed
print("=" * 70)
print("   STEP 2: Creating fresh database")
print("=" * 70)

sys.path.insert(0, backend_dir)
from app import create_app
from extensions import db
from models import Product

app = create_app()

with app.app_context():
    # Create all tables
    db.create_all()
    print("✅ Database tables created\n")
    
    # Check if products exist
    existing = Product.query.count()
    print(f"Current products: {existing}")
    
    if existing > 0:
        print("⚠️  Products already exist, skipping seed")
    else:
        print("\n" + "=" * 70)
        print("   STEP 3: Seeding 16 products")
        print("=" * 70)
        
        # Product data
        products_data = [
            # Cleansers
            {
                "name": "Hydrating Cleanser",
                "brand": "CeraVe",
                "category": "Cleanser",
                "price": 14.99,
                "stock_quantity": 50,
                "description": "Gentle, non-foaming cleanser that effectively removes dirt and makeup while maintaining skin's natural moisture barrier. Formulated with ceramides and hyaluronic acid.",
                "ingredients": "Water, Glycerin, Cetearyl Alcohol, PEG-100 Stearate, Ceramides, Hyaluronic Acid",
                "suitable_for_skin_types": ["Normal", "Dry", "Sensitive"],
                "target_concerns": ["Dryness", "Irritation"]
            },
            {
                "name": "Effaclar Gel Cleanser",
                "brand": "La Roche-Posay",
                "category": "Cleanser",
                "price": 18.50,
                "stock_quantity": 45,
                "description": "Purifying foaming gel for oily, acne-prone skin. Removes excess oil and impurities without over-drying.",
                "ingredients": "Water, Sodium Laureth Sulfate, PEG-8, Zinc PCA, Glycerin",
                "suitable_for_skin_types": ["Oily", "Combination", "Acne-Prone"],
                "target_concerns": ["Acne", "Excess Oil", "Clogged Pores"]
            },
            {
                "name": "Squalane Cleanser",
                "brand": "The Ordinary",
                "category": "Cleanser",
                "price": 8.00,
                "stock_quantity": 60,
                "description": "Gentle, moisturizing cleanser that removes makeup and impurities while supporting skin's moisture barrier.",
                "ingredients": "Squalane, Aqua, Coco-Caprylate, Glycerin, Sucrose Stearate",
                "suitable_for_skin_types": ["All Skin Types", "Dry", "Sensitive"],
                "target_concerns": ["Dryness", "Makeup Removal"]
            },
            {
                "name": "Gentle Skin Cleanser",
                "brand": "Cetaphil",
                "category": "Cleanser",
                "price": 12.99,
                "stock_quantity": 55,
                "description": "Mild, non-irritating formula that soothes skin as it cleans. Clinically proven to be gentle on sensitive skin.",
                "ingredients": "Water, Cetyl Alcohol, Propylene Glycol, Sodium Lauryl Sulfate, Stearyl Alcohol",
                "suitable_for_skin_types": ["Sensitive", "Dry", "Normal"],
                "target_concerns": ["Sensitivity", "Dryness"]
            },
            
            # Moisturisers
            {
                "name": "Moisturising Cream",
                "brand": "CeraVe",
                "category": "Moisturiser",
                "price": 16.99,
                "stock_quantity": 40,
                "description": "Rich, non-greasy moisturizer with MVE Technology for 24-hour hydration. Contains ceramides to restore protective skin barrier.",
                "ingredients": "Water, Glycerin, Cetearyl Alcohol, Ceramides, Cholesterol, Hyaluronic Acid",
                "suitable_for_skin_types": ["Dry", "Normal", "Sensitive"],
                "target_concerns": ["Dryness", "Barrier Repair"]
            },
            {
                "name": "Toleriane Sensitive Rich Cream",
                "brand": "La Roche-Posay",
                "category": "Moisturiser",
                "price": 24.99,
                "stock_quantity": 35,
                "description": "Soothing moisturizer for sensitive skin. Provides immediate comfort and long-lasting hydration.",
                "ingredients": "Water, Squalane, Glycerin, Niacinamide, Shea Butter",
                "suitable_for_skin_types": ["Sensitive", "Dry", "Normal"],
                "target_concerns": ["Sensitivity", "Redness", "Dryness"]
            },
            {
                "name": "Hydro Boost Water Gel",
                "brand": "Neutrogena",
                "category": "Moisturiser",
                "price": 19.99,
                "stock_quantity": 50,
                "description": "Oil-free gel moisturizer with hyaluronic acid. Instantly quenches dry skin and keeps it looking smooth and supple.",
                "ingredients": "Water, Dimethicone, Glycerin, Dimethicone Crosspolymer, Hyaluronic Acid",
                "suitable_for_skin_types": ["Oily", "Combination", "Normal"],
                "target_concerns": ["Dehydration", "Dullness"]
            },
            {
                "name": "Natural Moisturizing Factors + HA",
                "brand": "The Ordinary",
                "category": "Moisturiser",
                "price": 7.50,
                "stock_quantity": 65,
                "description": "Surface hydration formula with amino acids, fatty acids, triglycerides, and hyaluronic acid.",
                "ingredients": "Water, Caprylic/Capric Triglyceride, Cetyl Alcohol, Sodium Hyaluronate",
                "suitable_for_skin_types": ["All Skin Types"],
                "target_concerns": ["Dehydration", "Dryness"]
            },
            
            # Sunscreens
            {
                "name": "Anthelios Ultra-Light SPF 50+",
                "brand": "La Roche-Posay",
                "category": "Sunscreen",
                "price": 32.00,
                "stock_quantity": 30,
                "description": "Very high broad-spectrum protection. Ultra-light, non-greasy texture. Water resistant.",
                "ingredients": "Avobenzone, Homosalate, Octisalate, Octocrylene, Mexoryl SX, Mexoryl XL",
                "suitable_for_skin_types": ["All Skin Types", "Sensitive"],
                "target_concerns": ["UV Protection", "Photoaging"]
            },
            {
                "name": "Oil Control Sun Gel-Cream SPF 50+",
                "brand": "Eucerin",
                "category": "Sunscreen",
                "price": 22.50,
                "stock_quantity": 38,
                "description": "Advanced spectral technology combines UV filters for very high UV protection with Licochalcone A.",
                "ingredients": "Homosalate, Octocrylene, Butyl Methoxydibenzoylmethane, Licochalcone A",
                "suitable_for_skin_types": ["Oily", "Acne-Prone", "Combination"],
                "target_concerns": ["UV Protection", "Excess Oil"]
            },
            {
                "name": "Photoderm MAX SPF 50+",
                "brand": "Bioderma",
                "category": "Sunscreen",
                "price": 28.99,
                "stock_quantity": 42,
                "description": "Maximum UVA/UVB protection. Activates skin's natural defenses and protects from cellular damage.",
                "ingredients": "Ethylhexyl Methoxycinnamate, Octocrylene, Titanium Dioxide",
                "suitable_for_skin_types": ["Sensitive", "Normal", "Dry"],
                "target_concerns": ["UV Protection", "Sensitivity"]
            },
            {
                "name": "Sun UV Face Shine Control SPF 50",
                "brand": "Nivea",
                "category": "Sunscreen",
                "price": 11.99,
                "stock_quantity": 48,
                "description": "Mattifying sun protection with anti-shine effect. Provides immediate UVA/UVB protection.",
                "ingredients": "Homosalate, Octisalate, Octocrylene, Butyl Methoxydibenzoylmethane",
                "suitable_for_skin_types": ["Oily", "Combination"],
                "target_concerns": ["UV Protection", "Shine Control"]
            },
            
            # Toners
            {
                "name": "2% BHA Liquid Exfoliant",
                "brand": "Paula's Choice",
                "category": "Toner",
                "price": 30.00,
                "stock_quantity": 32,
                "description": "Gentle exfoliating toner with salicylic acid. Unclogs pores and smooths wrinkles.",
                "ingredients": "Water, Methylpropanediol, Butylene Glycol, Salicylic Acid",
                "suitable_for_skin_types": ["Oily", "Combination", "Acne-Prone"],
                "target_concerns": ["Clogged Pores", "Blackheads", "Fine Lines"]
            },
            {
                "name": "Glycolic Acid 7% Toning Solution",
                "brand": "The Ordinary",
                "category": "Toner",
                "price": 8.70,
                "stock_quantity": 58,
                "description": "Exfoliating toner with glycolic acid. Improves skin radiance and clarity.",
                "ingredients": "Water, Glycolic Acid, Rosa damascena flower water, Centaurea cyanus flower water",
                "suitable_for_skin_types": ["Normal", "Combination"],
                "target_concerns": ["Dullness", "Uneven Texture", "Dark Spots"]
            },
            {
                "name": "Glow Tonic",
                "brand": "Pixi",
                "category": "Toner",
                "price": 15.00,
                "stock_quantity": 44,
                "description": "Exfoliating toner with 5% glycolic acid. Gently exfoliates for a radiant glow.",
                "ingredients": "Water, Aloe Vera, Glycolic Acid, Horse Chestnut, Ginseng",
                "suitable_for_skin_types": ["All Skin Types"],
                "target_concerns": ["Dullness", "Uneven Tone"]
            },
            {
                "name": "Supple Preparation Facial Toner",
                "brand": "Klairs",
                "category": "Toner",
                "price": 21.00,
                "stock_quantity": 40,
                "description": "Hydrating toner that balances skin's pH. Preps skin to absorb serums and treatments.",
                "ingredients": "Water, Beta-Glucan, Sodium Hyaluronate, Centella Asiatica Extract",
                "suitable_for_skin_types": ["Sensitive", "Dry", "Normal"],
                "target_concerns": ["Dryness", "Sensitivity", "Irritation"]
            },
        ]
        
        # Create products
        for data in products_data:
            product = Product(**data)
            db.session.add(product)
            print(f"✅ Added: {data['brand']} - {data['name']}")
        
        db.session.commit()
        print(f"\n🎉 Successfully seeded {len(products_data)} products!\n")
    
    # Final count inside app context
    total = Product.query.count()
    
    print("=" * 70)
    print("   ✅ DATABASE SETUP COMPLETE")
    print("=" * 70)
    print(f"\nDatabase location: {os.path.join(instance_dir, 'skintech.db')}")
    print(f"Total products: {total}")
    print("\nBoth app.py and admin_app.py will now use this database!")
    print("=" * 70)
