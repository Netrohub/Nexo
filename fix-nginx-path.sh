#!/bin/bash
set -e

echo "🔧 Fixing Nginx Path Configuration"
echo "===================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check current Nginx configuration
print_status "Checking current Nginx configuration..."

if [ -f "/etc/nginx/sites-available/nxoland.com" ]; then
    echo "Current configuration:"
    cat /etc/nginx/sites-available/nxoland.com
    echo ""
else
    print_error "No Nginx configuration found"
    exit 1
fi

# Check if we're in the right directory
print_status "Checking current directory structure..."
echo "Current directory: $(pwd)"
echo "Contents:"
ls -la

echo ""
print_status "Checking if we're in the right location..."

# The issue might be that you're in /var/www/ploi/nxoland.com instead of /var/www/nxoland.com
if [[ "$(pwd)" == *"ploi"* ]]; then
    print_warning "You're in a Ploi directory structure"
    echo "Current path: $(pwd)"
    echo "Expected path: /var/www/nxoland.com"
    echo ""
    
    # Check if the correct directory exists
    if [ -d "/var/www/nxoland.com" ]; then
        print_status "Found correct directory at /var/www/nxoland.com"
        echo "Contents of /var/www/nxoland.com:"
        ls -la /var/www/nxoland.com/
        echo ""
        echo "Contents of /var/www/nxoland.com/public:"
        ls -la /var/www/nxoland.com/public/
    else
        print_error "Correct directory /var/www/nxoland.com not found"
    fi
fi

# Fix the Nginx configuration to point to the correct directory
print_status "Updating Nginx configuration..."

# Determine the correct path
if [ -d "/var/www/nxoland.com/public" ] && [ -f "/var/www/nxoland.com/public/index.html" ]; then
    CORRECT_PATH="/var/www/nxoland.com/public"
    print_success "Found correct path: $CORRECT_PATH"
elif [ -d "/var/www/ploi/nxoland.com/public" ] && [ -f "/var/www/ploi/nxoland.com/public/index.html" ]; then
    CORRECT_PATH="/var/www/ploi/nxoland.com/public"
    print_success "Found Ploi path: $CORRECT_PATH"
else
    print_error "Cannot find the correct public directory with index.html"
    echo "Available directories:"
    find /var/www -name "index.html" 2>/dev/null || echo "No index.html found"
    exit 1
fi

# Update Nginx configuration
print_status "Updating Nginx configuration to use: $CORRECT_PATH"

cat > /etc/nginx/sites-available/nxoland.com << EOF
server {
    listen 80;
    server_name nxoland.com www.nxoland.com;
    root $CORRECT_PATH;
    index index.html;

    # Handle React Router (SPA)
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";
    add_header X-XSS-Protection "1; mode=block";

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;

    # Logs
    access_log /var/log/nginx/nxoland.com.access.log;
    error_log /var/log/nginx/nxoland.com.error.log;
}
EOF

print_success "Nginx configuration updated"

# Test configuration
print_status "Testing Nginx configuration..."
if nginx -t; then
    print_success "Nginx configuration is valid"
else
    print_error "Nginx configuration has errors"
    exit 1
fi

# Reload Nginx
print_status "Reloading Nginx..."
systemctl reload nginx
print_success "Nginx reloaded"

# Test the site
print_status "Testing site accessibility..."
echo "Testing: http://localhost/"
curl -I http://localhost/ 2>/dev/null || echo "Local test failed"

# Get server IP and test
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "your-server-ip")
echo "Testing: http://$SERVER_IP/"
curl -I http://$SERVER_IP/ 2>/dev/null || echo "External test failed"

print_success "✅ Nginx path configuration complete!"
echo ""
echo "🌐 Your site should now be accessible at:"
echo "   http://$SERVER_IP/"
echo "   http://nxoland.com (if domain is configured)"
echo ""
echo "📁 Site files: $CORRECT_PATH"
echo "📄 Main file: $CORRECT_PATH/index.html"
echo ""
echo "🔍 To verify:"
echo "   curl -I http://$SERVER_IP/"
echo "   ls -la $CORRECT_PATH/"
