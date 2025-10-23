# NXOLand Server Setup Commands

## 🔧 SSH Commands for Server Setup

Run these commands on your server before deploying the project:

### **1. Fix MySQL Repository Issue:**
```bash
# Remove problematic MySQL repository
sudo rm -f /etc/apt/sources.list.d/mysql.list
sudo rm -f /etc/apt/sources.list.d/mysql-*.list

# Update package lists
sudo apt-get update
```

### **2. Install Node.js 18:**
```bash
# Install required packages
sudo apt-get install -y curl wget gnupg software-properties-common

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node -v
npm -v
```

### **3. Install NGINX:**
```bash
# Install NGINX
sudo apt-get install -y nginx

# Start and enable NGINX
sudo systemctl start nginx
sudo systemctl enable nginx

# Check status
sudo systemctl status nginx
```

### **4. Install PHP (for Laravel backend):**
```bash
# Add PHP repository
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update

# Install PHP 8.4 and extensions
sudo apt-get install -y php8.4 php8.4-fpm php8.4-mysql php8.4-xml php8.4-curl php8.4-zip php8.4-mbstring php8.4-gd php8.4-redis php8.4-bcmath

# Start PHP-FPM
sudo systemctl start php8.4-fpm
sudo systemctl enable php8.4-fpm
```

### **5. Install Composer:**
```bash
# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Verify installation
composer --version
```

### **6. Install MySQL:**
```bash
# Install MySQL
sudo apt-get install -y mysql-server mysql-client

# Start MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure MySQL installation
sudo mysql_secure_installation
```

### **7. Install Redis:**
```bash
# Install Redis
sudo apt-get install -y redis-server

# Start Redis
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Check status
sudo systemctl status redis-server
```

### **8. Configure Firewall:**
```bash
# Install UFW
sudo apt-get install -y ufw

# Configure firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw allow 80
sudo ufw allow 443
sudo ufw --force enable

# Check status
sudo ufw status
```

### **9. Create Project Directories:**
```bash
# Create directories
sudo mkdir -p /var/www/nxoland-frontend
sudo mkdir -p /var/www/nxoland-backend

# Set permissions
sudo chown -R www-data:www-data /var/www/nxoland-frontend
sudo chown -R www-data:www-data /var/www/nxoland-backend
sudo chmod -R 755 /var/www/nxoland-frontend
sudo chmod -R 755 /var/www/nxoland-backend
```

### **10. Configure MySQL Database:**
```bash
# Login to MySQL
sudo mysql -u root -p

# Run these commands in MySQL:
CREATE DATABASE nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nxoland_user'@'localhost' IDENTIFIED BY 'nxoland_secure_2024';
GRANT ALL PRIVILEGES ON nxoland.* TO 'nxoland_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### **11. Install SSL Certificates (Optional):**
```bash
# Install Certbot
sudo apt-get install -y certbot python3-certbot-nginx

# Get SSL certificates (replace with your domain)
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com -d api.yourdomain.com --non-interactive --agree-tos --email admin@yourdomain.com
```

---

## 🚀 Quick Setup Script

Save this as `setup-server.sh` and run it:

```bash
#!/bin/bash

# NXOLand Server Setup Script
set -e

echo "🚀 Setting up NXOLand server..."

# Fix MySQL repository
sudo rm -f /etc/apt/sources.list.d/mysql.list
sudo rm -f /etc/apt/sources.list.d/mysql-*.list
sudo apt-get update

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install NGINX
sudo apt-get install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install PHP 8.4
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install -y php8.4 php8.4-fpm php8.4-mysql php8.4-xml php8.4-curl php8.4-zip php8.4-mbstring php8.4-gd php8.4-redis php8.4-bcmath
sudo systemctl start php8.4-fpm
sudo systemctl enable php8.4-fpm

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# Install MySQL
sudo apt-get install -y mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql

# Install Redis
sudo apt-get install -y redis-server
sudo systemctl start redis-server
sudo systemctl enable redis-server

# Configure firewall
sudo apt-get install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

# Create directories
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
```

---

## 📋 After Server Setup:

1. **Upload your project** to the server
2. **Run the deployment script** in Ploi
3. **Configure DNS** to point to your server
4. **Test your site!**

Your server will be ready for the NXOLand deployment! 🚀
