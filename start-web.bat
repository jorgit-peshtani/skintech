@echo off
echo ========================================
echo   Starting SkinTech Web Application
echo ========================================
echo.

:: Start Backend (Django Oscar)
echo [1/2] Starting Django Oscar Backend...
start "SkinTech Backend" cmd /k "cd backend_django && python manage.py runserver 8000"
timeout /t 3 /nobreak > nul

:: Start Frontend
echo [2/2] Starting React Frontend...
start "SkinTech Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo ========================================
echo   Web App Starting!
echo ========================================
echo   Backend:  http://localhost:3000
echo   Frontend: http://localhost:5173
echo ========================================
echo.
echo Press any key to exit this window...
pause > nul
