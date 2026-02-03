
import os
import sys
import django

# Setup Django environment
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "skintech_django.settings")
django.setup()

from apps.scanner.models import Ingredient
from apps.scanner.services.ingredient_analyzer import IngredientAnalyzer

def check_db():
    count = Ingredient.objects.count()
    print(f"Total Ingredients in DB: {count}")
    
    if count == 0:
        print("CRITICAL: Database is empty! You need to seed ingredients.")
        return

    analyzer = IngredientAnalyzer()
    
    test_cases = [
        "Aqua",
        "Water",
        "Glycerin",
        "Glycerine", # Fuzzy
        "Aqua (Water)",
        "Parfum"
    ]
    
    print("\n--- Testing Analyzer ---")
    for name in test_cases:
        result = analyzer.find_ingredient(name)
        status = f"FOUND ({result.name})" if result else "NOT FOUND"
        print(f"'{name}' -> {status}")

if __name__ == "__main__":
    check_db()
