#!/bin/bash
set -e

echo "🚀 Deploying Coming Soon Page"
echo "=============================="
echo ""

# Navigate to site directory
cd $PLOI_SITE_DIRECTORY || cd /home/ploi/nxoland.com

echo "📁 Current directory: $(pwd)"
echo ""

# Pull latest from GitHub
echo "📦 Fetching latest code..."
git pull origin main || echo "Skipping git pull..."

echo ""
echo "📄 Deploying coming soon page..."

# Make sure public directory exists
mkdir -p public

# Copy the coming soon page as the main index
cp public/index.html public/index.html.bak 2>/dev/null || true

# Set permissions
chmod 644 public/*.html
chmod 755 public

echo ""
echo "✅ Coming Soon page deployed!"
echo "🌐 Visit: https://nxoland.com"
echo ""
echo "📝 To deploy full app later, use ploi-deploy.sh"
echo ""
