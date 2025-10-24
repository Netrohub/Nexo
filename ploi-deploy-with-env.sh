#!/bin/bash

# NXOLand Backend Deployment Script - With .env File Creation
# This script ensures the .env file is created properly

set -e  # Exit on any error

echo "🚀 Starting NXOLand Backend Deployment (With .env Creation)..."

# Change to the project directory
cd /home/ploi/api.nxoland.com

# Check if composer.json exists
if [ ! -f "composer.json" ]; then
    echo "❌ Error: composer.json not found!"
    echo "Please upload your backend files first."
    exit 1
fi

echo "✅ Found composer.json"

# Set basic permissions
echo "🔒 Setting basic permissions..."
chmod -R 755 /home/ploi/api.nxoland.com/

# Create vendor directory
echo "📁 Creating vendor directory..."
mkdir -p vendor
chmod 755 vendor

# Clear Composer cache
echo "🧹 Clearing Composer cache..."
composer clear-cache

# Install/update Composer dependencies
echo "📦 Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction

# Set proper permissions for web files
echo "🔒 Setting web file permissions..."
chmod -R 755 public/
chmod 644 public/.htaccess
chmod 644 public/index.php

# Create .env file (force creation)
echo "📝 Creating .env file..."
cat > .env << 'EOF'
APP_NAME=NXOLand API
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.nxoland.com

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=your_username
DB_PASSWORD=your_password

# JWT Configuration
JWT_SECRET=your_jwt_secret_key_here
JWT_ALGORITHM=HS256

# CORS Configuration
CORS_ALLOWED_ORIGINS=https://nxoland.com,https://www.nxoland.com

# API Configuration
API_VERSION=v1
API_PREFIX=api
EOF

# Set proper permissions for .env
chmod 644 .env

echo "✅ .env file created with contents:"
cat .env

# Try to reload PHP-FPM (optional)
echo "🔄 Attempting to reload PHP-FPM..."
if command -v php8.4-fpm >/dev/null 2>&1; then
    service php8.4-fpm reload 2>/dev/null || echo "⚠️  Could not reload PHP-FPM 8.4"
elif command -v php8.3-fpm >/dev/null 2>&1; then
    service php8.3-fpm reload 2>/dev/null || echo "⚠️  Could not reload PHP-FPM 8.3"
elif command -v php8.2-fpm >/dev/null 2>&1; then
    service php8.2-fpm reload 2>/dev/null || echo "⚠️  Could not reload PHP-FPM 8.2"
else
    echo "⚠️  PHP-FPM service not found or not accessible"
fi

echo "🎉 Backend API deployed successfully!"
echo "🌐 Your API is ready at: https://api.nxoland.com"
echo "📝 .env file created with all necessary variables"
echo "🧪 Test endpoint: curl https://api.nxoland.com/api/ping"
