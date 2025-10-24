@echo off
REM NXOLand Frontend Deployment Script (Using Existing Build)
setlocal

echo 🚀 Starting NXOLand Frontend Deployment...

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: package.json not found!
    echo 💡 Make sure you're in the project root directory
    exit /b 1
)

echo ✅ Found project root directory

REM Check if dist directory exists
if exist "dist" (
    echo ✅ Found existing build in dist/
    echo 📁 Build output: dist/
    echo 📊 Build contents:
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
    echo.
    echo 🎯 Your frontend is ready for deployment!
) else (
    echo ❌ No dist directory found!
    echo 💡 Run 'npm run build' first to create the build
    exit /b 1
)

echo 🎉 Frontend deployment ready!
echo 📦 Upload dist/ contents to your web server
