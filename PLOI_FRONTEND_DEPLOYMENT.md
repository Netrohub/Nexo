# 🚀 NXOLand Frontend Ploi Deployment Guide

## 📦 Package Ready
- **Build Directory**: `frontend/dist/`
- **Configuration**: `ploi-frontend.yml`
- **Created**: $(date)

## 🎯 Quick Deployment Steps

### 1. Connect to Ploi Dashboard
1. Go to [Ploi Dashboard](https://ploi.io)
2. Create a new site
3. Select "Static Site" as project type
4. Connect your Git repository

### 2. Configure Build Settings
- **Build Command**: `cd frontend && npm run build`
- **Output Directory**: `frontend/dist`
- **Node.js Version**: 18.x
- **Root Directory**: Leave empty (or set to project root)

### 3. Set Environment Variables
Add these in Ploi dashboard:
- `VITE_API_BASE_URL`: `https://api.nxoland.com`
- `VITE_COMING_SOON_MODE`: `false`
- `NODE_ENV`: `production`

### 4. Configure Domain
- **Domain**: `nxoland.com`
- **SSL**: Enable automatic SSL
- **CDN**: Enable if available

### 5. Deploy
- Click "Deploy" in Ploi dashboard
- Wait for build to complete
- Test your site at https://nxoland.com

## 🔧 Alternative: Manual Upload

If you prefer manual upload:

1. **Upload Files**
   - Upload the entire project to your server
   - Run `cd frontend && npm ci && npm run build`
   - Copy contents of `frontend/dist/` to your web root

2. **Configure Web Server**
   - Point document root to `frontend/dist` directory
   - Configure SPA routing (fallback to index.html)
   - Enable Gzip compression

## 📋 Post-Deployment Checklist

- [ ] Site accessible at https://nxoland.com
- [ ] API calls working (check browser network tab)
- [ ] SSL certificate installed
- [ ] CDN enabled (if available)
- [ ] Build artifacts in frontend/dist/ directory
- [ ] Environment variables set correctly
- [ ] No console errors in browser
- [ ] All routes working (SPA routing)

## 🧪 Testing Your Frontend

### 1. Basic Functionality
- Visit https://nxoland.com
- Check if the site loads without errors
- Test navigation between pages

### 2. API Integration
- Open browser developer tools
- Check Network tab for API calls
- Verify calls go to https://api.nxoland.com/
- Check for CORS errors

### 3. Performance
- Run Lighthouse audit
- Check page load speed
- Verify images and assets load correctly

## 🆘 Troubleshooting

### Build Failures
- Check Node.js version (should be 18+)
- Verify all dependencies installed
- Check for TypeScript errors
- Review build logs in Ploi dashboard

### API Connection Issues
- Verify VITE_API_BASE_URL is correct
- Check if backend API is running
- Test API endpoints directly
- Check CORS configuration

### Routing Issues
- Ensure SPA routing is configured
- Check if fallback to index.html is set
- Verify all routes are working

## 🎉 Success!

Once deployed, your React frontend will be available at:
- **Main Site**: https://nxoland.com
- **API Integration**: Connected to https://api.nxoland.com
- **Performance**: Optimized with CDN and caching
- **Security**: SSL enabled and secure

Your NXOLand marketplace frontend is ready for users! 🚀
