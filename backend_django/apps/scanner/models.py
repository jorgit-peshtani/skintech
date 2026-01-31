from django.db import models

class Ingredient(models.Model):
    name = models.CharField(max_length=255, unique=True)
    inci_name = models.CharField(max_length=255, blank=True, null=True)
    function = models.TextField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    safety_rating = models.IntegerField(default=5, help_text="1-10, lower is better")
    comedogenic_rating = models.IntegerField(default=0, help_text="0-5, lower is better")
    
    # Flags
    is_allergen = models.BooleanField(default=False)
    is_irritant = models.BooleanField(default=False)
    pregnancy_safe = models.BooleanField(default=True)
    
    # JSON for flexible data
    # format: {"oily": "beneficial", "dry": "avoid"}
    effects = models.JSONField(default=dict, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name
