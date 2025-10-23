#!/bin/bash

# NXOLand Server Setup Script
# Run this on your server before deploying the project

set -e

echo "🚀 Setting up NXOLand server..."

# Fix MySQL repository
echo "🔧 Fixing MySQL repository..."
sudo rm -f /etc/apt/sources.list.d/mysql.list
sudo rm -f /etc/apt/sources.list.d/mysql-*.list
sudo apt-get update

# Install Node.js 18
echo "📦 Installing Node.js 18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install NGINX
echo "🌐 Installing NGINX..."
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install PHP 8.4
echo "🔧 Installing PHP 8.4..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install -y php8.4 php8.4-fpm php8.4-mysql php8.4-xml php8.4-curl php8.4-zip php8.4-mbstring php8.4-gd php8.4-redis php8.4-bcmath
sudo systemctl start php8.4-fpm
sudo systemctl enable php8.4-fpm

# Install Composer
echo "📦 Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Install MySQL
echo "🗄️ Installing MySQL..."
sudo apt-get install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

# Install Redis
echo "⚡ Installing Redis..."
sudo apt-get install -y redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Configure firewall
echo "🔥 Configuring firewall..."
sudo apt-get install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

# Create directories
echo "📁 Creating project directories..."
sudo mkdir -p /var/www/nxoland-frontend
sudo mkdir -p /var/www/nxoland-backend
sudo chown -R www-data:www-data /var/www/nxoland-frontend
sudo chown -R www-data:www-data /var/www/nxoland-backend
sudo chmod -R 755 /var/www/nxoland-frontend
sudo chmod -R 755 /var/www/nxoland-backend

echo "✅ Server setup completed!"
echo "🚀 Node.js: $(node -v)"
echo "📦 npm: $(npm -v)"
echo "🔧 PHP: $(php -v | head -1)"
echo "🗄️ MySQL: $(mysql --version)"
echo "⚡ Redis: $(redis-server --version | head -1)"
echo ""
echo "🎉 Your server is ready for NXOLand deployment!"
