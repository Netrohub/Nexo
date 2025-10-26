#!/bin/bash

# NXOLand Backend Deployment Script
# This script handles the complete deployment process for the backend

set -e

echo "🚀 Starting NXOLand Backend Deployment..."
echo ""

# Navigate to backend directory
cd /home/ploi/api.nxoland.com

echo "📁 Current directory: $(pwd)"
echo ""

# Step 1: Stash any local changes
echo "📦 Stashing any local changes..."
git stash
echo "✅ Stashed local changes"
echo ""

# Step 2: Remove dist directory to avoid merge conflicts
echo "🧹 Removing dist directory to avoid conflicts..."
rm -rf dist
echo "✅ Removed dist directory"
echo ""

# Step 3: Pull latest changes
echo "📥 Pulling latest changes from repository..."
if git pull origin master; then
    echo "✅ Successfully pulled latest changes"
else
    echo "❌ Failed to pull latest changes"
    exit 1
fi
echo ""

# Step 4: Install all dependencies (including dev dependencies for build)
echo "📦 Installing all dependencies..."
if npm install; then
    echo "✅ Successfully installed dependencies"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi
echo ""

# Step 5: Generate Prisma client
echo "🔧 Generating Prisma client..."
if npx prisma generate; then
    echo "✅ Successfully generated Prisma client"
else
    echo "❌ Failed to generate Prisma client"
    exit 1
fi
echo ""

# Step 6: Push Prisma schema changes to database
echo "🗄️ Pushing Prisma schema changes to database..."
if npx prisma db push; then
    echo "✅ Successfully pushed schema changes"
else
    echo "⚠️ Failed to push schema changes (database might already be in sync)"
fi
echo ""

# Step 7: Build the application
echo "🏗️ Building the application..."
if npm run build; then
    echo "✅ Successfully built the application"
else
    echo "❌ Failed to build the application"
    exit 1
fi
echo ""

# Step 8: Install production dependencies only
echo "📦 Installing production dependencies only..."
if npm ci --omit=dev; then
    echo "✅ Successfully installed production dependencies"
else
    echo "❌ Failed to install production dependencies"
    exit 1
fi
echo ""

# Step 9: Restart PM2
echo "🔄 Restarting PM2..."
if pm2 restart nxoland-backend; then
    echo "✅ Successfully restarted PM2"
else
    echo "❌ Failed to restart PM2"
    exit 1
fi
echo ""

# Step 10: Show PM2 status
echo "📊 PM2 Status:"
pm2 status
echo ""

echo "🎉 Deployment completed successfully!"
echo ""
echo "Backend is now running with the latest changes."
echo ""
echo "Check logs with: pm2 logs nxoland-backend"
