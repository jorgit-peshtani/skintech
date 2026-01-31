from django.db import models
from oscar.apps.catalogue.abstract_models import AbstractProduct as CoreAbstractProduct

class Product(CoreAbstractProduct):
    brand = models.CharField(max_length=100, blank=True, null=True)

from oscar.apps.catalogue.models import * 
