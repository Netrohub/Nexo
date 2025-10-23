# NXOLand Full-Stack Deployment Guide

## 🚀 Complete Single-Server Deployment

This guide will help you deploy your entire NXOLand marketplace on **one server** with:
- ✅ React Frontend
- ✅ Laravel Backend API
- ✅ MySQL Database
- ✅ Redis Cache
- ✅ NGINX Web Server
- ✅ SSL Certificates

---

## 📋 Prerequisites

### Server Requirements:
- **OS:** Ubuntu 22.04 LTS (recommended)
- **RAM:** 2GB minimum (4GB recommended)
- **Storage:** 20GB minimum
- **CPU:** 1 core minimum (2 cores recommended)

### Domain Setup:
- **Frontend:** `yourdomain.com`
- **API:** `api.yourdomain.com`
- **SSL:** Automatic with Let's Encrypt

---

## 🎯 Deployment Options

### Option 1: Automated Deployment (Recommended)
**Best for:** Quick setup with minimal configuration

#### Steps:
1. **Prepare locally** (Windows):
   ```cmd
   deploy-full-stack.bat
   ```

2. **Upload to server**:
   - Upload `C:\var\www\nxoland-frontend\` → `/var/www/nxoland-frontend/`
   - Upload `C:\var\www\nxoland-backend\` → `/var/www/nxoland-backend/`

3. **Run on server**:
   ```bash
   bash deploy-full-stack.sh
   ```

4. **Configure DNS**:
   - `yourdomain.com` → `YOUR_SERVER_IP`
   - `api.yourdomain.com` → `YOUR_SERVER_IP`

### Option 2: Manual Deployment
**Best for:** Custom configuration and learning

#### Server Setup:
```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# 3. Install PHP 8.4
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
sudo apt install -y php8.4 php8.4-fpm php8.4-mysql php8.4-xml php8.4-curl php8.4-zip php8.4-mbstring php8.4-gd php8.4-redis php8.4-bcmath

# 4. Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# 5. Install MySQL
sudo apt install -y mysql-server mysql-client

# 6. Install Redis
sudo apt install -y redis-server

# 7. Install NGINX
sudo apt install -y nginx
```

---

## 🔧 Configuration Details

### Database Setup:
```sql
-- Create database
CREATE DATABASE nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user
CREATE USER 'nxoland_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON nxoland.* TO 'nxoland_user'@'localhost';
FLUSH PRIVILEGES;
```

### Environment Variables:

#### Frontend (.env.production):
```env
VITE_API_BASE_URL=https://api.yourdomain.com/api
VITE_COMING_SOON_MODE=false
VITE_MOCK_API=false
NODE_ENV=production
```

#### Backend (.env):
```env
APP_NAME=NXOLand
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.yourdomain.com

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=nxoland_user
DB_PASSWORD=secure_password

CACHE_DRIVER=redis
SESSION_DRIVER=redis
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
```

### NGINX Configuration:
```nginx
# Frontend (React)
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    root /var/www/nxoland-frontend/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}

# Backend API (Laravel)
server {
    listen 80;
    server_name api.yourdomain.com;
    root /var/www/nxoland-backend/public;
    index index.php;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}
```

---

## 🚀 Deployment Process

### Step 1: Prepare Your Code
```bash
# Build React frontend
npm ci
npm run build

# Prepare Laravel backend
cd laravel-backend
composer install --no-dev --optimize-autoloader
```

### Step 2: Upload to Server
```bash
# Upload frontend
scp -r dist/ user@server:/var/www/nxoland-frontend/

# Upload backend
scp -r laravel-backend/ user@server:/var/www/nxoland-backend/
```

### Step 3: Run Server Setup
```bash
# On your server
sudo bash deploy-full-stack.sh
```

### Step 4: Deploy Application
```bash
# Run deployment script
deploy-nxoland
```

---

## 🔒 Security Configuration

### Firewall Setup:
```bash
# Configure UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

### SSL Certificates:
```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get certificates
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com -d api.yourdomain.com
```

### PHP Security:
```bash
# Secure PHP configuration
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.4/fpm/php.ini
sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php/8.4/fpm/php.ini
sudo systemctl restart php8.4-fpm
```

---

## 📊 Performance Optimization

### Redis Configuration:
```bash
# Configure Redis for production
sudo sed -i 's/^# maxmemory <bytes>/maxmemory 256mb/' /etc/redis/redis.conf
sudo sed -i 's/^# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/' /etc/redis/redis.conf
sudo systemctl restart redis-server
```

### NGINX Optimization:
```nginx
# Add to NGINX config
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;

# Cache static assets
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}
```

---

## 🛠️ Maintenance Commands

### Update Application:
```bash
# Deploy new version
deploy-nxoland

# Clear caches
sudo -u www-data php /var/www/nxoland-backend/artisan cache:clear
sudo -u www-data php /var/www/nxoland-backend/artisan config:clear
```

### Database Management:
```bash
# Run migrations
sudo -u www-data php /var/www/nxoland-backend/artisan migrate

# Seed database
sudo -u www-data php /var/www/nxoland-backend/artisan db:seed
```

### Monitoring:
```bash
# Check services
sudo systemctl status nginx
sudo systemctl status php8.4-fpm
sudo systemctl status mysql
sudo systemctl status redis-server

# Check logs
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/php8.4-fpm.log
```

---

## 🎯 Post-Deployment Checklist

- [ ] **Frontend accessible** at `https://yourdomain.com`
- [ ] **API accessible** at `https://api.yourdomain.com/api`
- [ ] **SSL certificates** installed and working
- [ ] **Database** connected and migrations run
- [ ] **Redis cache** working
- [ ] **File permissions** set correctly
- [ ] **Firewall** configured
- [ ] **Monitoring** set up
- [ ] **Backup strategy** implemented

---

## 🆘 Troubleshooting

### Common Issues:

#### 1. Frontend not loading:
```bash
# Check NGINX configuration
sudo nginx -t
sudo systemctl restart nginx

# Check file permissions
sudo chown -R www-data:www-data /var/www/nxoland-frontend
```

#### 2. API not responding:
```bash
# Check PHP-FPM
sudo systemctl status php8.4-fpm
sudo systemctl restart php8.4-fpm

# Check Laravel logs
sudo tail -f /var/www/nxoland-backend/storage/logs/laravel.log
```

#### 3. Database connection issues:
```bash
# Test MySQL connection
mysql -u nxoland_user -p nxoland

# Check Laravel database config
sudo -u www-data php /var/www/nxoland-backend/artisan config:show database
```

---

## 💰 Cost Estimation

| Component | Monthly Cost | Notes |
|-----------|-------------|-------|
| **Server** | $10-20 | DigitalOcean/AWS/Linode |
| **Domain** | $1-2 | Namecheap/GoDaddy |
| **SSL** | $0 | Let's Encrypt (free) |
| **Total** | **$11-22** | Complete marketplace |

---

## 🎉 Success!

Your NXOLand marketplace is now live with:
- ✅ **High Performance** - Redis caching, NGINX optimization
- ✅ **Secure** - SSL certificates, firewall, security headers
- ✅ **Scalable** - Easy to upgrade server resources
- ✅ **Maintainable** - Automated deployment scripts
- ✅ **Cost-Effective** - Single server solution

**Your marketplace is ready for users!** 🚀
