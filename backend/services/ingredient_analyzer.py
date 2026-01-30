"""
Ingredient Analysis Service
Analyzes cosmetic ingredients for safety, compatibility, and effects
"""

from typing import List, Dict, Optional
from models import Ingredient, db
from sqlalchemy import or_
import re

class IngredientAnalyzer:
    def __init__(self):
        """Initialize the ingredient analyzer"""
        self.ingredient_cache = {}
    
    def find_ingredient(self, name: str) -> Optional[Ingredient]:
        """
        Find ingredient in database by name (fuzzy matching)
        
        Args:
            name: Ingredient name to search for
            
        Returns:
            Ingredient object or None
        """
        # Check cache first
        if name.lower() in self.ingredient_cache:
            return self.ingredient_cache[name.lower()]
        
        # Clean the name
        clean_name = self.clean_ingredient_name(name)
        
        # Try exact match first
        ingredient = Ingredient.query.filter(
            or_(
                Ingredient.name.ilike(clean_name),
                Ingredient.inci_name.ilike(clean_name)
            )
        ).first()
        
        if ingredient:
            self.ingredient_cache[name.lower()] = ingredient
            return ingredient
        
        # Try partial match
        ingredient = Ingredient.query.filter(
            or_(
                Ingredient.name.ilike(f'%{clean_name}%'),
                Ingredient.inci_name.ilike(f'%{clean_name}%')
            )
        ).first()
        
        if ingredient:
            self.ingredient_cache[name.lower()] = ingredient
        
        return ingredient
    
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
        
        Args:
            ingredient_names: List of ingredient names
            skin_type: User's skin type (optional)
            
        Returns:
            Analysis results dictionary
        """
        results = {
            'total_ingredients': len(ingredient_names),
            'identified_ingredients': [],
            'unidentified_ingredients': [],
            'overall_safety_score': 0,
            'concerns': [],
            'benefits': [],
            'skin_compatibility': {},
            'warnings': []
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
                    'description': ingredient.description
                })
                
                # Collect safety scores
                if ingredient.safety_rating:
                    safety_scores.append(ingredient.safety_rating)
                
                # Check for concerns
                if ingredient.is_allergen:
                    results['warnings'].append(f"{ingredient.name} is a known allergen")
                
                if ingredient.is_irritant:
                    results['warnings'].append(f"{ingredient.name} may cause irritation")
                
                if not ingredient.pregnancy_safe:
                    results['warnings'].append(f"{ingredient.name} is not recommended during pregnancy")
                
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
            results['overall_safety_score'] = sum(safety_scores) / len(safety_scores)
        else:
            results['overall_safety_score'] = 5  # Neutral if no data
        
        # Add summary
        results['summary'] = self.generate_summary(results)
        
        return results
    
    def generate_summary(self, analysis: Dict) -> str:
        """
        Generate a human-readable summary of the analysis
        
        Args:
            analysis: Analysis results dictionary
            
        Returns:
            Summary text
        """
        total = analysis['total_ingredients']
        identified = len(analysis['identified_ingredients'])
        score = analysis['overall_safety_score']
        
        summary = f"Analyzed {total} ingredients, identified {identified} ({int(identified/total*100)}% match rate). "
        
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
        
        if analysis['concerns']:
            summary += "Please review the detailed concerns below."
        else:
            summary += "No major concerns detected."
        
        return summary
    
    def get_recommendations(self, analysis: Dict, skin_type: str = None) -> List[str]:
        """
        Get product recommendations based on analysis
        
        Args:
            analysis: Analysis results
            skin_type: User's skin type
            
        Returns:
            List of recommendations
        """
        recommendations = []
        
        # Based on safety score
        if analysis['overall_safety_score'] > 7:
            recommendations.append("Consider looking for products with safer ingredient profiles")
        
        # Based on warnings
        if any('allergen' in w.lower() for w in analysis['warnings']):
            recommendations.append("If you have sensitive skin, patch test this product before use")
        
        # Based on skin type
        if skin_type and analysis['concerns']:
            recommendations.append(f"Some ingredients may not be ideal for {skin_type} skin")
        
        # Positive recommendations
        if analysis['overall_safety_score'] <= 3 and not analysis['warnings']:
            recommendations.append("This product has a clean ingredient profile!")
        
        return recommendations

# Example usage
if __name__ == '__main__':
    analyzer = IngredientAnalyzer()
    
    # Sample ingredient list
    ingredients = [
        "Aqua",
        "Glycerin",
        "Niacinamide",
        "Hyaluronic Acid",
        "Retinol"
    ]
    
    analysis = analyzer.analyze_ingredients(ingredients, skin_type='dry')
    print(f"Summary: {analysis['summary']}")
    print(f"Safety Score: {analysis['overall_safety_score']}/10")
    print(f"Warnings: {len(analysis['warnings'])}")
