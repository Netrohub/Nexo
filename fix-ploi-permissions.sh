#!/bin/bash

# Fix Ploi Backend Permissions and Deployment
# This script should be run on the Ploi server

set -e  # Exit on any error

echo "🔧 Fixing Ploi Backend Permissions and Deployment..."

# Change to the project directory
cd /home/ploi/api.nxoland.com

echo "📁 Current directory: $(pwd)"
echo "📋 Directory contents:"
ls -la

# Fix ownership and permissions
echo "🔒 Fixing ownership and permissions..."

# Set proper ownership (ploi user should own the files)
sudo chown -R ploi:ploi /home/ploi/api.nxoland.com/

# Set proper permissions for directories
find /home/ploi/api.nxoland.com -type d -exec chmod 755 {} \;

# Set proper permissions for files
find /home/ploi/api.nxoland.com -type f -exec chmod 644 {} \;

# Make sure composer can write to vendor directory
mkdir -p /home/ploi/api.nxoland.com/vendor
chmod 755 /home/ploi/api.nxoland.com/vendor
chown ploi:ploi /home/ploi/api.nxoland.com/vendor

# Clear composer cache
echo "🧹 Clearing Composer cache..."
composer clear-cache

# Install dependencies with proper permissions
echo "📦 Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction

# Set final permissions
echo "🔒 Setting final permissions..."
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

echo "🎉 Backend deployment fixed successfully!"
echo "🌐 Your API is ready at: https://api.nxoland.com"
echo "🧪 Test endpoint: curl https://api.nxoland.com/api/ping"
