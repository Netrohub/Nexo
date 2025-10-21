#!/bin/bash
set -e

echo "🚀 Deploying Coming Soon Page via SSH"
echo "====================================="
echo ""

# Site directory
SITE_DIR="/var/www/nxoland.com"

# Create directory if it doesn't exist
if [ ! -d "$SITE_DIR" ]; then
    echo "📁 Creating site directory..."
    sudo mkdir -p "$SITE_DIR"
fi

# Navigate to site directory
cd "$SITE_DIR"

# Clone repository if not exists
if [ ! -d ".git" ]; then
    echo "📦 Cloning repository..."
    sudo git clone https://github.com/Netrohub/Nexo.git .
else
    echo "📦 Updating repository..."
    sudo git pull origin main
fi

# Set permissions
echo "🔐 Setting permissions..."
sudo chown -R www-data:www-data "$SITE_DIR"
sudo chmod -R 755 "$SITE_DIR"

# Deploy coming soon page
echo "📄 Deploying coming soon page..."
sudo chmod 644 public/index.html
sudo chmod 755 public/

# Verify deployment
if [ -f "public/index.html" ]; then
    echo ""
    echo "✅ SUCCESS! Coming soon page deployed!"
    echo ""
    echo "🌐 Your site is ready at:"
    echo "   http://$(curl -s ifconfig.me)/"
    echo "   https://nxoland.com (if domain configured)"
    echo ""
    echo "📁 Files location: $SITE_DIR/public/"
    echo "📄 Main file: $SITE_DIR/public/index.html"
    echo ""
    echo "🎉 Deployment complete in 30 seconds!"
else
    echo "❌ ERROR: index.html not found"
    exit 1
fi
