import requests
import json

print("=" * 70)
print("   🧪 TESTING SKINTECH PRODUCTS - WEB & DESKTOP")
print("=" * 70)

# Test Web Frontend API (port 3000)
print("\n=== 1. Testing Web API (port 3000) ===")
try:
    response = requests.get('http://localhost:3000/api/products')
    if response.status_code == 200:
        data = response.json()
        products = data.get('products', [])
        print(f"✅ Status: {response.status_code}")
        print(f"✅ Products returned: {len(products)}")
        
        if products:
            print(f"\n📦 Sample Products:")
            for p in products[:3]:
                print(f"   - {p.get('brand')} - {p.get('name')}")
                print(f"     Price: ${p.get('price')} | Category: {p.get('category')}")
            
            # Count by category
            categories = {}
            for p in products:
                cat = p.get('category', 'Unknown')
                categories[cat] = categories.get(cat, 0) + 1
            
            print(f"\n📊 By Category:")
            for cat, count in sorted(categories.items()):
                print(f"   {cat}: {count} products")
        else:
            print("❌ No products returned!")
    else:
        print(f"❌ Status: {response.status_code}")
        print(f"❌ Error: {response.text[:200]}")
except Exception as e:
    print(f"❌ ERROR: {str(e)}")

# Test Desktop Admin API (port 3001)
print("\n=== 2. Testing Desktop Admin API (port 3001) ===")
try:
    response = requests.get('http://localhost:3001/api/admin/products')
    if response.status_code == 200:
        products = response.json()
        print(f"✅ Status: {response.status_code}")
        print(f"✅ Products returned: {len(products)}")
        
        if products:
            print(f"\n📦 Sample Products:")
            for p in products[:3]:
                print(f"   - {p.get('brand')} - {p.get('name')}")
                print(f"     Price: ${p.get('price')} | Stock: {p.get('stock_quantity')}")
            
            # Count by category  
            categories = {}
            for p in products:
                cat = p.get('category', 'Unknown')
                categories[cat] = categories.get(cat, 0) + 1
            
            print(f"\n📊 By Category:")
            for cat, count in sorted(categories.items()):
                print(f"   {cat}: {count} products")
        else:
            print("❌ No products returned!")
    else:
        print(f"❌ Status: {response.status_code}")
        print(f"❌ Error: {response.text[:200]}")
except requests.exceptions.ConnectionError:
    print("⚠️  Admin backend not running (port 3001)")
    print("   Start it with: python admin_app.py")
except Exception as e:
    print(f"❌ ERROR: {str(e)}")

print("\n" + "=" * 70)
print("   🎯 TEST RESULTS")
print("=" * 70)
print("\n✅ If both tests show 16 products, everything works!")
print("✅ Web Frontend can display products")
print("✅ Desktop Admin can manage products")
print("\n📝 Next Steps:")
print("  1. Start frontend: cd frontend && npm run dev")
print("  2. Visit: http://localhost:5173/products")
print("  3. Start desktop: cd desktop && npm run dev")
print("  4. Check Products tab")
print("=" * 70)
