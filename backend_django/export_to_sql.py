
import os
import django
import sys
from datetime import datetime

# Setup Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'skintech_django.settings')
django.setup()

from django.apps import apps
from django.db import connection

def escape_sql(value):
    if value is None:
        return "NULL"
    if isinstance(value, bool):
        return "TRUE" if value else "FALSE"
    if isinstance(value, (int, float)):
        return str(value)
    
    # String escaping for SQL
    val_str = str(value)
    val_str = val_str.replace("'", "''")
    return f"'{val_str}'"

def generate_inserts():
    print("-- SQL DUMP GENERATED FOR NEON POSTGRES")
    print("-- Run this in the Neon SQL Editor")
    print("\nBEGIN;")

    models_to_dump = [
        # Partner app (Dependencies for StockRecord)
        ('partner', 'Partner', 'partner_partner'),
        
        # Catalogue app (Product structure)
        ('catalogue', 'ProductClass', 'catalogue_productclass'),
        ('catalogue', 'Category', 'catalogue_category'),
        ('catalogue', 'Product', 'catalogue_product'),
        ('catalogue', 'ProductCategory', 'catalogue_productcategory'),
        ('catalogue', 'ProductImage', 'catalogue_productimage'),
        
        # Stock (Inventory)
        ('partner', 'StockRecord', 'partner_stockrecord'),
    ]

    for app_label, model_name, table_name in models_to_dump:
        Model = apps.get_model(app_label, model_name)
        objects = Model.objects.all()
        
        if not objects.exists():
            continue

        print(f"\n-- Data for {table_name}")
        
        for obj in objects:
            fields = []
            values = []
            
            # Get all concrete fields + M2M logic is complex, sticking to simple fields
            # For this seed data, we just need the main fields.
            
            # We iterate over the model fields to generate columns
            for field in Model._meta.fields:
                val = getattr(obj, field.name)
                
                # Special handling for FKs (need ID)
                if field.is_relation and val is not None:
                    val = val.pk
                
                fields.append(f'"{field.column}"')
                values.append(escape_sql(val))
            
            cols = ", ".join(fields)
            vals = ", ".join(values)
            
            print(f"INSERT INTO {table_name} ({cols}) VALUES ({vals}) ON CONFLICT DO NOTHING;")

    print("\nCOMMIT;")
    print("-- END OF DUMP")

if __name__ == "__main__":
    # Write directly to file with UTF-8 encoding
    with open("seed_data.sql", "w", encoding="utf-8") as f:
        # Redirect stdout to the file object temporarily, or just change logic
        # Simpler: Capture output or refactor print. verify logic...
        # Let's just redirect sys.stdout
        original_stdout = sys.stdout
        sys.stdout = f
        generate_inserts()
        sys.stdout = original_stdout
        print("SQL file generated: seed_data.sql")
