# Nexo Deployment Scripts Guide

## Overview
This repository contains comprehensive deployment scripts for the Nexo full-stack application, including React frontend and Laravel backend deployment options.

## Available Scripts

### 1. Full Stack Deployment (`deploy-full.sh`)
**Purpose**: Deploy both React frontend and Laravel backend
**Platform**: Linux/Mac
**Usage**:
```bash
# Deploy everything
./deploy-full.sh

# Deploy only frontend
./deploy-full.sh --frontend-only

# Deploy only backend
./deploy-full.sh --backend-only

# Deploy with Nginx configuration
./deploy-full.sh --with-nginx

# Deploy with cleanup
./deploy-full.sh --cleanup
```

### 2. Frontend Only (`deploy-frontend.sh`)
**Purpose**: Deploy React/Vite frontend application
**Platform**: Linux/Mac
**Usage**:
```bash
# Basic deployment
./deploy-frontend.sh

# Deploy to specific path
./deploy-frontend.sh --deploy-path /var/www/html

# Enable coming soon mode
./deploy-frontend.sh --coming-soon

# Set custom API URL
./deploy-frontend.sh --api-url https://api.example.com/api

# Create deployment package
./deploy-frontend.sh --create-package
```

### 3. Backend Only (`deploy-backend.sh`)
**Purpose**: Deploy Laravel API backend
**Platform**: Linux/Mac
**Usage**:
```bash
# Basic deployment
./deploy-backend.sh

# Set application URL
./deploy-backend.sh --app-url https://api.nxoland.com

# Set database configuration
./deploy-backend.sh --db-host localhost --db-database nexo_db

# Run database seeders
./deploy-backend.sh --run-seeders

# Setup queue worker
./deploy-backend.sh --setup-queue

# Setup cron jobs
./deploy-backend.sh --setup-cron
```

### 4. Windows Deployment (`deploy.bat`)
**Purpose**: Deploy React frontend on Windows
**Platform**: Windows
**Usage**:
```cmd
# Basic deployment
deploy.bat

# Deploy to specific path
deploy.bat --deploy-path C:\inetpub\wwwroot

# Enable coming soon mode
deploy.bat --coming-soon

# Set custom API URL
deploy.bat --api-url https://api.example.com/api

# Create deployment package
deploy.bat --create-package
```

## Environment Variables

### Frontend Variables
| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `VITE_API_BASE_URL` | Backend API URL | `https://api.nxoland.com/api` | `https://api.example.com/api` |
| `VITE_COMING_SOON_MODE` | Show coming soon page | `false` | `true` |
| `VITE_MOCK_API` | Use mock API | `false` | `false` |

### Backend Variables
| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `APP_URL` | Application URL | - | `https://api.nxoland.com` |
| `DB_HOST` | Database host | - | `localhost` |
| `DB_DATABASE` | Database name | - | `nexo_db` |
| `DB_USERNAME` | Database username | - | `nexo_user` |
| `DB_PASSWORD` | Database password | - | `secure_password` |

## Prerequisites

### For Frontend Deployment
- Node.js 18+ installed
- npm or yarn package manager
- Git (for cloning repository)

### For Backend Deployment
- PHP 8.2+ installed
- Composer 2+ installed
- MySQL/PostgreSQL database
- Web server (Apache/Nginx)

### For Full Stack Deployment
- All frontend prerequisites
- All backend prerequisites
- sudo/administrator access
- Web server configuration access

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/Netrohub/Nexo.git
cd Nexo
```

### 2. Make Scripts Executable (Linux/Mac)
```bash
chmod +x deploy-*.sh
```

### 3. Deploy Frontend Only
```bash
./deploy-frontend.sh --deploy-path /var/www/html
```

### 4. Deploy Backend Only
```bash
./deploy-backend.sh --app-url https://api.nxoland.com
```

### 5. Deploy Everything
```bash
./deploy-full.sh --with-nginx
```

## Advanced Configuration

### Nginx Configuration
The full deployment script can automatically configure Nginx:

```bash
# Set domain and web root
export DOMAIN=nxoland.com
export WEB_ROOT=/var/www/html
export NGINX_CONFIG=true

./deploy-full.sh --with-nginx
```

### Database Setup
For backend deployment with database:

```bash
# Set database configuration
export DB_HOST=localhost
export DB_DATABASE=nexo_db
export DB_USERNAME=nexo_user
export DB_PASSWORD=secure_password

./deploy-backend.sh --run-seeders
```

### Production Optimization
For production deployment:

```bash
# Frontend with optimization
./deploy-frontend.sh --api-url https://api.nxoland.com/api

# Backend with all optimizations
./deploy-backend.sh --app-url https://api.nxoland.com --setup-queue --setup-cron
```

## Troubleshooting

### Common Issues

#### 1. Node.js Version Error
**Error**: `Node.js version X detected. Recommended: 18+`
**Solution**: Update Node.js to version 18 or higher

#### 2. Composer Not Found
**Error**: `Composer is not installed`
**Solution**: Install Composer 2+ from https://getcomposer.org/

#### 3. Permission Denied
**Error**: `Permission denied` when setting file permissions
**Solution**: Run with sudo or ensure proper user permissions

#### 4. Database Connection Failed
**Error**: `Database connection failed`
**Solution**: Check database credentials and ensure database server is running

### Debug Mode
Enable debug mode for detailed output:

```bash
# Frontend debug
DEBUG=true ./deploy-frontend.sh

# Backend debug
DEBUG=true ./deploy-backend.sh
```

## Security Considerations

### File Permissions
- Frontend files: 755 (readable by web server)
- Backend files: 755 (readable by web server)
- Storage directories: 775 (writable by web server)
- Configuration files: 644 (readable by owner only)

### Environment Variables
- Never commit `.env` files to version control
- Use strong passwords for database connections
- Enable HTTPS in production
- Set secure session configurations

### Database Security
- Use strong database passwords
- Limit database user permissions
- Enable SSL for database connections
- Regular database backups

## Monitoring and Maintenance

### Health Checks
```bash
# Check frontend
curl -I https://nxoland.com

# Check backend API
curl -I https://api.nxoland.com/api/health

# Check database
php artisan migrate:status
```

### Log Monitoring
```bash
# Frontend logs (if using PM2)
pm2 logs nexo-frontend

# Backend logs
tail -f storage/logs/laravel.log

# Nginx logs
tail -f /var/log/nginx/access.log
```

### Backup Strategy
```bash
# Database backup
mysqldump -u username -p database_name > backup.sql

# File backup
tar -czf backup-$(date +%Y%m%d).tar.gz /var/www/html
```

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review the script logs for specific errors
3. Ensure all prerequisites are met
4. Verify environment variables are set correctly

## License

This deployment script is part of the Nexo project and follows the same license terms.
