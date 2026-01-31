import requests
import json

url = 'http://localhost:8000/api/auth/login'
data = {
    'email': 'admin@skintech.com',
    'password': 'admin' # Assuming this credentials, or I can try with bad ones to trigger the logic
}

try:
    response = requests.post(url, json=data)
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 500:
        import re
        content = response.text
        # Look for exception type and value
        exc_type = re.search(r'<h1 class="exc_type">(.*?)</h1>', content)
        exc_value = re.search(r'<pre class="exception_value">(.*?)</pre>', content)
        
        if exc_type:
            print(f"Exception Type: {exc_type.group(1)}")
        if exc_value:
            print(f"Exception Value: {exc_value.group(1)}")
            
        if not exc_type and not exc_value:
            print("Could not parse Django error page. Saving to error.html")
            with open('error.html', 'w', encoding='utf-8') as f:
                f.write(content)
    else:
        print(response.text[:500])
except Exception as e:
    print(f"Error: {e}")
