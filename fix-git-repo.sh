#!/bin/bash
set -e

echo "🔧 Fixing Git Repository Issue"
echo "==============================="
echo ""

# Colors
RED='\033[0;31m'
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

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check current directory
print_status "Current directory: $(pwd)"
print_status "Contents:"
ls -la

echo ""

# Check if we're in the right location
if [[ "$(pwd)" == *"ploi"* ]]; then
    print_warning "You're in a Ploi directory structure"
    SITE_DIR="/var/www/ploi/nxoland.com"
else
    SITE_DIR="/var/www/nxoland.com"
fi

print_status "Expected site directory: $SITE_DIR"

# Navigate to correct directory
if [ -d "$SITE_DIR" ]; then
    print_status "Navigating to $SITE_DIR"
    cd "$SITE_DIR"
else
    print_warning "Site directory not found, staying in current directory"
fi

print_status "Current directory: $(pwd)"

# Check if git repository exists
if [ -d ".git" ]; then
    print_success "✅ Git repository exists"
    print_status "Repository status:"
    git status 2>/dev/null || echo "Git status failed"
else
    print_warning "⚠️  No git repository found"
    print_status "Initializing git repository..."
    
    # Initialize git repository
    git init
    
    # Add remote origin
    git remote add origin https://github.com/Netrohub/Nexo.git
    
    # Fetch from remote
    print_status "Fetching from remote..."
    git fetch origin
    
    # Reset to main branch
    print_status "Setting up main branch..."
    git reset --hard origin/main
    
    print_success "✅ Git repository initialized and synced"
fi

echo ""

# Verify git is working
print_status "Verifying git repository..."
if git status >/dev/null 2>&1; then
    print_success "✅ Git repository is working"
    print_status "Current branch: $(git branch --show-current)"
    print_status "Remote origin: $(git remote get-url origin)"
else
    print_error "❌ Git repository still not working"
    exit 1
fi

echo ""

# Check if files are present
print_status "Checking project files..."
if [ -f "package.json" ]; then
    print_success "✅ Project files found"
    print_status "Package.json: $(head -5 package.json)"
else
    print_warning "⚠️  Project files not found"
    print_status "Available files:"
    ls -la
fi

echo ""

# Check if coming soon page exists
if [ -f "public/index.html" ]; then
    print_success "✅ Coming soon page found"
    print_status "File size: $(du -h public/index.html | cut -f1)"
else
    print_warning "⚠️  Coming soon page not found"
    print_status "Public directory contents:"
    ls -la public/ 2>/dev/null || echo "Public directory not found"
fi

echo ""

print_success "🎉 Git repository fixed!"
echo ""
echo "📊 Repository status:"
echo "   Directory: $(pwd)"
echo "   Branch: $(git branch --show-current)"
echo "   Remote: $(git remote get-url origin)"
echo ""
echo "🚀 You can now run deployment scripts:"
echo "   sudo ./smart-deploy.sh"
echo "   sudo ./setup-env.sh"
echo ""
echo "🔧 To pull latest changes:"
echo "   git pull origin main"
