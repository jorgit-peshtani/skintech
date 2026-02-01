@echo off
echo ===================================================
echo   Migration Tool: Local SQLite - to - Neon Postgres
echo ===================================================
echo.

cd backend_django
python migrate_script.py

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Migration script failed.
    pause
    exit /b
)

echo.
pause
