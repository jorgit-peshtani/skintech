@echo off
echo ========================================
echo   Starting SkinTech Desktop App
echo ========================================
echo.

:: Start Django Oscar Backend (same as web - shared backend)
echo [1/2] Starting Django Oscar Backend...
start "SkinTech Backend" cmd /k "cd backend_django && python manage.py runserver 8000"
timeout /t 3 /nobreak > nul

:: Start Desktop App
echo [2/2] Starting Electron Desktop App...
start "SkinTech Desktop" cmd /k "cd desktop && npm run dev"

echo.
echo ========================================
echo   Desktop App Starting!
echo ========================================
echo   Admin Backend: http://localhost:3001
echo   Desktop UI:    Electron Window
echo ========================================
echo.
echo Press any key to exit this window...
pause > nul
