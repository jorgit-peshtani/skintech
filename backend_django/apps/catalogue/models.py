from django.db import models
from oscar.apps.catalogue.abstract_models import AbstractProduct as CoreAbstractProduct
from oscar.apps.catalogue.abstract_models import AbstractCategory as CoreAbstractCategory

class Product(CoreAbstractProduct):
    brand = models.CharField(max_length=100, blank=True, null=True)

class Category(CoreAbstractCategory):
    exclude_from_menu = models.BooleanField(
        default=False, 
        db_index=True,
        verbose_name="Exclude from menu",
        help_text="Exclude this category from the menu."
    )
    long_description = models.TextField(blank=True, verbose_name="Long description")

from oscar.apps.catalogue.models import * 
