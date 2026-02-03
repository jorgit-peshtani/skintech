"""
OCR Service - Powered by OCR.space API
Replaces local Tesseract/EasyOCR to save server memory.
Restored original ingredient parsing logic ("Smart Face Secure" features).
"""

import logging
import requests
import os
import re
from typing import List, Dict

logger = logging.getLogger(__name__)

class OCRService:
    def __init__(self, engine='ocrspace', languages=['eng']):
        """
        Initialize OCR service using OCR.space
        """
        self.engine = engine
        self.languages = languages
        self.api_key = os.environ.get('OCR_SPACE_API_KEY', 'K84890674088957')
        self.api_url = 'https://api.ocr.space/parse/image'
        logger.info(f"OCR Service initialized using API: {self.api_url}")

    def preprocess_image(self, image_path: str):
        """Not needed for cloud OCR"""
        return []

    def extract_text(self, image_path: str) -> Dict[str, any]:
        """
        Send image to OCR.space API and retrieve text.
        """
        try:
            with open(image_path, 'rb') as f:
                payload = {
                    'apikey': self.api_key,
                    'language': 'eng', # 'eng' covers most ingredient lists
                    'isOverlayRequired': False,
                    'detectOrientation': True,
                    'scale': True,
                    'OCREngine': 2 # Engine 2 is better for text lines
                }
                files = {'file': f}
                
                logger.info("Sending request to OCR.space...")
                response = requests.post(self.api_url, files=files, data=payload, timeout=30)
                
                if response.status_code != 200:
                    return {
                        'success': False,
                        'error': f"API Error: {response.status_code}",
                        'engine': self.engine
                    }

                result = response.json()
                
                if result.get('IsErroredOnProcessing'):
                    error_msg = result.get('ErrorMessage', ['Unknown error'])[0]
                    return {
                        'success': False,
                        'error': error_msg,
                        'engine': self.engine
                    }

                # Extract parsed text from all regions
                parsed_results = result.get('ParsedResults', [])
                full_text = ""
                for page in parsed_results:
                    full_text += page.get('ParsedText', "") + "\n"

                return {
                    'success': True,
                    'text': full_text.strip(),
                    'engine': self.engine
                }

        except Exception as e:
            logger.error(f"OCR Exception: {str(e)}")
            return {
                'success': False,
                'error': str(e),
                'engine': self.engine
            }

    def extract_ingredient_list(self, text: str) -> List[str]:
        """
        Parse raw text into a clean list of ingredients.
        Restored logic from original implementation.
        """
        if not text:
            return []

        # 1. Normalize line endings and whitespace
        text = text.replace('\r\n', '\n').replace('\r', '\n')
        
        # 2. Try to detect if it's a comma-separated list vs newline-separated
        comma_count = text.count(',')
        newline_count = text.count('\n')

        raw_items = []
        if comma_count > newline_count and comma_count > 2:
            raw_items = text.split(',')
        else:
            raw_items = re.split(r'[,\n•·]', text)

        ingredients = []
        for item in raw_items:
            # === RESTORED CLEANING LOGIC ===
            clean_item = self.clean_text(item)
            
            # Additional logic from original: Inversion/Noise filtering
            if self.is_valid_ingredient(clean_item):
                ingredients.append(clean_item)

        return ingredients
        
    def clean_text(self, text: str) -> str:
        """Clean individual ingredient line - Restored Filters"""
        # 1. Remove citations/codes in brackets e.g. (CI 77891) or (Water)
        text = re.sub(r'\s*\([^)]*\)', '', text)
        
        # 2. Remove percentages e.g. 2% or 0.5%
        text = re.sub(r'\s*\d+(\.\d+)?%', '', text)
        
        # 3. Remove common prefixes
        text = re.sub(r'^(Ingredients:|Contains:|Active Ingredients:)', '', text, flags=re.IGNORECASE)
        
        # 4. Remove numbers/dates often found in footers
        text = re.sub(r'\d{6,}', '', text)  # Phone numbers/Zip codes
        
        # 5. Remove non-alphanumeric noise at edges
        text = text.strip(' .,-*:;_#@!&')
        
        # 6. Normalize whitespace
        text = re.sub(r'\s+', ' ', text)
        
        return text.strip()

    def is_valid_ingredient(self, text: str) -> bool:
        """Filter out obvious noise"""
        if len(text) < 3:
            return False
            
        text_lower = text.lower()
        
        # Structural words to skip
        if text_lower in ['ingredients', 'contains', 'made in', 'dist', 'distributor', 'active ingredients']:
            return False
            
        # Skip website URLs or emails
        if 'www.' in text_lower or '.com' in text_lower or '@' in text_lower:
            return False
            
        # Skip pure numbers
        if text.replace('.', '').isdigit():
            return False
            
        return True
