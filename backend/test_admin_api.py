import requests

print("=" * 70)
print("   Testing Admin Backend for Desktop App")
print("=" * 70)

try:
    # Test admin health
    response = requests.get('http://localhost:3001/api/health', timeout=3)
    print(f"\n✅ Admin backend is RUNNING")
    print(f"   Status: {response.status_code}")
except requests.exceptions.ConnectionError:
    print(f"\n❌ Admin backend NOT running!")
    print(f"   Start it with: python admin_app.py")
    exit(1)
except Exception as e:
    print(f"\n❌ Error: {e}")
    exit(1)

try:
    # Test products endpoint
    response = requests.get('http://localhost:3001/api/admin/products', timeout=3)
    print(f"\n📦 Products endpoint:")
    print(f"   Status: {response.status_code}")
    
    if response.status_code == 200:
        products = response.json()
        print(f"   Products: {len(products)}")
        
        if products:
            print(f"\n   First 3 products:")
            for p in products[:3]:
                print(f"   - {p['brand']} {p['name']} (${p['price']})")
        else:
            print(f"\n   ⚠️ No products returned!")
    else:
        print(f"   Error: {response.text[:200]}")
        
except Exception as e:
    print(f"\n❌ Error accessing products: {e}")

print("\n" + "=" * 70)
print("Desktop app should be able to connect now!")
print("=" * 70)
