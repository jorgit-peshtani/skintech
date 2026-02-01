"""
OCR Service Stub - Lightweight replacement for low-memory environments
Disables OCR to prevent Render OOM (Out Of Memory) errors.
"""

import logging
from typing import List, Dict

logger = logging.getLogger(__name__)

class OCRService:
    def __init__(self, engine='easyocr', languages=['en']):
        """
        Initialize OCR service Stub
        does NOT load heavy models.
        """
        self.engine = engine
        self.languages = languages
        logger.info("OCR Service initialized in LIGHTWEIGHT mode (OCR Disabled)")

    def preprocess_image(self, image_path: str):
        """Mock preprocessing"""
        return []

    def extract_text(self, image_path: str) -> Dict[str, any]:
        """
        Mock extraction that returns a friendly message.
        """
        return {
            'success': False,
            'text': "OCR is disabled on this server to save memory. Please verify ingredients manually.",
            'error': "OCR Disabled",
            'engine': self.engine
        }

    def extract_ingredient_list(self, text: str) -> List[str]:
        """
        Mock ingredient extraction.
        """
        return []
        
    def clean_text(self, text: str) -> str:
        return text
