#!/bin/bash

# Quick Deploy with Ploi Webhook
set -e

echo "🚀 Quick Deploy to Ploi..."

# Ploi webhook URL
PLOI_WEBHOOK="https://ploi.io/webhooks/servers/101779/sites/322429/deploy?token=x4BUbb4kfwwEtvuj05rdLhtyFFoHpQ7My2Z0mmZAaowowY6KPy"

# Commit and push changes
echo "📝 Adding changes to git..."
git add .

echo "💾 Committing changes..."
git commit -m "🚀 Quick deploy: $(date '+%Y-%m-%d %H:%M:%S')" || echo "⚠️ No changes to commit"

echo "📤 Pushing to repository..."
git push origin main

# Trigger Ploi deployment
echo "🌐 Triggering Ploi webhook..."
curl -X POST "$PLOI_WEBHOOK" \
  -H "Content-Type: application/json" \
  -d '{"message": "Quick deployment", "timestamp": "'$(date -Iseconds)'"}'

echo "✅ Deployment triggered!"
echo "⏱️  Your site will be updated in 1-2 minutes"
echo "🧪 Test: curl https://nxoland.com"
