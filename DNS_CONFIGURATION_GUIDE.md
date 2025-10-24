# DNS Configuration Guide for NXOLand
# Frontend: nxoland.com (Ploi) + Backend: api.nxoland.com (Hostinger)

## 🌐 Domain Setup Overview

| Service | Domain | Type | Provider | Purpose |
|---------|--------|------|----------|---------|
| **Frontend** | nxoland.com | Main Domain | Ploi | React application |
| **Backend** | api.nxoland.com | Subdomain | Hostinger | Laravel API |
| **WWW** | www.nxoland.com | Subdomain | Ploi | Redirect to main domain |

---

## 📋 Prerequisites

- Domain registered (nxoland.com)
- Ploi account for frontend hosting
- Hostinger account for backend hosting
- Access to domain DNS management

---

## 🔧 DNS Configuration Steps

### Step 1: Configure Main Domain (nxoland.com)

#### For Ploi Frontend:
```
Type: A
Name: @ (or leave blank)
Value: [Ploi Server IP]
TTL: 3600

Type: A  
Name: www
Value: [Ploi Server IP]
TTL: 3600
```

**Note:** The `@` record points the main domain (nxoland.com) to Ploi.

#### Get Ploi Server IP:
1. Login to Ploi dashboard
2. Go to your site settings
3. Look for "Server IP" or "IP Address"
4. Use this IP for your A records

### Step 2: Configure API Subdomain (api.nxoland.com)

#### For Hostinger Backend:
```
Type: A
Name: api
Value: [Hostinger Server IP]
TTL: 3600
```

**Note:** The `api` record creates the subdomain api.nxoland.com pointing to Hostinger.

#### Get Hostinger Server IP:
1. Login to Hostinger control panel
2. Go to "Advanced" → "DNS Zone Editor"
3. Look for your server IP address
4. Use this IP for your A record

### Step 3: CNAME Records (Optional but Recommended)

```
Type: CNAME
Name: api
Value: [your-hostinger-domain].hostinger.com
TTL: 3600
```

---

## 🚀 Complete DNS Configuration

### Option 1: Using Domain Registrar's DNS

If you manage DNS through your domain registrar:

```
# Main domain (nxoland.com) for frontend (Ploi)
@           A    [Ploi IP]     3600
www         A    [Ploi IP]     3600

# API subdomain (api.nxoland.com) for backend (Hostinger)  
api         A    [Hostinger IP] 3600

# Optional: CNAME for API subdomain
api         CNAME [hostinger-domain].hostinger.com 3600
```

**Domain Structure:**
- `nxoland.com` (main domain) → Ploi (frontend)
- `api.nxoland.com` (subdomain) → Hostinger (backend)
- `www.nxoland.com` (subdomain) → Ploi (redirects to main)

### Option 2: Using Cloudflare (Recommended)

If using Cloudflare for DNS management:

```
# Main domain for frontend (Ploi)
@           A    [Ploi IP]     Proxied
www         A    [Ploi IP]     Proxied

# API subdomain for backend (Hostinger)
api         A    [Hostinger IP] Proxied

# Optional: CNAME for API
api         CNAME [hostinger-domain].hostinger.com Proxied
```

**Cloudflare Benefits:**
- Free SSL certificates
- DDoS protection
- CDN acceleration
- Better performance

---

## 🔒 SSL Certificate Configuration

### For Ploi (Frontend):
- **Automatic**: Ploi handles SSL automatically
- **Domain**: nxoland.com, www.nxoland.com
- **Provider**: Let's Encrypt (free)

### For Hostinger (Backend):
- **Manual Setup**: Enable SSL in Hostinger control panel
- **Domain**: api.nxoland.com
- **Provider**: Let's Encrypt (free) or paid certificate

---

## 📊 DNS Propagation and Testing

### 1. Check DNS Propagation
```bash
# Check A records
nslookup nxoland.com
nslookup api.nxoland.com
nslookup www.nxoland.com

# Check with different DNS servers
dig @8.8.8.8 nxoland.com
dig @1.1.1.1 api.nxoland.com
```

### 2. Test Domain Resolution
```bash
# Test main domain
curl -I https://nxoland.com
curl -I https://www.nxoland.com

# Test API domain
curl -I https://api.nxoland.com
curl -I https://api.nxoland.com/api/health
```

### 3. Browser Testing
- Visit https://nxoland.com (should load React frontend)
- Visit https://api.nxoland.com (should load Laravel API)
- Check browser developer tools for CORS issues

---

## 🛠️ Common DNS Issues and Solutions

### Issue 1: Domain Not Resolving
**Symptoms:** "This site can't be reached" or "DNS_PROBE_FINISHED_NXDOMAIN"

**Solutions:**
1. Check DNS records are correct
2. Wait for propagation (up to 48 hours)
3. Clear DNS cache: `ipconfig /flushdns` (Windows) or `sudo dscacheutil -flushcache` (Mac)
4. Try different DNS servers (8.8.8.8, 1.1.1.1)

### Issue 2: Subdomain Not Working
**Symptoms:** api.nxoland.com not resolving

**Solutions:**
1. Verify A record for 'api' subdomain
2. Check TTL settings (lower for faster updates)
3. Ensure no conflicting CNAME records
4. Test with `nslookup api.nxoland.com`

### Issue 3: SSL Certificate Issues
**Symptoms:** "Not Secure" or certificate errors

**Solutions:**
1. Enable SSL in hosting control panels
2. Wait for certificate generation (up to 24 hours)
3. Check certificate status in browser
4. Verify domain ownership

### Issue 4: CORS Errors
**Symptoms:** "Access to fetch at 'api.nxoland.com' from origin 'nxoland.com' has been blocked by CORS policy"

**Solutions:**
1. Configure CORS in Laravel backend
2. Update CORS_ALLOWED_ORIGINS in .env
3. Check .htaccess headers
4. Verify both domains use HTTPS

---

## 📋 DNS Configuration Checklist

### Before Deployment:
- [ ] Domain registered and active
- [ ] Ploi account set up
- [ ] Hostinger account set up
- [ ] DNS management access available

### DNS Records Setup:
- [ ] A record for @ (nxoland.com) → Ploi IP
- [ ] A record for www → Ploi IP  
- [ ] A record for api → Hostinger IP
- [ ] TTL set to 3600 (1 hour)

### SSL Configuration:
- [ ] SSL enabled on Ploi (automatic)
- [ ] SSL enabled on Hostinger
- [ ] Both domains use HTTPS
- [ ] Certificates valid and trusted

### Testing:
- [ ] nxoland.com resolves and loads
- [ ] www.nxoland.com redirects to nxoland.com
- [ ] api.nxoland.com resolves and loads
- [ ] No CORS errors in browser console
- [ ] API endpoints responding correctly

---

## 🚀 Advanced DNS Configuration

### 1. Email Configuration (Optional)
```
Type: MX
Name: @
Value: mail.nxoland.com
Priority: 10
TTL: 3600
```

### 2. SPF Record (Email Security)
```
Type: TXT
Name: @
Value: "v=spf1 include:_spf.google.com ~all"
TTL: 3600
```

### 3. DKIM Record (Email Authentication)
```
Type: TXT
Name: default._domainkey
Value: [DKIM key from your email provider]
TTL: 3600
```

### 4. DMARC Record (Email Policy)
```
Type: TXT
Name: _dmarc
Value: "v=DMARC1; p=quarantine; rua=mailto:dmarc@nxoland.com"
TTL: 3600
```

---

## 💰 Cost Breakdown

| Service | Cost | Notes |
|---------|------|-------|
| **Domain Registration** | $10-15/year | nxoland.com |
| **Ploi Hosting** | $5-15/month | Frontend hosting |
| **Hostinger Hosting** | $3-10/month | Backend hosting |
| **SSL Certificates** | $0 | Let's Encrypt (free) |
| **DNS Management** | $0 | Included with domain |
| **Total Monthly** | **$8-25** | Complete setup |

---

## 🎯 Post-DNS Configuration Steps

### 1. Deploy Frontend to Ploi
- Connect repository to Ploi
- Configure build settings
- Set environment variables
- Deploy and test

### 2. Deploy Backend to Hostinger
- Upload Laravel files
- Configure database
- Set environment variables
- Test API endpoints

### 3. Final Testing
- Test both domains load correctly
- Verify SSL certificates
- Check API integration
- Test CORS functionality

---

## 🆘 Troubleshooting Commands

### Check DNS Resolution:
```bash
# Windows
nslookup nxoland.com
nslookup api.nxoland.com

# Linux/Mac
dig nxoland.com
dig api.nxoland.com
```

### Test HTTP/HTTPS:
```bash
# Test main domain
curl -I https://nxoland.com
curl -I http://nxoland.com

# Test API domain
curl -I https://api.nxoland.com
curl -I http://api.nxoland.com
```

### Check SSL Certificate:
```bash
# Check certificate details
openssl s_client -connect nxoland.com:443 -servername nxoland.com
openssl s_client -connect api.nxoland.com:443 -servername api.nxoland.com
```

---

## 🎉 Success!

Once DNS is configured correctly:

✅ **Frontend**: https://nxoland.com (React app on Ploi)  
✅ **Backend**: https://api.nxoland.com (Laravel API on Hostinger)  
✅ **SSL**: Both domains secured with HTTPS  
✅ **CORS**: Properly configured for cross-origin requests  
✅ **Performance**: Optimized with CDN and caching  

Your NXOLand marketplace is ready for users! 🚀
