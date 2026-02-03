
import os
import sys
import json
import django

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "skintech_django.settings")
django.setup()

from apps.scanner.models import Ingredient

def export():
    print("Exporting ingredients to JSON...")
    ingredients = Ingredient.objects.all().order_by('name')
    data = []
    
    for i in items:
        data.append({
            'name': i.name,
            'inci_name': i.inci_name,
            'function': i.function,
            'description': i.description,
            'safety_rating': i.safety_rating,
            'is_allergen': i.is_allergen,
            'is_irritant': i.is_irritant,
            'pregnancy_safe': i.pregnancy_safe,
            'effects': i.effects  # Assumes JSONField
        })
    
    output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'apps', 'scanner', 'data')
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, 'ingredients.json')
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)
    
    print(f"Success! Exported {len(data)} ingredients to {output_path}")

if __name__ == "__main__":
    # Fix 'items' typo in loop above
    print("Exporting ingredients to JSON...")
    items = Ingredient.objects.all().order_by('name')
    data = []
    
    for i in items:
        data.append({
            'name': i.name,
            'inci_name': i.inci_name,
            'function': i.function,
            'description': i.description,
            'safety_rating': i.safety_rating,
            'is_allergen': i.is_allergen,
            'is_irritant': i.is_irritant,
            'pregnancy_safe': i.pregnancy_safe,
            'effects': i.effects or {}
        })
    
    output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'apps', 'scanner', 'data')
    os.makedirs(output_dir, exist_ok=True)
    output_path = os.path.join(output_dir, 'ingredients.json')
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)
    
    print(f"Success! Exported {len(data)} ingredients to {output_path}")
