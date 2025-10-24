# 🚀 Upload Backend to Ploi Server

## 📦 Package Created
- **File**: backend-deploy.zip
- **Created**: Fri 10/24/2025 14:35:13.95

## 🎯 Upload Methods

### Method 1: Ploi File Manager (Recommended)

1. **Access Ploi Dashboard**
   - Go to your Ploi dashboard
   - Navigate to your `api.nxoland.com` site
   - Go to "Files" or "File Manager"

2. **Upload Files**
   - Upload `backend-deploy.zip` to `/home/ploi/api.nxoland.com/`
   - Extract the zip file in the directory
   - Delete the zip file after extraction

3. **Set Permissions**
   - Make sure `public/` directory has 755 permissions
   - Make sure `public/index.php` has 644 permissions
   - Make sure `public/.htaccess` has 644 permissions

### Method 2: SSH Upload

1. **Connect via SSH**
   ```bash
   ssh ploi@46.202.194.218
   ```

2. **Upload Files**
   ```bash
   # From your local machine
   scp backend-deploy.zip ploi@46.202.194.218:/home/ploi/api.nxoland.com/
   ```

3. **Extract and Setup**
   ```bash
   # On the server
   cd /home/ploi/api.nxoland.com
   unzip backend-deploy.zip
   rm backend-deploy.zip
   chmod -R 755 public/
   chmod 644 public/.htaccess
   chmod 644 public/index.php
   ```

## 🔧 Post-Upload Steps

### 1. **Update Ploi Deploy Script**
Replace your current deploy script with:
```bash
#!/bin/bash
cd /home/ploi/api.nxoland.com
composer install --no-dev --optimize-autoloader
chmod -R 755 public/
chmod 644 public/.htaccess
chmod 644 public/index.php
echo "" | sudo -S service php8.4-fpm reload
echo "Backend API deployed successfully!"
```

### 2. **Set Environment Variables**
In Ploi dashboard, add:
- `APP_NAME=NXOLand API`
- `APP_ENV=production`
- `APP_DEBUG=false`
- `APP_URL=https://api.nxoland.com`
- `DB_CONNECTION=mysql`
- `DB_HOST=your_database_host`
- `DB_DATABASE=nxoland`
- `DB_USERNAME=your_username`
- `DB_PASSWORD=your_password`
- `JWT_SECRET=your_secret_key`

### 3. **Configure Health Check**
Set health check URL to: `https://api.nxoland.com/api/ping`

### 4. **Deploy**
Click "Deploy now" in Ploi dashboard

## 🧪 Testing

### Test API Endpoint:
```bash
curl https://api.nxoland.com/api/ping
```
**Expected response:** `{"ok": true}`

### Test Other Endpoints:
```bash
curl https://api.nxoland.com/api/products
curl https://api.nxoland.com/api/members
```

## 🎉 Success!

Once uploaded and deployed:
- ✅ Backend files in correct location
- ✅ Composer dependencies installed
- ✅ API endpoints responding
- ✅ CORS headers working
- ✅ Ready for frontend connection

Your backend will be available at `https://api.nxoland.com`! 🚀
