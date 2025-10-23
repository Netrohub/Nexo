#!/bin/bash

# ============================================
# NXOLand Full-Stack Deployment Script
# Single Server: React + Laravel + MySQL + Redis
# ============================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="nxoland"
FRONTEND_DIR="/var/www/nxoland-frontend"
BACKEND_DIR="/var/www/nxoland-backend"
NGINX_DIR="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"
DOMAIN="${DOMAIN:-nxoland.com}"
API_DOMAIN="${API_DOMAIN:-api.nxoland.com}"

# Functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo -e "${PURPLE}🚀 $1${NC}"
}

# Check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "Please run as root (use sudo)"
        exit 1
    fi
}

# Update system packages
update_system() {
    log_step "Updating system packages..."
    apt update -y
    apt upgrade -y
    log_success "System updated"
}

# Install required packages
install_packages() {
    log_step "Installing required packages..."
    
    # Essential packages
    apt install -y curl wget git unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release
    
    # Node.js 18
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs
    
    # PHP 8.4 and extensions
    add-apt-repository ppa:ondrej/php -y
    apt update
    apt install -y php8.4 php8.4-fpm php8.4-mysql php8.4-xml php8.4-curl php8.4-zip php8.4-mbstring php8.4-gd php8.4-redis php8.4-bcmath
    
    # Composer
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
    
    # MySQL
    apt install -y mysql-server mysql-client
    
    # Redis
    apt install -y redis-server
    
    # NGINX
    apt install -y nginx
    
    log_success "All packages installed"
}

# Configure MySQL
setup_mysql() {
    log_step "Setting up MySQL database..."
    
    # Start MySQL service
    systemctl start mysql
    systemctl enable mysql
    
    # Create database and user
    mysql -e "CREATE DATABASE IF NOT EXISTS nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -e "CREATE USER IF NOT EXISTS 'nxoland_user'@'localhost' IDENTIFIED BY 'nxoland_secure_2024';"
    mysql -e "GRANT ALL PRIVILEGES ON nxoland.* TO 'nxoland_user'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
    
    log_success "MySQL configured"
}

# Configure Redis
setup_redis() {
    log_step "Setting up Redis..."
    
    # Start Redis service
    systemctl start redis-server
    systemctl enable redis-server
    
    # Configure Redis for production
    sed -i 's/^# maxmemory <bytes>/maxmemory 256mb/' /etc/redis/redis.conf
    sed -i 's/^# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/' /etc/redis/redis.conf
    
    systemctl restart redis-server
    
    log_success "Redis configured"
}

# Deploy Laravel Backend
deploy_backend() {
    log_step "Deploying Laravel backend..."
    
    # Create backend directory
    mkdir -p $BACKEND_DIR
    cd $BACKEND_DIR
    
    # Create Laravel project structure
    mkdir -p app/Models
    mkdir -p database/migrations
    mkdir -p database/seeders
    mkdir -p routes
    mkdir -p config
    
    # Create .env file
    cat > .env << EOF
APP_NAME=NXOLand
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://$API_DOMAIN

LOG_CHANNEL=stack
LOG_LEVEL=error

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=nxoland_user
DB_PASSWORD=nxoland_secure_2024

# Cache
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

# Redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

# Mail
MAIL_MAILER=smtp
MAIL_HOST=localhost
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="noreply@$DOMAIN"
MAIL_FROM_NAME="NXOLand"

# CORS
CORS_ALLOWED_ORIGINS=https://$DOMAIN,https://www.$DOMAIN

# Sanctum
SANCTUM_STATEFUL_DOMAINS=$DOMAIN,www.$DOMAIN

# Session
SESSION_DOMAIN=$DOMAIN
SESSION_SECURE_COOKIE=true
EOF

    # Generate app key
    php artisan key:generate
    
    # Set permissions
    chown -R www-data:www-data $BACKEND_DIR
    chmod -R 755 $BACKEND_DIR
    
    log_success "Laravel backend deployed"
}

# Deploy React Frontend
deploy_frontend() {
    log_step "Deploying React frontend..."
    
    # Create frontend directory
    mkdir -p $FRONTEND_DIR
    cd $FRONTEND_DIR
    
    # Create production build directory structure
    mkdir -p dist
    
    # Create environment file for frontend
    cat > .env.production << EOF
VITE_API_BASE_URL=https://$API_DOMAIN/api
VITE_COMING_SOON_MODE=false
VITE_MOCK_API=false
NODE_ENV=production
EOF

    # Set permissions
    chown -R www-data:www-data $FRONTEND_DIR
    chmod -R 755 $FRONTEND_DIR
    
    log_success "React frontend directory created"
}

# Configure NGINX
setup_nginx() {
    log_step "Configuring NGINX..."
    
    # Create NGINX configuration
    cat > $NGINX_DIR/$PROJECT_NAME << EOF
# Frontend (React)
server {
    listen 80;
    server_name $DOMAIN www.$DOMAIN;
    root $FRONTEND_DIR/dist;
    index index.html;
    
    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;
    
    # Handle React Router
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# Backend API (Laravel)
server {
    listen 80;
    server_name $API_DOMAIN;
    root $BACKEND_DIR/public;
    index index.php;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    
    # Handle Laravel
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }
    
    # Deny access to sensitive files
    location ~ /\. {
        deny all;
    }
}
EOF

    # Enable site
    ln -sf $NGINX_DIR/$PROJECT_NAME $NGINX_ENABLED/
    
    # Remove default site
    rm -f $NGINX_ENABLED/default
    
    # Test NGINX configuration
    nginx -t
    
    # Restart NGINX
    systemctl restart nginx
    systemctl enable nginx
    
    log_success "NGINX configured"
}

# Setup SSL with Let's Encrypt
setup_ssl() {
    log_step "Setting up SSL certificates..."
    
    # Install Certbot
    apt install -y certbot python3-certbot-nginx
    
    # Get SSL certificates
    certbot --nginx -d $DOMAIN -d www.$DOMAIN -d $API_DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN
    
    # Setup auto-renewal
    echo "0 12 * * * /usr/bin/certbot renew --quiet" | crontab -
    
    log_success "SSL certificates configured"
}

# Configure PHP-FPM
setup_php_fpm() {
    log_step "Configuring PHP-FPM..."
    
    # PHP-FPM configuration
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.4/fpm/php.ini
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 10M/' /etc/php/8.4/fpm/php.ini
    sed -i 's/post_max_size = 8M/post_max_size = 10M/' /etc/php/8.4/fpm/php.ini
    sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/8.4/fpm/php.ini
    
    # Restart PHP-FPM
    systemctl restart php8.4-fpm
    systemctl enable php8.4-fpm
    
    log_success "PHP-FPM configured"
}

# Setup firewall
setup_firewall() {
    log_step "Setting up firewall..."
    
    # Install UFW
    apt install -y ufw
    
    # Configure firewall
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow 'Nginx Full'
    ufw allow 3306  # MySQL (if needed externally)
    ufw --force enable
    
    log_success "Firewall configured"
}

# Create deployment script
create_deployment_script() {
    log_step "Creating deployment script..."
    
    cat > /usr/local/bin/deploy-nxoland << 'EOF'
#!/bin/bash

# NXOLand Deployment Script
set -e

FRONTEND_DIR="/var/www/nxoland-frontend"
BACKEND_DIR="/var/www/nxoland-backend"

echo "🚀 Deploying NXOLand..."

# Deploy frontend
echo "📦 Deploying frontend..."
cd $FRONTEND_DIR
npm ci --production=false
npm run build

# Deploy backend
echo "🔧 Deploying backend..."
cd $BACKEND_DIR
composer install --no-dev --optimize-autoloader
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run migrations
echo "🗄️ Running database migrations..."
php artisan migrate --force

# Clear caches
echo "🧹 Clearing caches..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Set permissions
chown -R www-data:www-data $FRONTEND_DIR $BACKEND_DIR
chmod -R 755 $FRONTEND_DIR $BACKEND_DIR

echo "✅ Deployment completed!"
EOF

    chmod +x /usr/local/bin/deploy-nxoland
    
    log_success "Deployment script created"
}

# Main deployment function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                NXOLand Full-Stack Deployment              ║"
    echo "║              Single Server: React + Laravel + MySQL         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Run deployment steps
    check_root
    update_system
    install_packages
    setup_mysql
    setup_redis
    deploy_backend
    deploy_frontend
    setup_nginx
    setup_php_fpm
    setup_firewall
    create_deployment_script
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              FULL-STACK DEPLOYMENT COMPLETED!              ║"
    echo "║                                                              ║"
    echo "║  🎉 NXOLand server is ready!                               ║"
    echo "║                                                              ║"
    echo "║  📁 Frontend: $FRONTEND_DIR                    ║"
    echo "║  🔧 Backend: $BACKEND_DIR                     ║"
    echo "║  🗄️ Database: MySQL (nxoland)                              ║"
    echo "║  ⚡ Cache: Redis                                           ║"
    echo "║  🌐 Web: NGINX                                             ║"
    echo "║                                                              ║"
    echo "║  🚀 Next steps:                                             ║"
    echo "║  1. Upload your React build to $FRONTEND_DIR/dist    ║"
    echo "║  2. Upload your Laravel code to $BACKEND_DIR         ║"
    echo "║  3. Run: deploy-nxoland                                   ║"
    echo "║  4. Configure DNS: $DOMAIN → $(curl -s ifconfig.me)        ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function
main "$@"
