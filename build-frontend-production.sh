#!/bin/bash

# NXOLand Frontend Production Build Script
set -e

echo "🚀 Building NXOLand Frontend for Production..."

# Navigate to frontend directory
cd frontend

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
    echo "🧪 TEST COMMANDS:"
    echo "npm run preview  # Test the build locally"
    echo "curl https://nxoland.com  # Test production site"
else
    echo "❌ Build failed!"
    exit 1
fi

echo "🎉 Frontend production build completed!"
