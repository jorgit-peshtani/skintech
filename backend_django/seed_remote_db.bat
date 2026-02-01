@echo off
color 0B
echo ===================================================
echo       SkinTech Remote Database Seeder 🚀
echo ===================================================
echo.
echo This script will help you push your local data (Products & Admin)
echo to your remote Railway database.
echo.

:: 1. Ask for URL
set /p RAILWAY_URL="👉 Paste your Railway URL (postgresql://...): "

if "%RAILWAY_URL%"=="" (
    color 0C
    echo.
    echo ❌ Error: URL is required!
    pause
    exit /b
)

:: 2. Set Env Var
set DATABASE_URL=%RAILWAY_URL%
echo.
echo ✅ Connected to Remote Database!
echo.

:: 3. Run safely
echo 📦 1/3 Checking Database Tables (Migrate)...
python manage.py migrate
if %errorlevel% neq 0 (
    color 0C
    echo ❌ Error running migrations. Check your URL.
    pause
    exit /b
)

echo.
echo 🛍️ 2/3 Importing Products...
python import_oscar_products.py

echo.
echo 👤 3/3 Creating Admin User...
python create_admin.py

echo.
echo ===================================================
echo 🎉 SUCCESS! Data pushed to Railway.
echo You can now check your website: skintech.onrender.com
echo ===================================================
pause
