@echo off
echo ========================================
echo   SkinTech - Install Project Dependencies
echo ========================================
echo.

echo This will install dependencies for:
echo   - Frontend (Web App)
echo   - Backend (API Server)
echo   - Mobile App
echo   - Desktop Admin App
echo.
pause

REM Get the directory where this script is located
cd /d "%~dp0"

echo.
echo ========================================
echo   Installing Backend Dependencies
echo ========================================
cd backend
if exist requirements.txt (
    echo [INFO] Installing Python packages...
    pip install -r requirements.txt
    if %errorLevel% == 0 (
        echo [OK] Backend dependencies installed
    ) else (
        echo [ERROR] Failed to install backend dependencies
    )
) else (
    echo [ERROR] requirements.txt not found
)
cd ..

echo.
echo ========================================
echo   Installing Frontend Dependencies
echo ========================================
cd frontend
if exist package.json (
    echo [INFO] Installing npm packages...
    call npm install
    if %errorLevel% == 0 (
        echo [OK] Frontend dependencies installed
    ) else (
        echo [ERROR] Failed to install frontend dependencies
    )
) else (
    echo [ERROR] package.json not found
)
cd ..

echo.
echo ========================================
echo   Installing Mobile Dependencies
echo ========================================
cd mobile
if exist package.json (
    echo [INFO] Installing npm packages...
    call npm install
    if %errorLevel% == 0 (
        echo [OK] Mobile dependencies installed
    ) else (
        echo [ERROR] Failed to install mobile dependencies
    )
) else (
    echo [ERROR] package.json not found
)
cd ..

echo.
echo ========================================
echo   Installing Desktop Dependencies
echo ========================================
cd desktop
if exist package.json (
    echo [INFO] Installing npm packages...
    call npm install
    if %errorLevel% == 0 (
        echo [OK] Desktop dependencies installed
    ) else (
        echo [ERROR] Failed to install desktop dependencies
    )
) else (
    echo [ERROR] package.json not found
)
cd ..

echo.
echo ========================================
echo   Installation Complete!
echo ========================================
echo.
echo All dependencies installed. You can now:
echo   1. Run the web app: start-web-app.bat
echo   2. Run the mobile app: start-mobile-app.bat
echo   3. Run the desktop app: start-desktop-app.bat
echo.
pause
