
import os
import cv2
import numpy as np
import easyocr
import sys

# Path to the user's NEW image (from artifacts)
IMAGE_PATH = r"C:\Users\jpesh\.gemini\antigravity\brain\c1134af8-6efa-4e07-9abe-00d9d4fdc2fc\uploaded_media_1769825207693.png"

def preprocess_strategies(image_path):
    img = cv2.imread(image_path)
    if img is None:
        print(f"Error: Could not read image at {image_path}")
        return {}

    strategies = {}
    
    # Base: Grayscale
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    strategies['Original Grayscale'] = gray
    
    # Strategy 0: Invert (White text on black background -> Black on white)
    inverted = cv2.bitwise_not(gray)
    strategies['Inverted'] = inverted

    # Strategy 1: Scale Up (2x) + Invert
    scale = 2.0
    scaled = cv2.resize(gray, None, fx=scale, fy=scale, interpolation=cv2.INTER_CUBIC)
    strategies['Scaled 2x'] = scaled
    
    # Inverted Scaled
    scaled_inverted = cv2.bitwise_not(scaled)
    strategies['Scaled 2x Inverted'] = scaled_inverted

    # Strategy 2: Adaptive Thresholding (for shadows/curved bottles) on Scaled
    adaptive = cv2.adaptiveThreshold(scaled, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)
    strategies['Adaptive Threshold'] = adaptive

    # Strategy 3: Denoised + Scaled
    denoised = cv2.fastNlMeansDenoising(scaled, None, 10, 7, 21)
    strategies['Denoised'] = denoised

    # Strategy 4: High Contrast (CLAHE) on Scaled
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
    enhanced = clahe.apply(scaled)
    strategies['CLAHE Enhanced'] = enhanced

    # Strategy 5: Otsu Binarization due to potentially bad lighting
    _, otsu = cv2.threshold(scaled, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    strategies['Otsu Binary'] = otsu

    return strategies

def test_ocr():
    print(f"Testing OCR on: {IMAGE_PATH}")
    if not os.path.exists(IMAGE_PATH):
        print("Image file not found!")
        return

    reader = easyocr.Reader(['en'])
    strategies = preprocess_strategies(IMAGE_PATH)

    for name, img in strategies.items():
        print(f"\n--- Testing Strategy: {name} ---")
        try:
            results = reader.readtext(img)
            text = ' '.join([result[1] for result in results])
            print(f"Length: {len(text)}")
            print(f"Snippet: {text[:150]}...")
            
            # Check for key phrase
            if "Ingredients" in text or "INGREDIENTS" in text:
                print("✅ Found 'Ingredients' marker!")
            else:
                print("❌ No 'Ingredients' marker found.")
                
        except Exception as e:
            print(f"Error during OCR: {e}")

if __name__ == "__main__":
    test_ocr()
