@echo off
REM ============================================
REM NXOLand Frontend Ploi Deployment Script
REM For nxoland.com (Windows Version)
REM ============================================

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              NXOLand Frontend Ploi Deployment                ║
echo ║                    For nxoland.com                         ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Check if we're in the right directory
echo 🚀 Checking environment...
if not exist "frontend" (
    echo ❌ Frontend directory not found. Please run this script from the project root.
    pause
    exit /b 1
)

if not exist "frontend\package.json" (
    echo ❌ package.json not found in frontend directory.
    pause
    exit /b 1
)

if not exist "frontend\vite.config.ts" (
    echo ❌ vite.config.ts not found in frontend directory.
    pause
    exit /b 1
)

echo ✅ Environment check passed

REM Install dependencies
echo.
echo 🚀 Installing frontend dependencies...
cd frontend
if not exist "node_modules" (
    echo ℹ️  Installing npm dependencies...
    npm ci
) else (
    echo ℹ️  Dependencies already installed
)
cd ..
echo ✅ Dependencies ready

REM Create production environment file
echo.
echo 🚀 Creating production environment file...
cd frontend
(
echo # NXOLand Frontend Production Environment
echo # For deployment on nxoland.com via Ploi
echo.
echo # API Configuration
echo VITE_API_BASE_URL=https://api.nxoland.com
echo.
echo # Coming Soon Mode ^(disabled for production^)
echo VITE_COMING_SOON_MODE=false
echo.
echo # Node Environment
echo NODE_ENV=production
echo.
echo # Build Configuration
echo VITE_BUILD_OPTIMIZE=true
echo VITE_BUILD_SOURCEMAP=false
) > .env.production
cd ..
echo ✅ Production environment file created

REM Build the project
echo.
echo 🚀 Building React frontend...
cd frontend
if exist "dist" (
    echo ℹ️  Removed old build directory
    rmdir /s /q dist
)

echo ℹ️  Running npm run build...
npm run build

if not exist "dist" (
    echo ❌ Build failed - dist directory not created
    pause
    exit /b 1
)
cd ..
echo ✅ Frontend built successfully

REM Create Ploi configuration
echo.
echo 🚀 Creating Ploi configuration...
(
echo # Ploi Deployment Configuration for NXOLand Frontend
echo # React/Vite project for nxoland.com
echo.
echo # Build commands for React/Vite
echo build:
echo   - cd frontend
echo   - npm ci
echo   - npm run build
echo.
echo # Environment variables for production
echo env:
echo   - VITE_API_BASE_URL=https://api.nxoland.com
echo   - VITE_COMING_SOON_MODE=false
echo   - NODE_ENV=production
echo.
echo # Build output directory
echo public_path: frontend/dist
echo.
echo # Node.js version
echo node_version: 18
echo.
echo # Deployment settings
echo deployment:
echo   type: static
echo   build_command: "cd frontend && npm run build"
echo   output_directory: "frontend/dist"
echo.
echo # Domain configuration
echo domain: nxoland.com
echo ssl: true
echo.
echo # Performance optimizations
echo optimization:
echo   - gzip_compression: true
echo   - static_caching: true
echo   - cdn_enabled: true
) > ploi-frontend.yml
echo ✅ Ploi configuration created: ploi-frontend.yml

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              PLOI DEPLOYMENT PACKAGE READY!               ║
echo ║                                                              ║
echo ║  📦 Build Directory: frontend\dist\                          ║
echo ║  📋 Instructions: PLOI_DEPLOYMENT_STEPS.md                  ║
echo ║  ⚙️  Configuration: ploi-frontend.yml                    ║
echo ║                                                              ║
echo ║  🚀 Next steps:                                             ║
echo ║  1. Connect repository to Ploi dashboard                  ║
echo ║  2. Set project type to 'Static Site'                     ║
echo ║  3. Configure build command: cd frontend && npm run build  ║
echo ║  4. Set output directory: frontend\dist                     ║
echo ║  5. Add environment variables                             ║
echo ║  6. Configure domain: nxoland.com                        ║
echo ║  7. Deploy and test!                                      ║
echo ║                                                              ║
echo ║  🌐 Your frontend will be ready for your API backend!     ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause
