#!/bin/bash
set -e

echo "🔧 Fixing NXOLand Deployment"
echo "============================="
echo ""

# Navigate to site directory
cd /var/www/nxoland.com

echo "📁 Current directory: $(pwd)"
echo "📄 Current files:"
ls -la
echo ""

# Remove existing files except the script
echo "🧹 Cleaning directory..."
sudo rm -rf * .* 2>/dev/null || true
sudo rm -rf .git 2>/dev/null || true

echo "📦 Cloning fresh repository..."
sudo git clone https://github.com/Netrohub/Nexo.git .

echo "🔐 Setting permissions..."
sudo chown -R www-data:www-data /var/www/nxoland.com
sudo chmod -R 755 /var/www/nxoland.com

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
    echo "📁 Files location: /var/www/nxoland.com/public/"
    echo "📄 Main file: /var/www/nxoland.com/public/index.html"
    echo ""
    echo "🎉 Deployment complete!"
else
    echo "❌ ERROR: index.html not found"
    exit 1
fi
