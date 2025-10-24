#!/bin/bash

# ============================================
# NXOLand Ploi Frontend Deployment Script
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
FRONTEND_DIR="."
BUILD_DIR="./dist"
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
    
    if [ ! -f "package.json" ]; then
        log_error "package.json not found. Please run this script from the project root."
        exit 1
    fi
    
    if [ ! -f "vite.config.ts" ]; then
        log_error "vite.config.ts not found. This doesn't appear to be a Vite project."
        exit 1
    fi
    
    log_success "Environment check passed"
}

# Install dependencies
install_dependencies() {
    log_step "Installing dependencies..."
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        log_info "Installing npm dependencies..."
        npm ci
    else
        log_info "Dependencies already installed"
    fi
    
    log_success "Dependencies ready"
}

# Create production environment file
create_production_env() {
    log_step "Creating production environment file..."
    
    cat > .env.production << EOF
# NXOLand Frontend Production Environment
# For deployment on nxoland.com via Ploi

# API Configuration
VITE_API_BASE_URL=https://$API_DOMAIN/api

# Coming Soon Mode (disabled for production)
VITE_COMING_SOON_MODE=false

# Mock API (disabled for production)
VITE_MOCK_API=false

# Node Environment
NODE_ENV=production

# Build Configuration
VITE_BUILD_OPTIMIZE=true
VITE_BUILD_SOURCEMAP=false
EOF

    log_success "Production environment file created"
}

# Build the project
build_project() {
    log_step "Building React frontend..."
    
    # Remove old build
    if [ -d "$BUILD_DIR" ]; then
        rm -rf $BUILD_DIR
        log_info "Removed old build directory"
    fi
    
    # Build the project
    log_info "Running npm run build..."
    npm run build
    
    if [ ! -d "$BUILD_DIR" ]; then
        log_error "Build failed - dist directory not created"
        exit 1
    fi
    
    log_success "Frontend built successfully"
}

# Create Ploi configuration
create_ploi_config() {
    log_step "Creating Ploi configuration..."
    
    # Update ploi.yml if it exists
    if [ -f "ploi.yml" ]; then
        log_info "Updating existing ploi.yml"
    else
        log_info "Creating new ploi.yml"
    fi
    
    cat > ploi.yml << EOF
# Ploi Deployment Configuration for NXOLand Frontend
# React/Vite project for nxoland.com

# Build commands for React/Vite
build:
  - npm ci
  - npm run build

# Environment variables for production
env:
  - VITE_API_BASE_URL=https://$API_DOMAIN/api
  - VITE_COMING_SOON_MODE=false
  - VITE_MOCK_API=false
  - NODE_ENV=production

# Build output directory
public_path: dist

# Node.js version
node_version: 18

# Deployment settings
deployment:
  type: static
  build_command: "npm run build"
  output_directory: "dist"
  
# Domain configuration
domain: $FRONTEND_DOMAIN
ssl: true

# Performance optimizations
optimization:
  - gzip_compression: true
  - static_caching: true
  - cdn_enabled: true
EOF

    log_success "Ploi configuration created"
}

# Create deployment package
create_deployment_package() {
    log_step "Creating deployment package..."
    
    # Create zip file for manual upload (if needed)
    if [ -d "$BUILD_DIR" ]; then
        zip -r nxoland-frontend-ploi.zip . -x "node_modules/*" "dist/*" "*.git*" "*.md" "*.log"
        log_success "Deployment package created: nxoland-frontend-ploi.zip"
    fi
}

# Create deployment instructions
create_instructions() {
    log_step "Creating deployment instructions..."
    
    cat > PLOI_DEPLOYMENT_INSTRUCTIONS.md << EOF
# Ploi Frontend Deployment Instructions

## 📦 Package Created
- **File**: nxoland-frontend-ploi.zip (if manual upload needed)
- **Build Directory**: dist/
- **Created**: $(date)

## 🚀 Deployment Steps

### Option 1: Automatic Deployment via Ploi Dashboard

1. **Connect Repository**
   - Go to your Ploi dashboard
   - Create a new site
   - Connect your Git repository
   - Select "Static Site" as project type

2. **Configure Build Settings**
   - **Build Command**: \`npm run build\`
   - **Output Directory**: \`dist\`
   - **Node.js Version**: 18.x

3. **Set Environment Variables**
   - \`VITE_API_BASE_URL\`: https://$API_DOMAIN/api
   - \`VITE_COMING_SOON_MODE\`: false
   - \`VITE_MOCK_API\`: false
   - \`NODE_ENV\`: production

4. **Configure Domain**
   - **Domain**: $FRONTEND_DOMAIN
   - **SSL**: Enable automatic SSL
   - **CDN**: Enable if available

5. **Deploy**
   - Click "Deploy" in Ploi dashboard
   - Wait for build to complete
   - Test your site

### Option 2: Manual Upload (if needed)

1. **Upload Files**
   - Upload nxoland-frontend-ploi.zip to your server
   - Extract in your web root directory
   - Run \`npm ci\` and \`npm run build\`

2. **Configure Web Server**
   - Point document root to \`dist\` directory
   - Configure SPA routing (fallback to index.html)
   - Enable Gzip compression

## 🔧 Configuration Files

- **ploi.yml**: Ploi deployment configuration
- **.env.production**: Production environment variables
- **package.json**: Node.js dependencies and scripts
- **vite.config.ts**: Vite build configuration

## 🌐 Domain Configuration

- **Frontend Domain**: $FRONTEND_DOMAIN
- **API Domain**: $API_DOMAIN
- **SSL**: Automatic via Ploi
- **CDN**: Enable for better performance

## 📋 Post-Deployment Checklist

- [ ] Site accessible at https://$FRONTEND_DOMAIN
- [ ] API calls working (check browser network tab)
- [ ] SSL certificate installed
- [ ] CDN enabled (if available)
- [ ] Build artifacts in dist/ directory
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
- Verify calls go to https://$API_DOMAIN/api/
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

### Performance Issues
- Enable CDN in Ploi
- Check image optimization
- Verify Gzip compression
- Review bundle size

## 📊 Performance Optimization

### Ploi Optimizations
- Enable CDN for static assets
- Configure caching headers
- Enable Gzip compression
- Use HTTP/2 if available

### Frontend Optimizations
- Optimize images (WebP format)
- Minimize bundle size
- Use lazy loading for components
- Implement code splitting

## 💰 Cost Considerations

| Service | Monthly Cost | Notes |
|---------|-------------|-------|
| **Ploi Hosting** | $5-15 | Static site hosting |
| **Domain** | $1-2 | nxoland.com |
| **SSL Certificate** | $0 | Automatic via Ploi |
| **CDN** | $0-5 | Optional for better performance |
| **Total** | **$6-22** | Frontend hosting only |

## 🎉 Success!

Once deployed, your React frontend will be available at:
- **Main Site**: https://$FRONTEND_DOMAIN
- **API Integration**: Connected to https://$API_DOMAIN/api
- **Performance**: Optimized with CDN and caching
- **Security**: SSL enabled and secure

Your NXOLand marketplace frontend is ready for users! 🚀
EOF

    log_success "Deployment instructions created: PLOI_DEPLOYMENT_INSTRUCTIONS.md"
}

# Main deployment function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              NXOLand Ploi Frontend Deployment             ║"
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
    echo "║  📦 Build Directory: dist/                                  ║"
    echo "║  📋 Instructions: PLOI_DEPLOYMENT_INSTRUCTIONS.md         ║"
    echo "║  ⚙️  Configuration: ploi.yml                               ║"
    echo "║                                                              ║"
    echo "║  🚀 Next steps:                                             ║"
    echo "║  1. Connect repository to Ploi dashboard                  ║"
    echo "║  2. Set project type to 'Static Site'                     ║"
    echo "║  3. Configure build command: npm run build                  ║"
    echo "║  4. Set output directory: dist                             ║"
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
