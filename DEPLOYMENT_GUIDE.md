# 🚀 **NXOLand Complete Deployment Guide**

## 📋 **Deployment Scripts Overview**

### **1. `deploy-backend.sh`** - Backend Only
- Deploys PHP backend to Ploi server
- Sets up database, JWT authentication, and API endpoints
- **Run on**: Ploi server

### **2. `deploy-frontend.sh`** - Frontend Only  
- Builds React frontend for production
- Creates optimized build in `frontend/dist/`
- **Run on**: Local machine or build server

### **3. `deploy-both.sh`** - Complete Deployment
- Deploys both backend and frontend
- **Run on**: Local machine (uploads to servers)

---

## 🔧 **Backend Deployment (Ploi Server)**

### **Step 1: Upload Backend Files**
```bash
# Upload all backend files to Ploi server
# Place them in: /home/ploi/api.nxoland.com/
```

### **Step 2: Run Backend Deployment**
```bash
# On the Ploi server
cd /home/ploi/api.nxoland.com
chmod +x deploy-backend.sh
./deploy-backend.sh
```

### **Step 3: Update Database Credentials**
```bash
# Edit .env file with your database credentials
nano .env

# Update these values:
DB_USERNAME=your_actual_username
DB_PASSWORD=your_actual_password
```

### **Step 4: Test Backend**
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

---

## 🌐 **Frontend Deployment (Web Server)**

### **Step 1: Build Frontend**
```bash
# On your local machine
chmod +x deploy-frontend.sh
./deploy-frontend.sh
```

### **Step 2: Upload Build Files**
```bash
# Upload all files from frontend/dist/ to your web server
# Make sure index.html is in the root of your web directory
```

### **Step 3: Configure Environment**
```bash
# Ensure your web server has the correct environment variables
VITE_API_BASE_URL=https://api.nxoland.com
VITE_APP_NAME=nxoland
VITE_APP_ENV=production
```

### **Step 4: Test Frontend**
```bash
# Local preview
npm run preview

# Production test
curl https://nxoland.com
```

---

## 🚀 **Complete Deployment (Both)**

### **Option 1: Automated Deployment**
```bash
# Run complete deployment script
chmod +x deploy-both.sh
./deploy-both.sh
```

### **Option 2: Manual Step-by-Step**
```bash
# 1. Deploy backend
chmod +x deploy-backend.sh
./deploy-backend.sh

# 2. Deploy frontend  
chmod +x deploy-frontend.sh
./deploy-frontend.sh

# 3. Upload files to servers
# 4. Test both endpoints
```

---

## 🧪 **Testing Commands**

### **Backend API Tests**
```bash
# Health check
curl https://api.nxoland.com/api/ping

# Products list
curl https://api.nxoland.com/api/products

# User registration
curl -X POST https://api.nxoland.com/api/auth/register \
  -H 'Content-Type: application/json' \
  -d '{"name":"Test User","email":"test@example.com","password":"password123","password_confirmation":"password123"}'

# User login
curl -X POST https://api.nxoland.com/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"user@nxoland.com","password":"password123"}'
```

### **Frontend Tests**
```bash
# Local development
npm run dev

# Production preview
npm run preview

# Production build
npm run build
```

---

## 🔧 **Environment Configuration**

### **Backend (.env)**
```env
APP_NAME=NXOLand API
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.nxoland.com

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=your_username
DB_PASSWORD=your_password

# JWT Configuration
JWT_SECRET=your_jwt_secret_key_change_in_production_2024
JWT_ALGORITHM=HS256

# CORS Configuration
CORS_ALLOWED_ORIGINS=https://nxoland.com,https://www.nxoland.com
```

### **Frontend (.env)**
```env
VITE_API_BASE_URL=https://api.nxoland.com
VITE_APP_NAME=nxoland
VITE_APP_ENV=production
VITE_AUTH_TOKEN_KEY=auth_token
VITE_SESSION_TIMEOUT=60
VITE_API_TIMEOUT=30000
```

---

## 📁 **File Structure After Deployment**

### **Backend (Ploi Server)**
```
/home/ploi/api.nxoland.com/
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
└── composer.json
```

### **Frontend (Web Server)**
```
your-web-server/
├── index.html
├── assets/
│   ├── index-[hash].js
│   └── index-[hash].css
└── other-static-files
```

---

## 🎯 **Deployment Checklist**

### **Backend Checklist**
- [ ] Upload all backend files to Ploi server
- [ ] Run `deploy-backend.sh` script
- [ ] Update database credentials in `.env`
- [ ] Test API endpoints
- [ ] Verify JWT authentication works

### **Frontend Checklist**
- [ ] Run `deploy-frontend.sh` script
- [ ] Upload `dist/` contents to web server
- [ ] Configure environment variables
- [ ] Test frontend locally and in production
- [ ] Verify API connections work

### **Integration Checklist**
- [ ] Backend API responds correctly
- [ ] Frontend can connect to backend
- [ ] Authentication flow works end-to-end
- [ ] All features function properly
- [ ] No console errors in production

---

## 🚨 **Troubleshooting**

### **Backend Issues**
- **Database connection failed**: Check credentials in `.env`
- **Composer errors**: Run `composer install` manually
- **Permission errors**: Check file permissions with `chmod`

### **Frontend Issues**
- **Build fails**: Check Node.js version and dependencies
- **API connection fails**: Verify `VITE_API_BASE_URL` is correct
- **CORS errors**: Check backend CORS configuration

### **Integration Issues**
- **Authentication not working**: Verify JWT secret matches
- **API calls failing**: Check network connectivity and URLs
- **CORS errors**: Update backend CORS allowed origins

---

## 🎉 **Success Indicators**

### **Backend Success**
- ✅ `curl https://api.nxoland.com/api/ping` returns `{"ok":true}`
- ✅ `curl https://api.nxoland.com/api/products` returns product data
- ✅ Authentication endpoints work with real data

### **Frontend Success**
- ✅ Frontend loads without errors
- ✅ API calls work without CORS issues
- ✅ Authentication flow completes successfully
- ✅ All features function properly

**Your NXOLand application is now fully deployed and ready for production!** 🚀