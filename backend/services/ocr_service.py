"""
OCR Service for extracting text from cosmetic product labels
Supports multiple OCR engines: Tesseract and EasyOCR
"""

import os
import cv2
import numpy as np
from PIL import Image
import pytesseract
import easyocr
from typing import List, Dict, Optional
import re

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
        
        if engine == 'easyocr':
            self.reader = easyocr.Reader(languages)
        elif engine == 'tesseract':
            # Tesseract should be installed separately
            pass
        else:
            raise ValueError(f"Unsupported OCR engine: {engine}")
    
    def preprocess_image(self, image_path: str) -> np.ndarray:
        """
        Preprocess image for better OCR results
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Preprocessed image as numpy array
        """
        # Read image
        img = cv2.imread(image_path)
        
        # Convert to grayscale
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        
        # Apply thresholding to get binary image
        _, binary = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        
        # Denoise
        denoised = cv2.fastNlMeansDenoising(binary)
        
        # Increase contrast
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
        enhanced = clahe.apply(denoised)
        
        return enhanced
    
    def extract_text_tesseract(self, image_path: str) -> str:
        """
        Extract text using Tesseract OCR
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Extracted text
        """
        preprocessed = self.preprocess_image(image_path)
        
        # Configure Tesseract
        custom_config = r'--oem 3 --psm 6'
        
        # Extract text
        text = pytesseract.image_to_string(preprocessed, config=custom_config)
        
        return text.strip()
    
    def extract_text_easyocr(self, image_path: str) -> str:
        """
        Extract text using EasyOCR
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Extracted text
        """
        preprocessed = self.preprocess_image(image_path)
        
        # Extract text
        results = self.reader.readtext(preprocessed)
        
        # Combine all detected text
        text = ' '.join([result[1] for result in results])
        
        return text.strip()
    
    def extract_text(self, image_path: str) -> Dict[str, any]:
        """
        Extract text from image using configured OCR engine
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Dictionary with extracted text and metadata
        """
        try:
            if self.engine == 'tesseract':
                text = self.extract_text_tesseract(image_path)
            elif self.engine == 'easyocr':
                text = self.extract_text_easyocr(image_path)
            else:
                raise ValueError(f"Unsupported OCR engine: {self.engine}")
            
            # Clean up text
            text = self.clean_text(text)
            
            return {
                'success': True,
                'text': text,
                'engine': self.engine,
                'languages': self.languages
            }
        except Exception as e:
            return {
                'success': False,
                'error': str(e),
                'text': '',
                'engine': self.engine
            }
    
    def clean_text(self, text: str) -> str:
        """
        Clean and normalize extracted text
        
        Args:
            text: Raw extracted text
            
        Returns:
            Cleaned text
        """
        # Remove extra whitespace
        text = re.sub(r'\s+', ' ', text)
        
        # Remove special characters but keep commas and parentheses
        text = re.sub(r'[^\w\s,().-]', '', text)
        
        return text.strip()
    
    def extract_ingredient_list(self, text: str) -> List[str]:
        """
        Extract ingredient list from OCR text
        Looks for common patterns like "Ingredients:", "INCI:", etc.
        
        Args:
            text: Extracted text from OCR
            
        Returns:
            List of ingredients
        """
        # Common ingredient list markers
        markers = [
            r'ingredients?:',
            r'inci:',
            r'composition:',
            r'contains:',
            r'formula:'
        ]
        
        # Try to find ingredient section
        ingredient_section = None
        for marker in markers:
            match = re.search(marker, text, re.IGNORECASE)
            if match:
                # Get text after the marker
                ingredient_section = text[match.end():].strip()
                break
        
        if not ingredient_section:
            # If no marker found, assume entire text is ingredients
            ingredient_section = text
        
        # Split by common separators
        ingredients = re.split(r'[,;]', ingredient_section)
        
        # Clean each ingredient
        ingredients = [self.clean_ingredient_name(ing) for ing in ingredients]
        
        # Filter out empty strings and very short strings
        ingredients = [ing for ing in ingredients if len(ing) > 2]
        
        return ingredients
    
    def clean_ingredient_name(self, ingredient: str) -> str:
        """
        Clean individual ingredient name
        
        Args:
            ingredient: Raw ingredient name
            
        Returns:
            Cleaned ingredient name
        """
        # Remove leading/trailing whitespace
        ingredient = ingredient.strip()
        
        # Remove parenthetical content (often percentages or clarifications)
        ingredient = re.sub(r'\([^)]*\)', '', ingredient)
        
        # Remove numbers and percentages
        ingredient = re.sub(r'\d+\.?\d*%?', '', ingredient)
        
        # Remove extra whitespace
        ingredient = re.sub(r'\s+', ' ', ingredient)
        
        return ingredient.strip()

# Example usage
if __name__ == '__main__':
    ocr = OCRService(engine='easyocr', languages=['en'])
    result = ocr.extract_text('sample_product.jpg')
    print(f"Extracted text: {result['text']}")
    
    if result['success']:
        ingredients = ocr.extract_ingredient_list(result['text'])
        print(f"Found {len(ingredients)} ingredients:")
        for ing in ingredients:
            print(f"  - {ing}")
