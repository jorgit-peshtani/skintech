"""
Test admin_app.py database connection
"""
import sys
import os

# Simulate admin_app.py startup
basedir = os.path.abspath(os.path.dirname(__file__))
FLASK_ENV = os.environ.get('FLASK_ENV', 'development')

print("=" * 70)
print("   Desktop Admin Database Configuration Test")
print("=" * 70)

if FLASK_ENV == 'production':
    print("Mode: PRODUCTION")
    print(f"Will use: {os.environ.get('DATABASE_URL', 'NOT SET')}")
else:
    print("Mode: DEVELOPMENT")
    instance_path = os.path.join(basedir, 'instance')
    db_path = os.path.join(instance_path, 'skintech.db')
    print(f"Database path: {db_path}")
    print(f"Database exists: {os.path.exists(db_path)}")
    
    if os.path.exists(db_path):
        size = os.path.getsize(db_path)
        print(f"Database size: {size:,} bytes")
        
        # Test with admin_app
        sys.path.insert(0, basedir)
        import admin_app
        
        with admin_app.app.app_context():
            from models import Product
            count = Product.query.count()
            print(f"\n✅ Products in admin_app database: {count}")
            
            if count > 0:
                print("\nSample products:")
                products = Product.query.limit(3).all()
                for p in products:
                    print(f"  - {p.brand} {p.name} (${p.price})")
    else:
        print("❌ Database file not found!")

print("=" * 70)
