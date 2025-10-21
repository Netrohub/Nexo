# 🚀 Deploy to Ploi - NXOLand Coming Soon Page

Complete guide to deploy your Coming Soon page and full marketplace on Ploi.

## 📋 What You Have:

1. ✅ **Coming Soon Page** - `public/index.html` (standalone)
2. ✅ **Full React App** - Complete marketplace (when ready to launch)
3. ✅ **GitHub Repository** - https://github.com/Netrohub/Nexo.git

---

## 🎯 Option 1: Coming Soon Page ONLY (Quick Launch)

Deploy just the coming soon page first, then upgrade to full app later.

### **Step 1: Build Static Coming Soon**

```bash
# In your NXOLand directory
npm run build
```

This creates a `dist/` folder with your built files.

### **Step 2: Login to Ploi**

1. Go to: https://ploi.io
2. Login to your account
3. Select your server

### **Step 3: Create New Site**

1. Click **"Sites"** → **"Add Site"**
2. **Domain**: `nexo.com` (or your domain)
3. **Web Directory**: `/public` (important!)
4. **Type**: Static HTML
5. Click **"Add Site"**

### **Step 4: Deploy Coming Soon Page**

**Method A: Git Deployment (Recommended)**

1. In Ploi site settings → **"Repository"**
2. **Provider**: GitHub
3. **Repository**: `Netrohub/Nexo`
4. **Branch**: `main`
5. **Deploy Script**:
   ```bash
   # No build needed, just serve the coming soon page
   cp public/index.html /home/ploi/nexo.com/public/index.html
   ```
6. Click **"Save & Deploy"**

**Method B: Manual Upload**

1. Copy `public/index.html` to your server
2. Via FTP/SFTP to: `/home/ploi/yourdomain.com/public/`
3. Done!

### **Step 5: Configure Nginx (if needed)**

Ploi usually handles this, but if needed:

```nginx
# Ploi → Site → Nginx Configuration
location / {
    try_files $uri $uri/ /index.html;
}
```

---

## 🚀 Option 2: Full React App Deployment

Deploy the complete marketplace application.

### **Step 1: Prepare for Production**

Update `.env` for production:

```env
# Disable mock API
VITE_MOCK_API=false

# Set production API URL
VITE_API_BASE_URL=https://api.yourdomain.com/api

# Production settings
VITE_APP_ENV=production
VITE_ENABLE_REACT_QUERY_DEVTOOLS=false
VITE_ENABLE_DEBUG_LOGS=false

# Your Google Analytics
VITE_GA_TRACKING_ID=G-23N0Q9P0S9

# Get real Turnstile keys from Cloudflare
VITE_TURNSTILE_SITE_KEY=your-production-key
```

### **Step 2: Build Production**

```bash
npm run build
```

Creates optimized production build in `dist/` folder.

### **Step 3: Create Site in Ploi**

1. **Sites** → **"Add Site"**
2. **Domain**: `nexo.com`
3. **Type**: Static site / Node.js
4. **Web Directory**: `/public`

### **Step 4: Setup Git Deployment**

**Repository Settings:**
```
Provider: GitHub
Repository: Netrohub/Nexo
Branch: main
```

**Deploy Script:**
```bash
cd /home/ploi/nexo.com

# Install dependencies
npm ci --production=false

# Build for production
npm run build

# Copy built files to public directory
cp -r dist/* public/

# Optional: Remove node_modules to save space
# rm -rf node_modules

echo "✅ Deployment complete!"
```

### **Step 5: Configure Nginx**

```nginx
# In Ploi → Site → Nginx Configuration

server {
    listen 80;
    listen [::]:80;
    server_name nexo.com www.nexo.com;
    root /home/ploi/nexo.com/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.html;

    charset utf-8;

    # Handle React Router (SPA)
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.html;

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

### **Step 6: Enable SSL**

1. In Ploi → Site → **SSL**
2. Click **"Enable Let's Encrypt"**
3. Wait for SSL certificate

### **Step 7: Setup Environment Variables (Optional)**

1. Ploi → Site → **"Environment"**
2. Add your variables:
   ```
   NODE_VERSION=22
   ```

---

## 🔄 Option 3: Coming Soon → Full App Migration

Start with coming soon, then upgrade when ready.

### **Phase 1: Coming Soon (Now)**

1. Deploy `public/index.html` as main page
2. Users see "Coming Soon" page
3. Collect Discord signups

### **Phase 2: Full Launch (Later)**

1. Update deploy script to build React app
2. Deploy full marketplace
3. Switch from `index.html` to React app

**Deploy Script for Migration:**
```bash
# Check if ready to launch
if [ -f ".env.production" ]; then
    # Full app
    npm ci
    npm run build
    cp -r dist/* public/
else
    # Coming soon
    cp public/index.html public/index.html
fi
```

---

## 📝 **Ploi Deploy Script (Complete)**

```bash
#!/bin/bash

cd /home/ploi/nexo.com

echo "🚀 Starting deployment..."

# Check Node version
node --version
npm --version

# Install dependencies
echo "📦 Installing dependencies..."
npm ci --production=false

# Build production
echo "🔨 Building production..."
npm run build

# Copy to public directory
echo "📁 Copying files to public..."
rm -rf public/*
cp -r dist/* public/

# Copy coming soon as backup
cp public/index.html public/coming-soon.html

# Set permissions
chmod -R 755 public/

echo "✅ Deployment complete!"
echo "🌐 Site available at: https://nexo.com"
```

---

## ⚙️ **Ploi Configuration:**

### **Site Settings:**

| Setting | Value |
|---------|-------|
| **Domain** | nexo.com |
| **Type** | Static Site / SPA |
| **Root** | `/public` |
| **PHP Version** | None (or if you have Laravel backend: 8.2+) |
| **Node Version** | 22.x |

### **Deploy Settings:**

| Setting | Value |
|---------|-------|
| **Auto Deploy** | ✅ Enabled (on push to main) |
| **Branch** | main |
| **Deploy Script** | See above |

---

## 🔒 **SSL Configuration:**

Ploi makes SSL easy:

1. **Site → SSL**
2. Click **"Enable Let's Encrypt"**
3. Auto-renews every 90 days

---

## 🌐 **Domain Configuration:**

### **DNS Settings (Point to Ploi):**

```
Type: A Record
Name: @
Value: [Your Ploi Server IP]

Type: A Record
Name: www
Value: [Your Ploi Server IP]
```

### **Get Server IP:**

Ploi → Server → **"IP Address"**

---

## 📊 **Performance Optimization:**

### **Enable Gzip Compression:**

Ploi usually enables this automatically, but verify:

```nginx
# In Nginx config
gzip on;
gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
```

### **Enable Browser Caching:**

Already included in the Nginx config above.

---

## 🧪 **Test Deployment:**

After deploying:

```bash
# Test if site is live
curl -I https://nexo.com

# Should return: 200 OK

# Test if coming soon page loads
curl https://nexo.com | grep "NEXO"

# Should return HTML with NEXO logo
```

---

## 🔄 **Auto-Deploy Setup:**

### **Enable GitHub Webhook:**

1. Ploi → Site → **"Repository"** → **"Enable Quick Deploy"**
2. This creates a webhook in GitHub
3. Every push to `main` = auto deploy!

**Test it:**
```bash
# Make a change
echo "# Update" >> README.md

# Commit and push
git add .
git commit -m "test: auto deploy"
git push origin main

# Watch Ploi deploy automatically!
```

---

## 📁 **File Structure on Server:**

```
/home/ploi/nexo.com/
├── public/               ← Your web root
│   ├── index.html       ← Coming soon page
│   ├── assets/          ← Built JS/CSS (after build)
│   └── ...
├── node_modules/
├── package.json
└── .env (created via Ploi)
```

---

## 🎯 **Quick Ploi Setup (Summary):**

```
1. Ploi → Add Site
   Domain: nexo.com
   Type: Static/SPA
   
2. Repository
   GitHub: Netrohub/Nexo
   Branch: main
   
3. Deploy Script:
   npm ci
   npm run build
   cp -r dist/* public/
   
4. SSL
   Enable Let's Encrypt
   
5. Deploy!
   Click "Deploy Now"
```

---

## 🆘 **Troubleshooting:**

### **Build fails on Ploi?**

**Check:**
- Node version (should be 22+)
- `package-lock.json` is committed
- `.env` exists on server

**Fix:**
```bash
# In deploy script, add:
export NODE_OPTIONS=--max_old_space_size=4096
npm run build
```

### **Routes don't work (404)?**

**Fix:** Update Nginx to handle SPA routing:
```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

### **Environment variables not loading?**

**Fix:** In Ploi → Site → Environment, add:
```
VITE_API_BASE_URL=your-value
```

---

## 📋 **Deployment Checklist:**

- [ ] Build locally works: `npm run build`
- [ ] Update .env for production
- [ ] Push to GitHub
- [ ] Create site in Ploi
- [ ] Connect GitHub repository
- [ ] Add deploy script
- [ ] Enable SSL
- [ ] Test deployment
- [ ] Verify site loads
- [ ] Test on mobile

---

## 🎉 **You're Ready!**

**Your coming soon page is in:** `public/index.html`

**To deploy on Ploi:**
1. Create site
2. Connect GitHub repo
3. Deploy!

**Your site will be live at:** `https://nexo.com` 🚀

---

**Need help with Ploi setup? Let me know which option you prefer!**
