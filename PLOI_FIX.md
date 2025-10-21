# 🔧 Fix Ploi Deployment - "fatal: not a git repository"

## ❌ **The Error:**

```
fatal: not a git repository (or any of the parent directories): .git
```

This means the site directory in Ploi is **not initialized as a Git repository**.

---

## ✅ **Solution: Initialize Git in Ploi**

### **Method 1: Via Ploi Dashboard (Easiest)**

1. **Go to Ploi Dashboard**
2. **Select your site** (nxoland.com)
3. **Click "Repository"** tab
4. **Fill in:**
   ```
   Provider: GitHub
   Repository: Netrohub/Nexo
   Branch: main
   ```
5. **Click "Install Repository"**

This will:
- Clone the repo to your site directory
- Set up git properly
- Enable auto-deploy

---

### **Method 2: Via SSH (If Method 1 doesn't work)**

**Connect to your server via SSH:**

```bash
# In Ploi → Server → Click "SSH" button
# Or use your SSH client

# Navigate to site directory
cd /home/ploi/nxoland.com

# Initialize git
git init

# Add remote
git remote add origin https://github.com/Netrohub/Nexo.git

# Pull the code
git pull origin main

# Verify
git status
```

---

## 📝 **Correct Ploi Configuration:**

### **Site Settings:**

1. **General**
   - Domain: `nxoland.com`
   - Directory: `/` (not `/public`)
   - Web Directory: `public`

2. **Repository**
   - ✅ **Provider**: GitHub
   - ✅ **Repository**: `Netrohub/Nexo`
   - ✅ **Branch**: `main`
   - ✅ **Install Repository**: Click this!

3. **Deploy Script** (for Coming Soon page):
   ```bash
   # Option A: Just serve coming soon (no build)
   echo "Deploying coming soon page..."
   chmod 644 public/index.html
   echo "✅ Done!"
   ```

   **OR** (for full React app):
   ```bash
   # Option B: Build and deploy full app
   npm ci
   npm run build
   rm -rf public/*
   cp -r dist/* public/
   echo "✅ Deployment complete!"
   ```

---

## 🎯 **Step-by-Step Fix:**

### **1. In Ploi Dashboard:**

```
Sites → nxoland.com → Repository
```

### **2. Click "Install Repository"**

Fill in:
```
Provider: GitHub
Repository: Netrohub/Nexo
Branch: main
```

Click **"Install Repository"** button

### **3. Wait for Installation**

Ploi will:
- Clone your repo
- Set up git
- Initialize the directory

### **4. Update Deploy Script**

**For Coming Soon page only:**
```bash
echo "✅ Coming soon page ready!"
```

**For Full React App:**
```bash
npm ci --production=false
npm run build
rm -rf public/*
cp -r dist/* public/
chmod -R 755 public/
```

### **5. Deploy**

Click **"Deploy Now"**

---

## 🔍 **Verify Git is Working:**

After installing repository, check via SSH:

```bash
cd /home/ploi/nxoland.com
git status

# Should show:
# On branch main
# Your branch is up to date with 'origin/main'
```

---

## 📋 **Ploi Settings Checklist:**

### **General Tab:**
- [x] Domain: `nxoland.com`
- [x] Root Directory: `/`
- [x] Public Directory: `public`
- [x] System User: `ploi`

### **Repository Tab:**
- [ ] Click **"Install Repository"**
- [ ] Provider: **GitHub**
- [ ] Repository: **Netrohub/Nexo**
- [ ] Branch: **main**
- [ ] ✅ Repository installed successfully

### **Deploy Script Tab:**

**Choose one:**

**Coming Soon Only (Simple):**
```bash
#!/bin/bash
echo "✅ Coming soon page active"
chmod 644 public/index.html
```

**Full React App (Complete):**
```bash
#!/bin/bash
set -e

cd $PLOI_SITE_DIRECTORY

# Install dependencies
npm ci --production=false

# Build
npm run build

# Deploy
rm -rf public/*
cp -r dist/* public/
chmod -R 755 public/

echo "✅ Deployment complete!"
```

---

## 🌐 **After Repository is Installed:**

### **Enable Auto-Deploy:**

1. Ploi → Site → **"Deploy"** tab
2. Toggle **"Quick Deploy"** ON
3. This creates a GitHub webhook
4. Every push = auto deploy!

### **Manual Deploy:**

Click **"Deploy Now"** button anytime

---

## 🎯 **What Each Script Does:**

### **Coming Soon Script:**
- ✅ No build process
- ✅ Just serves `public/index.html`
- ✅ Super fast (5 seconds)
- ✅ Perfect for launching now

### **Full App Script:**
- ✅ Installs dependencies
- ✅ Builds React app
- ✅ Deploys to public/
- ✅ Takes 2-3 minutes
- ✅ Use when backend is ready

---

## 🆘 **If Still Getting Errors:**

### **Error: "fatal: not a git repository"**

**Fix:**
1. Ploi → Repository → **"Uninstall Repository"**
2. Wait 10 seconds
3. Click **"Install Repository"** again
4. Fill in GitHub details
5. Wait for success message

### **Error: "Permission denied"**

**Fix:**
```bash
# Via SSH
cd /home/ploi/nxoland.com
sudo chown -R ploi:ploi .
sudo chmod -R 755 .
```

### **Error: "npm: command not found"**

**Fix:**
1. Ploi → Server → **"Node.js"**
2. Install Node.js (version 22)
3. Restart deployment

---

## 📞 **Quick Help:**

### **Your Repository:**
```
https://github.com/Netrohub/Nexo.git
```

### **Your Files:**
- `public/index.html` ← Coming soon page
- `dist/` ← Built React app (after `npm run build`)

### **Ploi Deploy Script to Use:**

**RIGHT NOW (Coming Soon):**
```bash
chmod 644 public/index.html
echo "✅ Coming soon page live!"
```

**LATER (Full App):**
```bash
npm ci
npm run build
cp -r dist/* public/
```

---

## ✅ **Action Steps:**

1. **Go to Ploi Dashboard**
2. **Sites → nxoland.com → Repository**
3. **Click "Install Repository"**
4. **Enter:**
   - Provider: GitHub
   - Repository: Netrohub/Nexo
   - Branch: main
5. **Click "Install"**
6. **Wait for success**
7. **Click "Deploy Now"**

**Your coming soon page will be live!** 🎉

---

**The error will be gone once you install the repository in Ploi!** ✅
