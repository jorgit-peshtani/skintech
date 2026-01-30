"""
Update product images with generated placeholder URLs
This will add proper cover images for each product
"""

import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from app import create_app
from extensions import db
from models import Product

app = create_app()

# Product image URLs (using placeholder service)
PRODUCT_IMAGES = {
    "CeraVe Hydrating Cleanser": "https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500",
    "La Roche-Posay Effaclar Gel Cleanser": "https://images.unsplash.com/photo-1556228852-80c3ca9c8e3c?w=500",
    "The Ordinary Squalane Cleanser": "https://images.unsplash.com/photo-1556228841-15f9b3e0e7e9?w=500",
    "Cetaphil Gentle Skin Cleanser": "https://images.unsplash.com/photo-1556228735-9bf7be5f61ff?w=500",
    
    "CeraVe Moisturising Cream": "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=500",
    "La Roche-Posay Toleriane Sensitive Rich Cream": "https://images.unsplash.com/photo-1571782742478-0816d0e95384?w=500",
    "Neutrogena Hydro Boost Water Gel": "https://images.unsplash.com/photo-1570554886111-e80fcca6a029?w=500",
    "The Ordinary Natural Moisturizing Factors + HA": "https://images.unsplash.com/photo-1598440947619-2c35fc9aa908?w=500",
    
    "La Roche-Posay Anthelios Ultra-Light SPF 50+": "https://images.unsplash.com/photo-1583241800698-4f6d3e8d0c56?w=500",
    "Eucerin Oil Control Sun Gel-Cream SPF 50+": "https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=500",
    "Bioderma Photoderm MAX SPF 50+": "https://images.unsplash.com/photo-1610458925006-c381b3ad8cc5?w=500",
    "Nivea Sun UV Face Shine Control SPF 50": "https://images.unsplash.com/photo-1591360236480-4ed861025fa1?w=500",
    
    "Paula's Choice 2% BHA Liquid Exfoliant": "https://images.unsplash.com/photo-1620916297824-05d39c6f3b0e?w=500",
    "The Ordinary Glycolic Acid 7% Toning Solution": "https://images.unsplash.com/photo-1608248543742-892f9c5f4c7c?w=500",
    "Pixi Glow Tonic": "https://images.unsplash.com/photo-1617897903246-719242758050?w=500",
    "Klairs Supple Preparation Facial Toner": "https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=500",
}

with app.app_context():
    print("=" * 60)
    print("   Updating Product Images")
    print("=" * 60)
    
    products = Product.query.all()
    updated = 0
    
    for product in products:
        if product.name in PRODUCT_IMAGES:
            product.image_url = PRODUCT_IMAGES[product.name]
            updated += 1
            print(f"✅ Updated: {product.name}")
    
    db.session.commit()
    
    print(f"\n🎉 Updated {updated} product images!")
    print("=" * 60)
