#!/bin/bash

# NXOLand Deployment with Ploi Webhook
set -e

echo "🚀 Starting NXOLand Deployment with Ploi Webhook..."

# Ploi webhook URL
PLOI_WEBHOOK="https://ploi.io/webhooks/servers/101779/sites/322429/deploy?token=x4BUbb4kfwwEtvuj05rdLhtyFFoHpQ7My2Z0mmZAaowowY6KPy"

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found!"
    echo "💡 Make sure you're in the project root directory"
    exit 1
fi

echo "✅ Found project root directory"

# Build Frontend
echo ""
echo "🔧 BUILDING FRONTEND..."
echo "================================"

if [ -d "frontend" ]; then
    echo "✅ Found frontend directory"
    
    # Navigate to frontend directory
    cd frontend
    
    # Check if we're in the right frontend directory
    if [ ! -f "package.json" ]; then
        echo "❌ Error: frontend/package.json not found!"
        exit 1
    fi
    
    echo "✅ Found frontend package.json"
    
    # Install dependencies
    echo "📦 Installing dependencies..."
    npm ci
    
    # Build for production
    echo "🏗️ Building for production..."
    npm run build
    
    # Verify build
    if [ -d "dist" ]; then
        echo "✅ Frontend build completed successfully!"
        echo "📁 Build output: frontend/dist/"
        echo "📊 Build size:"
        du -sh dist/
    else
        echo "❌ Frontend build failed!"
        exit 1
    fi
    
    # Go back to root
    cd ..
else
    echo "❌ Frontend directory not found!"
    echo "💡 Make sure frontend/ directory exists"
    exit 1
fi

# Commit and push changes
echo ""
echo "🔧 COMMITTING AND PUSHING CHANGES..."
echo "================================"

# Add all changes
echo "📝 Adding changes to git..."
git add .

# Commit changes
echo "💾 Committing changes..."
git commit -m "🚀 Deploy: $(date '+%Y-%m-%d %H:%M:%S')" || echo "⚠️ No changes to commit"

# Push to repository
echo "📤 Pushing to repository..."
git push origin main

# Trigger Ploi deployment
echo ""
echo "🚀 TRIGGERING PLOI DEPLOYMENT..."
echo "================================"

echo "🌐 Triggering Ploi webhook..."
curl -X POST "$PLOI_WEBHOOK" \
  -H "Content-Type: application/json" \
  -d '{"message": "NXOLand deployment triggered", "timestamp": "'$(date -Iseconds)'"}'

echo ""
echo "✅ Ploi webhook triggered successfully!"
echo "🌐 Your site will be automatically deployed"
echo "⏱️  Deployment usually takes 1-2 minutes"
echo ""
echo "🧪 Test your deployment:"
echo "   curl https://nxoland.com"
echo "   curl https://api.nxoland.com/api/ping"
echo ""
echo "🎉 Deployment process completed!"
