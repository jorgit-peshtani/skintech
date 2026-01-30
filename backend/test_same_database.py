"""
Test that both APIs now use the SAME database
"""
import sys
sys.path.insert(0, '.')

# Test main app database
print("=" * 60)
print("Testing Database Paths")
print("=" * 60)

from app import create_app
from models import Product

print("\n1. Main API (app.py):")
app1 = create_app()
with app1.app_context():
    count1 = Product.query.count()
    print(f"   Database: {app1.config['SQLALCHEMY_DATABASE_URI']}")
    print(f"   Products: {count1}")

# Test admin app database  
print("\n2. Admin API (admin_app.py):")
import admin_app
with admin_app.app.app_context():
    count2 = Product.query.count()
    print(f"   Database: {admin_app.app.config['SQLALCHEMY_DATABASE_URI']}")
    print(f"   Products: {count2}")

print("\n" + "=" * 60)
if count1 == count2:
    print(f"✅ SUCCESS! Both APIs use SAME database")
    print(f"✅ Both return {count1} products")
else:
    print(f"❌ MISMATCH! app.py: {count1}, admin_app.py: {count2}")
print("=" * 60)
