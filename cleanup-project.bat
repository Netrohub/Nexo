@echo off
REM ============================================
REM NXOLand Project Cleanup Script (Windows)
REM Removes unnecessary files for deployment
REM ============================================

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                NXOLand Project Cleanup                    ║
echo ║              Preparing for deployment                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Create backup directory
echo 🧹 Creating backup directory...
set BACKUP_DIR=backup-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%
set BACKUP_DIR=%BACKUP_DIR: =0%
mkdir "%BACKUP_DIR%" 2>nul
echo ✅ Backup directory created: %BACKUP_DIR%
echo.

REM Remove old deployment scripts
echo 🧹 Cleaning up deployment scripts...
del /f /q deploy-backend.sh 2>nul
del /f /q deploy-frontend.sh 2>nul
del /f /q deploy-full-stack.bat 2>nul
del /f /q deploy-full-stack.sh 2>nul
del /f /q deploy-full.sh 2>nul
del /f /q deploy.bat 2>nul
del /f /q deploy.sh 2>nul
del /f /q diagnose-deployment.sh 2>nul
del /f /q setup-server.sh 2>nul
echo ✅ Deployment scripts cleaned
echo.

REM Remove unnecessary documentation
echo 🧹 Cleaning up documentation...
del /f /q DATABASE_SETUP_GUIDE.md 2>nul
del /f /q DEPLOYMENT_GUIDE.md 2>nul
del /f /q FULL_STACK_DEPLOYMENT_GUIDE.md 2>nul
del /f /q QUICK_START_DEPLOYMENT.md 2>nul
del /f /q SERVER_SETUP_COMMANDS.md 2>nul
del /f /q TROUBLESHOOTING_DEPLOYMENT.md 2>nul
del /f /q hostinger-backend-config.md 2>nul
echo ✅ Documentation cleaned
echo.

REM Remove unnecessary files
echo 🧹 Removing unnecessary files...
del /f /q bun.lockb 2>nul
del /f /q ploi-env-config.txt 2>nul
echo ✅ Unnecessary files removed
echo.

REM Clean node_modules
echo 🧹 Cleaning node_modules...
if exist node_modules (
    echo ℹ️  Removing node_modules (will be reinstalled during deployment)
    rmdir /s /q node_modules
)
echo ✅ node_modules cleaned
echo.

REM Create deployment structure
echo 🧹 Creating deployment structure...
if exist deployment-packages rmdir /s /q deployment-packages
mkdir deployment-packages\frontend
mkdir deployment-packages\backend
echo ✅ Deployment structure created
echo.

REM Create frontend package
echo 🧹 Creating frontend package...
xcopy /e /i /y src deployment-packages\frontend\src
xcopy /e /i /y public deployment-packages\frontend\public
copy /y package.json deployment-packages\frontend\
copy /y package-lock.json deployment-packages\frontend\
copy /y vite.config.ts deployment-packages\frontend\
copy /y tailwind.config.ts deployment-packages\frontend\
copy /y tsconfig.json deployment-packages\frontend\
copy /y tsconfig.app.json deployment-packages\frontend\
copy /y tsconfig.node.json deployment-packages\frontend\
copy /y postcss.config.js deployment-packages\frontend\
copy /y eslint.config.js deployment-packages\frontend\
copy /y components.json deployment-packages\frontend\
copy /y index.html deployment-packages\frontend\
copy /y ploi.yml deployment-packages\frontend\
copy /y env.production deployment-packages\frontend\
echo ✅ Frontend package created in deployment-packages\frontend\
echo.

REM Create backend package
echo 🧹 Creating backend package...
xcopy /e /i /y api-files\public_html deployment-packages\backend\public_html
xcopy /e /i /y laravel-backend deployment-packages\backend\laravel-backend
echo ✅ Backend package created in deployment-packages\backend\
echo.

REM Create deployment instructions
echo 🧹 Creating deployment instructions...
(
echo # 🚀 NXOLand Deployment Ready!
echo.
echo Your project has been cleaned and organized for deployment.
echo.
echo ## 📦 Deployment Packages Created
echo.
echo ### Frontend Package ^(for Ploi^):
echo - **Location**: `deployment-packages\frontend\`
echo - **Destination**: Ploi ^(nxoland.com^)
echo - **Files**: React app, config files, build scripts
echo.
echo ### Backend Package ^(for Hostinger^):
echo - **Location**: `deployment-packages\backend\`
echo - **Destination**: Hostinger ^(api.nxoland.com^)
echo - **Files**: PHP API, database structure
echo.
echo ## 🚀 Next Steps
echo.
echo ### 1. Deploy Frontend to Ploi:
echo 1. Zip the `deployment-packages\frontend\` folder
echo 2. Upload to Ploi dashboard
echo 3. Configure build settings:
echo    - Build command: `npm run build`
echo    - Output directory: `dist`
echo    - Environment variables from `env.production`
echo.
echo ### 2. Deploy Backend to Hostinger:
echo 1. Zip the `deployment-packages\backend\` folder
echo 2. Upload to Hostinger file manager
echo 3. Extract in `public_html\` directory
echo 4. Configure database and environment variables
echo.
echo ### 3. Configure DNS:
echo - `nxoland.com` → Ploi server IP
echo - `api.nxoland.com` → Hostinger server IP
echo.
echo ## 📋 Files Removed
echo.
echo The following files were removed to clean up your project:
echo - Old deployment scripts
echo - Unnecessary documentation
echo - node_modules ^(will be reinstalled^)
echo - Temporary files
echo.
echo ## 🎉 Your Project is Ready!
echo.
echo Your NXOLand marketplace is now organized and ready for deployment!
) > DEPLOYMENT_READY.md
echo ✅ Deployment instructions created: DEPLOYMENT_READY.md
echo.

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              PROJECT CLEANUP COMPLETED!                    ║
echo ║                                                              ║
echo ║  📦 Frontend Package: deployment-packages\frontend\         ║
echo ║  🔧 Backend Package: deployment-packages\backend\        ║
echo ║  📋 Instructions: DEPLOYMENT_READY.md                      ║
echo ║                                                              ║
echo ║  🚀 Your project is ready for deployment!                   ║
echo ║                                                              ║
echo ║  Next steps:                                                ║
echo ║  1. Deploy frontend package to Ploi                         ║
echo ║  2. Deploy backend package to Hostinger                    ║
echo ║  3. Configure DNS records                                   ║
echo ║  4. Test your marketplace!                                 ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

pause
