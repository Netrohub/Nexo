@echo off
REM NXOLand Project Cleanup Script (Windows)
REM This script removes redundant, outdated, and temporary files

echo 🧹 Starting NXOLand Project Cleanup...
echo.

REM 1. Remove redundant deployment scripts
echo 📋 Removing redundant deployment scripts...
del /F /Q upload-backend-to-ploi.sh 2>nul
del /F /Q upload-backend-to-ploi.bat 2>nul
del /F /Q upload-complete-backend.sh 2>nul
del /F /Q troubleshoot-backend.sh 2>nul
del /F /Q backend-deploy-complete.sh 2>nul
del /F /Q backend-deploy-script.sh 2>nul
del /F /Q backend-deploy.zip 2>nul
del /F /Q deploy-backend.sh 2>nul
del /F /Q deploy-both.sh 2>nul
del /F /Q deploy-frontend-fixed.sh 2>nul
del /F /Q deploy-frontend-ready.bat 2>nul
del /F /Q deploy-frontend-simple.bat 2>nul
del /F /Q deploy-frontend-windows.bat 2>nul
del /F /Q deploy-frontend-ploi.bat 2>nul
del /F /Q deploy-frontend-ploi.sh 2>nul
del /F /Q deploy-frontend.sh 2>nul
del /F /Q deploy-with-ploi-webhook.sh 2>nul
del /F /Q ploi-deploy.sh 2>nul
del /F /Q ploi-deploy-simple.sh 2>nul
del /F /Q ploi-deploy-with-env.sh 2>nul
del /F /Q ploi-deploy-script-final.sh 2>nul
del /F /Q ploi-deploy-script-fixed.sh 2>nul
del /F /Q ploi-deploy-script-final-fixed.sh 2>nul
del /F /Q ploi-backend-deploy.sh 2>nul
del /F /Q quick-deploy.sh 2>nul
del /F /Q hostinger-deploy.sh 2>nul
del /F /Q fix-ploi-permissions.sh 2>nul
del /F /Q create-backend-zip.bat 2>nul
del /F /Q create-backend-zip.sh 2>nul
del /F /Q prepare-for-ploi.bat 2>nul
del /F /Q test-ploi-webhook.bat 2>nul
echo ✅ Removed redundant deployment scripts

REM 2. Remove redundant configuration files
echo 📋 Removing redundant configuration files...
del /F /Q ploi.yml 2>nul
del /F /Q ploi-frontend.yml 2>nul
del /F /Q ploi-simple.yml 2>nul
echo ✅ Removed redundant configuration files

REM 3. Remove redundant documentation
echo 📋 Removing redundant documentation...
del /F /Q COMPREHENSIVE_AUDIT_REPORT.md 2>nul
del /F /Q DEPLOY_MEMBERS_ENDPOINT_FIX.md 2>nul
del /F /Q FRONTEND_FIXES_COMPLETE.md 2>nul
del /F /Q FRONTEND_API_FIX_COMPLETE.md 2>nul
del /F /Q FRONTEND_BACKEND_CONNECTION_FIX.md 2>nul
del /F /Q DEPLOYMENT_READY.md 2>nul
del /F /Q DNS_CONFIGURATION_GUIDE.md 2>nul
del /F /Q COMPLETE_SOLUTION_SUMMARY.md 2>nul
del /F /Q DEPLOYMENT_GUIDE.md 2>nul
del /F /Q BACKEND_PLOI_DEPLOYMENT.md 2>nul
del /F /Q BACKEND_UPLOAD_INSTRUCTIONS.md 2>nul
del /F /Q KYC_VERIFICATION_FIX.md 2>nul
del /F /Q MANUAL_PLOI_UPLOAD_GUIDE.md 2>nul
del /F /Q PLOI_DEPLOYMENT.md 2>nul
del /F /Q PLOI_FIXED_DEPLOYMENT.md 2>nul
del /F /Q PLOI_FRONTEND_DEPLOYMENT.md 2>nul
del /F /Q PLOI_DEPLOYMENT_STEPS.md 2>nul
del /F /Q PROJECT_SPLIT_SUMMARY.md 2>nul
del /F /Q SAFE_REQUEST_HELPER_IMPLEMENTATION.md 2>nul
del /F /Q SEPARATE_DEPLOYMENT_GUIDE.md 2>nul
echo ✅ Removed redundant documentation

REM 4. Remove test/temporary files
echo 📋 Removing test/temporary files...
del /F /Q test-api-connection.html 2>nul
del /F /Q update-api-calls.js 2>nul
del /F /Q debug-frontend-api.js 2>nul
del /F /Q build-frontend-production.sh 2>nul
echo ✅ Removed test/temporary files

REM 5. Remove unused directories
echo 📋 Checking unused directories...
if exist laravel-backend (
    echo ⚠️  Found 'laravel-backend' directory - removing
    rmdir /S /Q laravel-backend 2>nul
)
if exist backend (
    echo ⚠️  Found 'backend' directory - removing
    rmdir /S /Q backend 2>nul
)
if exist api-files (
    echo ⚠️  Found 'api-files' directory - removing
    rmdir /S /Q api-files 2>nul
)
echo ✅ Cleaned up unused directories

REM 6. Clean up backend subdirectory
echo 📋 Cleaning up backend subdirectory...
if exist nxoland-backend (
    cd nxoland-backend
    
    REM Remove redundant deploy scripts
    del /F /Q deploy-name-fix.sh 2>nul
    del /F /Q deploy-complete-fix.sh 2>nul
    del /F /Q deploy-fixed.sh 2>nul
    del /F /Q deploy-nest-fixed.sh 2>nul
    del /F /Q upload-changes.sh 2>nul
    del /F /Q fix-cart-and-usernames.sh 2>nul
    del /F /Q complete-name-fix.md 2>nul
    del /F /Q fix-env-and-deploy.sh 2>nul
    del /F /Q fix-env-config.sh 2>nul
    del /F /Q deploy-admin-endpoints.sh 2>nul
    del /F /Q deploy-cors-fix-robust.sh 2>nul
    del /F /Q deploy-cors-fix.sh 2>nul
    del /F /Q deploy-members-endpoint.sh 2>nul
    del /F /Q deploy-without-db-fix.sh 2>nul
    del /F /Q deploy-username-fix.ps1 2>nul
    del /F /Q deploy-username-fix.sh 2>nul
    del /F /Q emergency-fix.sh 2>nul
    del /F /Q setup-env.sh 2>nul
    del /F /Q troubleshoot-email.sh 2>nul
    
    REM Remove old SQL files
    del /F /Q fix-undefined-names.sql 2>nul
    del /F /Q fix-undefined-usernames.sql 2>nul
    
    cd ..
    echo ✅ Cleaned up backend subdirectory
)

echo.
echo 🎉 Cleanup complete!
echo.
echo Summary:
echo - Removed redundant deployment scripts
echo - Removed redundant configuration files
echo - Removed redundant documentation
echo - Removed test/temporary files
echo - Cleaned up unused directories
echo.
echo Next steps:
echo 1. Review the changes: git status
echo 2. Commit the cleanup: git add -A ^&^& git commit -m "chore: Clean up redundant files"
echo 3. Push the changes: git push origin main

pause
