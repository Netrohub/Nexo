#!/bin/bash

# Create Backend Zip for Manual Ploi Upload
set -e

echo "🚀 Creating NXOLand Backend Zip for Manual Ploi Upload..."

# Create temporary directory
TEMP_DIR="nxoland-backend-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$TEMP_DIR"

echo "📁 Copying backend files..."

# Copy all backend files
cp -r backend/* "$TEMP_DIR/"

# Copy deployment script
cp deploy-backend.sh "$TEMP_DIR/"

# Create zip package
ZIP_FILE="nxoland-backend-$(date +%Y%m%d-%H%M%S).zip"
zip -r "$ZIP_FILE" "$TEMP_DIR/"

echo "✅ Created backend package: $ZIP_FILE"
echo "📦 Package includes:"
echo "   - All backend PHP files"
echo "   - Composer dependencies"
echo "   - Database schema"
echo "   - Production .env configuration"
echo "   - Deployment script"

# Cleanup
rm -rf "$TEMP_DIR"

echo "🎉 Backend zip package ready for manual upload!"
echo "📁 File: $ZIP_FILE"
echo "📤 Upload this file to your Ploi server"
