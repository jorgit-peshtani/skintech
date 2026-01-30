@echo off
echo ========================================
echo Starting Admin Backend for Desktop App
echo ========================================
echo.
echo Backend will run on: http://localhost:3001
echo Desktop app connects to port 3001
echo.
echo Press Ctrl+C to stop
echo ========================================
echo.

cd backend
python admin_app.py
