#!/bin/bash

# NXOLand Frontend Deployment Script
set -e

echo "🚀 Starting NXOLand Frontend Deployment..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found!"
    echo "💡 Make sure you're in the project root directory"
    exit 1
fi

# Check if frontend directory exists
if [ ! -d "frontend" ]; then
    echo "❌ Error: frontend directory not found!"
    echo "💡 Make sure you're in the project root directory"
    exit 1
fi

echo "✅ Found frontend directory"

# Navigate to frontend directory
cd frontend

# Check if we're in the right frontend directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: frontend/package.json not found!"
    exit 1
fi

echo "✅ Found frontend package.json"

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Build for production
echo "🏗️ Building for production..."
npm run build

# Verify build
if [ -d "dist" ]; then
    echo "✅ Build completed successfully!"
    echo "📁 Build output: frontend/dist/"
    echo "📊 Build size:"
    du -sh dist/
    echo ""
    echo "🚀 DEPLOYMENT READY:"
    echo "1. Upload contents of 'dist/' to your web server"
    echo "2. Ensure .env file is configured with correct API URL"
    echo "3. Test the application"
    echo ""
    echo "🧪 Test commands:"
    echo "   npm run preview  # Test the build locally"
    echo "   curl https://nxoland.com  # Test production site"
    echo ""
    echo "📁 Files to upload to web server:"
    echo "   - All files from frontend/dist/"
    echo "   - Make sure index.html is in the root of your web directory"
    echo ""
    echo "🔧 Environment variables needed:"
    echo "   VITE_API_BASE_URL=https://api.nxoland.com"
    echo "   VITE_APP_NAME=nxoland"
    echo "   VITE_APP_ENV=production"
else
    echo "❌ Build failed!"
    exit 1
fi

echo "🎉 Frontend production build completed!"
echo "📦 Ready for deployment to your web server"
