# 🚀 **Manual Ploi Upload Guide**

## 📋 **Step-by-Step Instructions**

### **Step 1: Create Backend Zip**
```bash
# Run this command to create the zip file
chmod +x create-backend-zip.sh
./create-backend-zip.sh
```

### **Step 2: Upload to Ploi Server**
```bash
# Upload the zip file to your Ploi server
scp nxoland-backend-*.zip root@46.202.194.218:/home/ploi/api.nxoland.com/
```

### **Step 3: Connect to Ploi Server**
```bash
# SSH into your Ploi server
ssh root@46.202.194.218
```

### **Step 4: Navigate to API Directory**
```bash
# Go to the API directory
cd /home/ploi/api.nxoland.com
```

### **Step 5: Remove Old Files**
```bash
# Remove old files (be careful!)
rm -rf *
# Or backup first:
# mv * ../backup-$(date +%Y%m%d-%H%M%S)/
```

### **Step 6: Extract New Backend**
```bash
# Extract the new backend files
unzip nxoland-backend-*.zip
mv nxoland-backend-*/* .
rm -rf nxoland-backend-*
```

### **Step 7: Set Permissions**
```bash
# Set proper permissions
chmod -R 755 /home/ploi/api.nxoland.com/
chmod 644 public/.htaccess
chmod 644 public/index.php
chmod 644 .env
```

### **Step 8: Run Deployment Script**
```bash
# Run the deployment script
chmod +x deploy-backend.sh
./deploy-backend.sh
```

### **Step 9: Test the API**
```bash
# Test the API endpoints
curl https://api.nxoland.com/api/ping
curl https://api.nxoland.com/api/products
```

---

## 🔧 **Alternative: Direct File Transfer**

### **Option 1: Using SCP**
```bash
# Copy backend directory directly
scp -r backend/* root@46.202.194.218:/home/ploi/api.nxoland.com/
```

### **Option 2: Using RSYNC**
```bash
# Sync backend files
rsync -avz --delete backend/ root@46.202.194.218:/home/ploi/api.nxoland.com/
```

### **Option 3: Using SFTP**
```bash
# Connect via SFTP
sftp root@46.202.194.218
# Then navigate to /home/ploi/api.nxoland.com/
# Upload files using put command
```

---

## 🗂️ **Files to Upload**

### **Backend Files Structure**
```
backend/
├── public/
│   ├── index.php
│   └── .htaccess
├── src/
│   ├── Controllers/
│   ├── Models/
│   ├── Database/
│   └── Auth/
├── vendor/
├── .env
├── composer.json
└── composer.lock
```

### **Key Files to Ensure Are Uploaded**
- ✅ `public/index.php` - Main entry point
- ✅ `public/.htaccess` - URL rewriting
- ✅ `src/Controllers/` - All controllers
- ✅ `src/Models/` - Database models
- ✅ `src/Database/` - Database connection
- ✅ `src/Auth/` - JWT authentication
- ✅ `vendor/` - Composer dependencies
- ✅ `.env` - Environment configuration
- ✅ `composer.json` - Dependencies

---

## 🧪 **Testing After Upload**

### **Backend API Tests**
```bash
# Health check
curl https://api.nxoland.com/api/ping

# Products endpoint
curl https://api.nxoland.com/api/products

# Authentication test
curl -X POST https://api.nxoland.com/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"user@nxoland.com","password":"password123"}'
```

### **Expected Responses**
```json
// /api/ping
{"ok": true}

// /api/products
{
  "status": "success",
  "message": "Products retrieved successfully",
  "data": [...],
  "meta": {...}
}

// /api/auth/login
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "user": {...},
    "token": "..."
  }
}
```

---

## 🔧 **Troubleshooting**

### **Common Issues**

#### **1. Permission Denied**
```bash
# Fix permissions
chmod -R 755 /home/ploi/api.nxoland.com/
chown -R ploi:ploi /home/ploi/api.nxoland.com/
```

#### **2. Composer Dependencies Missing**
```bash
# Install dependencies
cd /home/ploi/api.nxoland.com
composer install --no-dev --optimize-autoloader
```

#### **3. Database Connection Failed**
```bash
# Check database credentials in .env
nano .env
# Update DB_USERNAME and DB_PASSWORD
```

#### **4. 500 Internal Server Error**
```bash
# Check PHP error logs
tail -f /var/log/php_errors.log
# Check Apache error logs
tail -f /var/log/apache2/error.log
```

---

## 🎯 **Quick Commands Summary**

```bash
# 1. Create zip
./create-backend-zip.sh

# 2. Upload to server
scp nxoland-backend-*.zip root@46.202.194.218:/home/ploi/api.nxoland.com/

# 3. SSH to server
ssh root@46.202.194.218

# 4. Remove old files and extract new
cd /home/ploi/api.nxoland.com
rm -rf *
unzip nxoland-backend-*.zip
mv nxoland-backend-*/* .
rm -rf nxoland-backend-*

# 5. Set permissions
chmod -R 755 /home/ploi/api.nxoland.com/

# 6. Run deployment
chmod +x deploy-backend.sh
./deploy-backend.sh

# 7. Test API
curl https://api.nxoland.com/api/ping
```

---

## 🎉 **Success Indicators**

- ✅ **API responds** with `{"ok": true}` at `/api/ping`
- ✅ **Products endpoint** returns data
- ✅ **Authentication** works with real JWT tokens
- ✅ **No 500 errors** in logs
- ✅ **Database connection** successful

**Your backend will be live at `https://api.nxoland.com` once deployed!** 🚀
