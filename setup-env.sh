#!/bin/bash
set -e

echo "⚙️  NXOLand Environment Setup"
echo "=============================="
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

# Check if .env exists
if [ -f ".env" ]; then
    print_warning "⚠️  .env file already exists"
    echo "Current .env content:"
    cat .env
    echo ""
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Keeping existing .env file"
        exit 0
    fi
fi

echo ""
print_status "Setting up environment configuration..."

# Ask for deployment mode
echo ""
echo "🎯 Choose deployment mode:"
echo "1) Coming Soon Page (recommended for launch)"
echo "2) Full React App (requires backend)"
echo ""
read -p "Enter choice (1 or 2): " -n 1 -r
echo

if [[ $REPLY == "1" ]]; then
    COMING_SOON_MODE=true
    print_status "✅ Coming Soon mode selected"
elif [[ $REPLY == "2" ]]; then
    COMING_SOON_MODE=false
    print_status "✅ Full App mode selected"
else
    print_warning "Invalid choice, defaulting to Coming Soon mode"
    COMING_SOON_MODE=true
fi

# Ask for API configuration
echo ""
echo "🔗 API Configuration:"
read -p "Enter your Laravel API URL (e.g., https://api.nxoland.com): " API_URL
if [ -z "$API_URL" ]; then
    API_URL="http://localhost:8000/api"
    print_warning "Using default API URL: $API_URL"
fi

# Ask for Google Analytics
echo ""
read -p "Enter your Google Analytics ID (or press Enter to skip): " GA_ID
if [ -z "$GA_ID" ]; then
    GA_ID="G-23N0Q9P0S9"
    print_warning "Using default GA ID: $GA_ID"
fi

# Create .env file
print_status "Creating .env file..."

cat > .env << EOF
# NXOLand Environment Configuration
# Generated on $(date)

# ===========================================
# DEPLOYMENT MODE
# ===========================================
VITE_COMING_SOON_MODE=$COMING_SOON_MODE

# ===========================================
# API CONFIGURATION
# ===========================================
VITE_API_BASE_URL=$API_URL
VITE_MOCK_API=true

# ===========================================
# APPLICATION SETTINGS
# ===========================================
VITE_APP_NAME=NXOLand
VITE_APP_ENV=production

# ===========================================
# AUTHENTICATION
# ===========================================
VITE_AUTH_TOKEN_KEY=nxoland_auth_token
VITE_AUTH_REFRESH_TOKEN_KEY=nxoland_refresh_token

# ===========================================
# ANALYTICS
# ===========================================
VITE_GA_TRACKING_ID=$GA_ID
VITE_ENABLE_ANALYTICS=true

# ===========================================
# CLOUDFLARE TURNSTILE
# ===========================================
VITE_TURNSTILE_SITE_KEY=your-turnstile-site-key
VITE_ENABLE_TURNSTILE=true
VITE_TURNSTILE_THEME=dark
VITE_TURNSTILE_SIZE=normal

# ===========================================
# FEATURES
# ===========================================
VITE_ENABLE_REACT_QUERY_DEVTOOLS=false
VITE_ENABLE_DEBUG_LOGS=false
VITE_ENABLE_PREFETCH=true
EOF

print_success "✅ .env file created!"

echo ""
print_success "🎉 Environment setup complete!"
echo ""
echo "📄 Your .env file:"
echo "=================="
cat .env
echo ""

if [ "$COMING_SOON_MODE" = "true" ]; then
    print_status "🎯 Mode: COMING SOON PAGE"
    echo "   Your site will show the coming soon page"
    echo "   Perfect for launching and collecting signups"
else
    print_status "🎯 Mode: FULL REACT APP"
    echo "   Your site will show the complete marketplace"
    echo "   Requires Laravel backend to be running"
fi

echo ""
echo "🚀 Next steps:"
echo "1. Deploy with: sudo ./smart-deploy.sh"
echo "2. To change mode: Edit .env → VITE_COMING_SOON_MODE=true/false"
echo "3. Deploy again"
echo ""
echo "💡 Quick mode changes:"
echo "   Coming Soon: VITE_COMING_SOON_MODE=true"
echo "   Full App:    VITE_COMING_SOON_MODE=false"
