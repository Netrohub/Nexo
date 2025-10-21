@echo off
REM ============================================
REM Copy NXOLand Backend Files to Laravel Project
REM ============================================

echo.
echo ========================================
echo  NXOLand Backend File Copy Script
echo ========================================
echo.

REM Check if Laravel path is provided
if "%~1"=="" (
    echo ERROR: Please provide Laravel project path
    echo.
    echo Usage: copy-to-laravel.bat "C:\path\to\your\laravel-project"
    echo.
    pause
    exit /b 1
)

set "LARAVEL_PATH=%~1"

REM Check if Laravel project exists
if not exist "%LARAVEL_PATH%" (
    echo ERROR: Laravel project not found at: %LARAVEL_PATH%
    pause
    exit /b 1
)

if not exist "%LARAVEL_PATH%\artisan" (
    echo ERROR: Not a valid Laravel project (artisan not found^)
    pause
    exit /b 1
)

echo Found Laravel project at: %LARAVEL_PATH%
echo.

REM Create directories if needed
if not exist "%LARAVEL_PATH%\database\migrations" mkdir "%LARAVEL_PATH%\database\migrations"
if not exist "%LARAVEL_PATH%\app\Models" mkdir "%LARAVEL_PATH%\app\Models"
if not exist "%LARAVEL_PATH%\database\seeders" mkdir "%LARAVEL_PATH%\database\seeders"

REM Copy migrations
echo Copying migration files...
xcopy /Y "laravel-backend\migrations\*.php" "%LARAVEL_PATH%\database\migrations\"
echo.

REM Copy models
echo Copying model files...
xcopy /Y "laravel-backend\models\*.php" "%LARAVEL_PATH%\app\Models\"
echo.

REM Copy seeders
echo Copying seeder files...
xcopy /Y "laravel-backend\seeders\*.php" "%LARAVEL_PATH%\database\seeders\"
echo.

echo ========================================
echo  All files copied successfully!
echo ========================================
echo.
echo Next steps:
echo   1. Update Laravel .env: DB_DATABASE=nxoland
echo   2. Create database: mysql -u root -p ^< laravel-backend\setup-mysql.sql
echo   3. Run migrations: php artisan migrate
echo   4. Seed database: php artisan db:seed
echo.
echo Files copied to:
echo   - %LARAVEL_PATH%\database\migrations\
echo   - %LARAVEL_PATH%\app\Models\
echo   - %LARAVEL_PATH%\database\seeders\
echo.
echo Ready to migrate!
echo.
pause
