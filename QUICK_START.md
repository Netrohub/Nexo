# 🚀 Quick Start Guide - NXOLand

Get up and running with the Nebula Marketplace frontend in 5 minutes!

## ⚡ Prerequisites

- Node.js 20+ (you have 22.20.0 ✅)
- npm or yarn
- Laravel backend running (for API calls)

## 📦 Installation

```bash
# 1. Install dependencies (if not done)
npm install

# 2. Configure environment
# Edit .env file with your Laravel API URL
VITE_API_BASE_URL=http://localhost:8000/api

# 3. Start development server
npm run dev

# 4. Open browser
# Visit http://localhost:8080
```

## 🎯 What's Working Right Now

### ✅ Fully Functional Pages

**Public Pages:**
- `/` - Homepage with stellar animations
- `/products` - Product listing with filters (API-ready)
- `/login` - Login with form validation (API-ready)
- `/register` - Registration with validation (API-ready)
- `/games` - Gaming marketplace
- `/leaderboard` - Top performers
- `/pricing` - Seller plans
- `/about` - About page

**Protected Pages (require login):**
- `/account/dashboard` - User dashboard
- `/account/profile` - Profile settings
- `/account/orders` - Order history
- `/account/wallet` - Wallet management
- `/cart` - Shopping cart
- `/checkout` - Checkout process

**Seller Pages (require seller role):**
- `/seller/dashboard` - Seller dashboard with metrics
- `/seller/products` - Manage products
- `/seller/products/create` - Create new product
- `/seller/orders` - Seller orders
- `/seller/list/gaming` - List gaming account
- `/seller/list/social` - List social account

**Dispute Pages:**
- `/disputes` - View disputes
- `/disputes/create` - Create new dispute
- `/disputes/:id` - Dispute details

**Admin Pages (require admin role):**
- `/admin/disputes` - Manage all disputes

### 🎨 Features Available

1. **Authentication**
   - Login/Register with validation
   - JWT token management
   - Persistent sessions
   - Role-based access control

2. **API Integration**
   - All endpoints configured
   - React Query caching
   - Error handling
   - Loading states

3. **UI/UX**
   - Stellar dark theme
   - Glassmorphism effects
   - Smooth animations
   - Responsive design

4. **Internationalization**
   - English/Arabic languages
   - RTL support
   - Language switcher in navbar
   - 400+ translations

5. **Performance**
   - Lazy loading (most routes)
   - Query prefetching
   - Optimized animations
   - Fast page loads

## 🔧 Testing the Integration

### 1. Test Authentication Flow

```bash
# Start the dev server
npm run dev

# Navigate to http://localhost:8080/login
# Try logging in (will call your Laravel API)
```

### 2. Test Product Listing

```bash
# Navigate to http://localhost:8080/products
# The page will fetch products from your Laravel API
# Apply filters and see the requests in Network tab
```

### 3. Test Protected Routes

```bash
# Without logging in, try to access:
# http://localhost:8080/account/dashboard
# You should be redirected to /login
```

### 4. Test Language Switching

```bash
# Click the globe icon in navbar
# Switch between English and Arabic
# See the layout flip for RTL
```

## 🛠 Laravel Backend Setup

### Minimum Required Endpoints

```php
// routes/api.php

// Authentication
POST   /api/auth/login
POST   /api/auth/register  
POST   /api/auth/logout
GET    /api/auth/me

// Products
GET    /api/products
GET    /api/products/{id}
GET    /api/products?featured=true

// Cart
GET    /api/cart
POST   /api/cart
PUT    /api/cart/{id}
DELETE /api/cart/{id}

// Orders
GET    /api/orders
POST   /api/orders
GET    /api/orders/{id}
```

### CORS Configuration

```php
// config/cors.php
'paths' => ['api/*'],
'allowed_origins' => ['http://localhost:8080'],
'supports_credentials' => true,
```

### Test API Response Format

```json
// GET /api/products
{
  "data": [
    {
      "id": 1,
      "title": "Product Name",
      "description": "Product description",
      "price": 99.99,
      "discount_price": 79.99,
      "category": "Gaming",
      "images": ["url1.jpg", "url2.jpg"],
      "rating": 4.5,
      "reviews_count": 120,
      "featured": true,
      "seller": {
        "id": 1,
        "name": "Seller Name",
        "verified": true
      }
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 100,
    "per_page": 12
  }
}
```

## 📝 Common Issues & Solutions

### Issue: API calls failing

**Solution:**
1. Check `.env` has correct API URL
2. Verify Laravel is running
3. Check CORS is configured
4. Open browser DevTools → Network tab

### Issue: Authentication not working

**Solution:**
1. Verify `/api/auth/login` endpoint exists
2. Check it returns JWT token
3. Verify token is saved in localStorage
4. Check `/api/auth/me` is protected

### Issue: RTL not working

**Solution:**
1. Click language switcher
2. Check `<html>` has `dir="rtl"` and `lang="ar"`
3. Clear browser cache
4. Refresh page

### Issue: Images not loading

**Solution:**
1. Check image URLs in API responses
2. Update CORS to allow image requests
3. Use placeholder images for testing

## 🎓 Developer Tools

### Browser DevTools

```javascript
// Check authentication status
localStorage.getItem('auth_token')

// Check React Query cache
window.__REACT_QUERY_DEVTOOLS__

// Check current language
document.documentElement.getAttribute('lang')
document.documentElement.getAttribute('dir')
```

### React Query DevTools

React Query DevTools are automatically available in development:
- Click the floating icon (bottom left)
- See all cached queries
- Check loading states
- Inspect cache data

## 📚 Important Files

```
src/
├── lib/api.ts              # API client - modify for your endpoints
├── hooks/useApi.ts         # React Query hooks
├── contexts/AuthContext.tsx # Auth state management
├── components/RequireAuth.tsx # Route protection
└── contexts/LanguageContext.tsx # Language state

.env                        # Environment variables
README.md                   # Full documentation
DEPLOYMENT.md              # Deployment guide
INTEGRATION_COMPLETE.md    # Task completion summary
```

## 🎯 Next Actions

### For Development
1. ✅ Start dev server: `npm run dev`
2. ✅ Configure Laravel backend
3. ✅ Test authentication flow
4. ✅ Test product listing
5. ✅ Customize as needed

### For Production
1. Update `.env` with production API URL
2. Run `npm run build`
3. Deploy `dist/` folder
4. Configure production CORS
5. Test thoroughly

## 💡 Pro Tips

1. **Use React Query DevTools** - Essential for debugging API calls
2. **Check Network Tab** - See all API requests/responses
3. **Test with Mock Data** - Use sample responses for development
4. **Clear Cache** - Clear localStorage if auth issues occur
5. **Check Console** - Look for error messages and warnings

## 🚨 Important Notes

- The app expects Laravel API to return JSON responses
- All protected routes require authentication
- Role-based pages check user roles from `/api/auth/me`
- File uploads use FormData (multipart/form-data)
- Pagination uses Laravel's standard format

## 📞 Need Help?

Check these resources:
1. `README.md` - Complete documentation
2. `DEPLOYMENT.md` - Deployment instructions
3. `INTEGRATION_COMPLETE.md` - What's been done
4. Code comments in source files
5. React Query docs: https://tanstack.com/query
6. shadcn/ui docs: https://ui.shadcn.com

---

## ✅ Checklist

Before starting development:
- [ ] Node.js 20+ installed
- [ ] Dependencies installed (`npm install`)
- [ ] `.env` configured with API URL
- [ ] Laravel backend running
- [ ] CORS configured
- [ ] Dev server started (`npm run dev`)

You're all set! Start building amazing features! 🚀

---

**Happy Coding!** 🎉
