#!/bin/bash

# Nexo Frontend Deployment Script for Ploi
# This is a React/Vite project

echo "🚀 Starting Nexo Frontend Deployment..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found. Make sure you're in the project root."
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm ci --production=false

# Build the project
echo "🔨 Building project..."
npm run build

# Check if build was successful
if [ ! -d "dist" ]; then
    echo "❌ Error: Build failed. dist directory not found."
    exit 1
fi

echo "✅ Build completed successfully!"
echo "📁 Build output: dist/"

# Optional: Copy files to web root if needed
# cp -r dist/* /var/www/html/

echo "🎉 Deployment completed!"
