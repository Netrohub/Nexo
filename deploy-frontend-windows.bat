@echo off
REM NXOLand Frontend Deployment Script for Windows
setlocal

echo 🚀 Starting NXOLand Frontend Deployment...

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: package.json not found!
    echo 💡 Make sure you're in the project root directory
    exit /b 1
)

echo ✅ Found project root directory

REM Install dependencies
echo 📦 Installing dependencies...
call npm ci
if errorlevel 1 (
    echo ❌ npm ci failed!
    exit /b 1
)

REM Build for production
echo 🏗️ Building for production...
call npm run build
if errorlevel 1 (
    echo ❌ Build failed!
    exit /b 1
)

REM Verify build
if exist "dist" (
    echo ✅ Build completed successfully!
    echo 📁 Build output: dist/
    echo 📊 Build size:
    dir dist /s
    echo.
    echo 🚀 DEPLOYMENT READY:
    echo 1. Upload contents of 'dist/' to your web server
    echo 2. Ensure .env file is configured with correct API URL
    echo 3. Test the application
    echo.
    echo 🧪 Test commands:
    echo    npm run preview  # Test the build locally
    echo    curl https://nxoland.com  # Test production site
    echo.
    echo 📁 Files to upload to web server:
    echo    - All files from dist/
    echo    - Make sure index.html is in the root of your web directory
    echo.
    echo 🔧 Environment variables needed:
    echo    VITE_API_BASE_URL=https://api.nxoland.com
    echo    VITE_APP_NAME=nxoland
    echo    VITE_APP_ENV=production
) else (
    echo ❌ Build failed!
    exit /b 1
)

echo 🎉 Frontend production build completed!
echo 📦 Ready for deployment to your web server
