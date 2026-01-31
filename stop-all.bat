@echo off
echo ========================================
echo   Stopping All SkinTech Processes
echo ========================================
echo.

:: Kill Node processes (Frontend, Desktop)
echo Stopping Node.js processes...
taskkill /F /IM node.exe /T 2>nul
if %errorlevel% equ 0 (
    echo   - Node.js stopped
) else (
    echo   - No Node.js processes running
)

:: Kill Python processes (Backend)
echo Stopping Python processes...
taskkill /F /IM python.exe /T 2>nul
if %errorlevel% equ 0 (
    echo   - Python stopped
) else (
    echo   - No Python processes running
)

:: Kill Electron processes
echo Stopping Electron processes...
taskkill /F /IM electron.exe /T 2>nul
if %errorlevel% equ 0 (
    echo   - Electron stopped
) else (
    echo   - No Electron processes running
)

echo.
echo ========================================
echo   All processes stopped!
echo ========================================
echo.
pause
