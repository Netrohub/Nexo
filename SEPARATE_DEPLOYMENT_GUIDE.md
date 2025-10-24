# NXOLand Separate Deployment Guide
# Frontend: nxoland.com (Ploi) + Backend: api.nxoland.com (Hostinger)

## 🎯 Deployment Overview

This guide will help you deploy your NXOLand marketplace with:
- **Frontend**: React app on Ploi (nxoland.com - main domain)
- **Backend**: Laravel API on Hostinger (api.nxoland.com - subdomain)
- **Database**: MySQL on Hostinger
- **SSL**: Automatic for both domains

**Domain Structure:**
- `nxoland.com` (main domain) → Ploi (React frontend)
- `api.nxoland.com` (subdomain) → Hostinger (Laravel backend)

---

## 📋 Prerequisites

### Required Accounts:
- [ ] Ploi account (for frontend hosting)
- [ ] Hostinger account (for backend hosting)
- [ ] Domain registered (nxoland.com)
- [ ] Git repository access

### Required Tools:
- [ ] Node.js 18+ (for building frontend)
- [ ] Composer (for Laravel backend)
- [ ] Git (for version control)

---

## 🚀 Step-by-Step Deployment

### Phase 1: Prepare Your Code

#### 1.1 Frontend Preparation
```bash
# Build your React frontend
npm ci
npm run build

# Verify build output
ls -la dist/
```

#### 1.2 Backend Preparation
```bash
# Prepare Laravel backend
cd laravel-backend
composer install --no-dev --optimize-autoloader
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Phase 2: Deploy Backend to Hostinger

#### 2.1 Create Hostinger Package
```bash
# Run the Hostinger deployment script
./hostinger-deploy.sh
```

This creates:
- `nxoland-backend-hostinger.zip` - Ready to upload
- `HOSTINGER_DEPLOYMENT_INSTRUCTIONS.md` - Detailed instructions

#### 2.2 Upload to Hostinger
1. Login to Hostinger control panel
2. Go to File Manager
3. Navigate to `public_html` directory
4. Upload `nxoland-backend-hostinger.zip`
5. Extract the zip file
6. Move all files to `public_html` root

#### 2.3 Configure Database
1. Go to MySQL Databases in Hostinger
2. Create database: `nxoland_api`
3. Create user: `nxoland_user`
4. Set strong password
5. Grant all privileges

#### 2.4 Update Environment Variables
Edit `.env` file in `public_html`:
```env
DB_DATABASE=nxoland_api
DB_USERNAME=nxoland_user
DB_PASSWORD=[your_secure_password]
APP_URL=https://api.nxoland.com
```

#### 2.5 Run Database Migrations
```bash
# If SSH access available
cd public_html
php artisan migrate
```

#### 2.6 Test Backend
Visit: https://api.nxoland.com/api/health

### Phase 3: Deploy Frontend to Ploi

#### 3.1 Create Ploi Package
```bash
# Run the Ploi deployment script
./ploi-deploy.sh
```

This creates:
- `dist/` directory with built frontend
- `ploi.yml` configuration file
- `PLOI_DEPLOYMENT_INSTRUCTIONS.md` - Detailed instructions

#### 3.2 Connect to Ploi
1. Login to Ploi dashboard
2. Create new site
3. Connect your Git repository
4. Select "Static Site" as project type

#### 3.3 Configure Build Settings
- **Build Command**: `npm run build`
- **Output Directory**: `dist`
- **Node.js Version**: 18.x

#### 3.4 Set Environment Variables
```
VITE_API_BASE_URL=https://api.nxoland.com/api
VITE_COMING_SOON_MODE=false
VITE_MOCK_API=false
NODE_ENV=production
```

#### 3.5 Configure Domain
- **Domain**: nxoland.com
- **SSL**: Enable automatic SSL
- **CDN**: Enable if available

#### 3.6 Deploy and Test
1. Click "Deploy" in Ploi dashboard
2. Wait for build to complete
3. Test your site at https://nxoland.com

### Phase 4: Configure DNS

#### 4.1 DNS Records Setup
```
# Main domain (nxoland.com) for frontend (Ploi)
@           A    [Ploi Server IP]     3600
www         A    [Ploi Server IP]     3600

# API subdomain (api.nxoland.com) for backend (Hostinger)
api         A    [Hostinger Server IP] 3600
```

**Domain Structure:**
- `@` record = nxoland.com (main domain) → Ploi
- `www` record = www.nxoland.com (subdomain) → Ploi  
- `api` record = api.nxoland.com (subdomain) → Hostinger

#### 4.2 Get Server IPs
- **Ploi IP**: Check in Ploi dashboard → Site settings
- **Hostinger IP**: Check in Hostinger control panel → DNS Zone Editor

#### 4.3 Test DNS Resolution
```bash
nslookup nxoland.com
nslookup api.nxoland.com
```

---

## 🔧 Configuration Files

### Frontend Configuration (Ploi)
- **ploi.yml**: Ploi deployment configuration
- **.env.production**: Production environment variables
- **package.json**: Node.js dependencies
- **vite.config.ts**: Vite build configuration

### Backend Configuration (Hostinger)
- **.env**: Laravel environment variables
- **.htaccess**: Apache configuration
- **index.php**: Laravel entry point
- **composer.json**: PHP dependencies

---

## 🧪 Testing Your Deployment

### 1. Frontend Testing
- [ ] Visit https://nxoland.com
- [ ] Check if React app loads
- [ ] Test navigation between pages
- [ ] Verify no console errors

### 2. Backend Testing
- [ ] Visit https://api.nxoland.com
- [ ] Test API endpoints
- [ ] Check database connectivity
- [ ] Verify CORS configuration

### 3. Integration Testing
- [ ] Test API calls from frontend
- [ ] Check for CORS errors
- [ ] Verify authentication flow
- [ ] Test all major features

---

## 🛠️ Troubleshooting

### Common Issues:

#### Frontend Not Loading
**Symptoms:** "This site can't be reached" or blank page

**Solutions:**
1. Check DNS resolution: `nslookup nxoland.com`
2. Verify Ploi deployment status
3. Check build logs in Ploi dashboard
4. Ensure SSL certificate is active

#### API Not Responding
**Symptoms:** 500 error or "This site can't be reached"

**Solutions:**
1. Check Hostinger file permissions
2. Verify database connection
3. Check Laravel logs: `storage/logs/laravel.log`
4. Test API endpoints directly

#### CORS Errors
**Symptoms:** "Access to fetch at 'api.nxoland.com' from origin 'nxoland.com' has been blocked"

**Solutions:**
1. Update CORS_ALLOWED_ORIGINS in Laravel .env
2. Check .htaccess headers
3. Verify both domains use HTTPS
4. Test with browser developer tools

#### SSL Certificate Issues
**Symptoms:** "Not Secure" or certificate errors

**Solutions:**
1. Enable SSL in both hosting providers
2. Wait for certificate generation (up to 24 hours)
3. Check certificate status in browser
4. Verify domain ownership

---

## 📊 Performance Optimization

### Frontend Optimizations (Ploi)
- Enable CDN for static assets
- Configure caching headers
- Optimize images (WebP format)
- Minimize bundle size
- Use lazy loading

### Backend Optimizations (Hostinger)
- Enable OPcache if available
- Use database query caching
- Implement Redis if available
- Optimize database queries
- Use compression

---

## 💰 Cost Breakdown

| Service | Monthly Cost | Notes |
|---------|-------------|-------|
| **Ploi Hosting** | $5-15 | Frontend hosting |
| **Hostinger Hosting** | $3-10 | Backend hosting |
| **Domain** | $1-2 | nxoland.com |
| **SSL Certificates** | $0 | Let's Encrypt (free) |
| **Total** | **$9-27** | Complete marketplace |

---

## 🔒 Security Considerations

### Frontend Security (Ploi)
- HTTPS enforced
- Security headers configured
- CDN protection
- Regular updates

### Backend Security (Hostinger)
- Database security
- API authentication
- Input validation
- Rate limiting
- Regular backups

---

## 📋 Deployment Checklist

### Pre-Deployment:
- [ ] Code tested locally
- [ ] Environment variables configured
- [ ] Database schema ready
- [ ] SSL certificates planned

### Frontend Deployment:
- [ ] Repository connected to Ploi
- [ ] Build settings configured
- [ ] Environment variables set
- [ ] Domain configured
- [ ] SSL enabled
- [ ] CDN enabled (if available)

### Backend Deployment:
- [ ] Files uploaded to Hostinger
- [ ] Database created and configured
- [ ] Environment variables updated
- [ ] File permissions set
- [ ] SSL enabled
- [ ] API endpoints tested

### DNS Configuration:
- [ ] A records configured
- [ ] DNS propagation complete
- [ ] Both domains resolving
- [ ] SSL certificates active

### Final Testing:
- [ ] Frontend loads at https://nxoland.com
- [ ] Backend responds at https://api.nxoland.com
- [ ] API integration working
- [ ] No CORS errors
- [ ] All features functional

---

## 🎉 Success!

Your NXOLand marketplace is now live with:

✅ **Frontend**: https://nxoland.com (React app on Ploi)  
✅ **Backend**: https://api.nxoland.com (Laravel API on Hostinger)  
✅ **Database**: MySQL on Hostinger  
✅ **SSL**: Both domains secured  
✅ **Performance**: Optimized with CDN and caching  
✅ **Security**: Proper CORS and authentication  

**Your marketplace is ready for users!** 🚀

---

## 📞 Support and Maintenance

### Regular Maintenance:
- Monitor application logs
- Update dependencies regularly
- Backup database regularly
- Monitor performance metrics
- Check SSL certificate expiration

### Support Resources:
- Ploi documentation and support
- Hostinger support center
- Laravel documentation
- React documentation
- Community forums

### Emergency Procedures:
- Database backup and restore
- Code rollback procedures
- DNS failover options
- Monitoring and alerting setup
