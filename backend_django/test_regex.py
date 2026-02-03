
import re

def test_cleaning():
    # The problematic string from logs
    raw_text = "220909 SKŁADNIKI/INGREDIENTS (INCI): Aqua (Waterl, Glycerin"
    
    print(f"Original: '{raw_text}'")
    
    # 1. Regex from ocr_service.py
    text = raw_text
    
    # Remove leading numbers
    text = re.sub(r'^[\d\s]*', '', text)
    print(f"After Number Strip: '{text}'")
    
    # Header Regex
    # Current: r'^(?:SK.ADNIKI\/)?(?:Ingredients|Contains|Active Ingredients)(?:.*?)[\:]'
    pattern = r'^(?:SK.ADNIKI\/)?(?:Ingredients|Contains|Active Ingredients)(?:.*?)[\:]'
    text = re.sub(pattern, '', text, flags=re.IGNORECASE)
    print(f"After Header Strip: '{text}'")
    
    # Parenthesis Regex
    # Current: r'\s*\(.*?\)'
    text = re.sub(r'\s*\(.*?\)', '', text)
    print(f"After Paren Strip: '{text}'")
    
    # PROPOSED IMPROVEMENTS
    print("\n--- Testing Optimized Regex ---")
    text = raw_text
    text = re.sub(r'^[\d\s]*', '', text)
    
    # Improved Header Regex: Handle spaces, case, and robust start
    # Matches "SKŁADNIKI/INGREDIENTS (INCI):"
    # Note: "." in SK.ADNIKI matches the Polish char
    pattern_new = r'^(?:SK.ADNIKI\s*\/?)?\s*(?:INGREDIENTS|CONTAINS|ACTIVE INGREDIENTS).*?[:]'
    
    text = re.sub(pattern_new, '', text, flags=re.IGNORECASE)
    print(f"After New Header Strip: '{text}'")
    
    # Improved Paren Regex: Handle unclosed parens at end of words if needed
    # But mainly just need to strip the known "(INCI):" which the header regex should catch
    
    # Clean result
    print(f"Final: '{text.strip()}'")

if __name__ == "__main__":
    test_cleaning()
