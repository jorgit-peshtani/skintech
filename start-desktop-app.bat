@echo off
echo ========================================
echo Starting SkinTech DESKTOP ADMIN PANEL
echo ========================================
echo.
echo This will start:
echo   1. Admin Backend (port 3001)
echo   2. Desktop App (Electron)
echo.
echo Press Ctrl+C in any window to stop
echo ========================================
echo.

cd backend
start cmd /k "echo === ADMIN BACKEND (Port 3001) === && python admin_app.py"

timeout /t 3 /nobreak > nul

cd ..\desktop
start cmd /k "echo === DESKTOP APP === && npm run dev"

echo.
echo ========================================
echo Both services are starting...
echo ========================================
echo Admin Backend: http://localhost:3001
echo Desktop App:   Opening in Electron...
echo ========================================
echo.
echo Login credentials:
echo   Email:    admin@skintech.com
echo   Password: admin123
echo ========================================
pause
