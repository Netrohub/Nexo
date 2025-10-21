#!/bin/bash
set -e

echo "🚀 Smart NXOLand Deployment"
echo "============================="
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

# Navigate to site directory
cd $PLOI_SITE_DIRECTORY || cd /home/ploi/nxoland.com

print_status "Current directory: $(pwd)"

# Pull latest changes
print_status "Pulling latest changes..."
git pull origin main

# Check if .env file exists
if [ -f ".env" ]; then
    print_success "✅ Found .env file"
    
    # Check COMING_SOON_MODE
    if grep -q "VITE_COMING_SOON_MODE=true" .env; then
        COMING_SOON_MODE=true
        print_status "🎯 COMING SOON MODE detected"
    elif grep -q "VITE_COMING_SOON_MODE=false" .env; then
        COMING_SOON_MODE=false
        print_status "🎯 FULL APP MODE detected"
    else
        print_warning "⚠️  VITE_COMING_SOON_MODE not found in .env, defaulting to coming soon mode"
        COMING_SOON_MODE=true
    fi
else
    print_warning "⚠️  No .env file found, defaulting to coming soon mode"
    COMING_SOON_MODE=true
fi

echo ""

if [ "$COMING_SOON_MODE" = "true" ]; then
    print_status "🚀 Deploying COMING SOON PAGE..."
    
    # Ensure public directory exists
    mkdir -p public
    
    # Deploy coming soon page
    if [ -f "public/index.html" ]; then
        print_success "✅ Coming soon page found"
        chmod 644 public/index.html
        chmod 755 public/
        print_success "✅ Coming soon page deployed!"
    else
        print_error "❌ Coming soon page not found at public/index.html"
        exit 1
    fi
    
    echo ""
    print_success "🎉 COMING SOON PAGE IS LIVE!"
    echo "   🌐 Visit: https://nxoland.com"
    echo "   📄 Page: public/index.html"
    echo ""
    echo "💡 To switch to full app:"
    echo "   1. Edit .env file"
    echo "   2. Set VITE_COMING_SOON_MODE=false"
    echo "   3. Deploy again"
    
else
    print_status "🚀 Deploying FULL REACT APP..."
    
    # Install dependencies
    print_status "📦 Installing dependencies..."
    npm ci --production=false
    
    # Build React app
    print_status "🔨 Building React app..."
    npm run build
    
    # Deploy built files
    print_status "📁 Deploying built files..."
    rm -rf public/*
    cp -r dist/* public/
    
    # Set permissions
    chmod -R 755 public/
    
    print_success "✅ Full React app deployed!"
    
    echo ""
    print_success "🎉 FULL MARKETPLACE IS LIVE!"
    echo "   🌐 Visit: https://nxoland.com"
    echo "   📁 Files: public/ (built from dist/)"
    echo ""
    echo "💡 To switch to coming soon:"
    echo "   1. Edit .env file"
    echo "   2. Set VITE_COMING_SOON_MODE=true"
    echo "   3. Deploy again"
fi

echo ""
print_success "✅ Deployment complete!"
echo ""
echo "📊 Current mode: $([ "$COMING_SOON_MODE" = "true" ] && echo "Coming Soon" || echo "Full App")"
echo "🌐 Site: https://nxoland.com"
echo ""
echo "🔧 To change mode:"
echo "   Edit .env → VITE_COMING_SOON_MODE=true/false → Deploy"
