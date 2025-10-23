#!/bin/bash

# Nexo Full Stack Deployment Script
# Handles both React frontend and Laravel backend deployment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="Nexo"
FRONTEND_DIR="."
BACKEND_DIR="laravel-backend"
BUILD_DIR="dist"
NODE_VERSION="18"
PHP_VERSION="8.2"

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

check_requirements() {
    log_info "Checking requirements..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        log_error "Node.js is not installed. Please install Node.js $NODE_VERSION+"
        exit 1
    fi
    
    NODE_VER=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VER" -lt "$NODE_VERSION" ]; then
        log_warning "Node.js version $NODE_VER detected. Recommended: $NODE_VERSION+"
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        log_error "npm is not installed"
        exit 1
    fi
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ]; then
        log_error "package.json not found. Make sure you're in the project root."
        exit 1
    fi
    
    log_success "Requirements check passed"
}

deploy_frontend() {
    log_info "🚀 Deploying React Frontend..."
    
    # Install dependencies
    log_info "Installing frontend dependencies..."
    npm ci --production=false
    
    # Set environment variables for build
    export VITE_API_BASE_URL="${VITE_API_BASE_URL:-https://api.nxoland.com/api}"
    export VITE_COMING_SOON_MODE="${VITE_COMING_SOON_MODE:-false}"
    export VITE_MOCK_API="${VITE_MOCK_API:-false}"
    
    # Build the project
    log_info "Building React application..."
    npm run build
    
    # Check if build was successful
    if [ ! -d "$BUILD_DIR" ]; then
        log_error "Build failed. $BUILD_DIR directory not found."
        exit 1
    fi
    
    # Check build output
    if [ ! -f "$BUILD_DIR/index.html" ]; then
        log_error "Build output is incomplete. index.html not found."
        exit 1
    fi
    
    log_success "Frontend build completed successfully!"
    log_info "Build output: $BUILD_DIR/"
    
    # Optional: Copy to web root
    if [ -n "$WEB_ROOT" ]; then
        log_info "Copying files to web root: $WEB_ROOT"
        sudo cp -r $BUILD_DIR/* $WEB_ROOT/
        log_success "Files copied to web root"
    fi
}

deploy_backend() {
    if [ ! -d "$BACKEND_DIR" ]; then
        log_warning "Laravel backend directory not found. Skipping backend deployment."
        return
    fi
    
    log_info "🚀 Deploying Laravel Backend..."
    
    cd $BACKEND_DIR
    
    # Check if composer.json exists
    if [ ! -f "composer.json" ]; then
        log_warning "composer.json not found in $BACKEND_DIR. Skipping backend deployment."
        cd ..
        return
    fi
    
    # Install PHP dependencies
    log_info "Installing PHP dependencies..."
    composer install --no-dev --optimize-autoloader
    
    # Set Laravel environment
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            log_info "Creating .env file from .env.example"
            cp .env.example .env
        else
            log_warning "No .env file found. Please configure Laravel environment."
        fi
    fi
    
    # Generate application key
    log_info "Generating application key..."
    php artisan key:generate --force
    
    # Run migrations
    log_info "Running database migrations..."
    php artisan migrate --force
    
    # Clear caches
    log_info "Clearing Laravel caches..."
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    
    # Set permissions
    log_info "Setting file permissions..."
    sudo chown -R www-data:www-data storage bootstrap/cache
    sudo chmod -R 775 storage bootstrap/cache
    
    cd ..
    log_success "Backend deployment completed!"
}

deploy_nginx() {
    if [ -n "$NGINX_CONFIG" ]; then
        log_info "Configuring Nginx..."
        
        # Create Nginx configuration
        cat > /tmp/nexo-nginx.conf << EOF
server {
    listen 80;
    server_name ${DOMAIN:-nxoland.com};
    root ${WEB_ROOT:-/var/www/html};
    index index.html;
    
    # Frontend routes
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # API routes (if backend is on same server)
    location /api {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
    
    # Static files
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF
        
        # Copy configuration
        sudo cp /tmp/nexo-nginx.conf /etc/nginx/sites-available/nexo
        sudo ln -sf /etc/nginx/sites-available/nexo /etc/nginx/sites-enabled/
        
        # Test and reload Nginx
        sudo nginx -t && sudo systemctl reload nginx
        
        log_success "Nginx configuration updated"
    fi
}

cleanup() {
    log_info "Cleaning up..."
    
    # Remove old build files
    if [ -d "$BUILD_DIR" ]; then
        rm -rf $BUILD_DIR
    fi
    
    # Clear npm cache
    npm cache clean --force
    
    log_success "Cleanup completed"
}

# Main deployment function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    NEXO DEPLOYMENT SCRIPT                    ║"
    echo "║              Full Stack React + Laravel Deploy             ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Parse command line arguments
    DEPLOY_FRONTEND=true
    DEPLOY_BACKEND=false
    DEPLOY_NGINX=false
    CLEANUP=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --frontend-only)
                DEPLOY_FRONTEND=true
                DEPLOY_BACKEND=false
                shift
                ;;
            --backend-only)
                DEPLOY_FRONTEND=false
                DEPLOY_BACKEND=true
                shift
                ;;
            --with-nginx)
                DEPLOY_NGINX=true
                shift
                ;;
            --cleanup)
                CLEANUP=true
                shift
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --frontend-only    Deploy only React frontend"
                echo "  --backend-only     Deploy only Laravel backend"
                echo "  --with-nginx       Configure Nginx"
                echo "  --cleanup          Clean up after deployment"
                echo "  --help             Show this help"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Check requirements
    check_requirements
    
    # Deploy frontend
    if [ "$DEPLOY_FRONTEND" = true ]; then
        deploy_frontend
    fi
    
    # Deploy backend
    if [ "$DEPLOY_BACKEND" = true ]; then
        deploy_backend
    fi
    
    # Configure Nginx
    if [ "$DEPLOY_NGINX" = true ]; then
        deploy_nginx
    fi
    
    # Cleanup
    if [ "$CLEANUP" = true ]; then
        cleanup
    fi
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    DEPLOYMENT COMPLETED!                     ║"
    echo "║                                                              ║"
    echo "║  🎉 Your Nexo application has been deployed successfully!    ║"
    echo "║                                                              ║"
    echo "║  Frontend: React app built and ready                        ║"
    echo "║  Backend:  Laravel API configured                            ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function with all arguments
main "$@"
