@echo off
echo ========================================
echo Starting SkinTech MOBILE APP
echo ========================================
echo.
echo This will start:
echo   1. Django Backend (Port 8000)
echo   2. Mobile Metro Bundler
echo.
echo Note: If the backend is already running, you can close the extra window.
echo.
echo ========================================
echo.

cd backend_django
start cmd /k "echo === DJANGO BACKEND (Port 8000) === && title SkinTech Backend && python manage.py runserver 0.0.0.0:8000"

timeout /t 5 /nobreak > nul

cd ..\mobile
echo Checking and installing dependencies...
call npm install
echo.
echo ========================================
echo        MOBILE APP STARTED
echo ========================================
echo.
echo 1. Make sure your Android Emulator is open
echo 2. Press 'a' in this terminal to connect
echo.
call npm start

pause
