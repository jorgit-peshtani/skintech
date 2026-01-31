
import re

RAW_TEXT = "SKEADNIKIINGREDIENTS Aqua (WaterlCocamidopropyl BetaineCoco-GlucosideBetaineMandelic AcidGlycolic AcidFragaria Ananassa Fruit ExtractRubus Fruticosus Fruit ExtractRubus idaeus Fruit ExtractCoconut AcidSodium ChlorideMenthyl LactateCalcium Gluconate GluconolactoneSodium BenzoatePotassium SorbateParfum (FragrancelLimonene"

def clean_ingredient_name(ingredient):
    ingredient = ingredient.strip()
    ingredient = re.sub(r'\([^)]*\)', '', ingredient) # Remove parens
    ingredient = re.sub(r'\d+\.?\d*%?', '', ingredient)
    ingredient = re.sub(r'\s+', ' ', ingredient)
    return ingredient.strip()

def test_splitting(text):
    print(f"Original: {text[:100]}...")
    
    # 1. Insert space between Lowercase and Uppercase (CamelCase split)
    # Be careful not to split "McDairy" -> "Mc Dairy" (maybe okay?)
    # or "pH" -> "p H" (bad).
    # But for ingredients, it's usually "AcidGlycolic" -> "Acid Glycolic".
    
    # Simple CamelCase split
    split_text = re.sub(r'(?<=[a-z])(?=[A-Z])', ' ', text)
    print(f"\nCamelCase Split: {split_text[:100]}...")
    
    # 2. Fix the "WaterlCocamidopropyl" issue?
    # Maybe replace 'l' followed by Capital? That's risky ("AlCool"? No).
    # User's text: "(WaterlCocamidopropyl" -> likely "Water" | "Cocamidopropyl"
    # "l" is probably a typo for "|" or "/" or ")" or ",".
    # If we see "l" between a-z and A-Z, treat as separator?
    split_text = re.sub(r'(?<=[a-z])l(?=[A-Z])', ', ', split_text)
    print(f"\n'l' Typo Fix: {split_text[:100]}...")
    
    # Standard split
    ingredients = re.split(r'[,;•|]|\s{2,}', split_text)
    
    # Also split by the just-inserted spaces?
    # The regex re.sub inserted spaces. The re.split above splits by comma, semi, or DOUBLE space.
    # But now we might have "Betaine Coco-Glucoside". These are separate?
    # No, "Coco-Glucoside" is one thing.
    # "Betaine Coco" -> "Betaine", "Coco" ??
    # Wait, "BetaineCoco" -> "Betaine Coco".
    # "Betaine" is an ingredient. "Coco-Glucoside" is an ingredient.
    # "Betaine Coco-Glucoside" -> If space is the separator?
    # Our previous logic split by `\s{2,}` (two spaces).
    
    # If we rely on the analyzer to fuzzy match "Betaine" from "Betaine Coco-Glucoside",
    # providing "Betaine Coco-Glucoside" as a single string is risky?
    # "Betaine" is one. "Coco-Glucoside" is another.
    
    # Let's try splitting by single space IF the chunk is long?
    # Or just splitting by single space always, and reconstructing?
    # Reconstructing multi-word ingredients (Sodium Lauryl Sulfate) is hard if we split by space.
    
    # BETTER IDEA:
    # Use the database to tokenize! (Maximum Matching)
    # But that's expensive/complex here.
    
    # Let's see what happens if we just treat the result of CamelCase split as the "text to search".
    # And then split by comma?
    # The user text has NO commas.
    
    print("\n--- Tokenizing ---")
    # If we have inserted spaces, "AcidGlycolic" -> "Acid Glycolic".
    # Should be "Acid", "Glycolic"?
    # "Glycolic Acid" is the ingredient. "Mandelic Acid" is the ingredient.
    # "BetaineMandelic AcidGlycolic" -> "Betaine Mandelic Acid Glycolic"
    # -> "Betaine", "Mandelic Acid", "Glycolic" (Acid is missing?) NO "AcidGlycolic" -> "Acid Glycolic"
    # The text is "BetaineMandelic AcidGlycolic".
    # Split: "Betaine Mandelic Acid Glycolic".
    # Valid tokens: "Betaine", "Mandelic Acid", "Glycolic"... (Glycolic Acid?)
    # Wait, "AcidGlycolic " -> maybe it was "Glycolic Acid" inverted? Or "Mandelic Acid Glycolic Acid"?
    # Text: "Mandelic AcidGlycolic Acid"
    # Split: "Mandelic Acid Glycolic Acid"
    # Ingredients: "Mandelic Acid", "Glycolic Acid".
    
    # So if we just split by `CamelCase` and then `Space`, we get:
    # ["Mandelic", "Acid", "Glycolic", "Acid"]
    # We can pass these to the analyzer?
    # Does the analyzer handle single words?
    # "Acid" is not an ingredient. "Mandelic Acid" IS.
    
    # If we pass ["Mandelic Acid Glycolic Acid"] (one string) to Analyzer?
    # It might find nothing.
    
    # Maybe we iterate and try to combine?
    # Or we rely on the fact that ingredients usually end with "Acid", "Extract", "Oil"?
    
    pass

if __name__ == "__main__":
    test_splitting(RAW_TEXT)
