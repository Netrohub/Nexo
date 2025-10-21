#!/bin/bash
set -e

echo "🔍 Diagnosing 404 Error"
echo "======================="
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

SITE_DIR="/var/www/nxoland.com"

echo "1. Checking if site directory exists..."
if [ -d "$SITE_DIR" ]; then
    print_success "✅ Site directory exists: $SITE_DIR"
else
    print_error "❌ Site directory not found: $SITE_DIR"
    exit 1
fi

echo ""
echo "2. Checking if public directory exists..."
if [ -d "$SITE_DIR/public" ]; then
    print_success "✅ Public directory exists"
else
    print_error "❌ Public directory not found"
    exit 1
fi

echo ""
echo "3. Checking if index.html exists..."
if [ -f "$SITE_DIR/public/index.html" ]; then
    print_success "✅ index.html exists"
    echo "   File size: $(du -h $SITE_DIR/public/index.html | cut -f1)"
else
    print_error "❌ index.html not found"
    echo "   Available files in public/:"
    ls -la "$SITE_DIR/public/" 2>/dev/null || echo "   Directory is empty or doesn't exist"
fi

echo ""
echo "4. Checking file permissions..."
echo "   Directory permissions:"
ls -ld "$SITE_DIR" "$SITE_DIR/public" 2>/dev/null || echo "   Cannot access directories"

echo ""
echo "5. Checking Nginx status..."
if systemctl is-active --quiet nginx; then
    print_success "✅ Nginx is running"
else
    print_error "❌ Nginx is not running"
    echo "   Start with: sudo systemctl start nginx"
fi

echo ""
echo "6. Checking Nginx configuration..."
if nginx -t 2>/dev/null; then
    print_success "✅ Nginx configuration is valid"
else
    print_error "❌ Nginx configuration has errors"
    echo "   Run: sudo nginx -t"
fi

echo ""
echo "7. Checking if site is configured in Nginx..."
if [ -f "/etc/nginx/sites-available/nxoland.com" ]; then
    print_success "✅ Site configuration exists"
else
    print_warning "⚠️  Site configuration not found"
    echo "   Run: sudo ./nginx-config.sh"
fi

if [ -L "/etc/nginx/sites-enabled/nxoland.com" ]; then
    print_success "✅ Site is enabled"
else
    print_warning "⚠️  Site is not enabled"
    echo "   Run: sudo ln -s /etc/nginx/sites-available/nxoland.com /etc/nginx/sites-enabled/"
fi

echo ""
echo "8. Checking Nginx error logs..."
if [ -f "/var/log/nginx/error.log" ]; then
    echo "   Recent errors:"
    tail -5 /var/log/nginx/error.log 2>/dev/null || echo "   No recent errors"
fi

echo ""
echo "9. Testing local file access..."
if [ -f "$SITE_DIR/public/index.html" ]; then
    echo "   File content preview:"
    head -5 "$SITE_DIR/public/index.html" 2>/dev/null || echo "   Cannot read file"
fi

echo ""
echo "🔧 QUICK FIXES:"
echo "==============="
echo ""
echo "If index.html is missing:"
echo "   cd $SITE_DIR"
echo "   sudo rm -rf * .* 2>/dev/null || true"
echo "   sudo git clone https://github.com/Netrohub/Nexo.git ."
echo "   sudo chown -R www-data:www-data $SITE_DIR"
echo "   sudo chmod -R 755 $SITE_DIR"
echo ""
echo "If Nginx is not configured:"
echo "   sudo ./nginx-config.sh"
echo ""
echo "If Nginx is not running:"
echo "   sudo systemctl start nginx"
echo "   sudo systemctl enable nginx"
echo ""
echo "Test your site:"
echo "   curl -I http://localhost/"
echo "   curl -I http://$(curl -s ifconfig.me)/"
