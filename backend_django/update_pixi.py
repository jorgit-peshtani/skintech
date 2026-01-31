
import os
import django
import requests

# Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'skintech_django.settings')
django.setup()

def update_pixi():
    # Create a dummy image file
    with open('pixi_test.jpg', 'wb') as f:
        f.write(b'\xFF\xD8\xFF\xE0\x00\x10JFIF\x00\x01\x01\x01\x00H\x00H\x00\x00\xFF\xDB\x00C\x00\xFF\xC0\x00\x11\x08\x00\x0A\x00\x0A\x03\x01\x22\x00\x02\x11\x01\x03\x11\x01\xFF\xC4\x00\x1F\x00\x00\x01\x05\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\xFF\xDA\x00\x0C\x03\x01\x00\x02\x11\x03\x11\x00\x3F\x00\xBF\x00\xFF\xD9')

    url = 'http://localhost:8000/simple/products/15/'
    
    print('Updating Pixi (ID 15)...')
    
    # Use explicit open/close to avoid locking
    with open('pixi_test.jpg', 'rb') as img_f:
        files = {
            'image': ('pixi_test.jpg', img_f, 'image/jpeg')
        }
        data = {
            'title': 'Pixi - Glow Tonic',
            'price': '29.00',
            'stock': 45
        }
        
        try:
            # Requests.put/patch
            response = requests.put(url, data=data, files=files)
            print(f'Status: {response.status_code}')
            print(f'Response: {response.text}')
            
            if response.status_code == 200:
                print('Update success!')
        except Exception as e:
            print(f'Failed: {e}')
            
    # Cleanup
    try:
        if os.path.exists('pixi_test.jpg'):
            os.remove('pixi_test.jpg')
    except Exception as e:
        print(f"Cleanup failed: {e}")

if __name__ == '__main__':
    update_pixi()
