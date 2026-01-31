from django.urls import path
from .views import ScanUploadView, TextAnalysisView

urlpatterns = [
    path('upload', ScanUploadView.as_view(), name='scan-upload'),
    path('analyze-text', TextAnalysisView.as_view(), name='analyze-text'),
]
