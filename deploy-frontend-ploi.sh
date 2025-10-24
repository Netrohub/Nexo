#!/bin/bash

# ============================================
# NXOLand Frontend Ploi Deployment Script
# For nxoland.com
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
PROJECT_NAME="nxoland-frontend"
FRONTEND_DIR="frontend"
BUILD_DIR="frontend/dist"
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

# Check if we're in the right directory
check_environment() {
    log_step "Checking environment..."
    
    if [ ! -d "$FRONTEND_DIR" ]; then
        log_error "Frontend directory not found. Please run this script from the project root."
        exit 1
    fi
    
    if [ ! -f "$FRONTEND_DIR/package.json" ]; then
        log_error "package.json not found in frontend directory."
        exit 1
    fi
    
    if [ ! -f "$FRONTEND_DIR/vite.config.ts" ]; then
        log_error "vite.config.ts not found in frontend directory."
        exit 1
    fi
    
    log_success "Environment check passed"
}

# Install dependencies
install_dependencies() {
    log_step "Installing frontend dependencies..."
    
    cd $FRONTEND_DIR
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        log_info "Installing npm dependencies..."
        npm ci
    else
        log_info "Dependencies already installed"
    fi
    
    cd ..
    log_success "Dependencies ready"
}

# Create production environment file
create_production_env() {
    log_step "Creating production environment file..."
    
    cd $FRONTEND_DIR
    
    cat > .env.production << EOF
# NXOLand Frontend Production Environment
# For deployment on nxoland.com via Ploi

# API Configuration
VITE_API_BASE_URL=https://$API_DOMAIN

# Coming Soon Mode (disabled for production)
VITE_COMING_SOON_MODE=false

# Node Environment
NODE_ENV=production

# Build Configuration
VITE_BUILD_OPTIMIZE=true
VITE_BUILD_SOURCEMAP=false
EOF

    cd ..
    log_success "Production environment file created"
}

# Build the project
build_project() {
    log_step "Building React frontend..."
    
    cd $FRONTEND_DIR
    
    # Remove old build
    if [ -d "dist" ]; then
        rm -rf dist
        log_info "Removed old build directory"
    fi
    
    # Build the project
    log_info "Running npm run build..."
    npm run build
    
    if [ ! -d "dist" ]; then
        log_error "Build failed - dist directory not created"
        exit 1
    fi
    
    cd ..
    log_success "Frontend built successfully"
}

# Create Ploi configuration
create_ploi_config() {
    log_step "Creating Ploi configuration..."
    
    cat > ploi-frontend.yml << EOF
# Ploi Deployment Configuration for NXOLand Frontend
# React/Vite project for nxoland.com

# Build commands for React/Vite
build:
  - cd frontend
  - npm ci
  - npm run build

# Environment variables for production
env:
  - VITE_API_BASE_URL=https://$API_DOMAIN
  - VITE_COMING_SOON_MODE=false
  - NODE_ENV=production

# Build output directory
public_path: frontend/dist

# Node.js version
node_version: 18

# Deployment settings
deployment:
  type: static
  build_command: "cd frontend && npm run build"
  output_directory: "frontend/dist"
  
# Domain configuration
domain: $FRONTEND_DOMAIN
ssl: true

# Performance optimizations
optimization:
  - gzip_compression: true
  - static_caching: true
  - cdn_enabled: true
EOF

    log_success "Ploi configuration created: ploi-frontend.yml"
}

# Create deployment package
create_deployment_package() {
    log_step "Creating deployment package..."
    
    # Create zip file for manual upload (if needed)
    if [ -d "$BUILD_DIR" ]; then
        zip -r nxoland-frontend-ploi.zip frontend/ -x "frontend/node_modules/*" "frontend/dist/*" "*.git*" "*.md" "*.log"
        log_success "Deployment package created: nxoland-frontend-ploi.zip"
    fi
}

# Create deployment instructions
create_instructions() {
    log_step "Creating deployment instructions..."
    
    cat > PLOI_FRONTEND_DEPLOYMENT.md << EOF
# 🚀 NXOLand Frontend Ploi Deployment Guide

## 📦 Package Ready
- **Build Directory**: \`frontend/dist/\`
- **Configuration**: \`ploi-frontend.yml\`
- **Created**: $(date)

## 🎯 Quick Deployment Steps

### 1. Connect to Ploi Dashboard
1. Go to [Ploi Dashboard](https://ploi.io)
2. Create a new site
3. Select "Static Site" as project type
4. Connect your Git repository

### 2. Configure Build Settings
- **Build Command**: \`cd frontend && npm run build\`
- **Output Directory**: \`frontend/dist\`
- **Node.js Version**: 18.x
- **Root Directory**: Leave empty (or set to project root)

### 3. Set Environment Variables
Add these in Ploi dashboard:
- \`VITE_API_BASE_URL\`: \`https://$API_DOMAIN\`
- \`VITE_COMING_SOON_MODE\`: \`false\`
- \`NODE_ENV\`: \`production\`

### 4. Configure Domain
- **Domain**: \`$FRONTEND_DOMAIN\`
- **SSL**: Enable automatic SSL
- **CDN**: Enable if available

### 5. Deploy
- Click "Deploy" in Ploi dashboard
- Wait for build to complete
- Test your site at https://$FRONTEND_DOMAIN

## 🔧 Alternative: Manual Upload

If you prefer manual upload:

1. **Upload Files**
   - Upload \`nxoland-frontend-ploi.zip\` to your server
   - Extract in your web root directory
   - Run \`cd frontend && npm ci && npm run build\`

2. **Configure Web Server**
   - Point document root to \`frontend/dist\` directory
   - Configure SPA routing (fallback to index.html)
   - Enable Gzip compression

## 📋 Post-Deployment Checklist

- [ ] Site accessible at https://$FRONTEND_DOMAIN
- [ ] API calls working (check browser network tab)
- [ ] SSL certificate installed
- [ ] CDN enabled (if available)
- [ ] Build artifacts in frontend/dist/ directory
- [ ] Environment variables set correctly
- [ ] No console errors in browser
- [ ] All routes working (SPA routing)

## 🧪 Testing Your Frontend

### 1. Basic Functionality
- Visit https://$FRONTEND_DOMAIN
- Check if the site loads without errors
- Test navigation between pages

### 2. API Integration
- Open browser developer tools
- Check Network tab for API calls
- Verify calls go to https://$API_DOMAIN/
- Check for CORS errors

### 3. Performance
- Run Lighthouse audit
- Check page load speed
- Verify images and assets load correctly

## 🆘 Troubleshooting

### Build Failures
- Check Node.js version (should be 18+)
- Verify all dependencies installed
- Check for TypeScript errors
- Review build logs in Ploi dashboard

### API Connection Issues
- Verify VITE_API_BASE_URL is correct
- Check if backend API is running
- Test API endpoints directly
- Check CORS configuration

### Routing Issues
- Ensure SPA routing is configured
- Check if fallback to index.html is set
- Verify all routes are working

## 🎉 Success!

Once deployed, your React frontend will be available at:
- **Main Site**: https://$FRONTEND_DOMAIN
- **API Integration**: Connected to https://$API_DOMAIN
- **Performance**: Optimized with CDN and caching
- **Security**: SSL enabled and secure

Your NXOLand marketplace frontend is ready for users! 🚀
EOF

    log_success "Deployment instructions created: PLOI_FRONTEND_DEPLOYMENT.md"
}

# Main deployment function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              NXOLand Frontend Ploi Deployment                ║"
    echo "║                    For nxoland.com                         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Run deployment steps
    check_environment
    install_dependencies
    create_production_env
    build_project
    create_ploi_config
    create_deployment_package
    create_instructions
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              PLOI DEPLOYMENT PACKAGE READY!               ║"
    echo "║                                                              ║"
    echo "║  📦 Build Directory: frontend/dist/                          ║"
    echo "║  📋 Instructions: PLOI_FRONTEND_DEPLOYMENT.md               ║"
    echo "║  ⚙️  Configuration: ploi-frontend.yml                    ║"
    echo "║                                                              ║"
    echo "║  🚀 Next steps:                                             ║"
    echo "║  1. Connect repository to Ploi dashboard                  ║"
    echo "║  2. Set project type to 'Static Site'                     ║"
    echo "║  3. Configure build command: cd frontend && npm run build  ║"
    echo "║  4. Set output directory: frontend/dist                     ║"
    echo "║  5. Add environment variables                             ║"
    echo "║  6. Configure domain: $FRONTEND_DOMAIN                    ║"
    echo "║  7. Deploy and test!                                      ║"
    echo "║                                                              ║"
    echo "║  🌐 Your frontend will be ready for your API backend!     ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function
main "$@"
