"""
Management command to import products from Flask database to Oscar
"""
from django.core.management.base import BaseCommand
from oscar.apps.catalogue.models import Product, ProductClass, ProductAttribute, Category
from oscar.apps.partner.models import Partner, StockRecord
from decimal import Decimal
import os
import sys

# Import from Flask database
sys.path.append(os.path.join(os.path.dirname(__file__), '../../../../backend'))

class Command(BaseCommand):
    help = 'Import products from Flask SQLite database to Oscar'

    def handle(self, *args, **options):
        self.stdout.write("=" * 70)
        self.stdout.write("  Importing Products to Django Oscar")
        self.stdout.write("=" * 70)
        
        # Define products (same as Flask)
        products_data = [
            {
                'name': 'Hydrating Cleanser',
                'brand': 'CeraVe',
                'description': 'Gentle hydrating cleanser with ceramides and hyaluronic acid',
                'price': 12.99,
                'category': 'Cleanser',
                'stock': 150,
                'suitable_for': ['Dry', 'Normal', 'Sensitive'],
                'concerns': ['Hydration', 'Gentle Cleansing'],
            },
            {
                'name': 'Effaclar Gel Cleanser',
                'brand': 'La Roche-Posay',
                'description': 'Purifying foaming gel for oily sensitive skin',
                'price': 18.50,
                'category': 'Cleanser',
                'stock': 120,
                'suitable_for': ['Oily', 'Combination'],
                'concerns': ['Acne', 'Oil Control'],
            },
            {
                'name': 'Squalane Cleanser',
                'brand': 'The Ordinary',
                'description': 'Gentle cleansing balm with squalane',
                'price': 8.90,
                'category': 'Cleanser',
                'stock': 200,
                'suitable_for': ['All Skin Types'],
                'concerns': ['Makeup Removal', 'Gentle Cleansing'],
            },
            {
                'name': 'Gentle Skin Cleanser',
                'brand': 'Cetaphil',
                'description': 'Mild, non-irritating formula for sensitive skin',
                'price': 10.99,
                'category': 'Cleanser',
                'stock': 180,
                'suitable_for': ['Sensitive', 'Dry'],
                'concerns': ['Sensitive Skin', 'Gentle Cleansing'],
            },
            {
                'name': 'Moisturising Cream',
                'brand': 'CeraVe',
                'description': 'Daily moisturizer with ceramides for dry skin',
                'price': 15.99,
                'category': 'Moisturiser',
                'stock': 140,
                'suitable_for': ['Dry', 'Normal'],
                'concerns': ['Hydration', 'Barrier Repair'],
            },
            {
                'name': 'Toleriane Sensitive Rich Cream',
                'brand': 'La Roche-Posay',
                'description': 'Soothing moisturizer for sensitive skin',
                'price': 22.00,
                'category': 'Moisturiser',
                'stock': 100,
                'suitable_for': ['Sensitive', 'Dry'],
                'concerns': ['Sensitive Skin', 'Hydration'],
            },
            {
                'name': 'Hydro Boost Water Gel',
                'brand': 'Neutrogena',
                'description': 'Oil-free gel-cream with hyaluronic acid',
                'price': 16.50,
                'category': 'Moisturiser',
                'stock': 160,
                'suitable_for': ['Oily', 'Combination'],
                'concerns': ['Hydration', 'Oil-Free'],
            },
            {
                'name': 'Natural Moisturizing Factors + HA',
                'brand': 'The Ordinary',
                'description': 'Light moisturizer with amino acids and hyaluronic acid',
                'price': 7.50,
                'category': 'Moisturiser',
                'stock': 220,
                'suitable_for': ['All Skin Types'],
                'concerns': ['Hydration', 'Lightweight'],
            },
            {
                'name': 'Anthelios Ultra-Light SPF 50+',
                'brand': 'La Roche-Posay',
                'description': 'Very high protection sunscreen, lightweight texture',
                'price': 24.99,
                'category': 'Sunscreen',
                'stock': 110,
                'suitable_for': ['All Skin Types'],
                'concerns': ['Sun Protection', 'Lightweight'],
            },
            {
                'name': 'Oil Control Sun Gel-Cream SPF 50+',
                'brand': 'Eucerin',
                'description': 'Mattifying sun protection for oily skin',
                'price': 19.90,
                'category': 'Sunscreen',
                'stock': 95,
                'suitable_for': ['Oily', 'Combination'],
                'concerns': ['Sun Protection', 'Oil Control'],
            },
            {
                'name': 'Photoderm MAX SPF 50+',
                'brand': 'Bioderma',
                'description': 'Maximum UVA/UVB protection',
                'price': 21.50,
                'category': 'Sunscreen',
                'stock': 105,
                'suitable_for': ['Sensitive', 'All Skin Types'],
                'concerns': ['Sun Protection', 'Sensitive Skin'],
            },
            {
                'name': 'Sun UV Face Shine Control SPF 50',
                'brand': 'Nivea',
                'description': 'Mattifying sun protection with shine control',
                'price': 14.99,
                'category': 'Sunscreen',
                'stock': 130,
                'suitable_for': ['Oily', 'Combination'],
                'concerns': ['Sun Protection', 'Matte Finish'],
            },
            {
                'name': '2% BHA Liquid Exfoliant',
                'brand': "Paula's Choice",
                'description': 'Gentle exfoliant with salicylic acid',
                'price': 32.00,
                'category': 'Toner',
                'stock': 85,
                'suitable_for': ['Oily', 'Combination', 'Acne-Prone'],
                'concerns': ['Exfoliation', 'Acne', 'Pores'],
            },
            {
                'name': 'Glycolic Acid 7% Toning Solution',
                'brand': 'The Ordinary',
                'description': 'Exfoliating toner with glycolic acid',
                'price': 8.70,
                'category': 'Toner',
                'stock': 190,
                'suitable_for': ['Normal', 'Combination'],
                'concerns': ['Exfoliation', 'Texture', 'Brightness'],
            },
            {
                'name': 'Glow Tonic',
                'brand': 'Pixi',
                'description': 'Exfoliating toner with glycolic acid and aloe',
                'price': 18.00,
                'category': 'Toner',
                'stock': 125,
                'suitable_for': ['All Skin Types'],
                'concerns': ['Brightness', 'Exfoliation'],
            },
            {
                'name': 'Supple Preparation Facial Toner',
                'brand': 'Klairs',
                'description': 'Hydrating, pH-balancing toner',
                'price': 19.50,
                'category': 'Toner',
                'stock': 115,
                'suitable_for': ['Sensitive', 'Dry'],
                'concerns': ['Hydration', 'pH Balance', 'Sensitive Skin'],
            },
        ]

        # Create or get partner (your store)
        partner, _ = Partner.objects.get_or_create(
            name="SkinTech",
            code="skintech"
        )
        self.stdout.write(f"✅ Partner: {partner.name}")

        # Create product class
        product_class, _ = ProductClass.objects.get_or_create(
            name='Skincare Product',
            requires_shipping=True
        )
        self.stdout.write(f"✅ Product Class: {product_class.name}")

        # Create categories
        categories = {}
        for cat_name in ['Cleanser', 'Moisturiser', 'Sunscreen', 'Toner']:
            cat, _ = Category.objects.get_or_create(
                name=cat_name,
                defaults={'slug': cat_name.lower()}
            )
            categories[cat_name] = cat
        self.stdout.write(f"✅ Categories created: {len(categories)}")

        # Import products
        self.stdout.write("\nImporting products...")
        count = 0
        for data in products_data:
            full_name = f"{data['brand']} - {data['name']}"
            
            # Check if product exists
            if Product.objects.filter(title=full_name).exists():
                self.stdout.write(f"  ⏭️  {full_name} (already exists)")
                continue
            
            # Create product
            product = Product.objects.create(
                structure='standalone',
                title=full_name,
                description=data['description'],
                product_class=product_class,
            )
            
            # Add category
            product.categories.add(categories[data['category']])
            
            # Create stock record
            StockRecord.objects.create(
                product=product,
                partner=partner,
                price=Decimal(str(data['price'])),
                num_in_stock=data['stock'],
                partner_sku=f"SKIN-{product.id:04d}"
            )
            
            count += 1
            self.stdout.write(f"  ✅ {full_name}")

        self.stdout.write("\n" + "=" * 70)
        self.stdout.write(f"🎉 Successfully imported {count} products!")
        self.stdout.write(f"📊 Total products in catalog: {Product.objects.count()}")
        self.stdout.write("=" * 70)
