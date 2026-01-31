"""
Check what's in the database
"""
import sys
sys.path.insert(0, '.')

from app import create_app
from models import Product, User, Order

app = create_app()

with app.app_context():
    print("=" * 70)
    print("   DATABASE CONTENTS")
    print("=" * 70)
    
    # Products
    products = Product.query.all()
    print(f"\n📦 PRODUCTS: {len(products)} total")
    if products:
        print("\nSample products:")
        for p in products[:5]:
            print(f"  - [{p.id}] {p.brand} {p.name} - ${p.price} ({p.category})")
        if len(products) > 5:
            print(f"  ... and {len(products) - 5} more")
    
    # Users
    users = User.query.all()
    print(f"\n👤 USERS: {len(users)} total")
    if users:
        print("\nRegistered users:")
        for u in users[:5]:
            print(f"  - [{u.id}] {u.username} ({u.email})")
        if len(users) > 5:
            print(f"  ... and {len(users) - 5} more")
    
    # Orders
    orders = Order.query.all()
    print(f"\n🛒 ORDERS: {len(orders)} total")
    if orders:
        print("\nRecent orders:")
        for o in orders[:5]:
            print(f"  - Order #{o.id}: ${o.total_amount} - {o.status}")
        if len(orders) > 5:
            print(f"  ... and {len(orders) - 5} more")
    
    print("\n" + "=" * 70)
    print(f"Database location: {app.config['SQLALCHEMY_DATABASE_URI']}")
    print("=" * 70)
