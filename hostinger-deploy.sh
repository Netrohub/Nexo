#!/bin/bash

# ============================================
# NXOLand Hostinger Backend Deployment Script
# For api.nxoland.com
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
PROJECT_NAME="nxoland-backend"
BACKEND_DIR="./laravel-backend"
HOSTINGER_DIR="./hostinger-upload"
API_DOMAIN="api.nxoland.com"
FRONTEND_DOMAIN="nxoland.com"

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

# Check if Laravel backend exists
check_backend() {
    log_step "Checking Laravel backend..."
    
    if [ ! -d "$BACKEND_DIR" ]; then
        log_error "Laravel backend directory not found: $BACKEND_DIR"
        log_info "Please ensure your Laravel backend is in the laravel-backend/ directory"
        exit 1
    fi
    
    if [ ! -f "$BACKEND_DIR/composer.json" ]; then
        log_error "composer.json not found in Laravel backend"
        exit 1
    fi
    
    log_success "Laravel backend found"
}

# Prepare Laravel backend for Hostinger
prepare_backend() {
    log_step "Preparing Laravel backend for Hostinger..."
    
    # Create upload directory
    rm -rf $HOSTINGER_DIR
    mkdir -p $HOSTINGER_DIR
    
    # Copy Laravel files
    cp -r $BACKEND_DIR/* $HOSTINGER_DIR/
    
    # Create production .env file
    cat > $HOSTINGER_DIR/.env << EOF
APP_NAME=NXOLand
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://$API_DOMAIN

LOG_CHANNEL=stack
LOG_LEVEL=error

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=nxoland_api
DB_USERNAME=nxoland_user
DB_PASSWORD=[YOUR_DATABASE_PASSWORD]

# Cache Configuration
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync

# Mail Configuration
MAIL_MAILER=smtp
MAIL_HOST=smtp.hostinger.com
MAIL_PORT=587
MAIL_USERNAME=noreply@nxoland.com
MAIL_PASSWORD=[YOUR_EMAIL_PASSWORD]
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@nxoland.com
MAIL_FROM_NAME="NXOLand"

# CORS Configuration
CORS_ALLOWED_ORIGINS=https://$FRONTEND_DOMAIN,https://www.$FRONTEND_DOMAIN

# Sanctum Configuration
SANCTUM_STATEFUL_DOMAINS=$FRONTEND_DOMAIN,www.$FRONTEND_DOMAIN

# Session Configuration
SESSION_DOMAIN=.nxoland.com
SESSION_SECURE_COOKIE=true
EOF

    # Create .htaccess for Apache
    cat > $HOSTINGER_DIR/.htaccess << 'EOF'
<IfModule mod_rewrite.c>
    RewriteEngine On
    
    # Handle Laravel routing
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule ^(.*)$ index.php [QSA,L]
</IfModule>

# Security headers
<IfModule mod_headers.c>
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set X-Content-Type-Options "nosniff"
    Header always set Referrer-Policy "no-referrer-when-downgrade"
</IfModule>

# CORS headers
<IfModule mod_headers.c>
    Header always set Access-Control-Allow-Origin "https://nxoland.com"
    Header always set Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
    Header always set Access-Control-Allow-Headers "Content-Type, Authorization, X-Requested-With"
    Header always set Access-Control-Allow-Credentials "true"
</IfModule>
EOF

    # Create Laravel entry point
    cat > $HOSTINGER_DIR/index.php << 'EOF'
<?php

use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// Determine if the application is in maintenance mode
if (file_exists($maintenance = __DIR__.'/storage/framework/maintenance.php')) {
    require $maintenance;
}

// Register the Composer autoloader
require __DIR__.'/vendor/autoload.php';

// Bootstrap Laravel and handle the request
(require_once __DIR__.'/bootstrap/app.php')
    ->handleRequest(Request::capture());
EOF

    # Install dependencies
    log_step "Installing Composer dependencies..."
    cd $HOSTINGER_DIR
    composer install --no-dev --optimize-autoloader --no-interaction
    
    # Generate app key
    log_step "Generating application key..."
    php artisan key:generate --force
    
    # Cache configurations
    log_step "Caching configurations..."
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    
    cd ..
    
    log_success "Laravel backend prepared for Hostinger"
}

# Create deployment package
create_package() {
    log_step "Creating deployment package..."
    
    # Create zip file
    cd $HOSTINGER_DIR
    zip -r ../nxoland-backend-hostinger.zip . -x "*.git*" "node_modules/*" "tests/*" "*.md"
    cd ..
    
    log_success "Deployment package created: nxoland-backend-hostinger.zip"
}

# Create deployment instructions
create_instructions() {
    log_step "Creating deployment instructions..."
    
    cat > HOSTINGER_DEPLOYMENT_INSTRUCTIONS.md << EOF
# Hostinger Deployment Instructions

## 📦 Package Created
- **File**: nxoland-backend-hostinger.zip
- **Size**: $(du -h nxoland-backend-hostinger.zip | cut -f1)
- **Created**: $(date)

## 🚀 Deployment Steps

### 1. Upload to Hostinger
1. Login to your Hostinger control panel
2. Go to File Manager
3. Navigate to public_html directory
4. Upload nxoland-backend-hostinger.zip
5. Extract the zip file
6. Move all files to public_html root (not in a subdirectory)

### 2. Database Setup
1. Go to MySQL Databases in Hostinger control panel
2. Create a new database: nxoland_api
3. Create a new user: nxoland_user
4. Set a strong password
5. Grant all privileges to the user for the database

### 3. Update Environment Variables
Edit the .env file in your public_html directory:
- Update DB_DATABASE with your database name
- Update DB_USERNAME with your database username  
- Update DB_PASSWORD with your database password
- Update MAIL_PASSWORD with your email password

### 4. Run Database Migrations
If you have SSH access:
\`\`\`bash
cd public_html
php artisan migrate
\`\`\`

Or use Hostinger's terminal if available.

### 5. Set File Permissions
Set the following permissions:
- storage/ directory: 755
- bootstrap/cache/ directory: 755
- .env file: 644

### 6. Test Your API
Visit: https://api.nxoland.com/api/health

## 🔧 Configuration Files Included

- **.env**: Environment configuration
- **.htaccess**: Apache configuration
- **index.php**: Laravel entry point
- **composer.json**: PHP dependencies

## 🌐 Domain Configuration

- **API Domain**: api.nxoland.com
- **Frontend Domain**: nxoland.com
- **CORS**: Configured for frontend domain
- **SSL**: Enable in Hostinger control panel

## 📋 Post-Deployment Checklist

- [ ] Files uploaded to public_html
- [ ] Database created and configured
- [ ] Environment variables updated
- [ ] File permissions set
- [ ] SSL certificate enabled
- [ ] API endpoints responding
- [ ] CORS working with frontend
- [ ] Database migrations run

## 🆘 Troubleshooting

### 500 Internal Server Error
- Check file permissions
- Verify .env configuration
- Check Laravel logs in storage/logs/

### Database Connection Failed
- Verify database credentials in .env
- Check database server status
- Test connection manually

### CORS Issues
- Verify CORS_ALLOWED_ORIGINS in .env
- Check .htaccess headers
- Test with browser developer tools

## 📞 Support

If you encounter issues:
1. Check Hostinger documentation
2. Review Laravel logs
3. Test API endpoints individually
4. Verify database connectivity

## 🎉 Success!

Once deployed, your API will be available at:
- **Health Check**: https://api.nxoland.com/api/health
- **API Base**: https://api.nxoland.com/api/
- **CORS**: Configured for https://nxoland.com

Your React frontend on Ploi will be able to communicate with this API!
EOF

    log_success "Deployment instructions created: HOSTINGER_DEPLOYMENT_INSTRUCTIONS.md"
}

# Main deployment function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              NXOLand Hostinger Backend Deployment          ║"
    echo "║                    For api.nxoland.com                       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Run deployment steps
    check_backend
    prepare_backend
    create_package
    create_instructions
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              HOSTINGER DEPLOYMENT PACKAGE READY!           ║"
    echo "║                                                              ║"
    echo "║  📦 Package: nxoland-backend-hostinger.zip                  ║"
    echo "║  📋 Instructions: HOSTINGER_DEPLOYMENT_INSTRUCTIONS.md     ║"
    echo "║                                                              ║"
    echo "║  🚀 Next steps:                                             ║"
    echo "║  1. Upload zip file to Hostinger                           ║"
    echo "║  2. Extract in public_html directory                       ║"
    echo "║  3. Configure database in Hostinger control panel         ║"
    echo "║  4. Update .env file with your credentials                 ║"
    echo "║  5. Set file permissions                                  ║"
    echo "║  6. Test API at https://api.nxoland.com/api/health        ║"
    echo "║                                                              ║"
    echo "║  🌐 Your API will be ready for your React frontend!        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function
main "$@"
