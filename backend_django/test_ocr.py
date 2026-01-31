
import cv2
import numpy as np
import easyocr
import time
import os

def create_dummy_image():
    # Create a white image with black text
    img = np.ones((500, 500, 3), dtype=np.uint8) * 255
    
    # Add text
    font = cv2.FONT_HERSHEY_SIMPLEX
    cv2.putText(img, 'Ingredients: Aqua, Glycerin', (50, 250), font, 1, (0, 0, 0), 2, cv2.LINE_AA)
    
    cv2.imwrite('check_ocr.jpg', img)
    return 'check_ocr.jpg'


def test_ocr(image_path=None):
    if not image_path:
        print("1. Creating dummy image...")
        image_path = create_dummy_image()
    else:
        print(f"1. Using provided image: {image_path}")
    
    # Check if file exists
    if not os.path.exists(image_path):
        print(f"   ERROR: File not found at {image_path}")
        return

    print("2. Initializing OCRService (Multi-Pass)...")
    start = time.time()
    try:
        # We need to simulate the service logic here to test the full pipeline
        # Importing directly from the app to test the ACTUAL service code
        import sys
        sys.path.append(os.getcwd())
        from apps.scanner.services.ocr_service import OCRService
        
        ocr = OCRService(engine='easyocr')
        print(f"   Initialized in {time.time() - start:.2f}s")
    except Exception as e:
        print(f"   FATAL ERROR initializing Service: {e}")
        return

    print("3. Running OCR extraction...")
    start = time.time()
    try:
        # Use the FULL service method which includes preprocessing
        result = ocr.extract_text(image_path)
        print(f"   Completed in {time.time() - start:.2f}s")
        print(f"   Success: {result['success']}")
        print(f"   Length: {len(result['text'])}")
        print(f"   Text Preview: {result['text'][:200]}...")
        
        ingredients = ocr.extract_ingredient_list(result['text'])
        print(f"   \n4. Ingredients Found ({len(ingredients)}):")
        for ing in ingredients:
            print(f"      - {ing}")
             
    except Exception as e:
        print(f"   FATAL ERROR running OCR: {e}")

if __name__ == "__main__":
    # Path to the user's uploaded image
    img_path = r"C:/Users/jpesh/.gemini/antigravity/brain/c1134af8-6efa-4e07-9abe-00d9d4fdc2fc/uploaded_media_1769823383508.png"
    test_ocr(img_path)
