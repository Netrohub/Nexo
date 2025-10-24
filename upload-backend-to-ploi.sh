#!/bin/bash

# ============================================
# Upload Backend Files to Ploi Server
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
BACKEND_DIR="backend"
PLOI_SERVER="46.202.194.218"
PLOI_PATH="/home/ploi/api.nxoland.com"

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

# Check if backend directory exists
check_backend() {
    log_step "Checking backend directory..."
    
    if [ ! -d "$BACKEND_DIR" ]; then
        log_error "Backend directory not found. Please run this script from the project root."
        exit 1
    fi
    
    if [ ! -f "$BACKEND_DIR/composer.json" ]; then
        log_error "composer.json not found in backend directory."
        exit 1
    fi
    
    if [ ! -f "$BACKEND_DIR/public/index.php" ]; then
        log_error "public/index.php not found in backend directory."
        exit 1
    fi
    
    log_success "Backend directory verified"
}

# Create deployment package
create_package() {
    log_step "Creating deployment package..."
    
    # Create temporary directory
    TEMP_DIR="backend-deploy-temp"
    rm -rf "$TEMP_DIR"
    mkdir "$TEMP_DIR"
    
    # Copy backend files
    cp -r "$BACKEND_DIR"/* "$TEMP_DIR/"
    
    # Create deployment script
    cat > "$TEMP_DIR/deploy.sh" << 'EOF'
#!/bin/bash

# NXOLand Backend Deployment Script
cd /home/ploi/api.nxoland.com

# Install/update Composer dependencies
composer install --no-dev --optimize-autoloader

# Set proper permissions
chmod -R 755 public/
chmod 644 public/.htaccess
chmod 644 public/index.php

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    cat > .env << 'ENVEOF'
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
ENVEOF
fi

# Reload PHP-FPM
echo "" | sudo -S service php8.4-fpm reload

echo "Backend API deployed successfully!"
EOF
    
    chmod +x "$TEMP_DIR/deploy.sh"
    
    # Create zip file
    cd "$TEMP_DIR"
    zip -r ../backend-deploy.zip . -x "*.git*" "*.log" "node_modules/*"
    cd ..
    
    log_success "Deployment package created: backend-deploy.zip"
}

# Create upload instructions
create_instructions() {
    log_step "Creating upload instructions..."
    
    cat > BACKEND_UPLOAD_INSTRUCTIONS.md << EOF
# 🚀 Upload Backend to Ploi Server

## 📦 Package Created
- **File**: backend-deploy.zip
- **Size**: $(du -h backend-deploy.zip | cut -f1)
- **Created**: $(date)

## 🎯 Upload Methods

### Method 1: Ploi File Manager (Recommended)

1. **Access Ploi Dashboard**
   - Go to your Ploi dashboard
   - Navigate to your \`api.nxoland.com\` site
   - Go to "Files" or "File Manager"

2. **Upload Files**
   - Upload \`backend-deploy.zip\` to \`/home/ploi/api.nxoland.com/\`
   - Extract the zip file in the directory
   - Delete the zip file after extraction

3. **Set Permissions**
   - Make sure \`public/\` directory has 755 permissions
   - Make sure \`public/index.php\` has 644 permissions
   - Make sure \`public/.htaccess\` has 644 permissions

### Method 2: SSH Upload

1. **Connect via SSH**
   \`\`\`bash
   ssh ploi@$PLOI_SERVER
   \`\`\`

2. **Upload Files**
   \`\`\`bash
   # From your local machine
   scp backend-deploy.zip ploi@$PLOI_SERVER:/home/ploi/api.nxoland.com/
   \`\`\`

3. **Extract and Setup**
   \`\`\`bash
   # On the server
   cd /home/ploi/api.nxoland.com
   unzip backend-deploy.zip
   rm backend-deploy.zip
   chmod -R 755 public/
   chmod 644 public/.htaccess
   chmod 644 public/index.php
   \`\`\`

### Method 3: Git Repository

1. **Push to Git**
   - Push your backend code to a Git repository
   - Connect the repository to Ploi
   - Set the root directory to \`backend/\`

2. **Configure Ploi**
   - Set build command: \`composer install --no-dev --optimize-autoloader\`
   - Set output directory: \`public/\`

## 🔧 Post-Upload Steps

### 1. **Update Ploi Deploy Script**
Replace your current deploy script with:
\`\`\`bash
#!/bin/bash
cd /home/ploi/api.nxoland.com
composer install --no-dev --optimize-autoloader
chmod -R 755 public/
chmod 644 public/.htaccess
chmod 644 public/index.php
echo "" | sudo -S service php8.4-fpm reload
echo "Backend API deployed successfully!"
\`\`\`

### 2. **Set Environment Variables**
In Ploi dashboard, add:
- \`APP_NAME=NXOLand API\`
- \`APP_ENV=production\`
- \`APP_DEBUG=false\`
- \`APP_URL=https://api.nxoland.com\`
- \`DB_CONNECTION=mysql\`
- \`DB_HOST=your_database_host\`
- \`DB_DATABASE=nxoland\`
- \`DB_USERNAME=your_username\`
- \`DB_PASSWORD=your_password\`
- \`JWT_SECRET=your_secret_key\`

### 3. **Configure Health Check**
Set health check URL to: \`https://api.nxoland.com/api/ping\`

### 4. **Deploy**
Click "Deploy now" in Ploi dashboard

## 🧪 Testing

### Test API Endpoint:
\`\`\`bash
curl https://api.nxoland.com/api/ping
\`\`\`
**Expected response:** \`{"ok": true}\`

### Test Other Endpoints:
\`\`\`bash
curl https://api.nxoland.com/api/products
curl https://api.nxoland.com/api/members
\`\`\`

## 🎉 Success!

Once uploaded and deployed:
- ✅ Backend files in correct location
- ✅ Composer dependencies installed
- ✅ API endpoints responding
- ✅ CORS headers working
- ✅ Ready for frontend connection

Your backend will be available at \`https://api.nxoland.com\`! 🚀
EOF

    log_success "Upload instructions created: BACKEND_UPLOAD_INSTRUCTIONS.md"
}

# Main function
main() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              Upload Backend to Ploi Server                 ║"
    echo "║                    For api.nxoland.com                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    check_backend
    create_package
    create_instructions
    
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║              BACKEND PACKAGE READY!                       ║"
    echo "║                                                              ║"
    echo "║  📦 Package: backend-deploy.zip                            ║"
    echo "║  📋 Instructions: BACKEND_UPLOAD_INSTRUCTIONS.md          ║"
    echo "║                                                              ║"
    echo "║  🚀 Next steps:                                             ║"
    echo "║  1. Upload backend-deploy.zip to Ploi server              ║"
    echo "║  2. Extract files in /home/ploi/api.nxoland.com/           ║"
    echo "║  3. Update Ploi deploy script                              ║"
    echo "║  4. Set environment variables                               ║"
    echo "║  5. Deploy and test!                                       ║"
    echo "║                                                              ║"
    echo "║  🌐 Your backend will be ready at api.nxoland.com!        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Run main function
main "$@"
