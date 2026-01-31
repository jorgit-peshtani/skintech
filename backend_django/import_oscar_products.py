"""
Script to import products into Django Oscar
Run with: python import_oscar_products.py
"""
import os
import django
import sys

# Setup Django
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'skintech_django.settings')
django.setup()

from oscar.apps.catalogue.models import Product, ProductClass, Category
from oscar.apps.partner.models import Partner, StockRecord
from decimal import Decimal

print("=" * 70)
print("  Importing Products to Django Oscar")
print("=" * 70)

# Products data
products_data = [
    {'name': 'Hydrating Cleanser', 'brand': 'CeraVe', 'description': 'Gentle hydrating cleanser with ceramides and hyaluronic acid', 'price': 12.99, 'category': 'Cleanser', 'stock': 150},
    {'name': 'Effaclar Gel Cleanser', 'brand': 'La Roche-Posay', 'description': 'Purifying foaming gel for oily sensitive skin', 'price': 18.50, 'category': 'Cleanser', 'stock': 120},
    {'name': 'Squalane Cleanser', 'brand': 'The Ordinary', 'description': 'Gentle cleansing balm with squalane', 'price': 8.90, 'category': 'Cleanser', 'stock': 200},
    {'name': 'Gentle Skin Cleanser', 'brand': 'Cetaphil', 'description': 'Mild, non-irritating formula for sensitive skin', 'price': 10.99, 'category': 'Cleanser', 'stock': 180},
    {'name': 'Moisturising Cream', 'brand': 'CeraVe', 'description': 'Daily moisturizer with ceramides for dry skin', 'price': 15.99, 'category': 'Moisturiser', 'stock': 140},
    {'name': 'Toleriane Sensitive Rich Cream', 'brand': 'La Roche-Posay', 'description': 'Soothing moisturizer for sensitive skin', 'price': 22.00, 'category': 'Moisturiser', 'stock': 100},
    {'name': 'Hydro Boost Water Gel', 'brand': 'Neutrogena', 'description': 'Oil-free gel-cream with hyaluronic acid', 'price': 16.50, 'category': 'Moisturiser', 'stock': 160},
    {'name': 'Natural Moisturizing Factors + HA', 'brand': 'The Ordinary', 'description': 'Light moisturizer with amino acids and hyaluronic acid', 'price': 7.50, 'category': 'Moisturiser', 'stock': 220},
    {'name': 'Anthelios Ultra-Light SPF 50+', 'brand': 'La Roche-Posay', 'description': 'Very high protection sunscreen, lightweight texture', 'price': 24.99, 'category': 'Sunscreen', 'stock': 110},
    {'name': 'Oil Control Sun Gel-Cream SPF 50+', 'brand': 'Eucerin', 'description': 'Mattifying sun protection for oily skin', 'price': 19.90, 'category': 'Sunscreen', 'stock': 95},
    {'name': 'Photoderm MAX SPF 50+', 'brand': 'Bioderma', 'description': 'Maximum UVA/UVB protection', 'price': 21.50, 'category': 'Sunscreen', 'stock': 105},
    {'name': 'Sun UV Face Shine Control SPF 50', 'brand': 'Nivea', 'description': 'Mattifying sun protection with shine control', 'price': 14.99, 'category': 'Sunscreen', 'stock': 130},
    {'name': '2% BHA Liquid Exfoliant', 'brand': "Paula's Choice", 'description': 'Gentle exfoliant with salicylic acid', 'price': 32.00, 'category': 'Toner', 'stock': 85},
    {'name': 'Glycolic Acid 7% Toning Solution', 'brand': 'The Ordinary', 'description': 'Exfoliating toner with glycolic acid', 'price': 8.70, 'category': 'Toner', 'stock': 190},
    {'name': 'Glow Tonic', 'brand': 'Pixi', 'description': 'Exfoliating toner with glycolic acid and aloe', 'price': 18.00, 'category': 'Toner', 'stock': 125},
    {'name': 'Supple Preparation Facial Toner', 'brand': 'Klairs', 'description': 'Hydrating, pH-balancing toner', 'price': 19.50, 'category': 'Toner', 'stock': 115},
]

# Create partner
partner, _ = Partner.objects.get_or_create(name="SkinTech", code="skintech")
print(f"✅ Partner: {partner.name}")

# Create product class
product_class, _ = ProductClass.objects.get_or_create(name='Skincare Product', requires_shipping=True)
print(f"✅ Product Class: {product_class.name}")

# Create categories using treebeard structure
categories = {}
for cat_name in ['Cleanser', 'Moisturiser', 'Sunscreen', 'Toner']:
    try:
        cat = Category.objects.get(name=cat_name)
        print(f"  📁 Category '{cat_name}' already exists")
    except Category.DoesNotExist:
        cat = Category.add_root(name=cat_name, slug=cat_name.lower())
        print(f"  ✨ Created category '{cat_name}'")
    categories[cat_name] = cat
print(f"✅ Categories ready: {len(categories)}")

# Import products
print("\nImporting products...")
count = 0
for data in products_data:
    full_name = f"{data['brand']} - {data['name']}"
    
    if Product.objects.filter(title=full_name).exists():
        print(f"  ⏭️  {full_name} (already exists)")
        continue
    
    product = Product.objects.create(
        structure='standalone',
        title=full_name,
        description=data['description'],
        product_class=product_class,
    )
    
    product.categories.add(categories[data['category']])
    
    StockRecord.objects.create(
        product=product,
        partner=partner,
        price=Decimal(str(data['price'])),
        num_in_stock=data['stock'],
        partner_sku=f"SKIN-{product.id:04d}"
    )
    
    count += 1
    print(f"  ✅ {full_name}")

print("\n" + "=" * 70)
print(f"🎉 Successfully imported {count} products!")
print(f"📊 Total products in catalog: {Product.objects.count()}")
print("=" * 70)
