
import os
import sys
import django

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "skintech_django.settings")
django.setup()

from apps.scanner.models import Ingredient

def list_ratings():
    targets = [
        "Aqua", "Water", "Glycerin", "Cocamidopropyl Betaine", "Coco-Glucoside",
        "Betaine", "Mandelic Acid", "Glycolic Acid", "Fragaria Ananassa Fruit Extract",
        "Rubus Fruticosus Fruit Extract", "Rubus Idaeus Fruit Extract", "Coconut Acid",
        "Sodium Chloride", "Sodium Carbonate", "Menthyl Lactate", "Calcium Gluconate",
        "Gluconolactone", "Sodium Benzoate", "Potassium Sorbate", "Parfum", "Limonene"
    ]
    
    print(f"{'Ingredient':<30} | {'Risk (1-10)':<12} | {'Description'}")
    print("-" * 80)
    
    for name in targets:
        ing = Ingredient.objects.filter(name__icontains=name).first()
        if ing:
            rating = ing.safety_rating if ing.safety_rating is not None else "N/A"
            desc = (ing.description or "")[:40] + "..." if ing.description else ""
            print(f"{ing.name:<30} | {str(rating):<12} | {desc}")
        else:
            print(f"{name:<30} | {'NOT FOUND':<12} |")

if __name__ == "__main__":
    list_ratings()
