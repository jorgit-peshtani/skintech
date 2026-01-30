@echo off
echo ========================================
echo   SkinTech - Automated Setup Script
echo   Installing All Required Tools
echo ========================================
echo.

REM Check if running as Administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Running as Administrator
) else (
    echo [ERROR] Please run this script as Administrator!
    echo Right-click the file and select "Run as administrator"
    pause
    exit /b 1
)

echo.
echo Installing package manager (Chocolatey)...
echo ========================================

REM Install Chocolatey if not installed
where choco >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Chocolatey already installed
) else (
    echo [INFO] Installing Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    if %errorLevel% == 0 (
        echo [OK] Chocolatey installed successfully
    ) else (
        echo [ERROR] Failed to install Chocolatey
        pause
        exit /b 1
    )
)

echo.
echo Installing Node.js 18 LTS...
echo ========================================
choco install nodejs-lts -y
if %errorLevel% == 0 (
    echo [OK] Node.js installed
) else (
    echo [WARNING] Node.js installation had issues
)

echo.
echo Installing Python 3.11...
echo ========================================
choco install python311 -y
if %errorLevel% == 0 (
    echo [OK] Python 3.11 installed
) else (
    echo [WARNING] Python installation had issues
)

echo.
echo Installing Git...
echo ========================================
choco install git -y
if %errorLevel% == 0 (
    echo [OK] Git installed
) else (
    echo [WARNING] Git installation had issues
)

echo.
echo Installing Visual Studio Code (Optional)...
echo ========================================
choco install vscode -y
if %errorLevel% == 0 (
    echo [OK] VS Code installed
) else (
    echo [WARNING] VS Code installation had issues
)

echo.
echo Refreshing environment variables...
echo ========================================
refreshenv

echo.
echo Installing global Node.js packages...
echo ========================================

echo [INFO] Installing Expo CLI (for mobile)...
call npm install -g expo-cli
if %errorLevel% == 0 (
    echo [OK] Expo CLI installed
) else (
    echo [WARNING] Expo CLI installation had issues
)

echo [INFO] Installing EAS CLI (for mobile builds)...
call npm install -g eas-cli
if %errorLevel% == 0 (
    echo [OK] EAS CLI installed
) else (
    echo [WARNING] EAS CLI installation had issues
)

echo [INFO] Installing Vercel CLI (for deployment)...
call npm install -g vercel
if %errorLevel% == 0 (
    echo [OK] Vercel CLI installed
) else (
    echo [WARNING] Vercel CLI installation had issues
)

echo [INFO] Installing Railway CLI (for deployment)...
call npm install -g @railway/cli
if %errorLevel% == 0 (
    echo [OK] Railway CLI installed
) else (
    echo [WARNING] Railway CLI installation had issues
)

echo.
echo Upgrading pip...
echo ========================================
python -m pip install --upgrade pip
if %errorLevel% == 0 (
    echo [OK] pip upgraded
) else (
    echo [WARNING] pip upgrade had issues
)

echo.
echo ========================================
echo   Installation Complete!
echo ========================================
echo.
echo Installed tools:
echo   - Node.js (for Frontend, Mobile, Desktop)
echo   - Python 3.11 (for Backend)
echo   - Git (version control)
echo   - VS Code (code editor)
echo   - Expo CLI (mobile development)
echo   - EAS CLI (mobile builds)
echo   - Vercel CLI (frontend deployment)
echo   - Railway CLI (backend deployment)
echo.
echo ========================================
echo   Verifying Installation
echo ========================================
echo.

echo Node.js version:
call node --version

echo.
echo npm version:
call npm --version

echo.
echo Python version:
python --version

echo.
echo pip version:
pip --version

echo.
echo Git version:
git --version

echo.
echo ========================================
echo   Next Steps
echo ========================================
echo.
echo 1. Close this window
echo 2. Open a NEW command prompt (to load new environment)
echo 3. Navigate to your project folder
echo 4. Run: install-dependencies.bat
echo.
echo ========================================

pause
