@echo off
REM ============================================
REM Upload Backend Files to Ploi Server
REM For api.nxoland.com (Windows Version)
REM ============================================

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              Upload Backend to Ploi Server                 ║
echo ║                    For api.nxoland.com                      ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

REM Check if backend directory exists
echo 🚀 Checking backend directory...
if not exist "backend" (
    echo ❌ Backend directory not found. Please run this script from the project root.
    pause
    exit /b 1
)

if not exist "backend\composer.json" (
    echo ❌ composer.json not found in backend directory.
    pause
    exit /b 1
)

if not exist "backend\public\index.php" (
    echo ❌ public\index.php not found in backend directory.
    pause
    exit /b 1
)

echo ✅ Backend directory verified

REM Create deployment package
echo.
echo 🚀 Creating deployment package...

REM Create temporary directory
if exist "backend-deploy-temp" rmdir /s /q backend-deploy-temp
mkdir backend-deploy-temp

REM Copy backend files
xcopy backend\* backend-deploy-temp\ /E /I /Y
echo ✅ Backend files copied

REM Create deployment script
echo.
echo 🚀 Creating deployment script...
(
echo #!/bin/bash
echo.
echo # NXOLand Backend Deployment Script
echo cd /home/ploi/api.nxoland.com
echo.
echo # Install/update Composer dependencies
echo composer install --no-dev --optimize-autoloader
echo.
echo # Set proper permissions
echo chmod -R 755 public/
echo chmod 644 public/.htaccess
echo chmod 644 public/index.php
echo.
echo # Create .env file if it doesn't exist
echo if [ ! -f ".env" ]; then
echo     cat ^> .env ^<^< 'ENVEOF'
echo APP_NAME=NXOLand API
echo APP_ENV=production
echo APP_DEBUG=false
echo APP_URL=https://api.nxoland.com
echo.
echo DB_CONNECTION=mysql
echo DB_HOST=localhost
echo DB_PORT=3306
echo DB_DATABASE=nxoland
echo DB_USERNAME=your_username
echo DB_PASSWORD=your_password
echo.
echo JWT_SECRET=your_jwt_secret_key_here
echo JWT_ALGORITHM=HS256
echo ENVEOF
echo fi
echo.
echo # Reload PHP-FPM
echo echo "" ^| sudo -S service php8.4-fpm reload
echo.
echo echo "Backend API deployed successfully!"
) > backend-deploy-temp\deploy.sh

echo ✅ Deployment script created

REM Create zip file
echo.
echo 🚀 Creating zip package...
cd backend-deploy-temp
powershell Compress-Archive -Path * -DestinationPath ..\backend-deploy.zip -Force
cd ..
rmdir /s /q backend-deploy-temp

echo ✅ Deployment package created: backend-deploy.zip

REM Create upload instructions
echo.
echo 🚀 Creating upload instructions...

(
echo # 🚀 Upload Backend to Ploi Server
echo.
echo ## 📦 Package Created
echo - **File**: backend-deploy.zip
echo - **Created**: %date% %time%
echo.
echo ## 🎯 Upload Methods
echo.
echo ### Method 1: Ploi File Manager ^(Recommended^)
echo.
echo 1. **Access Ploi Dashboard**
echo    - Go to your Ploi dashboard
echo    - Navigate to your `api.nxoland.com` site
echo    - Go to "Files" or "File Manager"
echo.
echo 2. **Upload Files**
echo    - Upload `backend-deploy.zip` to `/home/ploi/api.nxoland.com/`
echo    - Extract the zip file in the directory
echo    - Delete the zip file after extraction
echo.
echo 3. **Set Permissions**
echo    - Make sure `public/` directory has 755 permissions
echo    - Make sure `public/index.php` has 644 permissions
echo    - Make sure `public/.htaccess` has 644 permissions
echo.
echo ### Method 2: SSH Upload
echo.
echo 1. **Connect via SSH**
echo    ```bash
echo    ssh ploi@46.202.194.218
echo    ```
echo.
echo 2. **Upload Files**
echo    ```bash
echo    # From your local machine
echo    scp backend-deploy.zip ploi@46.202.194.218:/home/ploi/api.nxoland.com/
echo    ```
echo.
echo 3. **Extract and Setup**
echo    ```bash
echo    # On the server
echo    cd /home/ploi/api.nxoland.com
echo    unzip backend-deploy.zip
echo    rm backend-deploy.zip
echo    chmod -R 755 public/
echo    chmod 644 public/.htaccess
echo    chmod 644 public/index.php
echo    ```
echo.
echo ## 🔧 Post-Upload Steps
echo.
echo ### 1. **Update Ploi Deploy Script**
echo Replace your current deploy script with:
echo ```bash
echo #!/bin/bash
echo cd /home/ploi/api.nxoland.com
echo composer install --no-dev --optimize-autoloader
echo chmod -R 755 public/
echo chmod 644 public/.htaccess
echo chmod 644 public/index.php
echo echo "" ^| sudo -S service php8.4-fpm reload
echo echo "Backend API deployed successfully!"
echo ```
echo.
echo ### 2. **Set Environment Variables**
echo In Ploi dashboard, add:
echo - `APP_NAME=NXOLand API`
echo - `APP_ENV=production`
echo - `APP_DEBUG=false`
echo - `APP_URL=https://api.nxoland.com`
echo - `DB_CONNECTION=mysql`
echo - `DB_HOST=your_database_host`
echo - `DB_DATABASE=nxoland`
echo - `DB_USERNAME=your_username`
echo - `DB_PASSWORD=your_password`
echo - `JWT_SECRET=your_secret_key`
echo.
echo ### 3. **Configure Health Check**
echo Set health check URL to: `https://api.nxoland.com/api/ping`
echo.
echo ### 4. **Deploy**
echo Click "Deploy now" in Ploi dashboard
echo.
echo ## 🧪 Testing
echo.
echo ### Test API Endpoint:
echo ```bash
echo curl https://api.nxoland.com/api/ping
echo ```
echo **Expected response:** `{"ok": true}`
echo.
echo ### Test Other Endpoints:
echo ```bash
echo curl https://api.nxoland.com/api/products
echo curl https://api.nxoland.com/api/members
echo ```
echo.
echo ## 🎉 Success!
echo.
echo Once uploaded and deployed:
echo - ✅ Backend files in correct location
echo - ✅ Composer dependencies installed
echo - ✅ API endpoints responding
echo - ✅ CORS headers working
echo - ✅ Ready for frontend connection
echo.
echo Your backend will be available at `https://api.nxoland.com`! 🚀
) > BACKEND_UPLOAD_INSTRUCTIONS.md

echo ✅ Upload instructions created: BACKEND_UPLOAD_INSTRUCTIONS.md

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║              BACKEND PACKAGE READY!                       ║
echo ║                                                              ║
echo ║  📦 Package: backend-deploy.zip                            ║
echo ║  📋 Instructions: BACKEND_UPLOAD_INSTRUCTIONS.md          ║
echo ║                                                              ║
echo ║  🚀 Next steps:                                             ║
echo ║  1. Upload backend-deploy.zip to Ploi server              ║
echo ║  2. Extract files in /home/ploi/api.nxoland.com/           ║
echo ║  3. Update Ploi deploy script                              ║
echo ║  4. Set environment variables                               ║
echo ║  5. Deploy and test!                                       ║
echo ║                                                              ║
echo ║  🌐 Your backend will be ready at api.nxoland.com!        ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
pause
