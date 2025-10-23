# 🔧 NXOLand Deployment Troubleshooting Guide

## 🚨 "This site can't be reached" - Common Issues & Solutions

### **Step 1: Check Server Status**

```bash
# SSH into your server and check services
sudo systemctl status nginx
sudo systemctl status php8.4-fpm
sudo systemctl status mysql
sudo systemctl status redis-server
```

**Expected Output:** All services should show "active (running)"

---

## 🔍 Common Issues & Solutions

### **Issue 1: NGINX Not Running**
```bash
# Check NGINX status
sudo systemctl status nginx

# If not running, start it
sudo systemctl start nginx
sudo systemctl enable nginx

# Check NGINX configuration
sudo nginx -t

# If config is wrong, restart
sudo systemctl restart nginx
```

### **Issue 2: Wrong File Permissions**
```bash
# Fix permissions
sudo chown -R www-data:www-data /var/www/nxoland-frontend
sudo chown -R www-data:www-data /var/www/nxoland-backend
sudo chmod -R 755 /var/www/nxoland-frontend
sudo chmod -R 755 /var/www/nxoland-backend
```

### **Issue 3: Missing Files**
```bash
# Check if files exist
ls -la /var/www/nxoland-frontend/dist/
ls -la /var/www/nxoland-backend/

# If missing, upload them
# Frontend: Upload your React build to /var/www/nxoland-frontend/dist/
# Backend: Upload Laravel files to /var/www/nxoland-backend/
```

### **Issue 4: DNS Not Configured**
```bash
# Check if domain resolves
nslookup yourdomain.com
ping yourdomain.com

# If DNS is not set up:
# 1. Go to your domain registrar
# 2. Add A record: yourdomain.com → YOUR_SERVER_IP
# 3. Add A record: api.yourdomain.com → YOUR_SERVER_IP
# 4. Wait 5-10 minutes for DNS propagation
```

### **Issue 5: Firewall Blocking**
```bash
# Check firewall status
sudo ufw status

# If firewall is blocking, allow HTTP/HTTPS
sudo ufw allow 'Nginx Full'
sudo ufw allow 80
sudo ufw allow 443
```

### **Issue 6: Port 80/443 Not Open**
```bash
# Check if ports are listening
sudo netstat -tlnp | grep :80
sudo netstat -tlnp | grep :443

# If not listening, restart NGINX
sudo systemctl restart nginx
```

---

## 🚀 Quick Fix Script

Create this script to fix common issues:

```bash
#!/bin/bash
# Quick fix for NXOLand deployment issues

echo "🔧 Fixing NXOLand deployment issues..."

# 1. Restart all services
echo "🔄 Restarting services..."
sudo systemctl restart nginx
sudo systemctl restart php8.4-fpm
sudo systemctl restart mysql
sudo systemctl restart redis-server

# 2. Fix permissions
echo "🔐 Fixing permissions..."
sudo chown -R www-data:www-data /var/www/nxoland-frontend
sudo chown -R www-data:www-data /var/www/nxoland-backend
sudo chmod -R 755 /var/www/nxoland-frontend
sudo chmod -R 755 /var/www/nxoland-backend

# 3. Check NGINX config
echo "🌐 Checking NGINX configuration..."
sudo nginx -t

# 4. Enable firewall rules
echo "🔥 Configuring firewall..."
sudo ufw allow 'Nginx Full'
sudo ufw allow 80
sudo ufw allow 443

# 5. Check services
echo "✅ Checking services..."
sudo systemctl status nginx --no-pager
sudo systemctl status php8.4-fpm --no-pager

echo "🎉 Fix completed! Try accessing your site now."
```

---

## 🔍 Diagnostic Commands

### **Check Server IP:**
```bash
curl ifconfig.me
```

### **Check NGINX Logs:**
```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log
```

### **Check PHP-FPM Logs:**
```bash
sudo tail -f /var/log/php8.4-fpm.log
```

### **Test Local Connection:**
```bash
# Test if server responds locally
curl localhost
curl localhost/api
```

---

## 🌐 DNS Configuration

### **Required DNS Records:**
```
Type: A
Name: @
Value: YOUR_SERVER_IP
TTL: 300

Type: A  
Name: www
Value: YOUR_SERVER_IP
TTL: 300

Type: A
Name: api
Value: YOUR_SERVER_IP
TTL: 300
```

### **Check DNS Propagation:**
- Use: https://dnschecker.org/
- Enter your domain and check if it resolves to your server IP

---

## 🔧 Manual NGINX Configuration

If the automatic setup failed, create NGINX config manually:

```bash
# Create NGINX config
sudo nano /etc/nginx/sites-available/nxoland
```

**Add this content:**
```nginx
# Frontend (React)
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    root /var/www/nxoland-frontend/dist;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

# Backend API (Laravel)
server {
    listen 80;
    server_name api.yourdomain.com;
    root /var/www/nxoland-backend/public;
    index index.php;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }
}
```

**Enable the site:**
```bash
sudo ln -s /etc/nginx/sites-available/nxoland /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🆘 Emergency Recovery

If nothing works, try this complete reset:

```bash
# 1. Stop all services
sudo systemctl stop nginx
sudo systemctl stop php8.4-fpm

# 2. Remove old configs
sudo rm -f /etc/nginx/sites-enabled/*
sudo rm -f /etc/nginx/sites-available/nxoland

# 3. Re-run deployment script
sudo bash deploy-full-stack.sh

# 4. Upload your files again
# Upload React build to /var/www/nxoland-frontend/dist/
# Upload Laravel to /var/www/nxoland-backend/

# 5. Set permissions
sudo chown -R www-data:www-data /var/www/nxoland-frontend
sudo chown -R www-data:www-data /var/www/nxoland-backend
```

---

## 📞 Still Not Working?

### **Check These:**
1. **Server IP** - Is it correct?
2. **Domain DNS** - Does it point to your server?
3. **Files uploaded** - Are they in the right directories?
4. **Services running** - Are all services active?
5. **Firewall** - Are ports 80/443 open?

### **Get Help:**
- Check server logs: `sudo journalctl -u nginx`
- Test with IP: `http://YOUR_SERVER_IP`
- Check if files exist: `ls -la /var/www/nxoland-frontend/dist/`

**Most common issue:** DNS not configured or files not uploaded properly!
