@echo off
echo ========================================
echo Starting SkinTech MOBILE APPLICATION
echo ========================================
echo.
echo This will start:
echo   1. Main Backend (port 3000)
echo   2. Mobile App (Expo)
echo.
echo Press Ctrl+C in any window to stop
echo ========================================
echo.

cd backend
start cmd /k "echo === MAIN BACKEND (Port 3000) === && python app.py"

timeout /t 3 /nobreak > nul

cd ..\mobile
start cmd /k "echo === MOBILE APP (Expo) === && npm start"

echo.
echo ========================================
echo Both services are starting...
echo ========================================
echo Backend:   http://localhost:3000
echo Mobile:    Check Expo DevTools
echo ========================================
echo.
echo IMPORTANT: Run ADB port forwarding:
echo   adb reverse tcp:3000 tcp:3000
echo.
echo Demo login:
echo   Email:    user@example.com
echo   Password: password123
echo ========================================
pause
