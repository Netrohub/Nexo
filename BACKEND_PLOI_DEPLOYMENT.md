# 🚀 NXOLand Backend - Ploi Deployment Guide

## ✅ **Backend Ready for Deployment**

Your PHP backend is ready for deployment to `api.nxoland.com` via Ploi!

## 📋 **Current Ploi Configuration**

Based on your Ploi dashboard, you have:

### **Deploy Script:**
```bash
cd /home/ploi/api.nxoland.com
echo "" | sudo -S service php8.4-fpm reload
echo " Application deployed!"
```

### **Webhook URL:**
```
https://ploi.io/webhooks/servers/101779/sites/322429/deploy?token=x4BUbb4kfwwEtvuj05rdLhtyFFoHpQ7My2Z0mmZAaowc
```

## 🔧 **Recommended Deployment Script**

Update your Ploi deploy script to:

```bash
#!/bin/bash

# NXOLand Backend Deployment Script
cd /home/ploi/api.nxoland.com

# Install/update Composer dependencies
composer install --no-dev --optimize-autoloader

# Set proper permissions
chmod -R 755 public/
chmod 644 public/.htaccess
chmod 644 public/index.php

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    cat > .env << EOF
APP_NAME=NXOLand API
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.nxoland.com

DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=your_username
DB_PASSWORD=your_password

JWT_SECRET=your_jwt_secret_key_here
JWT_ALGORITHM=HS256
EOF
fi

# Reload PHP-FPM
echo "" | sudo -S service php8.4-fpm reload

echo "Backend API deployed successfully!"
```

## 🎯 **Deployment Steps**

### **1. Update Deploy Script in Ploi:**
1. Go to your Ploi dashboard
2. Navigate to your `api.nxoland.com` site
3. Go to "Deployment" section
4. Replace the deploy script with the recommended script above
5. Click "Save"

### **2. Set Environment Variables:**
In your Ploi dashboard, add these environment variables:
- `APP_NAME=NXOLand API`
- `APP_ENV=production`
- `APP_DEBUG=false`
- `APP_URL=https://api.nxoland.com`
- `DB_CONNECTION=mysql`
- `DB_HOST=your_database_host`
- `DB_DATABASE=nxoland`
- `DB_USERNAME=your_username`
- `DB_PASSWORD=your_password`
- `JWT_SECRET=your_secret_key_here`

### **3. Configure Health Check:**
1. In the "Health check URL" section
2. Set the health URL to: `https://api.nxoland.com/api/ping`
3. Click "Save"

### **4. Deploy:**
1. Click "Deploy now" button
2. Wait for deployment to complete
3. Check the deploy logs for any errors

## 🧪 **Testing Your Backend**

### **1. Test API Endpoint:**
```bash
curl https://api.nxoland.com/api/ping
```
**Expected response:** `{"ok": true}`

### **2. Test Other Endpoints:**
```bash
# Test products endpoint
curl https://api.nxoland.com/api/products

# Test auth endpoint
curl -X POST https://api.nxoland.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

### **3. Check Response Headers:**
```bash
curl -I https://api.nxoland.com/api/ping
```
**Expected headers:**
- `Access-Control-Allow-Origin: *`
- `Content-Type: application/json`

## 📁 **Backend Structure**

Your backend should have this structure on the server:
```
/home/ploi/api.nxoland.com/
├── public/
│   ├── index.php          # Entry point
│   └── .htaccess          # URL rewriting
├── src/
│   └── Controllers/       # API controllers
├── vendor/                # Composer dependencies
├── composer.json          # PHP dependencies
├── .env                   # Environment variables
└── composer.lock         # Dependency lock file
```

## 🔧 **Troubleshooting**

### **Common Issues:**

#### **1. 500 Internal Server Error:**
- Check PHP error logs
- Verify file permissions
- Ensure Composer dependencies are installed

#### **2. 404 Not Found:**
- Check if `.htaccess` is working
- Verify `public/index.php` exists
- Check web server configuration

#### **3. CORS Issues:**
- Verify CORS headers in `public/index.php`
- Check if `Access-Control-Allow-Origin: *` is set

#### **4. Database Connection Issues:**
- Verify database credentials in `.env`
- Check if database server is accessible
- Ensure database exists

### **Debug Commands:**
```bash
# Check PHP version
php -v

# Check Composer
composer --version

# Test PHP syntax
php -l public/index.php

# Check file permissions
ls -la public/
```

## 🎉 **Success Checklist**

- [ ] Backend deployed successfully
- [ ] API endpoint responds: `https://api.nxoland.com/api/ping`
- [ ] CORS headers working
- [ ] All controllers responding
- [ ] Database connection working (if configured)
- [ ] Health check URL configured
- [ ] Frontend can connect to backend

## 🚀 **Next Steps**

Once your backend is deployed:

1. **Test the API endpoints**
2. **Configure your database** (if not already done)
3. **Deploy your frontend** to `nxoland.com`
4. **Test the full application**

Your backend is now ready for deployment! The API will be available at `https://api.nxoland.com` and your frontend will be able to connect to it seamlessly. 🎯
