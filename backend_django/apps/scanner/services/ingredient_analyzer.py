"""
Ingredient Analysis Service
Analyzes cosmetic ingredients for safety, compatibility, and effects
"""

from typing import List, Dict, Optional
from django.db.models import Q
from apps.scanner.models import Ingredient
import re
import difflib

class IngredientAnalyzer:
    def __init__(self):
        """Initialize the ingredient analyzer with JSON data"""
        self.ingredient_cache = {}
        self.db = []
        self._load_db()

    def _load_db(self):
        import json
        import os
        try:
            # Path to backend_django/apps/scanner/data/ingredients.json
            base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
            json_path = os.path.join(base_dir, 'data', 'ingredients.json')
            
            with open(json_path, 'r', encoding='utf-8') as f:
                self.db = json.load(f)
            print(f">>> JSON DB Loaded: {len(self.db)} ingredients")
        except Exception as e:
            print(f">>> ERROR Loading JSON DB: {e}")
            self.db = []

    def find_ingredient(self, name: str) -> Optional[Dict]:
        """
        Find ingredient by name (JSON lookup)
        """
        # DEBUG LOGGING
        print(f">>> Lookup: '{name}'")
        
        # Check cache first
        if name.lower() in self.ingredient_cache:
            # print(f"    -> Cached: {self.ingredient_cache[name.lower()]['name']}")
            return self.ingredient_cache[name.lower()]
        
        # Clean the name
        clean_name = self.clean_ingredient_name(name)
        print(f"    -> Cleaned: '{clean_name}'")
        
        # 1. Exact Match Check
        for ing in self.db:
            if ing['name'].lower() == clean_name.lower() or \
               (ing['inci_name'] and ing['inci_name'].lower() == clean_name.lower()):
                print(f"    -> Exact Match Found (JSON): {ing['name']}")
                self.ingredient_cache[name.lower()] = ing
                return ing
                
        # 2. Partial Match Check
        for ing in self.db:
            if clean_name.lower() in ing['name'].lower() or \
               (ing['inci_name'] and clean_name.lower() in ing['inci_name'].lower()):
                print(f"    -> Partial Match Found (JSON): {ing['name']}")
                self.ingredient_cache[name.lower()] = ing
                return ing
        
        # 3. Fuzzy match
        all_names = [i['name'] for i in self.db]
        # Add INCI names to candidates
        for i in self.db:
            if i['inci_name']:
                all_names.append(i['inci_name'])
                
        matches = difflib.get_close_matches(clean_name, all_names, n=1, cutoff=0.8)
        
        if matches:
            best_match = matches[0]
            print(f"    -> Fuzzy Candidate: '{best_match}'")
            # Find the dict
            for ing in self.db:
                if ing['name'] == best_match or ing['inci_name'] == best_match:
                    print(f"    -> Fuzzy Resolved: {ing['name']}")
                    self.ingredient_cache[name.lower()] = ing
                    return ing

        print("    -> NO MATCH found")
        return None
    
    def clean_ingredient_name(self, name: str) -> str:
        """Clean ingredient name for matching"""
        # 1. Remove text in parentheses (synonyms like 'Aqua (Water)')
        name = re.sub(r'\s*\(.*?\)', '', name)
        # 2. Remove extra whitespace
        name = re.sub(r'\s+', ' ', name.strip())
        # 3. Remove special characters
        name = re.sub(r'[^\w\s-]', '', name)
        return name.strip()
    
    def analyze_ingredients(self, ingredient_names: List[str], skin_type: str = None) -> Dict:
        """
        Analyze a list of ingredients
        """
        results = {
            'total_ingredients': len(ingredient_names),
            'identified_ingredients': [],
            'unidentified_ingredients': [],
            'overall_safety_score': 0,
            'concerns': [],
            'benefits': [],
            'skin_compatibility': {},
            'warnings': [],
            'recommendations': []
        }
        
        identified = []
        safety_scores = []
        
        for name in ingredient_names:
            ingredient = self.find_ingredient(name)
            
            if ingredient:
                identified.append(ingredient)
                results['identified_ingredients'].append({
                    'name': ingredient['name'],
                    'inci_name': ingredient.get('inci_name'),
                    'function': ingredient.get('function'),
                    'safety_rating': ingredient.get('safety_rating'),
                    'description': ingredient.get('description'),
                    'effects': ingredient.get('effects'),
                    'warnings': [] # Local warnings for this ingredient
                })
                
                # Collect safety scores
                if ingredient.get('safety_rating'):
                    safety_scores.append(ingredient['safety_rating'])
                
                # Check for concerns
                ing_warnings = []
                if ingredient.get('is_allergen'):
                    msg = f"{ingredient['name']} is a known allergen"
                    results['warnings'].append(msg)
                    ing_warnings.append("Allergen")
                
                if ingredient.get('is_irritant'):
                    msg = f"{ingredient['name']} may cause irritation"
                    results['warnings'].append(msg)
                    ing_warnings.append("Irritant")
                
                if not ingredient.get('pregnancy_safe'):
                    msg = f"{ingredient['name']} is not recommended during pregnancy"
                    results['warnings'].append(msg)
                    ing_warnings.append("Not Pregnancy Safe")

                # Update the last added ingredient dict with warnings
                results['identified_ingredients'][-1]['warnings'] = ing_warnings
                
                # Add benefits
                if ingredient.get('function'):
                    results['benefits'].append(f"{ingredient['name']}: {ingredient['function']}")
                
                # Skin type compatibility
                if skin_type and ingredient.get('effects'):
                    effect = ingredient['effects'].get(skin_type.lower())
                    if effect:
                        if effect == 'beneficial':
                            results['skin_compatibility'][ingredient['name']] = 'Good for your skin type'
                        elif effect == 'avoid':
                            results['skin_compatibility'][ingredient['name']] = 'Not recommended for your skin type'
                            results['concerns'].append(f"{ingredient['name']} may not be suitable for {skin_type} skin")
            else:
                results['unidentified_ingredients'].append(name)
        
        # Calculate overall safety score (1-10, lower is better)
        if safety_scores:
            results['overall_safety_score'] = round(sum(safety_scores) / len(safety_scores), 1)
        else:
            results['overall_safety_score'] = 5.0  # Neutral if no data
        
        # Grading text
        if results['overall_safety_score'] < 3:
             results['safety_assessment'] = "Excellent Safety Profile"
        elif results['overall_safety_score'] < 5:
             results['safety_assessment'] = "Good Safety Profile"
        elif results['overall_safety_score'] < 7:
             results['safety_assessment'] = "Moderate Risk"
        else:
             results['safety_assessment'] = "High Risk / Use Caution"

        # Generate recommendations
        results['recommendations'] = self.get_recommendations(results, skin_type)
        
        # Add summary
        results['summary'] = self.generate_summary(results)
        
        return results
    
    def generate_summary(self, analysis: Dict) -> str:
        total = analysis['total_ingredients']
        identified = len(analysis['identified_ingredients'])
        score = analysis['overall_safety_score']
        
        summary = f"Analyzed {total} ingredients, identified {identified}. "
        
        if score <= 3:
            summary += "Overall safety rating: Excellent. "
        elif score <= 5:
            summary += "Overall safety rating: Good. "
        elif score <= 7:
            summary += "Overall safety rating: Moderate. "
        else:
            summary += "Overall safety rating: Concerning. "
        
        if analysis['warnings']:
            summary += f"Found {len(analysis['warnings'])} potential concerns. "
        
        return summary
    
    def get_recommendations(self, analysis: Dict, skin_type: str = None) -> List[str]:
        recommendations = []
        
        if analysis['overall_safety_score'] > 7:
            recommendations.append("Consider looking for products with safer ingredient profiles")
        
        if any('allergen' in w.lower() for w in analysis['warnings']):
            recommendations.append("If you have sensitive skin, patch test this product before use")
        
        if skin_type and analysis['concerns']:
            recommendations.append(f"Some ingredients may not be ideal for {skin_type} skin")
            
        if analysis['overall_safety_score'] <= 3 and not analysis['warnings']:
            recommendations.append("This product has a clean ingredient profile!")
            
        return recommendations
