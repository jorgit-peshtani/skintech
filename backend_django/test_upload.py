
import os
import django
import requests
from django.core.files.uploadedfile import SimpleUploadedFile

# Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'skintech_django.settings')
django.setup()

def test_upload():
    # Create a dummy image file
    with open('test_image.jpg', 'wb') as f:
        f.write(b'\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x01\x00H\x00H\x00\x00\xFF\xDB\x00C\x00\xFF\xC0\x00\x11\x08\x00\x0A\x00\x0A\x03\x01\x22\x00\x02\x11\x01\x03\x11\x01\xFF\xC4\x00\x1F\x00\x00\x01\x05\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\xFF\xDA\x00\x0C\x03\x01\x00\x02\x11\x03\x11\x00\x3F\x00\xBF\x00\xFF\xD9')

    url = 'http://localhost:8000/simple/products/'
    
    # 1. Create a product first
    print('Creating product...')
    data = {
        'title': 'Test Upload Product',
        'price': '10.00',
        'stock': 10
    }
    # Create via POST first with no image to get ID (or just create new one with image)
    # Let's try creating NEW with image
    
    files = {
        'image': ('test_image.jpg', open('test_image.jpg', 'rb'), 'image/jpeg')
    }
    
    try:
        response = requests.post(url, data=data, files=files)
        print(f'Status: {response.status_code}')
        print(f'Response: {response.text}')
        
        if response.status_code == 200:
            print('Upload success!')
    except Exception as e:
        print(f'Failed: {e}')
    finally:
        if os.path.exists('test_image.jpg'):
            os.remove('test_image.jpg')

if __name__ == '__main__':
    test_upload()
