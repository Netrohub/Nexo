# 🎯 Smart Deployment Guide - Coming Soon vs Full App

Deploy your NXOLand project with environment-based mode switching!

---

## 🚀 **How It Works:**

Set one environment variable to switch between:
- **Coming Soon Page** (`VITE_COMING_SOON_MODE=true`)
- **Full React App** (`VITE_COMING_SOON_MODE=false`)

---

## ⚙️ **Setup (One Time):**

### **Step 1: Setup Environment**
```bash
# Download and run setup script
wget https://raw.githubusercontent.com/Netrohub/Nexo/main/setup-env.sh
chmod +x setup-env.sh
sudo ./setup-env.sh
```

**This will:**
- ✅ Create `.env` file
- ✅ Ask for your preferences
- ✅ Configure API settings
- ✅ Set deployment mode

---

## 🎯 **Deploy Scripts:**

### **Smart Deploy (Recommended):**
```bash
# Download smart deploy script
wget https://raw.githubusercontent.com/Netrohub/Nexo/main/smart-deploy.sh
chmod +x smart-deploy.sh

# Deploy (automatically detects mode from .env)
sudo ./smart-deploy.sh
```

### **Manual Deploy Scripts:**

**Coming Soon Only:**
```bash
#!/bin/bash
echo "🚀 Deploying Coming Soon Page"
git pull origin main
chmod 644 public/index.html
chmod 755 public/
echo "✅ Coming soon page deployed!"
```

**Full React App:**
```bash
#!/bin/bash
echo "🚀 Deploying Full React App"
git pull origin main
npm ci --production=false
npm run build
rm -rf public/*
cp -r dist/* public/
chmod -R 755 public/
echo "✅ Full app deployed!"
```

---

## 🔄 **Mode Switching:**

### **Switch to Coming Soon:**
```bash
# Edit .env file
nano .env

# Change this line:
VITE_COMING_SOON_MODE=true

# Deploy
sudo ./smart-deploy.sh
```

### **Switch to Full App:**
```bash
# Edit .env file
nano .env

# Change this line:
VITE_COMING_SOON_MODE=false

# Deploy
sudo ./smart-deploy.sh
```

---

## 📋 **Environment Variables:**

### **Deployment Mode:**
```env
# Coming Soon Page (default for launch)
VITE_COMING_SOON_MODE=true

# Full React App (when backend is ready)
VITE_COMING_SOON_MODE=false
```

### **API Configuration:**
```env
# Your Laravel backend URL
VITE_API_BASE_URL=https://api.nxoland.com/api

# Use mock API (for development)
VITE_MOCK_API=true
```

### **Analytics:**
```env
# Your Google Analytics ID
VITE_GA_TRACKING_ID=G-23N0Q9P0S9
VITE_ENABLE_ANALYTICS=true
```

### **Security:**
```env
# Cloudflare Turnstile
VITE_TURNSTILE_SITE_KEY=your-site-key
VITE_ENABLE_TURNSTILE=true
```

---

## 🎯 **Deployment Scenarios:**

### **Scenario 1: Launch Coming Soon**
```bash
# 1. Setup environment
sudo ./setup-env.sh
# Choose: Coming Soon mode

# 2. Deploy
sudo ./smart-deploy.sh
# Result: Coming soon page live
```

### **Scenario 2: Switch to Full App**
```bash
# 1. Edit .env
nano .env
# Change: VITE_COMING_SOON_MODE=false

# 2. Deploy
sudo ./smart-deploy.sh
# Result: Full marketplace live
```

### **Scenario 3: Back to Coming Soon**
```bash
# 1. Edit .env
nano .env
# Change: VITE_COMING_SOON_MODE=true

# 2. Deploy
sudo ./smart-deploy.sh
# Result: Coming soon page again
```

---

## 🔧 **Ploi Integration:**

### **In Ploi Dashboard:**

**1. Repository Tab:**
- Provider: GitHub
- Repository: Netrohub/Nexo
- Branch: main

**2. Deploy Script:**
```bash
#!/bin/bash
cd $PLOI_SITE_DIRECTORY
git pull origin main

# Check environment mode
if grep -q "VITE_COMING_SOON_MODE=true" .env; then
    echo "🚀 Deploying Coming Soon Page"
    chmod 644 public/index.html
    chmod 755 public/
    echo "✅ Coming soon page deployed!"
else
    echo "🚀 Deploying Full React App"
    npm ci --production=false
    npm run build
    rm -rf public/*
    cp -r dist/* public/
    chmod -R 755 public/
    echo "✅ Full app deployed!"
fi
```

**3. Environment Variables (in Ploi):**
```
VITE_COMING_SOON_MODE=true
VITE_API_BASE_URL=https://api.nxoland.com/api
VITE_GA_TRACKING_ID=G-23N0Q9P0S9
```

---

## 📊 **File Structure:**

```
nxoland.com/
├── .env                    ← Environment configuration
├── public/
│   ├── index.html         ← Coming soon page
│   └── assets/            ← Built React app (when deployed)
├── src/                   ← React source code
├── dist/                  ← Built React app
├── smart-deploy.sh        ← Smart deployment script
├── setup-env.sh           ← Environment setup
└── package.json
```

---

## 🎯 **Quick Commands:**

### **Setup (First Time):**
```bash
wget https://raw.githubusercontent.com/Netrohub/Nexo/main/setup-env.sh
chmod +x setup-env.sh
sudo ./setup-env.sh
```

### **Deploy (Any Time):**
```bash
wget https://raw.githubusercontent.com/Netrohub/Nexo/main/smart-deploy.sh
chmod +x smart-deploy.sh
sudo ./smart-deploy.sh
```

### **Switch Modes:**
```bash
# Edit .env
nano .env

# Change VITE_COMING_SOON_MODE=true/false

# Deploy
sudo ./smart-deploy.sh
```

---

## ✅ **Benefits:**

- ✅ **One-click mode switching**
- ✅ **No code changes needed**
- ✅ **Environment-based configuration**
- ✅ **Perfect for staging/production**
- ✅ **Easy A/B testing**
- ✅ **Quick rollbacks**

---

## 🎉 **Perfect for:**

- **Launch Phase**: Coming soon page
- **Development**: Full app with mock API
- **Production**: Full app with real API
- **Maintenance**: Back to coming soon
- **Testing**: Switch between modes

---

## 🚀 **Ready to Deploy!**

**Choose your deployment method:**
1. **Smart Deploy** (recommended)
2. **Manual Scripts**
3. **Ploi Integration**

**All methods support environment-based mode switching!** 🎯
