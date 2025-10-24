#!/bin/bash

# NXOLand Backend Troubleshooting Script
# This script helps diagnose and fix backend issues

echo "🔍 NXOLand Backend Troubleshooting..."

# Check if we're in the right directory
echo "📁 Current directory: $(pwd)"
echo "📋 Directory contents:"
ls -la

# Check if backend files exist
echo "🔍 Checking backend files..."
if [ -f "composer.json" ]; then
    echo "✅ composer.json found"
else
    echo "❌ composer.json not found"
fi

if [ -f "public/index.php" ]; then
    echo "✅ public/index.php found"
else
    echo "❌ public/index.php not found"
fi

if [ -f "public/.htaccess" ]; then
    echo "✅ public/.htaccess found"
else
    echo "❌ public/.htaccess not found"
fi

if [ -f ".env" ]; then
    echo "✅ .env file found"
    echo "📋 .env contents:"
    cat .env
else
    echo "❌ .env file not found"
fi

# Check vendor directory
if [ -d "vendor" ]; then
    echo "✅ vendor directory found"
    echo "📋 vendor contents:"
    ls -la vendor/ | head -10
else
    echo "❌ vendor directory not found"
fi

# Check PHP version
echo "🐘 PHP version:"
php -v

# Check if PHP can run the index file
echo "🧪 Testing PHP index file..."
php public/index.php

echo "🔍 Troubleshooting complete!"
