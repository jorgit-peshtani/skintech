@echo off
echo ========================================
echo SkinTech Database Seeding
echo ========================================
echo.
echo This will populate the database with:
echo   - Sample users (admin + 5 regular users)
echo   - 10 products
echo   - 10 ingredients
echo   - Multiple orders
echo   - Product scans
echo   - Reviews
echo.
echo WARNING: This will CLEAR existing data!
echo.
pause

cd backend
python seed_database.py

echo.
echo ========================================
echo Done! You can now:
echo   1. Start the desktop app to see stats
echo   2. Login to web/mobile with demo accounts
echo   3. Explore the data
echo ========================================
pause
