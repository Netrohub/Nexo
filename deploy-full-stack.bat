@echo off
REM ============================================
REM NXOLand Full-Stack Deployment Script (Windows)
REM Single Server: React + Laravel + MySQL + Redis
REM ============================================

setlocal enabledelayedexpansion

REM Configuration
set PROJECT_NAME=nxoland
set FRONTEND_DIR=C:\var\www\nxoland-frontend
set BACKEND_DIR=C:\var\www\nxoland-backend
set DOMAIN=nxoland.com
set API_DOMAIN=api.nxoland.com

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                NXOLand Full-Stack Deployment              ║
echo ║              Single Server: React + Laravel + MySQL         ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo ℹ️  This script prepares your local environment for deployment
echo ℹ️  Run this on your Windows machine before deploying to Ploi
echo.

REM Check if Node.js is installed
echo 🔍 Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js not found. Please install Node.js 18+ first.
    echo 📥 Download from: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if npm is available
npm --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ npm not found. Please install npm.
    pause
    exit /b 1
)

echo ✅ Node.js and npm are available

REM Install dependencies
echo 📦 Installing project dependencies...
call npm ci --production=false
if %errorlevel% neq 0 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

echo ✅ Dependencies installed

REM Build React frontend
echo 🔨 Building React frontend...
call npm run build
if %errorlevel% neq 0 (
    echo ❌ Frontend build failed
    pause
    exit /b 1
)

echo ✅ Frontend build completed

REM Create deployment package
echo 📦 Creating deployment package...

REM Create frontend deployment directory
if not exist "%FRONTEND_DIR%" mkdir "%FRONTEND_DIR%"
xcopy /E /I /Y "dist" "%FRONTEND_DIR%\dist"

REM Create backend deployment directory
if not exist "%BACKEND_DIR%" mkdir "%BACKEND_DIR%"

REM Copy Laravel backend files
if exist "laravel-backend" (
    xcopy /E /I /Y "laravel-backend\*" "%BACKEND_DIR%\"
    echo ✅ Laravel backend files copied
) else (
    echo ⚠️  Laravel backend directory not found
)

REM Create environment files
echo 🔧 Creating environment files...

REM Frontend environment
echo VITE_API_BASE_URL=https://%API_DOMAIN%/api > "%FRONTEND_DIR%\.env.production"
echo VITE_COMING_SOON_MODE=false >> "%FRONTEND_DIR%\.env.production"
echo VITE_MOCK_API=false >> "%FRONTEND_DIR%\.env.production"
echo NODE_ENV=production >> "%FRONTEND_DIR%\.env.production"

REM Backend environment
echo APP_NAME=NXOLand > "%BACKEND_DIR%\.env"
echo APP_ENV=production >> "%BACKEND_DIR%\.env"
echo APP_KEY= >> "%BACKEND_DIR%\.env"
echo APP_DEBUG=false >> "%BACKEND_DIR%\.env"
echo APP_URL=https://%API_DOMAIN% >> "%BACKEND_DIR%\.env"
echo. >> "%BACKEND_DIR%\.env"
echo LOG_CHANNEL=stack >> "%BACKEND_DIR%\.env"
echo LOG_LEVEL=error >> "%BACKEND_DIR%\.env"
echo. >> "%BACKEND_DIR%\.env"
echo DB_CONNECTION=mysql >> "%BACKEND_DIR%\.env"
echo DB_HOST=127.0.0.1 >> "%BACKEND_DIR%\.env"
echo DB_PORT=3306 >> "%BACKEND_DIR%\.env"
echo DB_DATABASE=nxoland >> "%BACKEND_DIR%\.env"
echo DB_USERNAME=nxoland_user >> "%BACKEND_DIR%\.env"
echo DB_PASSWORD=nxoland_secure_2024 >> "%BACKEND_DIR%\.env"
echo. >> "%BACKEND_DIR%\.env"
echo CACHE_DRIVER=redis >> "%BACKEND_DIR%\.env"
echo SESSION_DRIVER=redis >> "%BACKEND_DIR%\.env"
echo QUEUE_CONNECTION=redis >> "%BACKEND_DIR%\.env"
echo. >> "%BACKEND_DIR%\.env"
echo REDIS_HOST=127.0.0.1 >> "%BACKEND_DIR%\.env"
echo REDIS_PASSWORD=null >> "%BACKEND_DIR%\.env"
echo REDIS_PORT=6379 >> "%BACKEND_DIR%\.env"

echo ✅ Environment files created

REM Create deployment instructions
echo 📋 Creating deployment instructions...
echo. > "DEPLOYMENT_INSTRUCTIONS.txt"
echo NXOLand Full-Stack Deployment Instructions >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo ========================================== >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo. >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo 1. Upload the following directories to your Ploi server: >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo    - %FRONTEND_DIR% → /var/www/nxoland-frontend/ >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo    - %BACKEND_DIR% → /var/www/nxoland-backend/ >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo. >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo 2. Run the server setup script on your Ploi server: >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo    bash deploy-full-stack.sh >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo. >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo 3. Configure your domain DNS: >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo    %DOMAIN% → YOUR_SERVER_IP >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo    %API_DOMAIN% → YOUR_SERVER_IP >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo. >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo 4. Run the deployment command: >> "DEPLOYMENT_INSTRUCTIONS.txt"
echo    deploy-nxoland >> "DEPLOYMENT_INSTRUCTIONS.txt"

echo ✅ Deployment instructions created

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              LOCAL PREPARATION COMPLETED!                  ║
echo ║                                                              ║
echo ║  🎉 Your project is ready for deployment!                  ║
echo ║                                                              ║
echo ║  📁 Frontend: %FRONTEND_DIR%                    ║
echo ║  🔧 Backend: %BACKEND_DIR%                     ║
echo ║  📋 Instructions: DEPLOYMENT_INSTRUCTIONS.txt              ║
echo ║                                                              ║
echo ║  🚀 Next steps:                                             ║
echo ║  1. Upload files to your Ploi server                        ║
echo ║  2. Run: bash deploy-full-stack.sh                          ║
echo ║  3. Configure DNS                                            ║
echo ║                                                              ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

pause
