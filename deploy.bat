@echo off
REM Nexo Frontend Deployment Script for Ploi (Windows)
REM This is a React/Vite project

echo 🚀 Starting Nexo Frontend Deployment...

REM Check if we're in the right directory
if not exist "package.json" (
    echo ❌ Error: package.json not found. Make sure you're in the project root.
    exit /b 1
)

REM Install dependencies
echo 📦 Installing dependencies...
npm ci --production=false

REM Build the project
echo 🔨 Building project...
npm run build

REM Check if build was successful
if not exist "dist" (
    echo ❌ Error: Build failed. dist directory not found.
    exit /b 1
)

echo ✅ Build completed successfully!
echo 📁 Build output: dist/

echo 🎉 Deployment completed!
