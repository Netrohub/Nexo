#!/bin/bash
set -e

echo "🚀 NXOLand SSH Deployment"
echo "========================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_warning "Running as root. Consider using a regular user with sudo."
fi

# Get server details
print_status "Getting server information..."
echo "Server: $(hostname)"
echo "User: $(whoami)"
echo "Date: $(date)"
echo ""

# Create site directory
SITE_DIR="/var/www/nxoland.com"
print_status "Creating site directory: $SITE_DIR"

if [ ! -d "$SITE_DIR" ]; then
    sudo mkdir -p "$SITE_DIR"
    print_success "Directory created"
else
    print_warning "Directory already exists"
fi

# Set permissions
print_status "Setting permissions..."
sudo chown -R www-data:www-data "$SITE_DIR"
sudo chmod -R 755 "$SITE_DIR"
print_success "Permissions set"

# Navigate to site directory
cd "$SITE_DIR"

# Check if git repository exists
if [ ! -d ".git" ]; then
    print_status "Cloning repository..."
    sudo git clone https://github.com/Netrohub/Nexo.git .
    print_success "Repository cloned"
else
    print_status "Pulling latest changes..."
    sudo git pull origin main
    print_success "Repository updated"
fi

# Check Node.js
print_status "Checking Node.js..."
if ! command -v node &> /dev/null; then
    print_warning "Node.js not found. Installing..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs
    print_success "Node.js installed"
else
    NODE_VERSION=$(node --version)
    print_success "Node.js found: $NODE_VERSION"
fi

# Install dependencies
print_status "Installing dependencies..."
sudo npm ci --production=false
print_success "Dependencies installed"

# Deploy coming soon page
print_status "Deploying coming soon page..."
sudo cp public/index.html public/index.html.bak 2>/dev/null || true
sudo chmod 644 public/index.html
sudo chmod 755 public/
print_success "Coming soon page deployed"

# Test deployment
print_status "Testing deployment..."
if [ -f "public/index.html" ]; then
    print_success "✅ Coming soon page is ready!"
    echo ""
    echo "🌐 Your site should be accessible at:"
    echo "   http://$(curl -s ifconfig.me)/"
    echo "   https://nxoland.com (if domain is configured)"
    echo ""
    echo "📁 Files deployed to: $SITE_DIR/public/"
    echo "📄 Main file: $SITE_DIR/public/index.html"
else
    print_error "❌ Deployment failed - index.html not found"
    exit 1
fi

echo ""
print_success "🎉 Deployment complete!"
echo ""
echo "Next steps:"
echo "1. Configure your web server (Nginx/Apache)"
echo "2. Point your domain to this server"
echo "3. Enable SSL certificate"
echo "4. Test your site!"
echo ""
echo "For full React app deployment, run:"
echo "   sudo npm run build && sudo cp -r dist/* public/"
echo ""
