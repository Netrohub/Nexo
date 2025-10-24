#!/bin/bash

# NXOLand Complete Deployment Script (Backend + Frontend)
set -e

echo "🚀 Starting NXOLand Complete Deployment (Backend + Frontend)..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: package.json not found!"
    echo "💡 Make sure you're in the project root directory"
    exit 1
fi

echo "✅ Found project root directory"

# Deploy Backend
echo ""
echo "🔧 DEPLOYING BACKEND..."
echo "================================"

if [ -d "backend" ]; then
    echo "✅ Found backend directory"
    
    # Check if we're on the server (for backend deployment)
    if [ -d "/home/ploi/api.nxoland.com" ]; then
        echo "🌐 Deploying backend to Ploi server..."
        
        # Copy backend files to server directory
        echo "📁 Copying backend files..."
        cp -r backend/* /home/ploi/api.nxoland.com/
        
        # Run backend deployment
        echo "🚀 Running backend deployment..."
        cd /home/ploi/api.nxoland.com
        chmod +x deploy-backend.sh
        ./deploy-backend.sh
        
        echo "✅ Backend deployed successfully!"
    else
        echo "⚠️  Not on Ploi server - backend deployment skipped"
        echo "💡 Upload backend files to your server and run deploy-backend.sh there"
    fi
else
    echo "❌ Backend directory not found!"
    echo "💡 Make sure backend/ directory exists"
fi

# Deploy Frontend
echo ""
echo "🔧 DEPLOYING FRONTEND..."
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
        echo ""
        echo "🚀 FRONTEND DEPLOYMENT READY:"
        echo "1. Upload contents of 'frontend/dist/' to your web server"
        echo "2. Ensure .env file is configured with correct API URL"
        echo "3. Test the application"
    else
        echo "❌ Frontend build failed!"
        exit 1
    fi
else
    echo "❌ Frontend directory not found!"
    echo "💡 Make sure frontend/ directory exists"
fi

# Summary
echo ""
echo "🎉 DEPLOYMENT SUMMARY"
echo "====================="
echo "✅ Backend: Ready for deployment to Ploi server"
echo "✅ Frontend: Built and ready for web server upload"
echo ""
echo "🧪 TEST COMMANDS:"
echo "   Backend:"
echo "     curl https://api.nxoland.com/api/ping"
echo "     curl https://api.nxoland.com/api/products"
echo "   Frontend:"
echo "     npm run preview  # Test locally"
echo "     curl https://nxoland.com  # Test production"
echo ""
echo "📁 FILES TO UPLOAD:"
echo "   Backend: All backend/ files to /home/ploi/api.nxoland.com/"
echo "   Frontend: All frontend/dist/ files to your web server"
echo ""
echo "🔧 ENVIRONMENT VARIABLES:"
echo "   Backend: Update .env file with database credentials"
echo "   Frontend: VITE_API_BASE_URL=https://api.nxoland.com"
echo ""
echo "🎯 NEXT STEPS:"
echo "1. Upload backend files to Ploi server"
echo "2. Run deploy-backend.sh on the server"
echo "3. Upload frontend/dist/ to your web server"
echo "4. Test both backend and frontend"
echo ""
echo "🚀 Complete deployment ready!"
