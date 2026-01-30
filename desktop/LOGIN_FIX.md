# Desktop App Login - Quick Fix

## The Problem
Flask and backend dependencies aren't installed, so the backend can't start and login fails.

## Quick Fix (3 Steps)

### Step 1: Install Backend Dependencies
```bash
cd backend
pip install flask flask-cors flask-sqlalchemy flask-jwt-extended flask-bcrypt flask-migrate python-dotenv opencv-python pillow pytesseract easyocr
```

### Step 2: Create Admin User
```bash
python create_admin.py
```

### Step 3: Start Backend Server
```bash
python app.py
```

## Then Login to Desktop App

Once the backend is running, use these credentials in the desktop app:
- **Email**: `admin@skintech.com`
- **Password**: `admin123`

## Alternative: One-Line Setup

Or use the requirements file if it exists:
```bash
cd backend
pip install -r requirements.txt
python create_admin.py
python app.py
```

## Verification

You should see:
```
🚀 SkinTech Backend Server Starting...
Server: http://localhost:5000
```

Then the desktop app login will work!
