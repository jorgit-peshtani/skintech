@echo off
echo ========================================
echo   Starting EVERYTHING - SkinTech
echo ========================================
echo.

:: Start Django Oscar Backend (shared by web and desktop)
echo [1/3] Starting Django Oscar Backend (Port 8000)...
start "SkinTech Backend" cmd /k "cd backend_django && python manage.py runserver 8000"
timeout /t 3 /nobreak > nul

:: Start Frontend
echo [3/4] Starting Web Frontend...
start "SkinTech Frontend" cmd /k "cd frontend && npm run dev"
timeout /t 2 /nobreak > nul

:: Start Desktop
echo [4/4] Starting Desktop App...
start "SkinTech Desktop" cmd /k "cd desktop && npm run dev"

echo.
echo ========================================
echo   ALL APPLICATIONS STARTING!
echo ========================================
echo   Main Backend:   http://localhost:3000
echo   Admin Backend:  http://localhost:3001
echo   Web Frontend:   http://localhost:5173
echo   Desktop:        Electron Window
echo ========================================
echo.
echo Press any key to exit this window...
pause > nul
