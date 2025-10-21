#!/bin/bash
set -e

echo "🔧 Quick Git Repository Fix"
echo "==========================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo "Current directory: $(pwd)"
echo "Contents:"
ls -la
echo ""

# Check if we're in the right place
if [ -f "package.json" ] || [ -f "public/index.html" ]; then
    print_status "✅ Project files found in current directory"
else
    print_warning "⚠️  Project files not found, checking common locations..."
    
    # Check common locations
    LOCATIONS=(
        "/var/www/nxoland.com"
        "/var/www/ploi/nxoland.com"
        "/home/ploi/nxoland.com"
    )
    
    for location in "${LOCATIONS[@]}"; do
        if [ -d "$location" ] && [ -f "$location/package.json" ]; then
            print_status "✅ Found project at: $location"
            cd "$location"
            break
        fi
    done
fi

print_status "Working in: $(pwd)"

# Initialize git if needed
if [ ! -d ".git" ]; then
    print_status "Initializing git repository..."
    git init
    git remote add origin https://github.com/Netrohub/Nexo.git
    git fetch origin
    git reset --hard origin/main
    print_success "✅ Git repository initialized"
else
    print_status "Git repository exists, pulling latest changes..."
    git pull origin main || echo "Git pull failed, continuing..."
fi

# Set permissions
print_status "Setting permissions..."
chown -R www-data:www-data . 2>/dev/null || true
chmod -R 755 . 2>/dev/null || true

print_success "✅ Git repository fixed!"
echo ""
echo "📊 Status:"
echo "   Directory: $(pwd)"
echo "   Git status: $(git status --porcelain 2>/dev/null | wc -l) changes"
echo "   Remote: $(git remote get-url origin 2>/dev/null || echo 'Not set')"
echo ""
echo "🚀 Ready to deploy!"
