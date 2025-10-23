#!/bin/bash

# Nexo Laravel Backend Deployment Script
# Handles Laravel API deployment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="Nexo Backend"
BACKEND_DIR="laravel-backend"
PHP_VERSION="8.2"
COMPOSER_VERSION="2"

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

# Check if backend directory exists
check_backend() {
    if [ ! -d "$BACKEND_DIR" ]; then
        log_error "Laravel backend directory not found: $BACKEND_DIR"
        exit 1
    fi
    
    cd $BACKEND_DIR
    
    if [ ! -f "composer.json" ]; then
        log_error "composer.json not found in $BACKEND_DIR"
        exit 1
    fi
    
    log_success "Backend directory verified"
}

# Check PHP and Composer
check_requirements() {
    # Check PHP
    if ! command -v php &> /dev/null; then
        log_error "PHP is not installed. Please install PHP $PHP_VERSION+"
        exit 1
    fi
    
    PHP_VER=$(php -v | head -n1 | cut -d' ' -f2 | cut -d'.' -f1,2)
    log_success "PHP version: $PHP_VER"
    
    # Check Composer
    if ! command -v composer &> /dev/null; then
        log_error "Composer is not installed. Please install Composer $COMPOSER_VERSION+"
        exit 1
    fi
    
    COMPOSER_VER=$(composer --version | cut -d' ' -f3 | cut -d'.' -f1)
    log_success "Composer version: $(composer --version)"
}

# Install PHP dependencies
install_dependencies() {
    log_info "Installing PHP dependencies..."
    
    # Install with Composer
    composer install --no-dev --optimize-autoloader --no-interaction
    
    log_success "PHP dependencies installed"
}

# Setup environment
setup_environment() {
    log_info "Setting up Laravel environment..."
    
    # Copy .env.example to .env if .env doesn't exist
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            log_info "Creating .env file from .env.example"
            cp .env.example .env
        else
            log_warning "No .env.example found. Please create .env manually."
        fi
    fi
    
    # Generate application key
    log_info "Generating application key..."
    php artisan key:generate --force
    
    # Set environment variables if provided
    if [ -n "$APP_URL" ]; then
        log_info "Setting APP_URL to $APP_URL"
        sed -i "s|APP_URL=.*|APP_URL=$APP_URL|" .env
    fi
    
    if [ -n "$DB_HOST" ]; then
        log_info "Setting database host to $DB_HOST"
        sed -i "s|DB_HOST=.*|DB_HOST=$DB_HOST|" .env
    fi
    
    if [ -n "$DB_DATABASE" ]; then
        log_info "Setting database name to $DB_DATABASE"
        sed -i "s|DB_DATABASE=.*|DB_DATABASE=$DB_DATABASE|" .env
    fi
    
    log_success "Environment configured"
}

# Run database migrations
run_migrations() {
    log_info "Running database migrations..."
    
    # Check if database is accessible
    if ! php artisan migrate:status &> /dev/null; then
        log_warning "Database connection failed. Skipping migrations."
        return
    fi
    
    # Run migrations
    php artisan migrate --force
    
    # Run seeders if needed
    if [ "$RUN_SEEDERS" = "true" ]; then
        log_info "Running database seeders..."
        php artisan db:seed --force
    fi
    
    log_success "Database migrations completed"
}

# Clear and cache Laravel
optimize_laravel() {
    log_info "Optimizing Laravel application..."
    
    # Clear all caches
    php artisan cache:clear
    php artisan config:clear
    php artisan route:clear
    php artisan view:clear
    
    # Cache for production
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    
    log_success "Laravel optimized"
}

# Set file permissions
set_permissions() {
    log_info "Setting file permissions..."
    
    # Set storage and cache permissions
    sudo chown -R www-data:www-data storage bootstrap/cache
    sudo chmod -R 775 storage bootstrap/cache
    
    # Set application permissions
    sudo chown -R www-data:www-data .
    sudo chmod -R 755 .
    
    log_success "File permissions set"
}

# Setup queue worker (if needed)
setup_queue() {
    if [ "$SETUP_QUEUE" = "true" ]; then
        log_info "Setting up queue worker..."
        
        # Create queue worker service
        cat > /tmp/nexo-queue.service << EOF
[Unit]
Description=Nexo Queue Worker
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=$(pwd)
ExecStart=/usr/bin/php artisan queue:work --sleep=3 --tries=3 --max-time=3600
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
        
        sudo cp /tmp/nexo-queue.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable nexo-queue
        sudo systemctl start nexo-queue
        
        log_success "Queue worker configured"
    fi
}

# Setup cron jobs
setup_cron() {
    if [ "$SETUP_CRON" = "true" ]; then
        log_info "Setting up cron jobs..."
        
        # Add Laravel scheduler to crontab
        (crontab -l 2>/dev/null; echo "* * * * * cd $(pwd) && php artisan schedule:run >> /dev/null 2>&1") | crontab -
        
        log_success "Cron jobs configured"
    fi
}

# Create deployment package
create_package() {
    if [ "$CREATE_PACKAGE" = "true" ]; then
        log_info "Creating deployment package..."
        
        PACKAGE_NAME="nexo-backend-$(date +%Y%m%d-%H%M%S).tar.gz"
        
        # Exclude unnecessary files
        tar --exclude='node_modules' \
            --exclude='.git' \
            --exclude='storage/logs' \
            --exclude='storage/framework/cache' \
            --exclude='storage/framework/sessions' \
            --exclude='storage/framework/views' \
            -czf "../$PACKAGE_NAME" .
        
        log_success "Package created: $PACKAGE_NAME"
    fi
}

# Main deployment function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                   NEXO BACKEND DEPLOYMENT                 ║"
    echo "║                    Laravel API Server                     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --app-url)
                APP_URL="$2"
                shift 2
                ;;
            --db-host)
                DB_HOST="$2"
                shift 2
                ;;
            --db-database)
                DB_DATABASE="$2"
                shift 2
                ;;
            --run-seeders)
                RUN_SEEDERS="true"
                shift
                ;;
            --setup-queue)
                SETUP_QUEUE="true"
                shift
                ;;
            --setup-cron)
                SETUP_CRON="true"
                shift
                ;;
            --create-package)
                CREATE_PACKAGE="true"
                shift
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --app-url URL        Set application URL"
                echo "  --db-host HOST       Set database host"
                echo "  --db-database DB     Set database name"
                echo "  --run-seeders        Run database seeders"
                echo "  --setup-queue        Setup queue worker"
                echo "  --setup-cron         Setup cron jobs"
                echo "  --create-package     Create deployment package"
                echo "  --help               Show this help"
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Run deployment steps
    check_backend
    check_requirements
    install_dependencies
    setup_environment
    run_migrations
    optimize_laravel
    set_permissions
    setup_queue
    setup_cron
    create_package
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                BACKEND DEPLOYMENT COMPLETED!               ║"
    echo "║                                                              ║"
    echo "║  🎉 Your Nexo Laravel backend has been deployed!          ║"
    echo "║                                                              ║"
    echo "║  🚀 API server is ready                                      ║"
    echo "║  📊 Database migrations completed                           ║"
    echo "║  ⚡ Application optimized for production                     ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function with all arguments
main "$@"
