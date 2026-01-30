"""
Seed products into existing database
Run this after database is cleaned
"""

import os
import sys

backend_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, backend_dir)

from app import create_app
from extensions import db
from models import Product

app = create_app()

print("=" * 70)
print("   Seeding Products into Database")
print("=" * 70)

with app.app_context():
    # Check existing
    existing = Product.query.count()
    print(f"Current products in database: {existing}\n")
    
    if existing >= 16:
        print("✅ Database already has products. Done!")
        sys.exit(0)
    
    # Product data
    products_data = [
        # Cleansers
        {"name": "Hydrating Cleanser", "brand": "CeraVe", "category": "Cleanser", "price": 14.99, "stock_quantity": 50,
         "description": "Gentle, non-foaming cleanser that effectively removes dirt and makeup while maintaining skin's natural moisture barrier.",
         "ingredients": "Water, Glycerin, Cetearyl Alcohol, PEG-100 Stearate, Ceramides, Hyaluronic Acid",
         "suitable_for_skin_types": ["Normal", "Dry", "Sensitive"], "target_concerns": ["Dryness", "Irritation"]},
        
        {"name": "Effaclar Gel Cleanser", "brand": "La Roche-Posay", "category": "Cleanser", "price": 18.50, "stock_quantity": 45,
         "description": "Purifying foaming gel for oily, acne-prone skin. Removes excess oil without over-drying.",
         "ingredients": "Water, Sodium Laureth Sulfate, PEG-8, Zinc PCA, Glycerin",
         "suitable_for_skin_types": ["Oily", "Combination", "Acne-Prone"], "target_concerns": ["Acne", "Excess Oil"]},
        
        {"name": "Squalane Cleanser", "brand": "The Ordinary", "category": "Cleanser", "price": 8.00, "stock_quantity": 60,
         "description": "Gentle, moisturizing cleanser that removes makeup and impurities.",
         "ingredients": "Squalane, Aqua, Coco-Caprylate, Glycerin, Sucrose Stearate",
         "suitable_for_skin_types": ["All Skin Types", "Dry", "Sensitive"], "target_concerns": ["Dryness", "Makeup Removal"]},
        
        {"name": "Gentle Skin Cleanser", "brand": "Cetaphil", "category": "Cleanser", "price": 12.99, "stock_quantity": 55,
         "description": "Mild, non-irritating formula that soothes skin as it cleans.",
         "ingredients": "Water, Cetyl Alcohol, Propylene Glycol, Sodium Lauryl Sulfate",
         "suitable_for_skin_types": ["Sensitive", "Dry", "Normal"], "target_concerns": ["Sensitivity", "Dryness"]},
        
        # Moisturisers
        {"name": "Moisturising Cream", "brand": "CeraVe", "category": "Moisturiser", "price": 16.99, "stock_quantity": 40,
         "description": "Rich moisturizer with MVE Technology for 24-hour hydration.",
         "ingredients": "Water, Glycerin, Cetearyl Alcohol, Ceramides, Hyaluronic Acid",
         "suitable_for_skin_types": ["Dry", "Normal", "Sensitive"], "target_concerns": ["Dryness", "Barrier Repair"]},
        
        {"name": "Toleriane Sensitive Rich Cream", "brand": "La Roche-Posay", "category": "Moisturiser", "price": 24.99, "stock_quantity": 35,
         "description": "Soothing moisturizer for sensitive skin with immediate comfort.",
         "ingredients": "Water, Squalane, Glycerin, Niacinamide, Shea Butter",
         "suitable_for_skin_types": ["Sensitive", "Dry", "Normal"], "target_concerns": ["Sensitivity", "Redness"]},
        
        {"name": "Hydro Boost Water Gel", "brand": "Neutrogena", "category": "Moisturiser", "price": 19.99, "stock_quantity": 50,
         "description": "Oil-free gel moisturizer with hyaluronic acid for smooth skin.",
         "ingredients": "Water, Dimethicone, Glycerin, Hyaluronic Acid",
         "suitable_for_skin_types": ["Oily", "Combination", "Normal"], "target_concerns": ["Dehydration", "Dullness"]},
        
        {"name": "Natural Moisturizing Factors + HA", "brand": "The Ordinary", "category": "Moisturiser", "price": 7.50, "stock_quantity": 65,
         "description": "Surface hydration formula with amino acids and hyaluronic acid.",
         "ingredients": "Water, Caprylic/Capric Triglyceride, Sodium Hyaluronate",
         "suitable_for_skin_types": ["All Skin Types"], "target_concerns": ["Dehydration", "Dryness"]},
        
        # Sunscreens
        {"name": "Anthelios Ultra-Light SPF 50+", "brand": "La Roche-Posay", "category": "Sunscreen", "price": 32.00, "stock_quantity": 30,
         "description": "Very high broad-spectrum protection. Ultra-light, non-greasy.",
         "ingredients": "Avobenzone, Homosalate, Octisalate, Mexoryl SX",
         "suitable_for_skin_types": ["All Skin Types", "Sensitive"], "target_concerns": ["UV Protection", "Photoaging"]},
        
        {"name": "Oil Control Sun Gel-Cream SPF 50+", "brand": "Eucerin", "category": "Sunscreen", "price": 22.50, "stock_quantity": 38,
         "description": "Advanced UV protection with oil control for acne-prone skin.",
         "ingredients": "Homosalate, Octocrylene, Licochalcone A",
         "suitable_for_skin_types": ["Oily", "Acne-Prone", "Combination"], "target_concerns": ["UV Protection", "Oil Control"]},
        
        {"name": "Photoderm MAX SPF 50+", "brand": "Bioderma", "category": "Sunscreen", "price": 28.99, "stock_quantity": 42,
         "description": "Maximum UVA/UVB protection for sensitive skin.",
         "ingredients": "Ethylhexyl Methoxycinnamate, Octocrylene, Titanium Dioxide",
         "suitable_for_skin_types": ["Sensitive", "Normal", "Dry"], "target_concerns": ["UV Protection", "Sensitivity"]},
        
        {"name": "Sun UV Face Shine Control SPF 50", "brand": "Nivea", "category": "Sunscreen", "price": 11.99, "stock_quantity": 48,
         "description": "Mattifying sun protection with anti-shine effect.",
         "ingredients": "Homosalate, Octisalate, Octocrylene",
         "suitable_for_skin_types": ["Oily", "Combination"], "target_concerns": ["UV Protection", "Shine Control"]},
        
        # Toners
        {"name": "2% BHA Liquid Exfoliant", "brand": "Paula's Choice", "category": "Toner", "price": 30.00, "stock_quantity": 32,
         "description": "Gentle exfoliating toner with salicylic acid. Unclogs pores.",
         "ingredients": "Water, Methylpropanediol, Salicylic Acid",
         "suitable_for_skin_types": ["Oily", "Combination", "Acne-Prone"], "target_concerns": ["Clogged Pores", "Blackheads"]},
        
        {"name": "Glycolic Acid 7% Toning Solution", "brand": "The Ordinary", "category": "Toner", "price": 8.70, "stock_quantity": 58,
         "description": "Exfoliating toner with glycolic acid for radiant skin.",
         "ingredients": "Water, Glycolic Acid, Rosa damascena flower water",
         "suitable_for_skin_types": ["Normal", "Combination"], "target_concerns": ["Dullness", "Uneven Texture"]},
        
        {"name": "Glow Tonic", "brand": "Pixi", "category": "Toner", "price": 15.00, "stock_quantity": 44,
         "description": "Exfoliating toner with 5% glycolic acid for a radiant glow.",
         "ingredients": "Water, Aloe Vera, Glycolic Acid, Ginseng",
         "suitable_for_skin_types": ["All Skin Types"], "target_concerns": ["Dullness", "Uneven Tone"]},
        
        {"name": "Supple Preparation Facial Toner", "brand": "Klairs", "category": "Toner", "price": 21.00, "stock_quantity": 40,
         "description": "Hydrating toner that balances skin's pH and preps for serums.",
         "ingredients": "Water, Beta-Glucan, Sodium Hyaluronate, Centella Asiatica",
         "suitable_for_skin_types": ["Sensitive", "Dry", "Normal"], "target_concerns": ["Dryness", "Sensitivity"]},
    ]
    
    print("Adding products...\n")
    for data in products_data:
        product = Product(**data)
        db.session.add(product)
        print(f"✅ {data['brand']} - {data['name']}")
    
    db.session.commit()
    
    total = Product.query.count()
    print(f"\n🎉 Successfully added {len(products_data)} products!")
    print(f"📦 Total products in database: {total}")
    print("=" * 70)
