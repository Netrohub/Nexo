#!/bin/bash
set -e

echo "🚀 NXOLand Deployment Script"
echo "=============================="
echo ""

# Navigate to site directory
cd $PLOI_SITE_DIRECTORY || cd /home/ploi/nxoland.com

echo "📁 Current directory: $(pwd)"
echo ""

# Pull latest changes from GitHub
echo "📦 Pulling latest changes from GitHub..."
git pull origin main

echo ""
echo "📦 Installing dependencies..."
npm ci --production=false

echo ""
echo "🔨 Building production assets..."
npm run build

echo ""
echo "📁 Deploying built files..."
# Clear public directory except .htaccess
find public -type f ! -name '.htaccess' -delete 2>/dev/null || true

# Copy built files to public
cp -r dist/* public/

# Ensure correct permissions
chmod -R 755 public/

echo ""
echo "✅ Deployment complete!"
echo "🌐 Site: https://nxoland.com"
echo ""
