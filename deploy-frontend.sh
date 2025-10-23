#!/bin/bash

# Nexo Frontend Deployment Script
# Optimized for React/Vite deployment

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="Nexo Frontend"
BUILD_DIR="dist"
NODE_VERSION="18"

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

# Check if we're in the right directory
check_project() {
    if [ ! -f "package.json" ]; then
        log_error "package.json not found. Make sure you're in the project root."
        exit 1
    fi
    
    if [ ! -f "vite.config.ts" ]; then
        log_error "vite.config.ts not found. This doesn't appear to be a Vite project."
        exit 1
    fi
    
    log_success "Project structure verified"
}

# Check Node.js version
check_node() {
    if ! command -v node &> /dev/null; then
        log_error "Node.js is not installed. Please install Node.js $NODE_VERSION+"
        exit 1
    fi
    
    NODE_VER=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VER" -lt "$NODE_VERSION" ]; then
        log_warning "Node.js version $NODE_VER detected. Recommended: $NODE_VERSION+"
    fi
    
    log_success "Node.js version: $(node -v)"
}

# Install dependencies
install_dependencies() {
    log_info "Installing dependencies..."
    
    # Clean install
    if [ -d "node_modules" ]; then
        log_info "Cleaning existing node_modules..."
        rm -rf node_modules
    fi
    
    # Install with npm ci for production builds
    npm ci --production=false
    
    log_success "Dependencies installed"
}

# Set environment variables
setup_environment() {
    log_info "Setting up environment variables..."
    
    # Default values
    export VITE_API_BASE_URL="${VITE_API_BASE_URL:-https://api.nxoland.com/api}"
    export VITE_COMING_SOON_MODE="${VITE_COMING_SOON_MODE:-false}"
    export VITE_MOCK_API="${VITE_MOCK_API:-false}"
    
    # Log environment
    log_info "Environment variables:"
    log_info "  VITE_API_BASE_URL: $VITE_API_BASE_URL"
    log_info "  VITE_COMING_SOON_MODE: $VITE_COMING_SOON_MODE"
    log_info "  VITE_MOCK_API: $VITE_MOCK_API"
}

# Build the project
build_project() {
    log_info "Building React application..."
    
    # Remove old build
    if [ -d "$BUILD_DIR" ]; then
        log_info "Removing old build..."
        rm -rf $BUILD_DIR
    fi
    
    # Build with Vite
    npm run build
    
    # Verify build
    if [ ! -d "$BUILD_DIR" ]; then
        log_error "Build failed. $BUILD_DIR directory not found."
        exit 1
    fi
    
    if [ ! -f "$BUILD_DIR/index.html" ]; then
        log_error "Build output is incomplete. index.html not found."
        exit 1
    fi
    
    # Check build size
    BUILD_SIZE=$(du -sh $BUILD_DIR | cut -f1)
    log_success "Build completed successfully! Size: $BUILD_SIZE"
}

# Optimize build
optimize_build() {
    log_info "Optimizing build..."
    
    # Compress images if possible
    if command -v imagemin &> /dev/null; then
        log_info "Compressing images..."
        find $BUILD_DIR -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | while read file; do
            imagemin "$file" --out-dir="$(dirname "$file")" --plugin=pngquant --plugin=mozjpeg
        done
    fi
    
    # Generate service worker if needed
    if [ -f "public/sw.js" ]; then
        log_info "Copying service worker..."
        cp public/sw.js $BUILD_DIR/
    fi
    
    log_success "Build optimized"
}

# Deploy to server
deploy_to_server() {
    if [ -z "$DEPLOY_PATH" ]; then
        log_warning "DEPLOY_PATH not set. Skipping server deployment."
        return
    fi
    
    log_info "Deploying to server: $DEPLOY_PATH"
    
    # Create directory if it doesn't exist
    mkdir -p "$DEPLOY_PATH"
    
    # Copy files
    cp -r $BUILD_DIR/* "$DEPLOY_PATH/"
    
    # Set permissions
    chmod -R 755 "$DEPLOY_PATH"
    
    log_success "Deployed to $DEPLOY_PATH"
}

# Create deployment package
create_package() {
    if [ "$CREATE_PACKAGE" = "true" ]; then
        log_info "Creating deployment package..."
        
        PACKAGE_NAME="nexo-frontend-$(date +%Y%m%d-%H%M%S).tar.gz"
        tar -czf "$PACKAGE_NAME" -C $BUILD_DIR .
        
        log_success "Package created: $PACKAGE_NAME"
    fi
}

# Main deployment function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                  NEXO FRONTEND DEPLOYMENT                   ║"
    echo "║                    React + Vite Build                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --deploy-path)
                DEPLOY_PATH="$2"
                shift 2
                ;;
            --create-package)
                CREATE_PACKAGE="true"
                shift
                ;;
            --coming-soon)
                export VITE_COMING_SOON_MODE="true"
                shift
                ;;
            --api-url)
                export VITE_API_BASE_URL="$2"
                shift 2
                ;;
            --help)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --deploy-path PATH    Deploy to specific path"
                echo "  --create-package     Create deployment package"
                echo "  --coming-soon        Enable coming soon mode"
                echo "  --api-url URL        Set API URL"
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
    check_project
    check_node
    install_dependencies
    setup_environment
    build_project
    optimize_build
    deploy_to_server
    create_package
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                FRONTEND DEPLOYMENT COMPLETED!               ║"
    echo "║                                                              ║"
    echo "║  🎉 Your Nexo frontend has been built successfully!         ║"
    echo "║                                                              ║"
    echo "║  📁 Build output: $BUILD_DIR/                              ║"
    echo "║  🌐 Ready for deployment to web server                      ║"
    echo "║                                                              ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function with all arguments
main "$@"
