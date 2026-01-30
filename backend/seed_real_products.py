"""
Product Database Seeder - Add Real SkinTech Products
Adds 16 skincare products across 4 categories with descriptions
"""

import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from app import create_app
from extensions import db
from models import Product

def seed_products():
    """Seed database with real skincare products"""
    
    app = create_app()
    
    with app.app_context():
        # Clear existing products (optional - comment out to keep existing)
        print("🗑️  Clearing existing products...")
        Product.query.delete()
        
        products = [
            # CLEANSERS
            {
                'name': 'Hydrating Cleanser',
                'brand': 'CeraVe',
                'description': 'Gentle, non-foaming cleanser with 3 essential ceramides and hyaluronic acid. Perfect for normal to dry skin, removes makeup and dirt while maintaining skin\'s natural moisture barrier. Fragrance-free, non-comedogenic formula developed with dermatologists.',
                'category': 'Cleanser',
                'price': 14.99,
                'stock_quantity': 50,
                'image_url': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500',
                'ingredients': 'Ceramides, Hyaluronic Acid, Glycerin, Cholesterol',
                'suitable_for_skin_types': ['Normal', 'Dry', 'Sensitive'],
                'target_concerns': ['Dryness', 'Barrier Function']
            },
            {
                'name': 'Effaclar Gel Cleanser',
                'brand': 'La Roche-Posay',
                'description': 'Purifying foaming gel cleanser formulated for oily and acne-prone skin. Contains zinc pidolate to help remove excess oil while maintaining skin\'s pH balance. Soap-free formula cleanses without over-drying, leaving skin feeling fresh and clean.',
                'category': 'Cleanser',
                'price': 18.50,
                'stock_quantity': 45,
                'image_url': 'https://images.unsplash.com/photo-1571875257727-256c39da42af?w=500',
                'ingredients': 'Zinc Pidolate, Thermal Spring Water, Glycerin',
                'suitable_for_skin_types': ['Oily', 'Combination', 'Acne-Prone'],
                'target_concerns': ['Acne', 'Excess Oil', 'Large Pores']
            },
            {
                'name': 'Squalane Cleanser',
                'brand': 'The Ordinary',
                'description': 'Gentle, moisturizing cleansing balm formulated to target makeup removal. Plant-derived squalane supports the skin\'s moisture barrier while effectively removing makeup, dirt, and impurities. Leaves skin feeling smooth, nourished, and never stripped.',
                'category': 'Cleanser',
                'price': 8.00,
                'stock_quantity': 60,
                'image_url': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=500',
                'ingredients': 'Squalane, Caprylic/Capric Triglyceride, Sucrose Stearate',
                'suitable_for_skin_types': ['All Types', 'Dry', 'Sensitive'],
                'target_concerns': ['Makeup Removal', 'Dryness']
            },
            {
                'name': 'Gentle Skin Cleanser',
                'brand': 'Cetaphil',
                'description': 'Dermatologist-recommended gentle cleanser that soothes and softens as it cleans. Clinically proven to deep clean while maintaining the skin\'s moisture barrier. Ideal for sensitive skin and can be used with or without water for ultimate convenience.',
                'category': 'Cleanser',
                'price': 12.99,
                'stock_quantity': 55,
                'image_url': 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=500',
                'ingredients': 'Glycerin, Panthenol, Niacinamide',
                'suitable_for_skin_types': ['Sensitive', 'Dry', 'All Types'],
                'target_concerns': ['Sensitivity', 'Dryness', 'Irritation']
            },
            
            # MOISTURISERS
            {
                'name': 'Moisturising Cream',
                'brand': 'CeraVe',
                'description': 'Rich, non-greasy moisturizer with MVE Technology® for 24-hour hydration. Contains 3 essential ceramides to help restore and maintain the skin\'s protective barrier. Developed with dermatologists, this cream is suitable for both face and body use.',
                'category': 'Moisturiser',
                'price': 16.99,
                'stock_quantity': 48,
                'image_url': 'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500',
                'ingredients': 'Ceramides 1, 3, 6-II, Hyaluronic Acid, Petrolatum',
                'suitable_for_skin_types': ['Dry', 'Normal', 'Sensitive'],
                'target_concerns': ['Dryness', 'Barrier Repair', 'Hydration']
            },
            {
                'name': 'Toleriane Sensitive Rich Cream',
                'brand': 'La Roche-Posay',
                'description': 'Ultra-soothing moisturizer specifically designed for sensitive and dry skin. Enriched with neurosensine, niacinamide, and thermal spring water to immediately calm discomfort and strengthen skin\'s tolerance threshold over time. Fragrance-free and paraben-free.',
                'category': 'Moisturiser',
                'price': 21.50,
                'stock_quantity': 40,
                'image_url': 'https://images.unsplash.com/photo-1570554886111-e80fcca6a029?w=500',
                'ingredients': 'Neurosensine, Niacinamide, Thermal Spring Water, Shea Butter',
                'suitable_for_skin_types': ['Sensitive', 'Dry', 'Reactive'],
                'target_concerns': ['Sensitivity', 'Dryness', 'Redness']
            },
            {
                'name': 'Hydro Boost Water Gel',
                'brand': 'Neutrogena',
                'description': 'Oil-free gel moisturizer with purified hyaluronic acid that instantly quenches dry skin. Unique water-gel formula absorbs quickly like a gel but provides intense hydration like a cream. Non-comedogenic and ideal for combination to oily skin types.',
                'category': 'Moisturiser',
                'price': 15.99,
                'stock_quantity': 52,
                'image_url': 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=500',
                'ingredients': 'Hyaluronic Acid, Glycerin, Dimethicone',
                'suitable_for_skin_types': ['Combination', 'Oily', 'Normal'],
                'target_concerns': ['Dehydration', 'Oiliness']
            },
            {
                'name': 'Natural Moisturizing Factors + HA',
                'brand': 'The Ordinary',
                'description': 'Surface hydration formula that delivers elements found naturally in healthy skin. Amino acids, fatty acids, triglycerides, urea, ceramides, phospholipids, glycerin, saccharides, sodium PCA, and hyaluronic acid work together to support optimal barrier function and hydration.',
                'category': 'Moisturiser',
                'price': 7.50,
                'stock_quantity': 65,
                'image_url': 'https://images.unsplash.com/photo-1617897903246-719242758050?w=500',
                'ingredients': 'Amino Acids, Hyaluronic Acid, Ceramides, Urea, Glycerin',
                'suitable_for_skin_types': ['All Types', 'Dehydrated'],
                'target_concerns': ['Dehydration', 'Barrier Support']
            },
            
            # SPF/SUNSCREEN
            {
                'name': 'Anthelios Invisible Fluid SPF 50+',
                'brand': 'La Roche-Posay',
                'description': 'Ultra-light, invisible sunscreen with very high UVA/UVB protection. Advanced Anthelios XL protection technology provides broad-spectrum coverage against sun damage. Water-resistant, non-greasy, and won\'t leave white marks on any skin tone.',
                'category': 'Sunscreen',
                'price': 19.99,
                'stock_quantity': 42,
                'image_url': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=500',
                'ingredients': 'Mexoryl XL, Mexoryl SX, Thermal Spring Water',
                'suitable_for_skin_types': ['All Types', 'Sensitive'],
                'target_concerns': ['Sun Protection', 'UV Damage', 'Aging']
            },
            {
                'name': 'Oil Control Sun Gel-Cream SPF 50+',
                'brand': 'Eucerin',
                'description': 'Mattifying sun gel-cream with Oil Control Technology specifically for oily and acne-prone skin. Provides very high sun protection while offering an impressive 8-hour anti-shine effect. Non-comedogenic, water-resistant, and won\'t clog pores.',
                'category': 'Sunscreen',
                'price': 17.50,
                'stock_quantity': 38,
                'image_url': 'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500',
                'ingredients': 'Oil Control Technology, UVA/UVB Filters, L-Carnitine',
                'suitable_for_skin_types': ['Oily', 'Acne-Prone', 'Combination'],
                'target_concerns': ['Sun Protection', 'Oiliness', 'Shine']
            },
            {
                'name': 'Photoderm MAX Cream SPF 50+',
                'brand': 'Bioderma',
                'description': 'Very high sun protection cream with exclusive Cellular Bioprotection® patent. Activates the skin\'s natural defenses, protects from cellular damage, and fights premature skin aging. Particularly suitable for very fair, sun-intolerant, or recently-treated skin.',
                'category': 'Sunscreen',
                'price': 18.99,
                'stock_quantity': 35,
                'image_url': 'https://images.unsplash.com/photo-1571875257727-256c39da42af?w=500',
                'ingredients': 'Cellular Bioprotection®, UVA/UVB Filters, Vitamin E',
                'suitable_for_skin_types': ['Very Fair', 'Sensitive', 'All Types'],
                'target_concerns': ['Sun Protection', 'UV Damage', 'Anti-aging']
            },
            {
                'name': 'Sun UV Face Shine Control SPF 50',
                'brand': 'Nivea',
                'description': 'Lightweight facial sunscreen with immediate mattifying effect for a naturally matte finish. Formulated with Liquorice Extract for an even complexion and provides up to 12 hours of shine control. Non-greasy, fast-absorbing formula perfect for daily use under makeup.',
                'category': 'Sunscreen',
                'price': 9.99,
                'stock_quantity': 50,
                'image_url': 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=500',
                'ingredients': 'Liquorice Extract, UVA/UVB Filters, Silica',
                'suitable_for_skin_types': ['Oily', 'Combination', 'Normal'],
                'target_concerns': ['Sun Protection', 'Shine', 'Oiliness']
            },
            
            # TONERS
            {
                'name': 'Skin Perfecting 2% BHA Liquid Exfoliant',
                'brand': 'Paula\'s Choice',
                'description': 'Gentle leave-on exfoliant with salicylic acid that unclogs and diminishes enlarged pores, exfoliates dead skin cells, smooths wrinkles, and brightens skin. Combats redness, aging signs, and breakouts for beautiful, radiant skin. Game-changer for combination to oily skin.',
                'category': 'Toner',
                'price': 32.00,
                'stock_quantity': 30,
                'image_url': 'https://images.unsplash.com/photo-1570554886111-e80fcca6a029?w=500',
                'ingredients': '2% BHA (Salicylic Acid), Green Tea, Methylpropanediol',
                'suitable_for_skin_types': ['Combination', 'Oily', 'Acne-Prone'],
                'target_concerns': ['Large Pores', 'Blackheads', 'Texture', 'Acne']
            },
            {
                'name': 'Glycolic Acid 7% Toning Solution',
                'brand': 'The Ordinary',
                'description': 'Exfoliating toner with 7% glycolic acid to improve skin radiance, clarity, and texture. Helps target uneven tone, textural irregularities, and fine lines for a brighter complexion. Enhanced with amino acids, aloe vera, ginseng, and tasmanian pepperberry for added skin benefits.',
                'category': 'Toner',
                'price': 8.70,
                'stock_quantity': 55,
                'image_url': 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=500',
                'ingredients': '7% Glycolic Acid, Aloe Vera, Ginseng, Tasmanian Pepperberry',
                'suitable_for_skin_types': ['Normal', 'Combination', 'Oily'],
                'target_concerns': ['Dullness', 'Texture', 'Uneven Tone', 'Fine Lines']
            },
            {
                'name': 'Glow Tonic',
                'brand': 'Pixi',
                'description': 'Cult-favorite exfoliating toner with 5% glycolic acid that gently removes dead skin cells to reveal fresh, glowing skin. Infused with aloe vera to soothe and ginseng to energize the complexion. Helps improve skin texture, tone, and overall radiance without irritation.',
                'category': 'Toner',
                'price': 15.00,
                'stock_quantity': 45,
                'image_url': 'https://images.unsplash.com/photo-1617897903246-719242758050?w=500',
                'ingredients': '5% Glycolic Acid, Aloe Vera, Ginseng, Witch Hazel',
                'suitable_for_skin_types': ['All Types', 'Dull', 'Combination'],
                'target_concerns': ['Dullness', 'Texture', 'Uneven Tone']
            },
            {
                'name': 'Supple Preparation Facial Toner',
                'brand': 'Klairs',
                'description': 'Balancing facial toner that preps skin to absorb subsequent products more effectively. Contains plant-based extracts like phyto-oligo and beta-glucan to deeply soothe, strengthen, and hydrate. Gentle enough for sensitive skin and free from artificial fragrance and essential oils.',
                'category': 'Toner',
                'price': 21.00,
                'stock_quantity': 40,
                'image_url': 'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=500',
                'ingredients': 'Phyto-oligo, Beta-glucan, Centella Asiatica, Aloe Vera',
                'suitable_for_skin_types': ['Sensitive', 'Dry', 'All Types'],
                'target_concerns': ['Sensitivity', 'Dryness', 'Hydration']
            }
        ]
        
        print(f"📦 Adding {len(products)} products to database...\n")
        
        for product_data in products:
            product = Product(**product_data)
            db.session.add(product)
            print(f"✅ Added: {product_data['brand']} {product_data['name']} - ${product_data['price']}")
        
        db.session.commit()
        
        print(f"\n🎉 Successfully added {len(products)} products!")
        print("\n📊 Product Summary:")
        
        # Count by category
        categories = {}
        for p in products:
            cat = p['category']
            categories[cat] = categories.get(cat, 0) + 1
        
        for cat, count in categories.items():
            print(f"  - {cat}: {count} products")
        
        # Count by brand
        print("\n🏷️  Brands:")
        brands = {}
        for p in products:
            brand = p['brand']
            brands[brand] = brands.get(brand, 0) + 1
        
        for brand, count in sorted(brands.items()):
            print(f"  - {brand}: {count} products")

if __name__ == '__main__':
    print("=" * 50)
    print("   SkinTech Product Database Seeder")
    print("=" * 50)
    print()
    
    seed_products()
    
    print("\n" + "=" * 50)
    print("   Seeding Complete!")
    print("=" * 50)
