
import os
import sys
import django
import re

# Force UTF-8 for Windows console
sys.stdout.reconfigure(encoding='utf-8')

# Setup Django environment
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "skintech_django.settings")
django.setup()

from apps.scanner.services.ocr_service import OCRService

def test_ocr():
    # User uploaded image path (The LABEL, not the error screenshot)
    image_path = "C:/Users/jpesh/.gemini/antigravity/brain/c1134af8-6efa-4e07-9abe-00d9d4fdc2fc/uploaded_media_1770085478592.png"
    
    print(f"Testing OCR with image: {image_path}")
    
    if not os.path.exists(image_path):
        print("Image file not found!")
        return

    service = OCRService()
    
    # 1. Test Text Extraction
    print("\n--- Extracting Text ---")
    result = service.extract_text(image_path)
    
    if not result['success']:
        print(f"Error: {result.get('error')}")
        return

    raw_text = result['text']
    print(f"Raw Text Preview:\n{raw_text[:500]}")

    # 2. Test Ingredient Parsing (Step by Step)
    print("\n--- Parsing Debug ---")
    
    # Debug Split
    text = raw_text.replace('\r\n', '\n').replace('\r', '\n')
    comma_count = text.count(',')
    newline_count = text.count('\n')
    print(f"Commas: {comma_count}, Newlines: {newline_count}")

    raw_items = []
    if comma_count > newline_count and comma_count > 2:
        print("Strategy: Split by Comma")
        raw_items = text.split(',')
    else:
        print("Strategy: Split by Regex")
        raw_items = re.split(r'[,\n•·]', text)

    print(f"Raw Items Count: {len(raw_items)}")

    print("\n--- Cleaning Items ---")
    ingredients = []
    for item in raw_items:
        original = item
        clean_item = service.clean_text(item)
        is_valid = service.is_valid_ingredient(clean_item)
        
        status = "KEPT" if is_valid else "DROPPED"
        if len(clean_item) > 0: # Only show non-empty attempts
             print(f"['{original.strip()[:20]}...'] -> ['{clean_item}'] : {status}")

        if is_valid:
            ingredients.append(clean_item)

    print(f"\nFINAL INGREDIENTS ({len(ingredients)}):")
    for ing in ingredients:
        print(f"- {ing}")

if __name__ == "__main__":
    test_ocr()
