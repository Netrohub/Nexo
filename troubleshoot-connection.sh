#!/bin/bash
set -e

echo "🔍 Troubleshooting Connection Issues"
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

echo "1. Checking server IP address..."
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "unknown")
echo "   Your server IP: $SERVER_IP"

echo ""
echo "2. Checking if Nginx is running..."
if systemctl is-active --quiet nginx; then
    print_success "✅ Nginx is running"
else
    print_error "❌ Nginx is not running"
    echo "   Start with: sudo systemctl start nginx"
fi

echo ""
echo "3. Checking Nginx configuration..."
if nginx -t 2>/dev/null; then
    print_success "✅ Nginx configuration is valid"
else
    print_error "❌ Nginx configuration has errors"
fi

echo ""
echo "4. Checking if site files exist..."
if [ -f "/var/www/nxoland.com/public/index.html" ]; then
    print_success "✅ index.html exists at /var/www/nxoland.com/public/"
elif [ -f "/var/www/ploi/nxoland.com/public/index.html" ]; then
    print_success "✅ index.html exists at /var/www/ploi/nxoland.com/public/"
else
    print_error "❌ index.html not found"
    echo "   Searching for index.html..."
    find /var/www -name "index.html" 2>/dev/null || echo "   No index.html found"
fi

echo ""
echo "5. Testing local server response..."
echo "   Testing: http://localhost/"
LOCAL_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/ 2>/dev/null || echo "failed")
if [ "$LOCAL_RESPONSE" = "200" ]; then
    print_success "✅ Local server responds with 200 OK"
elif [ "$LOCAL_RESPONSE" = "404" ]; then
    print_warning "⚠️  Local server responds with 404 - Nginx config issue"
else
    print_error "❌ Local server not responding (code: $LOCAL_RESPONSE)"
fi

echo ""
echo "6. Testing external access..."
echo "   Testing: http://$SERVER_IP/"
EXTERNAL_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://$SERVER_IP/ 2>/dev/null || echo "failed")
if [ "$EXTERNAL_RESPONSE" = "200" ]; then
    print_success "✅ External access works: http://$SERVER_IP/"
elif [ "$EXTERNAL_RESPONSE" = "404" ]; then
    print_warning "⚠️  External access returns 404 - Nginx config issue"
else
    print_error "❌ External access failed (code: $EXTERNAL_RESPONSE)"
fi

echo ""
echo "7. Checking domain DNS..."
echo "   Testing: nxoland.com"
DOMAIN_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://nxoland.com/ 2>/dev/null || echo "failed")
if [ "$DOMAIN_RESPONSE" = "200" ]; then
    print_success "✅ Domain works: http://nxoland.com/"
elif [ "$DOMAIN_RESPONSE" = "failed" ]; then
    print_warning "⚠️  Domain not pointing to this server"
    echo "   DNS needs to point to: $SERVER_IP"
else
    print_warning "⚠️  Domain returns: $DOMAIN_RESPONSE"
fi

echo ""
echo "8. Checking firewall status..."
if command -v ufw >/dev/null 2>&1; then
    UFW_STATUS=$(ufw status 2>/dev/null | grep "Status" || echo "Unknown")
    echo "   UFW Status: $UFW_STATUS"
    if [[ "$UFW_STATUS" == *"active"* ]]; then
        print_warning "⚠️  UFW firewall is active - check if port 80 is open"
    fi
fi

echo ""
echo "9. Checking if port 80 is listening..."
if netstat -tlnp 2>/dev/null | grep ":80 " >/dev/null; then
    print_success "✅ Port 80 is listening"
    netstat -tlnp 2>/dev/null | grep ":80 "
else
    print_error "❌ Port 80 is not listening"
fi

echo ""
echo "🔧 SOLUTIONS:"
echo "============="
echo ""

if [ "$LOCAL_RESPONSE" = "200" ] && [ "$EXTERNAL_RESPONSE" = "200" ]; then
    print_success "✅ Your server is working! The issue is DNS/domain configuration."
    echo ""
    echo "🌐 Your site is accessible at:"
    echo "   http://$SERVER_IP/"
    echo ""
    echo "📋 To fix domain access:"
    echo "   1. Go to your domain registrar (GoDaddy, Namecheap, etc.)"
    echo "   2. Update DNS A record:"
    echo "      Type: A"
    echo "      Name: @"
    echo "      Value: $SERVER_IP"
    echo "   3. Add CNAME record:"
    echo "      Type: CNAME"
    echo "      Name: www"
    echo "      Value: nxoland.com"
    echo "   4. Wait 5-10 minutes for DNS propagation"
    echo ""
    echo "🔍 Test your domain:"
    echo "   nslookup nxoland.com"
    echo "   dig nxoland.com"
    
elif [ "$LOCAL_RESPONSE" = "404" ] || [ "$EXTERNAL_RESPONSE" = "404" ]; then
    print_warning "⚠️  Nginx configuration issue detected."
    echo ""
    echo "🔧 Fix Nginx configuration:"
    echo "   1. Check if site is enabled:"
    echo "      ls -la /etc/nginx/sites-enabled/"
    echo "   2. Check Nginx configuration:"
    echo "      cat /etc/nginx/sites-available/nxoland.com"
    echo "   3. Test configuration:"
    echo "      sudo nginx -t"
    echo "   4. Reload Nginx:"
    echo "      sudo systemctl reload nginx"
    
else
    print_error "❌ Server configuration issues detected."
    echo ""
    echo "🔧 Fix server issues:"
    echo "   1. Start Nginx:"
    echo "      sudo systemctl start nginx"
    echo "   2. Enable Nginx:"
    echo "      sudo systemctl enable nginx"
    echo "   3. Check Nginx status:"
    echo "      sudo systemctl status nginx"
    echo "   4. Check Nginx logs:"
    echo "      sudo tail -f /var/log/nginx/error.log"
fi

echo ""
echo "📊 Quick Tests:"
echo "==============="
echo "curl -I http://$SERVER_IP/"
echo "curl -I http://localhost/"
echo "curl -I http://nxoland.com/"
echo ""
echo "🔍 DNS Check:"
echo "nslookup nxoland.com"
echo "dig nxoland.com"
