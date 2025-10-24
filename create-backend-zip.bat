@echo off
REM Create Backend Zip for Manual Ploi Upload
setlocal

echo 🚀 Creating NXOLand Backend Zip for Manual Ploi Upload...

REM Create temporary directory
set TEMP_DIR=nxoland-backend-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%
set TEMP_DIR=%TEMP_DIR: =0%
mkdir "%TEMP_DIR%"

echo 📁 Copying backend files...

REM Copy all backend files
xcopy backend\* "%TEMP_DIR%\" /E /I /Y

REM Copy deployment script
copy deploy-backend.sh "%TEMP_DIR%\" /Y

REM Create zip package
set ZIP_FILE=nxoland-backend-%date:~-4,4%%date:~-10,2%%date:~-7,2%-%time:~0,2%%time:~3,2%%time:~6,2%.zip
set ZIP_FILE=%ZIP_FILE: =0%

echo ✅ Created backend package: %ZIP_FILE%
echo 📦 Package includes:
echo    - All backend PHP files
echo    - Composer dependencies
echo    - Database schema
echo    - Production .env configuration
echo    - Deployment script

echo 🎉 Backend zip package ready for manual upload!
echo 📁 File: %ZIP_FILE%
echo 📤 Upload this file to your Ploi server
