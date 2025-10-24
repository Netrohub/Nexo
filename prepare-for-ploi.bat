@echo off
REM ============================================
REM Prepare Frontend for Ploi Deployment
REM This script copies frontend files to root for Ploi
REM ============================================

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              Prepare Frontend for Ploi Deployment            ║
echo ║                    For nxoland.com                         ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo 🚀 Preparing frontend for Ploi deployment...

REM Check if frontend directory exists
if not exist "frontend" (
    echo ❌ Frontend directory not found!
    pause
    exit /b 1
)

echo ✅ Frontend directory found

REM Copy frontend files to root (for Ploi deployment)
echo 🚀 Copying frontend files to root directory...

REM Copy package.json
copy "frontend\package.json" "package.json" /Y
echo ✅ Copied package.json

REM Copy package-lock.json
copy "frontend\package-lock.json" "package-lock.json" /Y
echo ✅ Copied package-lock.json

REM Copy vite.config.ts
copy "frontend\vite.config.ts" "vite.config.ts" /Y
echo ✅ Copied vite.config.ts

REM Copy index.html
copy "frontend\index.html" "index.html" /Y
echo ✅ Copied index.html

REM Copy src directory
if exist "src" rmdir /s /q src
xcopy "frontend\src" "src" /E /I /Y
echo ✅ Copied src directory

REM Copy public directory
if exist "public" rmdir /s /q public
xcopy "frontend\public" "public" /E /I /Y
echo ✅ Copied public directory

REM Copy other config files
copy "frontend\tailwind.config.ts" "tailwind.config.ts" /Y
copy "frontend\postcss.config.js" "postcss.config.js" /Y
copy "frontend\tsconfig*.json" "." /Y
copy "frontend\eslint.config.js" "eslint.config.js" /Y
copy "frontend\components.json" "components.json" /Y

echo ✅ Copied all configuration files

REM Create .env file for production
echo 🚀 Creating production environment file...
(
echo VITE_API_BASE_URL=https://api.nxoland.com
echo VITE_COMING_SOON_MODE=false
) > .env

echo ✅ Created .env file

REM Install dependencies and build
echo 🚀 Installing dependencies and building...
npm ci
npm run build

if not exist "dist" (
    echo ❌ Build failed!
    pause
    exit /b 1
)

echo ✅ Build successful!

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              FRONTEND READY FOR PLOI!                    ║
echo ║                                                              ║
echo ║  📦 Build Directory: dist\                                  ║
echo ║  📋 Configuration: ploi-simple.yml                         ║
echo ║                                                              ║
echo ║  🚀 Next steps in Ploi:                                     ║
echo ║  1. Use ploi-simple.yml configuration                      ║
echo ║  2. Build command: npm run build                           ║
echo ║  3. Output directory: dist                                 ║
echo ║  4. Set environment variables                             ║
echo ║  5. Deploy!                                                ║
echo ║                                                              ║
echo ║  🌐 Your frontend will be ready!                          ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause
