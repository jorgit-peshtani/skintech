
import os
import sys
import django

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "skintech_django.settings")
django.setup()

from apps.scanner.models import Ingredient

def run():
    print("--- INGREDIENT RISK RATINGS ---")
    # Query all ingredients to be sure
    items = Ingredient.objects.all().order_by('name')
    for i in items:
        # Format: Name (Rating/10) - Description
        print(f"{i.name}: {i.safety_rating if i.safety_rating is not None else 'N/A'}/10")

if __name__ == "__main__":
    run()
