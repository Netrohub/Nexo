#!/bin/bash
set -e

echo "🌐 Configuring Nginx for NXOLand"
echo "================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root (use sudo)"
    exit 1
fi

# Site configuration
SITE_NAME="nxoland.com"
SITE_DIR="/var/www/nxoland.com"
NGINX_CONFIG="/etc/nginx/sites-available/$SITE_NAME"
NGINX_ENABLED="/etc/nginx/sites-enabled/$SITE_NAME"

print_status "Creating Nginx configuration for $SITE_NAME"

# Create Nginx configuration
cat > "$NGINX_CONFIG" << EOF
server {
    listen 80;
    server_name $SITE_NAME www.$SITE_NAME;
    root $SITE_DIR/public;
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
    access_log /var/log/nginx/$SITE_NAME.access.log;
    error_log /var/log/nginx/$SITE_NAME.error.log;
}
EOF

print_success "Nginx configuration created: $NGINX_CONFIG"

# Enable the site
print_status "Enabling site..."
ln -sf "$NGINX_CONFIG" "$NGINX_ENABLED"
print_success "Site enabled: $NGINX_ENABLED"

# Test Nginx configuration
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

# Check if site is accessible
print_status "Checking site accessibility..."

# Get server IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "your-server-ip")

print_success "✅ Nginx configuration complete!"
echo ""
echo "🌐 Your site should now be accessible at:"
echo "   http://$SERVER_IP/"
echo "   http://$SITE_NAME (if domain is configured)"
echo ""
echo "📁 Site files: $SITE_DIR/public/"
echo "📄 Main file: $SITE_DIR/public/index.html"
echo ""
echo "🔍 To check if files exist:"
echo "   ls -la $SITE_DIR/public/"
echo ""
echo "📊 To check Nginx status:"
echo "   systemctl status nginx"
echo ""
echo "📝 To view Nginx logs:"
echo "   tail -f /var/log/nginx/$SITE_NAME.access.log"
echo "   tail -f /var/log/nginx/$SITE_NAME.error.log"
echo ""

# Check if index.html exists
if [ -f "$SITE_DIR/public/index.html" ]; then
    print_success "✅ index.html found - site should work!"
else
    print_warning "⚠️  index.html not found - you may need to deploy first"
    echo "Run: cd $SITE_DIR && sudo git clone https://github.com/Netrohub/Nexo.git ."
fi
