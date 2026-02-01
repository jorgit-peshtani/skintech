@echo off
echo ===================================================
echo   CREATING DATABASE TABLES IN NEON
echo ===================================================
echo.
echo This command will build the "Skeleton" of your database.
echo (It performs the "CREATE TABLE" commands you asked for).
echo.
echo Please wait... it make take 30-60 seconds.
echo.

cd backend_django
set "DATABASE_URL=postgresql://neondb_owner:npg_CcFUwx9po1iI@ep-blue-morning-agax7d85-pooler.c-2.eu-central-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"

python manage.py migrate

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Could not create tables.
    pause
    exit /b
)

echo.
echo [SUCCESS] All tables created!
echo.
echo NOW you can go back to Neon SQL Editor and run the seed_data.sql code.
echo.
pause
