# 🚀 Deploy NXOLand via SSH - Complete Guide

Deploy your coming soon page and full React app directly via SSH.

---

## 📋 **What You Need:**

1. ✅ **SSH access** to your server
2. ✅ **Domain pointing** to your server IP
3. ✅ **Nginx/Apache** configured
4. ✅ **Node.js** installed (version 22+)

---

## 🎯 **Step 1: Connect to Server**

```bash
# Connect via SSH
ssh root@your-server-ip
# OR
ssh ploi@your-server-ip
```

---

## 🎯 **Step 2: Create Site Directory**

```bash
# Create directory for your site
mkdir -p /var/www/nxoland.com
cd /var/www/nxoland.com

# Set permissions
chown -R www-data:www-data /var/www/nxoland.com
chmod -R 755 /var/www/nxoland.com
```

---

## 🎯 **Step 3: Clone Repository**

```bash
# Clone your repository
git clone https://github.com/Netrohub/Nexo.git .

# Verify files
ls -la
# Should see: package.json, src/, public/, etc.
```

---

## 🎯 **Step 4: Install Dependencies**

```bash
# Install Node.js (if not installed)
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install project dependencies
npm install

# Verify installation
node --version
npm --version
```

---

## 🎯 **Step 5: Deploy Coming Soon Page (Quick)**

```bash
# Just copy the coming soon page
cp public/index.html public/index.html

# Set permissions
chmod 644 public/index.html
chmod 755 public/

# Test if file exists
ls -la public/index.html
```

**Your coming soon page is now live!** 🎉

---

## 🎯 **Step 6: Deploy Full React App (When Ready)**

```bash
# Build the React app
npm run build

# Deploy built files
rm -rf public/*
cp -r dist/* public/

# Set permissions
chmod -R 755 public/

# Verify deployment
ls -la public/
```

---

## 🌐 **Step 7: Configure Web Server**

### **For Nginx:**

Create `/etc/nginx/sites-available/nxoland.com`:

```nginx
server {
    listen 80;
    server_name nxoland.com www.nxoland.com;
    root /var/www/nxoland.com/public;
    index index.html;

    # Handle React Router (SPA)
    location / {
        try_files $uri $uri/ /index.html;
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
}
```

Enable the site:
```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/nxoland.com /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx
```

### **For Apache:**

Create `/etc/apache2/sites-available/nxoland.com.conf`:

```apache
<VirtualHost *:80>
    ServerName nxoland.com
    ServerAlias www.nxoland.com
    DocumentRoot /var/www/nxoland.com/public

    <Directory /var/www/nxoland.com/public>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
        
        # Handle React Router
        RewriteEngine On
        RewriteBase /
        RewriteRule ^index\.html$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.html [L]
    </Directory>

    # Cache static assets
    <LocationMatch "\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$">
        ExpiresActive On
        ExpiresDefault "access plus 1 year"
    </LocationMatch>
</VirtualHost>
```

Enable the site:
```bash
# Enable site
sudo a2ensite nxoland.com.conf

# Enable rewrite module
sudo a2enmod rewrite

# Reload apache
sudo systemctl reload apache2
```

---

## 🔒 **Step 8: Enable SSL (Let's Encrypt)**

```bash
# Install certbot
sudo apt update
sudo apt install certbot python3-certbot-nginx

# For Nginx
sudo certbot --nginx -d nxoland.com -d www.nxoland.com

# For Apache
sudo certbot --apache -d nxoland.com -d www.nxoland.com

# Auto-renewal (already configured)
sudo certbot renew --dry-run
```

---

## 🔄 **Step 9: Auto-Deploy Script**

Create `/var/www/nxoland.com/deploy.sh`:

```bash
#!/bin/bash
set -e

echo "🚀 NXOLand Auto-Deploy"
echo "======================"

cd /var/www/nxoland.com

# Pull latest changes
echo "📦 Pulling latest changes..."
git pull origin main

# Install dependencies (if package.json changed)
echo "📦 Installing dependencies..."
npm ci --production=false

# Build React app
echo "🔨 Building React app..."
npm run build

# Deploy to public
echo "📁 Deploying files..."
rm -rf public/*
cp -r dist/* public/

# Set permissions
chmod -R 755 public/

echo "✅ Deployment complete!"
echo "🌐 Site: https://nxoland.com"
```

Make it executable:
```bash
chmod +x /var/www/nxoland.com/deploy.sh
```

**Run deployment:**
```bash
./deploy.sh
```

---

## 🔄 **Step 10: GitHub Webhook (Auto-Deploy)**

### **Install webhook receiver:**

```bash
# Install webhook
sudo apt install webhook

# Create webhook config
sudo mkdir -p /etc/webhook
```

Create `/etc/webhook/hooks.json`:
```json
[
  {
    "id": "nxoland-deploy",
    "execute-command": "/var/www/nxoland.com/deploy.sh",
    "command-working-directory": "/var/www/nxoland.com",
    "response-message": "Deployment triggered!"
  }
]
```

Start webhook service:
```bash
sudo systemctl enable webhook
sudo systemctl start webhook
```

### **GitHub Webhook Setup:**

1. Go to: https://github.com/Netrohub/Nexo/settings/hooks
2. Click **"Add webhook"**
3. **Payload URL**: `http://your-server-ip:9000/hooks/nxoland-deploy`
4. **Content type**: `application/json`
5. **Events**: Just the push event
6. **Active**: ✅ Checked
7. Click **"Add webhook"**

**Now every push to main = auto deploy!** 🚀

---

## 📊 **Step 11: Monitoring & Logs**

### **Check deployment logs:**
```bash
# View deploy script logs
tail -f /var/www/nxoland.com/deploy.log

# View nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# View webhook logs
sudo journalctl -u webhook -f
```

### **Check if site is running:**
```bash
# Test if site responds
curl -I https://nxoland.com

# Should return: 200 OK
```

---

## 🎯 **Quick Commands Summary:**

### **Deploy Coming Soon (30 seconds):**
```bash
cd /var/www/nxoland.com
git pull origin main
chmod 644 public/index.html
echo "✅ Coming soon page live!"
```

### **Deploy Full App (2 minutes):**
```bash
cd /var/www/nxoland.com
git pull origin main
npm ci
npm run build
rm -rf public/*
cp -r dist/* public/
chmod -R 755 public/
echo "✅ Full app deployed!"
```

### **Check Status:**
```bash
# Check if site is live
curl -I https://nxoland.com

# Check files
ls -la /var/www/nxoland.com/public/

# Check git status
cd /var/www/nxoland.com && git status
```

---

## 🆘 **Troubleshooting:**

### **Permission Issues:**
```bash
sudo chown -R www-data:www-data /var/www/nxoland.com
sudo chmod -R 755 /var/www/nxoland.com
```

### **Node.js Issues:**
```bash
# Install Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify
node --version
npm --version
```

### **Nginx Issues:**
```bash
# Test config
sudo nginx -t

# Reload
sudo systemctl reload nginx

# Check status
sudo systemctl status nginx
```

### **Git Issues:**
```bash
# Re-clone if needed
cd /var/www
rm -rf nxoland.com
git clone https://github.com/Netrohub/Nexo.git nxoland.com
```

---

## ✅ **Deployment Checklist:**

- [ ] SSH access to server
- [ ] Domain pointing to server IP
- [ ] Node.js 22+ installed
- [ ] Nginx/Apache configured
- [ ] Repository cloned
- [ ] Dependencies installed
- [ ] Coming soon page deployed
- [ ] SSL certificate installed
- [ ] Auto-deploy webhook setup
- [ ] Site accessible at https://nxoland.com

---

## 🎉 **You're Ready!**

**Your deployment options:**

1. **Coming Soon Page** (5 minutes)
2. **Full React App** (10 minutes)
3. **Auto-deploy Setup** (15 minutes)

**Choose your path and let's deploy!** 🚀
