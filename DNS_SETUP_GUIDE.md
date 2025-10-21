# 🌐 DNS Setup Guide - Fix "Refused to Connect"

Your deployment is working, but your domain isn't pointing to your server yet.

---

## 🔍 **Quick Diagnosis:**

Run this to check your server:
```bash
# Download diagnostic script
wget https://raw.githubusercontent.com/Netrohub/Nexo/main/troubleshoot-connection.sh
chmod +x troubleshoot-connection.sh
sudo ./troubleshoot-connection.sh
```

---

## 🎯 **The Problem:**

- ✅ **Your server is working** (deployment successful)
- ✅ **Files are deployed** (coming soon page ready)
- ❌ **Domain not pointing to server** (DNS issue)

---

## 🔧 **Solution: Configure DNS**

### **Step 1: Get Your Server IP**

```bash
# Get your server IP
curl ifconfig.me
# OR
curl ipinfo.io/ip
```

**Example output:** `123.456.789.012`

### **Step 2: Update DNS Records**

Go to your domain registrar (GoDaddy, Namecheap, Cloudflare, etc.) and add these DNS records:

#### **A Record (Main Domain):**
```
Type: A
Name: @
Value: YOUR_SERVER_IP
TTL: 300 (5 minutes)
```

#### **CNAME Record (WWW):**
```
Type: CNAME
Name: www
Value: nxoland.com
TTL: 300 (5 minutes)
```

---

## 📋 **Step-by-Step for Popular Registrars:**

### **GoDaddy:**
1. Login to GoDaddy
2. Go to **"My Products"** → **"DNS"**
3. Click **"Manage"** next to your domain
4. Add A record: `@` → `YOUR_SERVER_IP`
5. Add CNAME record: `www` → `nxoland.com`
6. Save changes

### **Namecheap:**
1. Login to Namecheap
2. Go to **"Domain List"** → **"Manage"**
3. Go to **"Advanced DNS"** tab
4. Add A record: `@` → `YOUR_SERVER_IP`
5. Add CNAME record: `www` → `nxoland.com`
6. Save changes

### **Cloudflare:**
1. Login to Cloudflare
2. Select your domain
3. Go to **"DNS"** → **"Records"**
4. Add A record: `@` → `YOUR_SERVER_IP`
5. Add CNAME record: `www` → `nxoland.com`
6. Save changes

---

## ⏱️ **DNS Propagation:**

After updating DNS:
- **Wait 5-10 minutes** for changes to take effect
- **Maximum 24 hours** for full propagation worldwide
- **Test with:** `nslookup nxoland.com`

---

## 🧪 **Test Your Setup:**

### **1. Test Server Direct Access:**
```bash
# Test with your server IP
curl -I http://YOUR_SERVER_IP/
# Should return: HTTP/1.1 200 OK
```

### **2. Test Domain DNS:**
```bash
# Check if domain points to your server
nslookup nxoland.com
# Should show your server IP

# Test domain access
curl -I http://nxoland.com/
# Should return: HTTP/1.1 200 OK
```

### **3. Test in Browser:**
- **http://YOUR_SERVER_IP/** ← Should work immediately
- **http://nxoland.com/** ← Should work after DNS propagation

---

## 🔍 **Troubleshooting:**

### **If Server IP Test Fails:**
```bash
# Check if Nginx is running
sudo systemctl status nginx

# Check if site is configured
ls -la /etc/nginx/sites-enabled/

# Check Nginx logs
sudo tail -f /var/log/nginx/error.log
```

### **If DNS Test Fails:**
```bash
# Check DNS propagation
dig nxoland.com
nslookup nxoland.com

# Wait longer for propagation
# Try different DNS servers: 8.8.8.8, 1.1.1.1
```

---

## ✅ **Quick Commands:**

```bash
# Get server IP
SERVER_IP=$(curl -s ifconfig.me)
echo "Your server IP: $SERVER_IP"

# Test server
curl -I http://$SERVER_IP/

# Test domain
curl -I http://nxoland.com/

# Check DNS
nslookup nxoland.com
```

---

## 🎯 **Expected Results:**

### **Working Setup:**
```bash
$ curl -I http://YOUR_SERVER_IP/
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/html

$ curl -I http://nxoland.com/
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/html
```

### **Your Coming Soon Page Should Show:**
- ✅ **NEXO logo** with gradient colors
- ✅ **"Coming Soon"** title
- ✅ **Language switcher** (EN/AR)
- ✅ **Discord button**
- ✅ **Animated stars** background

---

## 🚀 **Next Steps After DNS is Fixed:**

1. **Enable SSL** (Let's Encrypt)
2. **Test on mobile devices**
3. **Share your coming soon page**
4. **Collect Discord signups**

---

## 📞 **Still Having Issues?**

Run the diagnostic script:
```bash
wget https://raw.githubusercontent.com/Netrohub/Nexo/main/troubleshoot-connection.sh
chmod +x troubleshoot-connection.sh
sudo ./troubleshoot-connection.sh
```

**The script will tell you exactly what's wrong and how to fix it!** 🔧
