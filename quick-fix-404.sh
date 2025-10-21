#!/bin/bash
set -e

echo "🚀 Quick Fix for 404 Error"
echo "=========================="
echo ""

# Check where we are and what files exist
echo "Current directory: $(pwd)"
echo "Contents:"
ls -la

echo ""
echo "Checking for index.html in common locations:"

# Check various possible locations
LOCATIONS=(
    "/var/www/nxoland.com/public/index.html"
    "/var/www/ploi/nxoland.com/public/index.html"
    "/var/www/nxoland.com/index.html"
    "/var/www/ploi/nxoland.com/index.html"
)

FOUND_PATH=""
for location in "${LOCATIONS[@]}"; do
    if [ -f "$location" ]; then
        echo "✅ Found: $location"
        FOUND_PATH=$(dirname "$location")
        break
    else
        echo "❌ Not found: $location"
    fi
done

if [ -z "$FOUND_PATH" ]; then
    echo ""
    echo "❌ No index.html found in any location!"
    echo "Let's find where your files are:"
    find /var/www -name "index.html" 2>/dev/null || echo "No index.html found anywhere"
    exit 1
fi

echo ""
echo "✅ Found index.html in: $FOUND_PATH"

# Update Nginx configuration
echo ""
echo "🔧 Updating Nginx configuration..."

cat > /etc/nginx/sites-available/nxoland.com << EOF
server {
    listen 80;
    server_name nxoland.com www.nxoland.com;
    root $FOUND_PATH;
    index index.html;

    location / {
        try_files \$uri \$uri/ /index.html;
    }
}
EOF

echo "✅ Nginx configuration updated to use: $FOUND_PATH"

# Test and reload
echo ""
echo "🔧 Testing and reloading Nginx..."
nginx -t && systemctl reload nginx

echo ""
echo "✅ Configuration complete!"
echo ""
echo "🌐 Test your site:"
echo "   curl -I http://localhost/"
echo "   curl -I http://$(curl -s ifconfig.me)/"
echo ""
echo "📁 Your files are in: $FOUND_PATH"
