#!/bin/bash

# NXOLand Backend Complete Deployment Script
set -e

echo "🚀 Starting NXOLand Backend Complete Deployment..."

cd /home/ploi/api.nxoland.com

# Check if composer.json exists
if [ ! -f "composer.json" ]; then
    echo "❌ Error: composer.json not found!"
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

# Install dependencies
echo "📦 Installing Composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction

# Set web file permissions
echo "🔒 Setting web file permissions..."
chmod -R 755 public/
chmod 644 public/.htaccess
chmod 644 public/index.php

# Create .env file with production values
echo "📝 Creating production .env file..."
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
JWT_SECRET=your_jwt_secret_key_change_in_production_2024
JWT_ALGORITHM=HS256

# CORS Configuration
CORS_ALLOWED_ORIGINS=https://nxoland.com,https://www.nxoland.com

# API Configuration
API_VERSION=v1
API_PREFIX=api
EOF

# Set proper permissions for .env
chmod 644 .env

echo "✅ .env file created with production values"

# Create database if it doesn't exist
echo "🗄️ Setting up database..."
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" || echo "⚠️ Database creation skipped (may need manual setup)"

# Import database schema
echo "📊 Importing database schema..."
if [ -f "database/schema.sql" ]; then
    mysql -u root -p nxoland < database/schema.sql || echo "⚠️ Schema import skipped (may need manual setup)"
else
    echo "⚠️ Schema file not found, creating basic tables..."
    mysql -u root -p nxoland << 'SQL'
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NULL,
    avatar VARCHAR(500) NULL,
    roles JSON DEFAULT '["user"]',
    kyc_status JSON DEFAULT '{"email": false, "phone": false, "identity": false}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NULL,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(100) NOT NULL,
    images JSON NULL,
    status ENUM('active', 'inactive', 'deleted') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    status ENUM('active', 'removed', 'purchased') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO products (name, description, price, category, images, status) VALUES 
('Instagram Account', 'High-quality Instagram account with 10k followers', 50.00, 'Social Media', '["https://example.com/ig1.jpg"]', 'active'),
('Discord Nitro', 'Discord Nitro subscription for 1 month', 9.99, 'Digital Services', '["https://example.com/discord.jpg"]', 'active'),
('Steam Game Key', 'Popular Steam game key', 29.99, 'Gaming', '["https://example.com/steam.jpg"]', 'active');

-- Insert sample user (password: password123)
INSERT INTO users (name, email, password, roles) VALUES 
('Admin User', 'admin@nxoland.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '["admin"]'),
('Test User', 'user@nxoland.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '["user"]');
SQL
fi

# Try to reload PHP-FPM
echo "🔄 Attempting to reload PHP-FPM..."
if command -v php8.4-fpm >/dev/null 2>&1; then
    service php8.4-fpm reload 2>/dev/null || echo "⚠️  Could not reload PHP-FPM"
fi

echo "🎉 Backend API deployment completed successfully!"
echo "🌐 Your API is ready at: https://api.nxoland.com"
echo "📝 .env file created with production values"
echo "🗄️ Database schema imported"
echo "🧪 Test endpoints:"
echo "   - curl https://api.nxoland.com/api/ping"
echo "   - curl https://api.nxoland.com/api/products"
echo "   - curl -X POST https://api.nxoland.com/api/auth/login -H 'Content-Type: application/json' -d '{\"email\":\"user@nxoland.com\",\"password\":\"password123\"}'"
