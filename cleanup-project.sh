#!/bin/bash

# ============================================
# NXOLand Project Cleanup Script
# Removes unnecessary files for deployment
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
    echo -e "${PURPLE}🧹 $1${NC}"
}

# Create backup directory
create_backup() {
    log_step "Creating backup directory..."
    mkdir -p backup-$(date +%Y%m%d-%H%M%S)
    BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"
    log_success "Backup directory created: $BACKUP_DIR"
}

# Remove deployment scripts (keep only the ones we need)
cleanup_deployment_scripts() {
    log_step "Cleaning up deployment scripts..."
    
    # Keep only the scripts we created for separate deployment
    KEEP_SCRIPTS=("ploi-deploy.sh" "hostinger-deploy.sh")
    
    # Remove old deployment scripts
    for script in deploy-*.sh deploy-*.bat deploy-*.yml; do
        if [[ ! " ${KEEP_SCRIPTS[@]} " =~ " ${script} " ]]; then
            if [ -f "$script" ]; then
                log_info "Removing: $script"
                rm -f "$script"
            fi
        fi
    done
    
    log_success "Deployment scripts cleaned"
}

# Remove documentation files (keep only essential ones)
cleanup_documentation() {
    log_step "Cleaning up documentation..."
    
    # Keep only essential documentation
    KEEP_DOCS=("SEPARATE_DEPLOYMENT_GUIDE.md" "DNS_CONFIGURATION_GUIDE.md" "PLOI_DEPLOYMENT.md")
    
    # Remove old documentation
    for doc in *.md; do
        if [[ ! " ${KEEP_DOCS[@]} " =~ " ${doc} " ]]; then
            if [ -f "$doc" ]; then
                log_info "Removing: $doc"
                rm -f "$doc"
            fi
        fi
    done
    
    log_success "Documentation cleaned"
}

# Remove unnecessary files
cleanup_unnecessary_files() {
    log_step "Removing unnecessary files..."
    
    # Remove files that shouldn't be deployed
    UNNECESSARY_FILES=(
        "bun.lockb"
        "diagnose-deployment.sh"
        "setup-server.sh"
        "ploi-env-config.txt"
        "TROUBLESHOOTING_DEPLOYMENT.md"
        "QUICK_START_DEPLOYMENT.md"
        "SERVER_SETUP_COMMANDS.md"
        "FULL_STACK_DEPLOYMENT_GUIDE.md"
        "TROUBLESHOOTING_DEPLOYMENT.md"
        "DATABASE_SETUP_GUIDE.md"
        "DEPLOYMENT_GUIDE.md"
        "hostinger-backend-config.md"
    )
    
    for file in "${UNNECESSARY_FILES[@]}"; do
        if [ -f "$file" ]; then
            log_info "Removing: $file"
            rm -f "$file"
        fi
    done
    
    log_success "Unnecessary files removed"
}

# Clean node_modules (will be reinstalled during deployment)
cleanup_node_modules() {
    log_step "Cleaning node_modules..."
    
    if [ -d "node_modules" ]; then
        log_info "Removing node_modules (will be reinstalled during deployment)"
        rm -rf node_modules
    fi
    
    log_success "node_modules cleaned"
}

# Create deployment-ready structure
create_deployment_structure() {
    log_step "Creating deployment-ready structure..."
    
    # Create frontend package directory
    mkdir -p deployment-packages/frontend
    mkdir -p deployment-packages/backend
    
    log_success "Deployment structure created"
}

# Create frontend package
create_frontend_package() {
    log_step "Creating frontend package..."
    
    # Copy frontend files
    cp -r src deployment-packages/frontend/
    cp -r public deployment-packages/frontend/
    cp package.json deployment-packages/frontend/
    cp package-lock.json deployment-packages/frontend/
    cp vite.config.ts deployment-packages/frontend/
    cp tailwind.config.ts deployment-packages/frontend/
    cp tsconfig.json deployment-packages/frontend/
    cp tsconfig.app.json deployment-packages/frontend/
    cp tsconfig.node.json deployment-packages/frontend/
    cp postcss.config.js deployment-packages/frontend/
    cp eslint.config.js deployment-packages/frontend/
    cp components.json deployment-packages/frontend/
    cp index.html deployment-packages/frontend/
    cp ploi.yml deployment-packages/frontend/
    cp env.production deployment-packages/frontend/
    
    log_success "Frontend package created in deployment-packages/frontend/"
}

# Create backend package
create_backend_package() {
    log_step "Creating backend package..."
    
    # Copy backend files
    cp -r api-files/public_html deployment-packages/backend/
    cp -r laravel-backend deployment-packages/backend/
    
    log_success "Backend package created in deployment-packages/backend/"
}

# Create final deployment instructions
create_deployment_instructions() {
    log_step "Creating final deployment instructions..."
    
    cat > DEPLOYMENT_READY.md << 'EOF'
# 🚀 NXOLand Deployment Ready!

Your project has been cleaned and organized for deployment.

## 📦 Deployment Packages Created

### Frontend Package (for Ploi):
- **Location**: `deployment-packages/frontend/`
- **Destination**: Ploi (nxoland.com)
- **Files**: React app, config files, build scripts

### Backend Package (for Hostinger):
- **Location**: `deployment-packages/backend/`
- **Destination**: Hostinger (api.nxoland.com)
- **Files**: PHP API, database structure

## 🚀 Next Steps

### 1. Deploy Frontend to Ploi:
1. Zip the `deployment-packages/frontend/` folder
2. Upload to Ploi dashboard
3. Configure build settings:
   - Build command: `npm run build`
   - Output directory: `dist`
   - Environment variables from `env.production`

### 2. Deploy Backend to Hostinger:
1. Zip the `deployment-packages/backend/` folder
2. Upload to Hostinger file manager
3. Extract in `public_html/` directory
4. Configure database and environment variables

### 3. Configure DNS:
- `nxoland.com` → Ploi server IP
- `api.nxoland.com` → Hostinger server IP

## 📋 Files Removed

The following files were removed to clean up your project:
- Old deployment scripts
- Unnecessary documentation
- node_modules (will be reinstalled)
- Temporary files

## 🎉 Your Project is Ready!

Your NXOLand marketplace is now organized and ready for deployment!
EOF

    log_success "Deployment instructions created: DEPLOYMENT_READY.md"
}

# Main cleanup function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                NXOLand Project Cleanup                    ║"
    echo "║              Preparing for deployment                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Run cleanup steps
    create_backup
    cleanup_deployment_scripts
    cleanup_documentation
    cleanup_unnecessary_files
    cleanup_node_modules
    create_deployment_structure
    create_frontend_package
    create_backend_package
    create_deployment_instructions
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              PROJECT CLEANUP COMPLETED!                    ║"
    echo "║                                                              ║"
    echo "║  📦 Frontend Package: deployment-packages/frontend/         ║"
    echo "║  🔧 Backend Package: deployment-packages/backend/          ║"
    echo "║  📋 Instructions: DEPLOYMENT_READY.md                      ║"
    echo "║                                                              ║"
    echo "║  🚀 Your project is ready for deployment!                   ║"
    echo "║                                                              ║"
    echo "║  Next steps:                                                ║"
    echo "║  1. Deploy frontend package to Ploi                         ║"
    echo "║  2. Deploy backend package to Hostinger                    ║"
    echo "║  3. Configure DNS records                                   ║"
    echo "║  4. Test your marketplace!                                 ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function
main "$@"
