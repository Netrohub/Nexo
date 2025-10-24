#!/bin/bash

# Complete Backend Upload Script for Ploi
set -e

echo "🚀 Creating complete backend package for Ploi deployment..."

# Create temporary directory
TEMP_DIR="nxoland-backend-complete-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$TEMP_DIR"

echo "📁 Copying backend files..."

# Copy all backend files
cp -r backend/* "$TEMP_DIR/"

# Copy deployment script
cp backend-deploy-complete.sh "$TEMP_DIR/"

# Create zip package
ZIP_FILE="nxoland-backend-complete.zip"
zip -r "$ZIP_FILE" "$TEMP_DIR/"

echo "✅ Created complete backend package: $ZIP_FILE"
echo "📦 Package includes:"
echo "   - All backend PHP files"
echo "   - Composer dependencies"
echo "   - Database schema"
echo "   - Production .env configuration"
echo "   - Complete deployment script"

echo ""
echo "🚀 DEPLOYMENT INSTRUCTIONS:"
echo "1. Upload $ZIP_FILE to your Ploi server"
echo "2. Extract the files to /home/ploi/api.nxoland.com/"
echo "3. Run: chmod +x backend-deploy-complete.sh"
echo "4. Run: ./backend-deploy-complete.sh"
echo ""
echo "🔧 MANUAL STEPS REQUIRED:"
echo "1. Update database credentials in .env file"
echo "2. Create MySQL database 'nxoland'"
echo "3. Import database schema"
echo "4. Test API endpoints"
echo ""
echo "🧪 TEST COMMANDS:"
echo "curl https://api.nxoland.com/api/ping"
echo "curl https://api.nxoland.com/api/products"
echo "curl -X POST https://api.nxoland.com/api/auth/login -H 'Content-Type: application/json' -d '{\"email\":\"user@nxoland.com\",\"password\":\"password123\"}'"

# Cleanup
rm -rf "$TEMP_DIR"

echo "🎉 Complete backend package ready for deployment!"
