
import re
import difflib

# This is the raw text from the user's previous error report/logs
RAW_TEXT_SAMPLE = """
Skin Cleanser GENTLE FOR SENSITIVE SKIN Tue Joop cleonser is speciolly lormuloted For tenthvo skin skin to ratoin needed moistvre. Rises olf couly ond Ihosin Jolt ond soolh Directions Without Woter Apply berol omounf of clconser to tho skin ond rub n Removo OCO wth solt dloth lcoving Jhin Gm onthe Wath Woter Apply cleonser to the skin ond rub gent Riso Maith wolors Coulion Forexernoluse only When this produdOvoid contod whoret Mcontod docs OccUrimmediotely Huth wah woter. Vovolowed gel medicol help Kecp out ofreoch olchidren Ingredicnis Aqvo Cetyd Akohol Propylene Glycol Sodium Lovrxd Sulote Steoryd Akohol MethylporobenPropylporoben Butylporoben Joc CJ Distribution Otae o e Fnet cete Oet alt gentlo fecling Using Weedtd Deeea il ee Vi Jer Ja Caa aaa Gu
"""

def clean_ingredient_name(ingredient):
    ingredient = ingredient.strip()
    ingredient = re.sub(r'\([^)]*\)', '', ingredient)
    ingredient = re.sub(r'\d+\.?\d*%?', '', ingredient)
    ingredient = re.sub(r'\s+', ' ', ingredient)
    return ingredient.strip()

def extract_ingredient_list(text):
    print("--- RAW TEXT ---")
    print(text)
    print("----------------")

    markers = [
        r'ingredients?:',
        r'INGREDIENTS?:',
        r'inci:',
        r'INCI:',
        r'composition:',
        r'contains:',
        r'formula:',
        r'Ingredicnis' # Typos seen in OCR
    ]
    
    ingredient_section = None
    
    # 1. Find Start
    print("\n>>> Searching for Start Marker...")
    for marker in markers:
        match = re.search(marker, text, re.IGNORECASE)
        print(f"Checking marker '{marker}': {match}")
        if match:
            print(f"MATCH FOUND! Start index: {match.end()}")
            ingredient_section = text[match.end():].strip()
            break
    
    if not ingredient_section:
        print(">>> NO MARKER FOUND. Using full text fallback.")
        ingredient_section = text

    print(f"\n>>> Section after Start Crop:\n{ingredient_section[:200]}...")

    # 2. Find End
    print("\n>>> Searching for End Marker...")
    end_markers = [
        r'Dist\.', r'Distributed', r'Manufactured', r'Mfd\.', r'Made in', r'www\.',
        r'Store at', r'Caution:', r'Warning:', r'Directions:', r'EXP', r'Batch',
        r'Lot', r'Questions\?', r'Joc CJ Distribution' # Seen in user text
    ]
    
    first_end_index = len(ingredient_section)
    for end_marker in end_markers:
        end_match = re.search(end_marker, ingredient_section, re.IGNORECASE)
        if end_match:
             print(f"Found end marker '{end_marker}' at index {end_match.start()}")
             if end_match.start() < first_end_index:
                 first_end_index = end_match.start()
    
    ingredient_section = ingredient_section[:first_end_index].strip()
    print(f"\n>>> Section after End Crop:\n{ingredient_section}")

    # Split
    # OCR often misses commas. Let's try to split by capital letters if commas are missing?
    # Or just use the space splitting for this specific case?
    # The user text has: "Aqvo Cetyd Akohol Propylene Glycol Sodium..." (Spaces, no commas)
    
    print("\n>>> Splitting Strategy...")
    if ',' in ingredient_section:
        print("Using Comma Split")
        ingredients = re.split(r'[,;•|]', ingredient_section)
    else:
        print("No commas found! Using ' Capital' split heuristic.")
        # Split by Space followed by Capital letter, but be careful with "Sodium Lauryl Sulfate"
        # Actually in this specific text: "Aqvo Cetyd Akohol Propylene Glycol..."
        # It's hard to split "Cetyd Akohol Propylene Glycol" without knowing ingredients.
        # But we can try to split by standard delims first.
        ingredients = re.split(r'[,;•|]|\s{2,}', ingredient_section)
    
    clean_ingredients = []
    print("\n>>> Filtering Ingredients...")
    for ing in ingredients:
         cleaned = clean_ingredient_name(ing)
         print(f"Candidate: '{ing}' -> Cleaned: '{cleaned}'")
         
         if len(cleaned) <= 2:
             print("  -> REJECT (Too short)")
             continue
             
         if len(cleaned) > 50:
             print("  -> REJECT (Too long)")
             continue
             
         if re.search(r'\d{3,}', cleaned):
             print("  -> REJECT (Numbers)")
             continue
             
         clean_ingredients.append(cleaned)
         print("  -> ACCEPT")

    return clean_ingredients

if __name__ == "__main__":
    results = extract_ingredient_list(RAW_TEXT_SAMPLE)
    print("\n=== FINAL RESULTS ===")
    print(results)
