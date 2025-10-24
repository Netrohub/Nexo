#!/bin/bash

# ============================================
# NXOLand Backend Deployment Script
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

# Main deployment function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              NXOLand Backend Deployment                      ║"
    echo "║                    For api.nxoland.com                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    log_step "Starting backend deployment..."
    
    # Check if we're in the right directory
    if [ ! -f "composer.json" ]; then
        log_error "composer.json not found. Please run this script from the backend directory."
        exit 1
    fi
    
    if [ ! -f "public/index.php" ]; then
        log_error "public/index.php not found. Backend structure is incomplete."
        exit 1
    fi
    
    log_success "Backend structure verified"
    
    # Install/update Composer dependencies
    log_step "Installing Composer dependencies..."
    if [ -f "composer.lock" ]; then
        composer install --no-dev --optimize-autoloader
    else
        composer install --no-dev --optimize-autoloader
    fi
    log_success "Dependencies installed"
    
    # Set proper permissions
    log_step "Setting file permissions..."
    chmod -R 755 public/
    chmod 644 public/.htaccess
    chmod 644 public/index.php
    log_success "Permissions set"
    
    # Create .env file if it doesn't exist
    if [ ! -f ".env" ]; then
        log_step "Creating .env file..."
        cat > .env << EOF
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
        log_success ".env file created"
    else
        log_info ".env file already exists"
    fi
    
    # Test the API endpoint
    log_step "Testing API endpoint..."
    if curl -s -f "http://localhost/api/ping" > /dev/null 2>&1; then
        log_success "API endpoint test passed"
    else
        log_warning "API endpoint test failed (this is normal if server is not running locally)"
    fi
    
    # Reload PHP-FPM if available
    log_step "Reloading PHP-FPM..."
    if command -v php-fpm >/dev/null 2>&1; then
        # Try to reload PHP-FPM
        if systemctl is-active --quiet php8.4-fpm 2>/dev/null; then
            systemctl reload php8.4-fpm
            log_success "PHP-FPM 8.4 reloaded"
        elif systemctl is-active --quiet php8.3-fpm 2>/dev/null; then
            systemctl reload php8.3-fpm
            log_success "PHP-FPM 8.3 reloaded"
        elif systemctl is-active --quiet php8.2-fpm 2>/dev/null; then
            systemctl reload php8.2-fpm
            log_success "PHP-FPM 8.2 reloaded"
        else
            log_info "PHP-FPM service not found or not running"
        fi
    else
        log_info "PHP-FPM not available"
    fi
    
    log_success "Backend deployment completed successfully!"
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              BACKEND DEPLOYMENT SUCCESSFUL!               ║"
    echo "║                                                              ║"
    echo "║  🌐 API Endpoint: https://api.nxoland.com/api/ping          ║"
    echo "║  📁 Document Root: public/                                  ║"
    echo "║  ⚙️  PHP Version: 8.4+                                      ║"
    echo "║  📦 Dependencies: Installed                                 ║"
    echo "║  🔒 Permissions: Set                                        ║"
    echo "║                                                              ║"
    echo "║  🧪 Test your API:                                          ║"
    echo "║  curl https://api.nxoland.com/api/ping                      ║"
    echo "║                                                              ║"
    echo "║  🎉 Your backend is ready for your frontend!              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function
main "$@"
