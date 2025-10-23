# Ploi Deployment Guide for Nexo Frontend

## Problem
Ploi is trying to run Composer commands on a React/Vite project, which doesn't have a `composer.json` file.

## Solution
This is a **React/Vite frontend project**, not a PHP project. The Laravel backend is separate.

## Ploi Configuration

### 1. Project Type
- **Type**: Static Site (React/Vite)
- **NOT**: PHP/Laravel project

### 2. Build Commands
```bash
npm ci
npm run build
```

### 3. Environment Variables
```
VITE_API_BASE_URL=https://api.nxoland.com/api
VITE_COMING_SOON_MODE=false
VITE_MOCK_API=false
```

### 4. Build Output
- **Directory**: `dist/`
- **Public Path**: `dist/`

### 5. Node.js Version
- **Version**: 18.x

## Deployment Steps

### Option 1: Use Ploi Dashboard
1. Go to your site settings in Ploi
2. Change project type to "Static Site"
3. Set build command: `npm run build`
4. Set output directory: `dist`
5. Add environment variables above

### Option 2: Use Configuration Files
The project now includes:
- `ploi.yml` - Ploi configuration
- `deploy.sh` - Linux deployment script
- `deploy.bat` - Windows deployment script

## Important Notes

### ❌ Don't Use Composer
- This project doesn't use Composer
- No `composer.json` file needed
- No PHP dependencies

### ✅ Use Node.js/NPM
- Install Node.js 18+
- Use `npm ci` for dependencies
- Use `npm run build` for building

### 🔧 Laravel Backend
- The Laravel backend is in `laravel-backend/` directory
- Deploy it separately as a PHP project
- Use different domain/subdomain for API

## Troubleshooting

### Error: "Composer could not find composer.json"
**Solution**: Change project type to "Static Site" in Ploi dashboard

### Error: "Build failed"
**Solution**: 
1. Check Node.js version (18+)
2. Ensure all dependencies are installed
3. Check build logs for specific errors

### Error: "dist directory not found"
**Solution**: 
1. Verify `npm run build` completes successfully
2. Check if Vite build process runs without errors
3. Ensure all environment variables are set

## Environment Variables Reference

| Variable | Description | Example |
|----------|-------------|---------|
| `VITE_API_BASE_URL` | Backend API URL | `https://api.nxoland.com/api` |
| `VITE_COMING_SOON_MODE` | Show coming soon page | `false` |
| `VITE_MOCK_API` | Use mock API (production: false) | `false` |

## Deployment Checklist

- [ ] Project type set to "Static Site"
- [ ] Node.js 18+ installed
- [ ] Build command: `npm run build`
- [ ] Output directory: `dist`
- [ ] Environment variables configured
- [ ] Laravel backend deployed separately
- [ ] API URL points to backend
- [ ] Coming soon mode disabled for production
