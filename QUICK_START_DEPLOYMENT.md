# 🚀 NXOLand Quick Start Deployment

## ⚡ Fastest Way to Deploy Your Marketplace

### **Step 1: Prepare Locally (Windows)**
```cmd
# Run the Windows deployment script
deploy-full-stack.bat
```

### **Step 2: Upload to Ploi Server**
1. **Upload Frontend:**
   - Upload `C:\var\www\nxoland-frontend\` to `/var/www/nxoland-frontend/`

2. **Upload Backend:**
   - Upload `C:\var\www\nxoland-backend\` to `/var/www/nxoland-backend/`

3. **Upload Script:**
   - Upload `deploy-full-stack.sh` to your server

### **Step 3: Run on Server**
```bash
# Make script executable
chmod +x deploy-full-stack.sh

# Run deployment
sudo bash deploy-full-stack.sh
```

### **Step 4: Configure DNS**
- `yourdomain.com` → `YOUR_SERVER_IP`
- `api.yourdomain.com` → `YOUR_SERVER_IP`

---

## 🎯 What the Script Does

### **Automatically Installs:**
- ✅ **Node.js 18** - For React frontend
- ✅ **PHP 8.4** - For Laravel backend
- ✅ **MySQL 8.4** - For database
- ✅ **Redis** - For caching
- ✅ **NGINX** - For web server
- ✅ **Composer** - For Laravel dependencies
- ✅ **SSL Certificates** - For HTTPS

### **Configures:**
- ✅ **Database** - Creates `nxoland` database
- ✅ **Environment** - Sets up all config files
- ✅ **NGINX** - Routes frontend and API
- ✅ **Firewall** - Security configuration
- ✅ **Permissions** - File access rights

### **Creates:**
- ✅ **Deployment script** - `deploy-nxoland` command
- ✅ **SSL certificates** - Automatic HTTPS
- ✅ **Monitoring** - Service status checks

---

## 🔧 Manual Commands (If Needed)

### **Check Services:**
```bash
sudo systemctl status nginx
sudo systemctl status php8.4-fpm
sudo systemctl status mysql
sudo systemctl status redis-server
```

### **Deploy Updates:**
```bash
# Run this after uploading new code
deploy-nxoland
```

### **Check Logs:**
```bash
# NGINX logs
sudo tail -f /var/log/nginx/error.log

# Laravel logs
sudo tail -f /var/www/nxoland-backend/storage/logs/laravel.log
```

---

## 🎉 Success Checklist

After running the script, verify:

- [ ] **Frontend loads** at `https://yourdomain.com`
- [ ] **API responds** at `https://api.yourdomain.com/api`
- [ ] **SSL certificate** is valid (green lock)
- [ ] **Database** is accessible
- [ ] **All services** are running

---

## 🆘 Quick Fixes

### **Frontend not loading?**
```bash
sudo systemctl restart nginx
sudo chown -R www-data:www-data /var/www/nxoland-frontend
```

### **API not responding?**
```bash
sudo systemctl restart php8.4-fpm
sudo -u www-data php /var/www/nxoland-backend/artisan config:clear
```

### **Database issues?**
```bash
sudo systemctl restart mysql
sudo -u www-data php /var/www/nxoland-backend/artisan migrate
```

---

## 💰 Total Cost: ~$15-25/month

- **Server:** $10-20/month
- **Domain:** $1-2/month
- **SSL:** Free (Let's Encrypt)
- **Total:** Complete marketplace for under $25/month!

---

## 🚀 Ready to Deploy?

1. **Run:** `deploy-full-stack.bat` (Windows)
2. **Upload** files to your Ploi server
3. **Run:** `sudo bash deploy-full-stack.sh` (Server)
4. **Configure** DNS
5. **Enjoy** your live marketplace! 🎉
