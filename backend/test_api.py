import requests
import json

print("=" * 60)
print("   Testing SkinTech API Endpoints")
print("=" * 60)

# Test main API
print("\n1. Testing Main API (port 3000)...")
try:
    response = requests.get('http://localhost:3000/api/products')
    print(f"   Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"   Products returned: {len(data.get('products', []))}")
        if data.get('products'):
            print(f"   First product: {data['products'][0].get('brand')} - {data['products'][0].get('name')}")
            print(f"   Price: ${data['products'][0].get('price')}")
    else:
        print(f"   Error: {response.text[:200]}")
except Exception as e:
    print(f"   ERROR: {str(e)}")

# Test admin API
print("\n2. Testing Admin API (port 3001)...")
try:
    response = requests.get('http://localhost:3001/api/admin/products')
    print(f"   Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"   Products returned: {len(data)}")
        if data:
            print(f"   First product: {data[0].get('brand')} - {data[0].get('name')}")
            print(f"   Price: ${data[0].get('price')}")
    else:
        print(f"   Error: {response.text[:200]}")
except Exception as e:
    print(f"   ERROR: {str(e)}")

print("\n" + "=" * 60)
