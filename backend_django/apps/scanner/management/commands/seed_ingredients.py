from django.core.management.base import BaseCommand
from apps.scanner.models import Ingredient
import json

class Command(BaseCommand):
    help = 'Seeds the database with initial cosmetic ingredients'

    def handle(self, *args, **kwargs):
        self.stdout.write('Seeding ingredients...')
        
        ingredients = [
            {
                "name": "Water",
                "inci_name": "Aqua",
                "function": "Solvent",
                "description": "Essential for hydration and dissolving other ingredients.",
                "safety_rating": 1,
                "comedogenic_rating": 0,
                "effects": {"oily": "beneficial", "dry": "beneficial", "sensitive": "beneficial"}
            },
            {
                "name": "Glycerin",
                "inci_name": "Glycerin",
                "function": "Humectant",
                "description": "Attracts moisture to the skin.",
                "safety_rating": 1,
                "comedogenic_rating": 0,
                "effects": {"oily": "beneficial", "dry": "beneficial"}
            },
            {
                "name": "Niacinamide",
                "inci_name": "Niacinamide",
                "function": "Active",
                "description": "Vitamin B3, brightens skin and controls oil.",
                "safety_rating": 1,
                "comedogenic_rating": 0,
                "effects": {"oily": "beneficial", "sensitive": "beneficial"}
            },
            {
                "name": "Alcohol Denat.",
                "inci_name": "Alcohol Denat.",
                "function": "Solvent, Astringent",
                "description": "Can be drying and irritating to sensitive skin.",
                "safety_rating": 5,
                "is_irritant": True,
                "comedogenic_rating": 0,
                "effects": {"oily": "neutral", "dry": "avoid", "sensitive": "avoid"}
            },
            {
                "name": "Fragrance",
                "inci_name": "Parfum",
                "function": "Scent",
                "description": "Synthetic or natural scent, common cause of allergic reactions.",
                "safety_rating": 8,
                "is_allergen": True,
                "is_irritant": True,
                "comedogenic_rating": 0,
                "effects": {"sensitive": "avoid"}
            },
            {
                "name": "Retinol",
                "inci_name": "Retinol",
                "function": "Active",
                "description": "Vitamin A derivative, anti-aging. Not pregnancy safe.",
                "safety_rating": 4,
                "is_irritant": True,
                "pregnancy_safe": False,
                "comedogenic_rating": 1,
                "effects": {"dry": "caution", "sensitive": "caution"}
            },
            {
                "name": "Salicylic Acid",
                "inci_name": "Salicylic Acid",
                "function": "Exfoliant",
                "description": "BHA, exfoliates inside pores. Great for acne.",
                "safety_rating": 3,
                "is_irritant": True,
                "comedogenic_rating": 0,
                "effects": {"oily": "beneficial", "acne": "beneficial", "sensitive": "caution"}
            },
            {
                "name": "Hyaluronic Acid",
                "inci_name": "Sodium Hyaluronate",
                "function": "Humectant",
                "description": "Holds 1000x its weight in water, hydrates skin.",
                "safety_rating": 1,
                "comedogenic_rating": 0,
                "effects": {"dry": "beneficial", "oily": "beneficial"}
            },
            {
                "name": "Phenoxyethanol",
                "inci_name": "Phenoxyethanol",
                "function": "Preservative",
                "description": "Safe synthetic preservative.",
                "safety_rating": 3,
                "is_irritant": True,
                "comedogenic_rating": 0
            },
            {
                "name": "Parabens",
                "inci_name": "Methylparaben",
                "function": "Preservative",
                "description": "Controversial preservative, often avoided.",
                "safety_rating": 7,
            },
            {
                "name": "Cetyl Alcohol",
                "inci_name": "Cetyl Alcohol",
                "function": "Emollient, Thickener",
                "description": "Fatty alcohol used to stabilize formulations and soften skin. Non-irritating.",
                "safety_rating": 1,
                "comedogenic_rating": 2,
                "effects": {"dry": "beneficial"}
            },
            {
                "name": "Propylene Glycol",
                "inci_name": "Propylene Glycol",
                "function": "Humectant, Solvent",
                "description": "Helps ingredients penetrate skin. Can be irritating to very sensitive skin.",
                "safety_rating": 3,
                "is_irritant": True,
                "comedogenic_rating": 0,
                "effects": {"sensitive": "caution"}
            },
            {
                "name": "Sodium Lauryl Sulfate",
                "inci_name": "Sodium Lauryl Sulfate",
                "function": "Surfactant",
                "description": "Strong cleanser (SLS). Can be drying and strip natural oils. Often avoided in gentle skincare.",
                "safety_rating": 5,
                "is_irritant": True,
                "comedogenic_rating": 3,
                "effects": {"dry": "avoid", "sensitive": "avoid"}
            },
            {
                "name": "Stearyl Alcohol",
                "inci_name": "Stearyl Alcohol",
                "function": "Emollient",
                "description": "Fatty alcohol, smooths skin and thickens products.",
                "safety_rating": 1,
                "comedogenic_rating": 2
            },
            {
                "name": "Propylparaben",
                "inci_name": "Propylparaben",
                "function": "Preservative",
                "description": "Paraben preservative. Prevents mold and bacteria.",
                "safety_rating": 7,
                "effects": {"sensitive": "caution"}
            },
            {
                "name": "Butylparaben",
                "inci_name": "Butylparaben",
                "function": "Preservative",
                "description": "Paraben preservative.",
                "safety_rating": 7,
                "effects": {"sensitive": "caution"}
            },
            {
                "name": "Cocamidopropyl Betaine",
                "inci_name": "Cocamidopropyl Betaine",
                "function": "Surfactant",
                "description": "Mild surfactant derived from coconut oil. Generally safe but can cause allergies.",
                "safety_rating": 3,
                "is_irritant": True,
                "effects": {"sensitive": "caution"}
            },
            {
                "name": "Coco-Glucoside",
                "inci_name": "Coco-Glucoside",
                "function": "Surfactant",
                "description": "Very gentle cleanser derived from fruit sugar and coconut oil.",
                "safety_rating": 1,
                "effects": {"sensitive": "beneficial", "dry": "beneficial"}
            },
            {
                "name": "Mandelic Acid",
                "inci_name": "Mandelic Acid",
                "function": "Exfoliant",
                "description": "AHA derived from bitter almonds. Gentler than glycolic acid.",
                "safety_rating": 2,
                "effects": {"acne": "beneficial", "sensitive": "beneficial"}
            },
            {
                "name": "Glycolic Acid",
                "inci_name": "Glycolic Acid",
                "function": "Exfoliant",
                "description": "AHA that exfoliates skin. Can be irritating.",
                "safety_rating": 4,
                "is_irritant": True,
                "effects": {"sensitive": "caution", "dry": "caution"}
            },
            {
                "name": "Strawberry Extract",
                "inci_name": "Fragaria Ananassa Fruit Extract",
                "function": "Antioxidant",
                "description": "Natural extract rich in Vitamin C.",
                "safety_rating": 1,
                "effects": {"oily": "beneficial"}
            },
            {
                "name": "Blackberry Extract",
                "inci_name": "Rubus Fruticosus Fruit Extract",
                "function": "Antioxidant",
                "description": "Rich in antioxidants and vitamins.",
                "safety_rating": 1,
                "effects": {"oily": "beneficial"}
            },
            {
                "name": "Raspberry Extract",
                "inci_name": "Rubus Idaeus Fruit Extract",
                "function": "Antioxidant",
                "description": "Soothing and antioxidant properties.",
                "safety_rating": 1,
                "effects": {"sensitive": "beneficial"}
            },
            {
                "name": "Coconut Acid",
                "inci_name": "Coconut Acid",
                "function": "Emollient, Surfactant",
                "description": "Fatty acids from coconut oil.",
                "safety_rating": 1,
                "comedogenic_rating": 4,
                "effects": {"acne": "avoid"}
            },
            {
                "name": "Sodium Chloride",
                "inci_name": "Sodium Chloride",
                "function": "Thickener",
                "description": "Table salt. Used to thicken products.",
                "safety_rating": 1,
                "comedogenic_rating": 5,
                "effects": {"acne": "avoid"}
            },
            {
                "name": "Menthyl Lactate",
                "inci_name": "Menthyl Lactate",
                "function": "Cooling Agent",
                "description": "Provides a cooling sensation. Milder than menthol.",
                "safety_rating": 2,
                "effects": {"sensitive": "caution"}
            },
            {
                "name": "Calcium Gluconate",
                "inci_name": "Calcium Gluconate",
                "function": "Humectant",
                "description": "Skin conditioning agent.",
                "safety_rating": 1
            },
            {
                "name": "Gluconolactone",
                "inci_name": "Gluconolactone",
                "function": "Exfoliant, Humectant",
                "description": "PHA, very gentle exfoliant suitable for sensitive skin.",
                "safety_rating": 1,
                "effects": {"sensitive": "beneficial"}
            },
            {
                "name": "Sodium Benzoate",
                "inci_name": "Sodium Benzoate",
                "function": "Preservative",
                "description": "Common food-grade preservative.",
                "safety_rating": 2,
                "effects": {"sensitive": "caution"}
            },
            {
                "name": "Potassium Sorbate",
                "inci_name": "Potassium Sorbate",
                "function": "Preservative",
                "description": "Mild preservative.",
                "safety_rating": 2
            },
            {
                "name": "Limonene",
                "inci_name": "Limonene",
                "function": "Fragrance Component",
                "description": "Citrus scent component. Common allergen.",
                "safety_rating": 6,
                "is_allergen": True,
                "effects": {"sensitive": "avoid"}
            },
            {
                "name": "Betaine",
                "inci_name": "Betaine",
                "function": "Humectant, Anti-irritant",
                "description": "Hydrates skin and reduces irritation.",
                "safety_rating": 1,
                "effects": {"sensitive": "beneficial", "dry": "beneficial"}
            },
            {
                "name": "Sodium Carbonate",
                "inci_name": "Sodium Carbonate",
                "function": "pH Adjuster",
                "description": "Soda ash. Used to adjust pH. Can be drying in high concentrations.",
                "safety_rating": 2,
                "is_irritant": True,
                "effects": {"dry": "caution"}
            }
        ]

        count = 0
        for data in ingredients:
            ing, created = Ingredient.objects.get_or_create(
                name=data['name'],
                defaults=data
            )
            if created:
                count += 1
        
        self.stdout.write(self.style.SUCCESS(f'Successfully seeded {count} ingredients'))
