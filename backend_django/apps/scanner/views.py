from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser, JSONParser
from .services.ocr_service import OCRService
from .services.ingredient_analyzer import IngredientAnalyzer
import os
import tempfile

class ScanUploadView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        print(">>> ScanUploadView POST called")
        if 'image' not in request.FILES:
            print(">>> ERROR: No image in request.FILES")
            return Response({'error': 'No image provided'}, status=status.HTTP_400_BAD_REQUEST)
        
        image_file = request.FILES['image']
        print(f">>> Image received: {image_file.name}, size: {image_file.size}")
        
        # Save temp file for OCR
        # Note: In production, might want to handle this in memory or clean up better
        fd, path = tempfile.mkstemp(suffix='.jpg')
        try:
            print(f">>> Saving to temp file: {path}")
            with os.fdopen(fd, 'wb') as tmp:
                for chunk in image_file.chunks():
                    tmp.write(chunk)
            
            # 1. OCR
            print(">>> Initializing OCRService...")
            ocr = OCRService(engine='easyocr') # Defaulting to easyocr
            print(f">>> Extracting text from: {path}")
            text_result = ocr.extract_text(path)
            print(f">>> OCR Result: {text_result}")
            
            if not text_result['success']:
                print(f">>> OCR Failed: {text_result.get('error')}")
                return Response({'error': f"OCR Failed: {text_result.get('error')}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
            
            raw_text = text_result['text']
            print(f">>> Raw Text: {raw_text[:100]}...") # Print first 100 chars
            
            # 2. Extract Ingredients
            print(">>> parsing ingredients...")
            ingredients_list = ocr.extract_ingredient_list(raw_text)
            print(f">>> Extracted {len(ingredients_list)} potential ingredients: {ingredients_list}")
            
            # REMOVED EARLY RETURN: Let analyzer report 0 instead of returning a different JSON structure
            # if not ingredients_list: ...

            # 3. Analyze Ingredients
            print(">>> Analyzing ingredients...")
            analyzer = IngredientAnalyzer()
            # Determine skin type if user is authenticated (future feature)
            analysis_result = analyzer.analyze_ingredients(ingredients_list)
            print(f">>> Analysis Result: Identified={len(analysis_result['identified_ingredients'])}, Unidentified={len(analysis_result['unidentified_ingredients'])}")
            print(f">>> Identified: {[i['name'] for i in analysis_result['identified_ingredients']]}")
            print(f">>> Unidentified: {analysis_result['unidentified_ingredients']}")
            
            return Response(analysis_result, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        finally:
            # Clean up temp file
            if os.path.exists(path):
                os.remove(path)

class TextAnalysisView(APIView):
    parser_classes = (JSONParser,)

    def post(self, request, *args, **kwargs):
        text = request.data.get('text', '')
        if not text:
            return Response({'error': 'No text provided'}, status=status.HTTP_400_BAD_REQUEST)
            
        analyzer = IngredientAnalyzer()
        
        # Split text into list if it's a comma-separated string
        if isinstance(text, str):
            ingredients_list = [i.strip() for i in text.split(',') if i.strip()]
        else:
            ingredients_list = text 
            
        analysis_result = analyzer.analyze_ingredients(ingredients_list)
        
        return Response(analysis_result, status=status.HTTP_200_OK)
