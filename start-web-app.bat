@echo off
echo ========================================
echo Starting SkinTech WEB APPLICATION
echo ========================================
echo.
echo This will start:
echo   1. Main Backend (port 3000)
echo   2. Web Frontend (port 3001)
echo.
echo Press Ctrl+C in any window to stop
echo ========================================
echo.

cd backend
start cmd /k "echo === MAIN BACKEND (Port 3000) === && python app.py"

timeout /t 3 /nobreak > nul

cd ..\frontend
start cmd /k "echo === WEB FRONTEND === && npm run dev"

echo.
echo ========================================
echo Both services are starting...
echo ========================================
echo Backend:  http://localhost:3000
echo Frontend: http://localhost:5173
echo ========================================
pause
