
import os
import sys
import django

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "skintech_django.settings")
django.setup()

from apps.scanner.services.ocr_service import OCRService
from apps.scanner.services.ingredient_analyzer import IngredientAnalyzer

def run_simulation():
    image_path = "C:/Users/jpesh/.gemini/antigravity/brain/c1134af8-6efa-4e07-9abe-00d9d4fdc2fc/uploaded_media_1770085478592.png" # Using the clear label image
    
    print(f"--- Simulating Scan for: {os.path.basename(image_path)} ---")
    
    # 1. OCR
    ocr = OCRService()
    print("Running OCR...")
    ocr_result = ocr.extract_text(image_path)
    
    if not ocr_result['success']:
        print(f"OCR Failed: {ocr_result.get('error')}")
        return

    raw_text = ocr_result['text']
    
    # 2. Extract List
    print("Extracting Ingredients...")
    ingredients_list = ocr.extract_ingredient_list(raw_text)
    print(f"Found {len(ingredients_list)} potential items.")

    # 3. Analyze
    print("Analyzing Risks...")
    analyzer = IngredientAnalyzer()
    result = analyzer.analyze_ingredients(ingredients_list)
    
    # 4. Display Results
    print("\n" + "="*50)
    print(f"OVERALL SAFETY RATING: {result['overall_safety_score']}/10")
    print(f"ASSESSMENT: {result.get('safety_assessment', 'N/A')}")
    print("="*50)
    
    print(f"\nIdentified Ingredients ({len(result['identified_ingredients'])}):")
    print(f"{'Name':<30} | {'Risk':<5} | {'Notes'}")
    print("-" * 60)
    
    for item in result['identified_ingredients']:
        risk = item['safety_rating'] if item['safety_rating'] is not None else "N/A"
        notes = []
        if item.get('is_allergen'): notes.append("Allergen")
        if item.get('warnings'): notes.extend(item['warnings'])
        note_str = ", ".join(notes)
        print(f"{item['name']:<30} | {str(risk):<5} | {note_str}")

if __name__ == "__main__":
    run_simulation()
