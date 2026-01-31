"""
OCR Service for extracting text from cosmetic product labels
Supports multiple OCR engines: Tesseract and EasyOCR
"""

import os
import cv2
import numpy as np
from PIL import Image
import pytesseract
try:
    import easyocr
except ImportError:
    easyocr = None
from typing import List, Dict, Optional
import re
import logging

logger = logging.getLogger(__name__)

class OCRService:
    def __init__(self, engine='easyocr', languages=['en']):
        """
        Initialize OCR service
        
        Args:
            engine: 'tesseract' or 'easyocr'
            languages: List of language codes
        """
        self.engine = engine
        self.languages = languages
        self.reader = None
        
        if engine == 'easyocr':
            if easyocr:
                # Initialize Only once if possible or catch errors
                try:
                    self.reader = easyocr.Reader(languages) 
                except Exception as e:
                    logger.error(f"Failed to initialize EasyOCR: {e}")
                    # Fallback or error
            else:
                logger.warning("EasyOCR not installed, fallback might be needed")
        elif engine == 'tesseract':
            # Tesseract should be installed separately
            pass
        else:
            raise ValueError(f"Unsupported OCR engine: {engine}")
    
    def preprocess_image(self, image_path: str) -> List[np.ndarray]:
        """
        Preprocess image for better OCR results.
        Returns a list of preprocessed versions to try (Original, Grayscale, Contrast Enhanced)
        """
        # Read image
        if isinstance(image_path, str):
            img = cv2.imread(image_path)
        else:
             img = cv2.imread(image_path)

        if img is None:
             raise ValueError("Could not read image")
        
    def preprocess_image(self, image_path: str) -> List[np.ndarray]:
        """
        Preprocess image for better OCR results.
        Returns a list of preprocessed versions to try.
        """
        # Read image
        if isinstance(image_path, str):
            img = cv2.imread(image_path)
        else:
             img = cv2.imread(image_path)

        if img is None:
             raise ValueError("Could not read image")

        strategies = []

        # 1. Standard Upscale (Crucial for small text)
        # Always work with at least 2x scale if image is small-ish
        height, width = img.shape[:2]
        if height < 2000:
            scale = 2.0
            img_scaled = cv2.resize(img, None, fx=scale, fy=scale, interpolation=cv2.INTER_CUBIC)
        else:
            img_scaled = img

        gray = cv2.cvtColor(img_scaled, cv2.COLOR_BGR2GRAY)
        strategies.append(gray) # Strategy 1: Scaled Grayscale
        
        # 2. Inverted (CRITICAL for white text on dark bottles)
        inverted = cv2.bitwise_not(gray)
        strategies.append(inverted) # Strategy 2: Inverted

        # 3. Denoised (Great for camera photos)
        denoised = cv2.fastNlMeansDenoising(gray, None, 10, 7, 21)
        strategies.append(denoised) # Strategy 3: Denoised
        
        # 4. Inverted Denoised
        denoised_inverted = cv2.bitwise_not(denoised)
        strategies.append(denoised_inverted) # Strategy 4: Inverted Denoised

        # 5. Contrast Enhanced (CLAHE)
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
        enhanced = clahe.apply(denoised)
        strategies.append(enhanced) # Strategy 5: Enhanced

        # 6. Adaptive Threshold (Good for curved/shadowed bottles)
        adaptive = cv2.adaptiveThreshold(denoised, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 11, 2)
        strategies.append(adaptive) # Strategy 6: Adaptive Binary
        
        return strategies
    
    def extract_text_tesseract(self, image_path: str) -> str:
        # For Tesseract, just use the enhanced version
        preprocessed_list = self.preprocess_image(image_path)
        enhanced = preprocessed_list[1] # Use contrast enhanced
        
        custom_config = r'--oem 3 --psm 6'
        text = pytesseract.image_to_string(enhanced, config=custom_config)
        return text.strip()
    
    def extract_text_easyocr(self, image_path: str) -> str:
        if not self.reader:
             return "OCR Engine not initialized"
             
        preprocessed_versions = self.preprocess_image(image_path)
        
        longest_text = ""
        
        # Try all preprocessing strategies and keep the longest result
        for img_version in preprocessed_versions:
            results = self.reader.readtext(img_version)
            text = ' '.join([result[1] for result in results])
            
            if len(text) > len(longest_text):
                longest_text = text
                
            # Heuristic: If we found "Ingredients" or reasonable length, stop
            if "ingredient" in text.lower() or len(text) > 100:
                return text.strip()
                
        return longest_text.strip()
    
    def extract_text(self, image_path: str) -> Dict[str, any]:
        try:
            if self.engine == 'tesseract':
                text = self.extract_text_tesseract(image_path)
            elif self.engine == 'easyocr':
                text = self.extract_text_easyocr(image_path)
            else:
                raise ValueError(f"Unsupported OCR engine: {self.engine}")
            
            clean_text = self.clean_text(text)
            
            return {
                'success': True,
                'text': clean_text,
                'engine': self.engine,
                'languages': self.languages
            }
        except Exception as e:
            logger.error(f"OCR Error: {e}")
            return {
                'success': False,
                'error': str(e),
                'text': '',
                'engine': self.engine
            }
    
    def clean_text(self, text: str) -> str:
        text = re.sub(r'\s+', ' ', text)
        text = re.sub(r'[^\w\s,().-]', '', text)
        return text.strip()
    
    def extract_ingredient_list(self, text: str) -> List[str]:
        # Common ingredient list markers
        markers = [
            r'ingredients?:',
            r'INGREDIENTS?:',
            r'inci:',
            r'INCI:',
            r'composition:',
            r'contains:',
            r'formula:'
        ]
        
        ingredient_section = None
        
        # 1. Find Start (Ingredients header)
        for marker in markers:
            match = re.search(marker, text, re.IGNORECASE)
            if match:
                ingredient_section = text[match.end():].strip()
                break
        
        # If no marker is found, we might want to be conservative or try to find a block of comma-separated words
        # For now, if no marker, we'll try to use the whole text but aggressive filtering will help
        if not ingredient_section:
            # Fallback: Treat whole text as candidate but filter more aggressively later
            ingredient_section = text

        # 2. Find End (Footer markers like "Distributed by", "Made in", etc)
        # These markers signify the end of the ingredient list and start of business info
        end_markers = [
            r'Dist\.',
            r'Distributed',
            r'Manufactured',
            r'Mfd\.',
            r'Made in',
            r'www\.',
            r'Store at',
            r'Caution:',
            r'Warning:',
            r'Directions:',
            r'EXP',
            r'Batch',
            r'Lot',
            r'Questions\?'
        ]
        
        for end_marker in end_markers:
             end_match = re.search(end_marker, ingredient_section, re.IGNORECASE)
             if end_match:
                 # Cut off text at the start of the end marker
                 ingredient_section = ingredient_section[:end_match.start()].strip()
                 # We can break early if we find a very strong marker, but continuing might find an earlier one
                 # Actually, we want the *first* occurrence of ANY end marker
        
        # To find the true "first" end marker, it's better to search all and pick min index, 
        # but regex search loop is okay if we are careful. Let's do a slightly better approach:
        first_end_index = len(ingredient_section)
        for end_marker in end_markers:
            end_match = re.search(end_marker, ingredient_section, re.IGNORECASE)
            if end_match:
                 if end_match.start() < first_end_index:
                     first_end_index = end_match.start()
        
        ingredient_section = ingredient_section[:first_end_index].strip()
        
        # Split by common separators (comma, semicolon, bullet point, newlines treated as space elsewhere but maybe helpful here)
        # Also clean up OCR errors where '.' might be used as ','
        # Replace '.' with ',' if it looks like a separator (e.g., "Water. Glycerin")
        ingredient_section = re.sub(r'(?<=[a-zA-Z])\.(?=\s[A-Z])', ',', ingredient_section)
        
        # FIX: Handle mashed text like "BetaineCoco" -> "Betaine Coco"
        # Insert space between Lowercase and Uppercase
        ingredient_section = re.sub(r'(?<=[a-z])(?=[A-Z])', ' ', ingredient_section)
        
        # FIX: Handle "WaterlCocamidopropyl" typo (l instead of | or ,)
        # This is specific but helpful for the user's case
        ingredient_section = re.sub(r'(?<=[a-z])l(?=[A-Z])', ', ', ingredient_section)

        # Strategy A: Split by delimiters if present
        if re.search(r'[,;•|]', ingredient_section):
            ingredients = re.split(r'[,;•|]', ingredient_section)
        # Strategy B: No delimiters found? Try to split by "Capitalized Chemical Names"
        else:
             # Heuristic: Split if we see " [A-Z]" but reject if it looks like part of a 2-word chemical
             # This is hard. Better approach: Use the Ingredient Analyzer to "find" known ingredients in the blob?
             # For now, let's try a regex that looks for Space+Capital, but allow common multi-word starts
             
             # Fallback simpler split: Split by ANY space, then reconstruct? No, that's too fragmented.
             # Try splitting by "Capitalized words that don't follow typical connectives"
             
             # Let's try to identify chemical blocks.
             # "Aqvo Cetyd Akohol Propylene Glycol..."
             
             # Regex to find potential ingredients (Capitalized Word + Optional Second Word)
             # This regex looks for: CapWord (space CapWord)*
             matches = re.findall(r'[A-Z][a-z]+(?:\s[A-Z][a-z]+)*', ingredient_section)
             if len(matches) > 3: # If we found a bunch of potential chemical names
                 ingredients = matches
             else:
                 # Last resort: just split by space and let the user correct it? 
                 # Or just split by 2+ spaces
                 ingredients = re.split(r'\s{2,}', ingredient_section)

        clean_ingredients = []
        for ing in ingredients:
             cleaned = self.clean_ingredient_name(ing)
             # Filter logic:
             # 1. Must be longer than 2 chars
             # 2. Should not be a long sentence (ingredients are usually < 50 chars)
             # 3. Should not contain too many numbers
             # 4. Filter out common noise words
             
             if len(cleaned) <= 2:
                 continue
                 
             if len(cleaned) > 50:
                 # Likely a sentence or instruction that wasn't cut off
                 continue
                 
             if re.search(r'\d{3,}', cleaned): # e.g. phone numbers or zip codes
                 continue
                 
             clean_ingredients.append(cleaned)

        return clean_ingredients
    
    def clean_ingredient_name(self, ingredient: str) -> str:
        ingredient = ingredient.strip()
        ingredient = re.sub(r'\([^)]*\)', '', ingredient)
        ingredient = re.sub(r'\d+\.?\d*%?', '', ingredient)
        ingredient = re.sub(r'\s+', ' ', ingredient)
        return ingredient.strip()
