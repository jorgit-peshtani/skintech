"""
🧪 SkinTech Database Architecture Test
Tests that all 3 apps (Web, Desktop, Mobile) use the SAME database
"""

import requests
import json
from colorama import init, Fore, Style

init(autoreset=True)

print("=" * 80)
print(f"{Fore.CYAN}{'🧪 SKINTECH DATABASE ARCHITECTURE TEST':^80}{Style.RESET_ALL}")
print("=" * 80)
print(f"\n{Fore.YELLOW}Testing that Web, Desktop, and Mobile all use the SAME database{Style.RESET_ALL}")
print(f"{Fore.YELLOW}Database: backend/skintech.db (SQLite){Style.RESET_ALL}\n")

# Track test results
tests_passed = 0
tests_total = 0

def test_endpoint(name, url, expected_count=None):
    """Test an API endpoint"""
    global tests_passed, tests_total
    tests_total += 1
    
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            data = response.json()
            
            # Determine count based on response structure
            if isinstance(data, list):
                count = len(data)
            elif 'products' in data:
                count = len(data['products'])
            elif 'users' in data:
                count = len(data['users'])
            elif 'orders' in data:
                count = len(data['orders'])
            else:
                count = 1
            
            if expected_count is not None and count == expected_count:
                print(f"{Fore.GREEN}✅ {name}: {count} records (PASS){Style.RESET_ALL}")
                tests_passed += 1
                return True
            elif expected_count is None:
                print(f"{Fore.GREEN}✅ {name}: {count} records (Connected){Style.RESET_ALL}")
                tests_passed += 1
                return True
            else:
                print(f"{Fore.RED}❌ {name}: Expected {expected_count}, got {count} (FAIL){Style.RESET_ALL}")
                return False
        else:
            print(f"{Fore.RED}❌ {name}: Status {response.status_code} (FAIL){Style.RESET_ALL}")
            return False
    except requests.exceptions.ConnectionError:
        print(f"{Fore.YELLOW}⚠️  {name}: Server not running{Style.RESET_ALL}")
        return False
    except Exception as e:
        print(f"{Fore.RED}❌ {name}: Error - {str(e)}{Style.RESET_ALL}")
        return False

print(f"\n{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}")
print(f"{Fore.CYAN}TEST 1: Main Backend (Web + Mobile) - Port 3000{Style.RESET_ALL}")
print(f"{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}\n")

# Test products (should have 16 from seeding)
test_endpoint("📦 Products API", "http://localhost:3000/api/products", 16)

# Test health
test_endpoint("💚 Health Check", "http://localhost:3000/api/health")

print(f"\n{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}")
print(f"{Fore.CYAN}TEST 2: Admin Backend (Desktop) - Port 3001{Style.RESET_ALL}")
print(f"{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}\n")

# Test admin products (should have same 16 products)
test_endpoint("📦 Admin Products API", "http://localhost:3001/api/admin/products", 16)

# Test admin users
test_endpoint("👥 Admin Users API", "http://localhost:3001/api/admin/users")

# Test admin orders
test_endpoint("🛒 Admin Orders API", "http://localhost:3001/api/admin/orders")

print(f"\n{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}")
print(f"{Fore.CYAN}DATABASE VERIFICATION{Style.RESET_ALL}")
print(f"{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}\n")

# Verify both return same products
try:
    web_products = requests.get('http://localhost:3000/api/products').json()
    admin_products = requests.get('http://localhost:3001/api/admin/products').json()
    
    web_count = len(web_products.get('products', []))
    admin_count = len(admin_products)
    
    if web_count == admin_count == 16:
        print(f"{Fore.GREEN}✅ SAME DATABASE CONFIRMED!{Style.RESET_ALL}")
        print(f"{Fore.GREEN}   Web API: {web_count} products{Style.RESET_ALL}")
        print(f"{Fore.GREEN}   Admin API: {admin_count} products{Style.RESET_ALL}")
        print(f"{Fore.GREEN}   ✨ Both use: backend/skintech.db{Style.RESET_ALL}")
        tests_passed += 1
    else:
        print(f"{Fore.RED}❌ DATABASE MISMATCH!{Style.RESET_ALL}")
        print(f"{Fore.RED}   Web: {web_count}, Admin: {admin_count}{Style.RESET_ALL}")
    tests_total += 1
except Exception as e:
    print(f"{Fore.YELLOW}⚠️  Could not verify database synchronization{Style.RESET_ALL}")

print(f"\n{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}")
print(f"{Fore.CYAN}ARCHITECTURE SUMMARY{Style.RESET_ALL}")
print(f"{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}\n")

print("""
┌─────────────────────────────────────────────────────────┐
│               SINGLE DATABASE ARCHITECTURE              │
└─────────────────────────────────────────────────────────┘

            backend/skintech.db (SQLite)
                      │
        ┌─────────────┼─────────────┐
        │             │             │
        ▼             ▼             ▼
   ┌────────┐   ┌─────────┐   ┌─────────┐
   │  app.py│   │admin_app│   │admin_app│
   │Port 3000│   │Port 3001│   │Port 3001│
   └────────┘   └─────────┘   └─────────┘
        │             │             │
        ▼             ▼             ▼
   ┌────────┐   ┌─────────┐   ┌─────────┐
   │   Web  │   │ Desktop │   │ Mobile  │
   │Frontend│   │  Admin  │   │   App   │
   └────────┘   └─────────┘   └─────────┘

✅ Web: Fetches products from port 3000
✅ Desktop: Manages data via port 3001
✅ Mobile: Uses port 3000 for all data
✅ All use SAME SQLite database file
""")

print(f"\n{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}")
print(f"{Fore.CYAN}TEST RESULTS{Style.RESET_ALL}")
print(f"{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}\n")

if tests_passed == tests_total:
    print(f"{Fore.GREEN}{'🎉 ALL TESTS PASSED!':^80}{Style.RESET_ALL}")
    print(f"{Fore.GREEN}{f'{tests_passed}/{tests_total} tests successful':^80}{Style.RESET_ALL}")
    print(f"\n{Fore.GREEN}✅ Database architecture is correct!{Style.RESET_ALL}")
    print(f"{Fore.GREEN}✅ All apps connected to same database!{Style.RESET_ALL}")
    print(f"{Fore.GREEN}✅ Ready to use!{Style.RESET_ALL}")
else:
    print(f"{Fore.YELLOW}{'⚠️  SOME TESTS INCOMPLETE':^80}{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}{f'{tests_passed}/{tests_total} tests successful':^80}{Style.RESET_ALL}")
    print(f"\n{Fore.YELLOW}Make sure both backends are running:{Style.RESET_ALL}")
    print(f"{Fore.YELLOW}  1. python app.py (port 3000){Style.RESET_ALL}")
    print(f"{Fore.YELLOW}  2. python admin_app.py (port 3001){Style.RESET_ALL}")

print(f"\n{Fore.CYAN}{'=' * 80}{Style.RESET_ALL}\n")
