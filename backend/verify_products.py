from app import create_app
from extensions import db
from models import Product

app = create_app()

with app.app_context():
    products = Product.query.all()
    
    print("=" * 60)
    print("   DATABASE VERIFICATION - Products")
    print("=" * 60)
    print(f"\nTotal Products: {len(products)}\n")
    
    # By Category
    categories = {}
    for p in products:
        categories[p.category] = categories.get(p.category, 0) + 1
    
    print("📊 By Category:")
    for cat, count in sorted(categories.items()):
        print(f"  {cat}: {count} products")
    
    # By Brand
    brands = {}
    for p in products:
        brands[p.brand] = brands.get(p.brand, 0) + 1
    
    print("\n🏷️  By Brand:")
    for brand, count in sorted(brands.items()):
        print(f"  {brand}: {count} products")
    
    # Sample Products
    print("\n✨ Sample Products:")
    for p in products[:5]:
        print(f"\n{p.id}. {p.brand} - {p.name}")
        print(f"   💰 Price: ${float(p.price):.2f}")
        print(f"   📦 Stock: {p.stock_quantity}")
        print(f"   🏷️  Category: {p.category}")
        if p.suitable_for_skin_types:
            print(f"   🧴 For: {', '.join(p.suitable_for_skin_types[:3])}")
    
    print("\n" + "=" * 60)
    print(f"✅ Database contains {len(products)} products ready to use!")
    print("=" * 60)
