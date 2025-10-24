@echo off
REM Test Ploi Webhook Deployment

echo 🚀 Testing Ploi Webhook Deployment...
echo.

echo 📡 Triggering deployment via webhook...
curl -X POST "https://ploi.io/webhooks/servers/101779/sites/322429/deploy?token=x4BUbb4kfwwEtvuj05rdLhtyFFoHpQ7My2Z0mmZAaowowY6KPy"

echo.
echo ✅ Webhook triggered! Check your Ploi dashboard for deployment status.
echo.
echo 🧪 Test your API after deployment:
echo curl https://api.nxoland.com/api/ping
echo.
pause
