#!/bin/bash

# NXOLand Backend Deployment Script - Fixed Version
# This script handles permissions and Composer issues

set -e  # Exit on any error

echo "🚀 Starting NXOLand Backend Deployment (Fixed Version)..."

# Change to the project directory
cd /home/ploi/api.nxoland.com

# Check if composer.json exists
if [ ! -f "composer.json" ]; then
    echo "❌ Error: composer.json not found!"
    echo "Please upload your backend files first."
    exit 1
fi

echo "✅ Found composer.json"

# Fix ownership and permissions first
echo "🔒 Fixing ownership and permissions..."
sudo chown -R ploi:ploi /home/ploi/api.nxoland.com/
sudo chmod -R 755 /home/ploi/api.nxoland.com/

# Create vendor directory with proper permissions
echo "📁 Creating vendor directory..."
mkdir -p vendor
chown ploi:ploi vendor
chmod 755 vendor

# Clear Composer cache
echo "🧹 Clearing Composer cache..."
composer clear-cache

# Install/update Composer dependencies with proper permissions
echo "📦 Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction

# Set proper permissions for web files
echo "🔒 Setting web file permissions..."
chmod -R 755 public/
chmod 644 public/.htaccess
chmod 644 public/index.php

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "📝 Creating .env file..."
    cat > .env << 'EOF'
APP_NAME=NXOLand API
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.nxoland.com

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=your_username
DB_PASSWORD=your_password

JWT_SECRET=your_jwt_secret_key_here
JWT_ALGORITHM=HS256
EOF
    chown ploi:ploi .env
    chmod 644 .env
    echo "✅ .env file created"
else
    echo "✅ .env file already exists"
fi

# Reload PHP-FPM
echo "🔄 Reloading PHP-FPM..."
echo "" | sudo -S service php8.4-fpm reload

echo "🎉 Backend API deployed successfully!"
echo "🌐 Your API is ready at: https://api.nxoland.com"
echo "🧪 Test endpoint: curl https://api.nxoland.com/api/ping"
