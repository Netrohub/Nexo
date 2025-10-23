#!/bin/bash

# NXOLand Deployment Diagnostic Script
# Run this on your server to identify issues

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                NXOLand Deployment Diagnostic                ║"
echo "║              Identifying deployment issues                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    log_error "Please run as root (use sudo)"
    exit 1
fi

# 1. Check server IP
log_info "🔍 Checking server IP..."
SERVER_IP=$(curl -s ifconfig.me)
log_success "Server IP: $SERVER_IP"

# 2. Check services
log_info "🔍 Checking services..."

# NGINX
if systemctl is-active --quiet nginx; then
    log_success "NGINX: Running"
else
    log_error "NGINX: Not running"
    log_info "Starting NGINX..."
    systemctl start nginx
    systemctl enable nginx
fi

# PHP-FPM
if systemctl is-active --quiet php8.4-fpm; then
    log_success "PHP-FPM: Running"
else
    log_error "PHP-FPM: Not running"
    log_info "Starting PHP-FPM..."
    systemctl start php8.4-fpm
    systemctl enable php8.4-fpm
fi

# MySQL
if systemctl is-active --quiet mysql; then
    log_success "MySQL: Running"
else
    log_error "MySQL: Not running"
    log_info "Starting MySQL..."
    systemctl start mysql
    systemctl enable mysql
fi

# Redis
if systemctl is-active --quiet redis-server; then
    log_success "Redis: Running"
else
    log_error "Redis: Not running"
    log_info "Starting Redis..."
    systemctl start redis-server
    systemctl enable redis-server
fi

# 3. Check ports
log_info "🔍 Checking ports..."

if netstat -tlnp | grep -q :80; then
    log_success "Port 80: Listening"
else
    log_error "Port 80: Not listening"
fi

if netstat -tlnp | grep -q :443; then
    log_success "Port 443: Listening"
else
    log_warning "Port 443: Not listening (SSL not configured yet)"
fi

# 4. Check files
log_info "🔍 Checking files..."

# Frontend files
if [ -d "/var/www/nxoland-frontend/dist" ]; then
    if [ -f "/var/www/nxoland-frontend/dist/index.html" ]; then
        log_success "Frontend: Files exist"
    else
        log_error "Frontend: index.html missing"
        log_info "Upload your React build to /var/www/nxoland-frontend/dist/"
    fi
else
    log_error "Frontend: Directory missing"
    log_info "Create directory: mkdir -p /var/www/nxoland-frontend/dist"
fi

# Backend files
if [ -d "/var/www/nxoland-backend" ]; then
    if [ -f "/var/www/nxoland-backend/public/index.php" ]; then
        log_success "Backend: Files exist"
    else
        log_error "Backend: Laravel files missing"
        log_info "Upload Laravel files to /var/www/nxoland-backend/"
    fi
else
    log_error "Backend: Directory missing"
    log_info "Create directory: mkdir -p /var/www/nxoland-backend"
fi

# 5. Check permissions
log_info "🔍 Checking permissions..."

# Fix permissions if needed
chown -R www-data:www-data /var/www/nxoland-frontend 2>/dev/null || true
chown -R www-data:www-data /var/www/nxoland-backend 2>/dev/null || true
chmod -R 755 /var/www/nxoland-frontend 2>/dev/null || true
chmod -R 755 /var/www/nxoland-backend 2>/dev/null || true

log_success "Permissions: Fixed"

# 6. Check NGINX configuration
log_info "🔍 Checking NGINX configuration..."

if nginx -t 2>/dev/null; then
    log_success "NGINX: Configuration valid"
else
    log_error "NGINX: Configuration invalid"
    log_info "Check NGINX config: nginx -t"
fi

# 7. Check firewall
log_info "🔍 Checking firewall..."

if ufw status | grep -q "Status: active"; then
    if ufw status | grep -q "Nginx Full"; then
        log_success "Firewall: NGINX allowed"
    else
        log_warning "Firewall: NGINX not allowed"
        log_info "Run: ufw allow 'Nginx Full'"
    fi
else
    log_warning "Firewall: Not active"
fi

# 8. Test local connection
log_info "🔍 Testing local connection..."

if curl -s localhost >/dev/null 2>&1; then
    log_success "Local connection: Working"
else
    log_error "Local connection: Failed"
    log_info "Check NGINX logs: tail -f /var/log/nginx/error.log"
fi

# 9. Check DNS (if domain provided)
if [ ! -z "$1" ]; then
    DOMAIN="$1"
    log_info "🔍 Checking DNS for $DOMAIN..."
    
    if nslookup "$DOMAIN" >/dev/null 2>&1; then
        RESOLVED_IP=$(nslookup "$DOMAIN" | grep "Address:" | tail -1 | awk '{print $2}')
        if [ "$RESOLVED_IP" = "$SERVER_IP" ]; then
            log_success "DNS: Correctly pointing to this server"
        else
            log_error "DNS: Pointing to $RESOLVED_IP (should be $SERVER_IP)"
            log_info "Configure DNS: $DOMAIN → $SERVER_IP"
        fi
    else
        log_error "DNS: Domain not resolving"
        log_info "Configure DNS: $DOMAIN → $SERVER_IP"
    fi
fi

# 10. Generate report
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    DIAGNOSTIC REPORT                        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo "📊 Server Information:"
echo "   IP Address: $SERVER_IP"
echo "   OS: $(lsb_release -d | cut -f2)"
echo "   Uptime: $(uptime -p)"

echo ""
echo "🌐 Access URLs:"
echo "   Frontend: http://$SERVER_IP"
if [ ! -z "$1" ]; then
    echo "   Domain: http://$1"
fi
echo "   API: http://$SERVER_IP/api"

echo ""
echo "🔧 Quick Fixes:"
echo "   1. Upload files:"
echo "      - React build → /var/www/nxoland-frontend/dist/"
echo "      - Laravel → /var/www/nxoland-backend/"
echo ""
echo "   2. Configure DNS:"
echo "      - yourdomain.com → $SERVER_IP"
echo "      - api.yourdomain.com → $SERVER_IP"
echo ""
echo "   3. Restart services:"
echo "      sudo systemctl restart nginx"
echo "      sudo systemctl restart php8.4-fpm"

echo ""
echo "📋 Next Steps:"
echo "   1. Upload your React build files"
echo "   2. Upload your Laravel backend files"
echo "   3. Configure your domain DNS"
echo "   4. Test access via IP first, then domain"

echo -e "${GREEN}"
echo "🎉 Diagnostic completed! Check the report above for issues."
echo -e "${NC}"
