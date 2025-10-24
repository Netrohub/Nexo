#!/bin/bash

# NXOLand Backend Deployment Script
# This script should be used in Ploi after uploading backend files

set -e  # Exit on any error

echo "🚀 Starting NXOLand Backend Deployment..."

# Change to the project directory
cd /home/ploi/api.nxoland.com

# Check if composer.json exists
if [ ! -f "composer.json" ]; then
    echo "❌ Error: composer.json not found!"
    echo "Please upload your backend files first."
    echo "Upload backend-deploy.zip to /home/ploi/api.nxoland.com/ and extract it."
    exit 1
fi

echo "✅ Found composer.json"

# Install/update Composer dependencies
echo "📦 Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader

# Set proper permissions
echo "🔒 Setting file permissions..."
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
