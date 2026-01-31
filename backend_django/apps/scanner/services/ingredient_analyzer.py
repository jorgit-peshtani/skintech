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
        """Initialize the ingredient analyzer"""
        self.ingredient_cache = {}
    
    def find_ingredient(self, name: str) -> Optional[Ingredient]:
        """
        Find ingredient in database by name (fuzzy matching)
        """
        # Check cache first
        if name.lower() in self.ingredient_cache:
            return self.ingredient_cache[name.lower()]
        
        # Clean the name
        clean_name = self.clean_ingredient_name(name)
        
        # 1. Try exact match
        ingredient = Ingredient.objects.filter(
            Q(name__iexact=clean_name) | 
            Q(inci_name__iexact=clean_name)
        ).first()
        
        if ingredient:
            self.ingredient_cache[name.lower()] = ingredient
            return ingredient
        
        # 2. Try partial match
        ingredient = Ingredient.objects.filter(
            Q(name__icontains=clean_name) | 
            Q(inci_name__icontains=clean_name)
        ).first()
        
        if ingredient:
            self.ingredient_cache[name.lower()] = ingredient
            return ingredient

        # 3. Fuzzy matching (Levenshtein distance) for OCR typos
        # Load all names (caching this would be better at class level in production)
        all_ingredients = list(Ingredient.objects.values_list('name', flat=True))
        all_inci = list(Ingredient.objects.values_list('inci_name', flat=True))
        candidates = list(set(all_ingredients + all_inci))
        
        matches = difflib.get_close_matches(clean_name, candidates, n=1, cutoff=0.8)
        
        if matches:
            best_match = matches[0]
            # Find the ingredient object for this match
            ingredient = Ingredient.objects.filter(
                Q(name__iexact=best_match) | 
                Q(inci_name__iexact=best_match)
            ).first()
            
            if ingredient:
                self.ingredient_cache[name.lower()] = ingredient
                return ingredient
        
        return None
    
    def clean_ingredient_name(self, name: str) -> str:
        """Clean ingredient name for matching"""
        # Remove extra whitespace
        name = re.sub(r'\s+', ' ', name.strip())
        # Remove special characters
        name = re.sub(r'[^\w\s-]', '', name)
        return name
    
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
                    'name': ingredient.name,
                    'inci_name': ingredient.inci_name,
                    'function': ingredient.function,
                    'safety_rating': ingredient.safety_rating,
                    'description': ingredient.description,
                    'effects': ingredient.effects,
                    'warnings': [] # Local warnings for this ingredient
                })
                
                # Collect safety scores
                if ingredient.safety_rating:
                    safety_scores.append(ingredient.safety_rating)
                
                # Check for concerns
                ing_warnings = []
                if ingredient.is_allergen:
                    msg = f"{ingredient.name} is a known allergen"
                    results['warnings'].append(msg)
                    ing_warnings.append("Allergen")
                
                if ingredient.is_irritant:
                    msg = f"{ingredient.name} may cause irritation"
                    results['warnings'].append(msg)
                    ing_warnings.append("Irritant")
                
                if not ingredient.pregnancy_safe:
                    msg = f"{ingredient.name} is not recommended during pregnancy"
                    results['warnings'].append(msg)
                    ing_warnings.append("Not Pregnancy Safe")

                # Update the last added ingredient dict with warnings
                results['identified_ingredients'][-1]['warnings'] = ing_warnings
                
                # Add benefits
                if ingredient.function:
                    results['benefits'].append(f"{ingredient.name}: {ingredient.function}")
                
                # Skin type compatibility
                if skin_type and ingredient.effects:
                    effect = ingredient.effects.get(skin_type.lower())
                    if effect:
                        if effect == 'beneficial':
                            results['skin_compatibility'][ingredient.name] = 'Good for your skin type'
                        elif effect == 'avoid':
                            results['skin_compatibility'][ingredient.name] = 'Not recommended for your skin type'
                            results['concerns'].append(f"{ingredient.name} may not be suitable for {skin_type} skin")
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
