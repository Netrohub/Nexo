# NXOLand Database Setup Guide

## 🗄️ Database Options

### Option 1: Full-Stack with Database (Recommended)
**Best for:** Complete marketplace functionality

#### Requirements:
- MySQL 8.0+ database
- Laravel backend server
- React frontend (already deployed)

#### Setup Steps:
1. **Create MySQL Database:**
   ```sql
   -- Use the provided setup-mysql.sql
   mysql -u root -p < laravel-backend/setup-mysql.sql
   ```

2. **Deploy Laravel Backend:**
   - Upload `laravel-backend/` to your server
   - Configure `.env` with database credentials
   - Run migrations: `php artisan migrate`
   - Seed data: `php artisan db:seed`

3. **Update Frontend API URL:**
   ```
   VITE_API_BASE_URL=https://api.nxoland.com/api
   ```

#### Benefits:
- ✅ Complete marketplace functionality
- ✅ User authentication & profiles
- ✅ Product management
- ✅ Order processing
- ✅ Dispute resolution
- ✅ Admin panel

---

### Option 2: Frontend-Only (Current)
**Best for:** Coming soon page or demo

#### Current Setup:
- React frontend deployed on Ploi
- No database required
- Static content only

#### Benefits:
- ✅ Fast deployment
- ✅ No server maintenance
- ✅ Perfect for coming soon page
- ❌ No user accounts
- ❌ No product management
- ❌ No transactions

---

### Option 3: Hybrid (Coming Soon + Database)
**Best for:** Gradual launch

#### Setup:
1. Keep current frontend deployment
2. Set `VITE_COMING_SOON_MODE=true` initially
3. Deploy database when ready
4. Switch to `VITE_COMING_SOON_MODE=false`

---

## 🚀 Quick Database Setup

### For Production (Recommended):

1. **Get a MySQL database:**
   - **DigitalOcean Managed Database** ($15/month)
   - **AWS RDS** (pay-as-you-go)
   - **PlanetScale** (free tier available)
   - **Railway** (free tier available)

2. **Deploy Laravel Backend:**
   ```bash
   # Upload laravel-backend/ to your server
   # Configure .env with database credentials
   php artisan migrate
   php artisan db:seed
   ```

3. **Update Frontend:**
   ```
   VITE_API_BASE_URL=https://your-api-domain.com/api
   VITE_COMING_SOON_MODE=false
   ```

### For Development:

1. **Local MySQL:**
   ```bash
   # Install MySQL locally
   mysql -u root -p < laravel-backend/setup-mysql.sql
   ```

2. **Docker (Easiest):**
   ```bash
   # Use Docker Compose for local development
   docker-compose up -d mysql
   ```

---

## 📊 Database Schema Overview

Your database includes:
- **Users & Profiles** (authentication)
- **Products & Categories** (marketplace)
- **Orders & Cart** (e-commerce)
- **Disputes & Reviews** (trust & safety)
- **Admin Roles** (management)

---

## 🎯 Recommendation

**For immediate launch:** Keep current frontend-only setup with coming soon page

**For full marketplace:** Deploy database + Laravel backend

**For gradual launch:** Start with coming soon, add database later

---

## 💰 Cost Comparison

| Option | Monthly Cost | Features |
|--------|-------------|----------|
| Frontend Only | $5-10 | Coming soon page |
| + Database | $15-25 | Full marketplace |
| + CDN | $20-35 | Global performance |

Choose based on your launch timeline and budget!
