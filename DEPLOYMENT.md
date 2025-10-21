# Deployment Guide - NXOLand Frontend

This guide covers deploying the NXOLand React frontend with Laravel backend integration.

## 🚀 Quick Deployment

### 1. Build the Application

```bash
# Install dependencies
npm install

# Build for production
npm run build
```

The build output will be in the `dist/` folder.

### 2. Environment Configuration

Create production environment variables:

```env
# Production API Configuration
VITE_API_BASE_URL=https://your-laravel-domain.com/api
VITE_APP_NAME=NetroHub
VITE_APP_ENV=production
```

### 3. Deploy to Static Hosting

#### Vercel
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel --prod
```

#### Netlify
```bash
# Install Netlify CLI
npm i -g netlify-cli

# Deploy
netlify deploy --prod --dir=dist
```

#### GitHub Pages
```bash
# Install gh-pages
npm install --save-dev gh-pages

# Add to package.json scripts
"deploy": "gh-pages -d dist"

# Deploy
npm run deploy
```

## 🔧 Laravel Backend Setup

### 1. CORS Configuration

In your Laravel `config/cors.php`:

```php
'paths' => ['api/*', 'sanctum/csrf-cookie'],
'allowed_methods' => ['*'],
'allowed_origins' => [
    'http://localhost:5173',  // Vite dev server
    'https://your-frontend-domain.com',  // Production domain
],
'allowed_origins_patterns' => [],
'allowed_headers' => ['*'],
'exposed_headers' => [],
'max_age' => 0,
'supports_credentials' => true,
```

### 2. API Routes

Ensure your Laravel API routes are properly configured in `routes/api.php`:

```php
// Authentication routes
Route::prefix('auth')->group(function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::post('register', [AuthController::class, 'register']);
    Route::post('logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
    Route::get('me', [AuthController::class, 'me'])->middleware('auth:sanctum');
    Route::post('verify-phone', [AuthController::class, 'verifyPhone'])->middleware('auth:sanctum');
    Route::post('kyc', [AuthController::class, 'submitKYC'])->middleware('auth:sanctum');
});

// Product routes
Route::apiResource('products', ProductController::class);
Route::get('products/featured', [ProductController::class, 'featured']);

// Cart routes
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('cart', CartController::class);
    Route::apiResource('orders', OrderController::class);
    Route::apiResource('wishlist', WishlistController::class);
    Route::apiResource('disputes', DisputeController::class);
    
    // Seller routes
    Route::prefix('seller')->group(function () {
        Route::get('dashboard-metrics', [SellerController::class, 'dashboard']);
        Route::apiResource('products', SellerProductController::class);
        Route::get('orders', [SellerController::class, 'orders']);
        Route::get('payouts', [SellerController::class, 'payouts']);
        Route::get('notifications', [SellerController::class, 'notifications']);
        Route::post('listing/gaming-account', [SellerController::class, 'listGamingAccount']);
        Route::post('listing/social-account', [SellerController::class, 'listSocialAccount']);
    });
    
    // Admin routes
    Route::prefix('admin')->middleware('role:admin')->group(function () {
        Route::get('disputes', [AdminController::class, 'disputes']);
        Route::put('disputes/{dispute}', [AdminController::class, 'updateDispute']);
    });
});
```

### 3. Sanctum Configuration

Install and configure Laravel Sanctum:

```bash
# Install Sanctum
composer require laravel/sanctum

# Publish configuration
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# Run migrations
php artisan migrate
```

Update `config/sanctum.php`:

```php
'stateful' => explode(',', env('SANCTUM_STATEFUL_DOMAINS', sprintf(
    '%s%s',
    'localhost,localhost:3000,127.0.0.1,127.0.0.1:8000,::1',
    env('APP_URL') ? ','.parse_url(env('APP_URL'), PHP_URL_HOST) : ''
))),
```

### 4. File Upload Configuration

For product images and dispute evidence:

```php
// In your controller
public function store(Request $request)
{
    $request->validate([
        'images.*' => 'image|mimes:jpeg,png,jpg,gif|max:2048',
        'evidence.*' => 'file|mimes:jpeg,png,jpg,pdf,doc,docx|max:5120',
    ]);
    
    // Handle file uploads
    $images = [];
    if ($request->hasFile('images')) {
        foreach ($request->file('images') as $image) {
            $path = $image->store('products', 'public');
            $images[] = Storage::url($path);
        }
    }
    
    // Save to database
    $product = Product::create([
        'title' => $request->title,
        'images' => $images,
        // ... other fields
    ]);
    
    return response()->json($product, 201);
}
```

## 🔒 Security Considerations

### 1. Environment Variables

Never commit sensitive data to version control:

```bash
# Add to .gitignore
.env
.env.local
.env.production
```

### 2. API Security

- Use HTTPS in production
- Implement rate limiting
- Validate all inputs
- Use CSRF protection for state-changing operations
- Implement proper authentication middleware

### 3. File Upload Security

```php
// Validate file types and sizes
$request->validate([
    'image' => 'required|image|mimes:jpeg,png,jpg|max:2048',
]);

// Scan for malware (optional)
// Use services like ClamAV or VirusTotal API
```

## 📊 Performance Optimization

### 1. Frontend Optimization

```bash
# Analyze bundle size
npm run build -- --analyze

# Enable compression
# Most hosting providers enable gzip automatically
```

### 2. Laravel Optimization

```bash
# Optimize for production
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan optimize

# Use Redis for caching (optional)
php artisan config:cache
```

### 3. Database Optimization

- Add proper indexes
- Use database connection pooling
- Implement query optimization
- Use database caching for frequently accessed data

## 🔍 Monitoring & Debugging

### 1. Error Tracking

Consider integrating error tracking services:

- **Sentry** - Error monitoring
- **LogRocket** - Session replay
- **New Relic** - Performance monitoring

### 2. Logging

Configure proper logging in Laravel:

```php
// In config/logging.php
'channels' => [
    'api' => [
        'driver' => 'daily',
        'path' => storage_path('logs/api.log'),
        'level' => 'debug',
        'days' => 14,
    ],
],
```

### 3. Health Checks

Create health check endpoints:

```php
// In routes/api.php
Route::get('health', function () {
    return response()->json([
        'status' => 'ok',
        'timestamp' => now(),
        'version' => config('app.version'),
    ]);
});
```

## 🚀 CI/CD Pipeline

### GitHub Actions Example

```yaml
# .github/workflows/deploy.yml
name: Deploy Frontend

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build
      run: npm run build
      env:
        VITE_API_BASE_URL: ${{ secrets.API_BASE_URL }}
    
    - name: Deploy to Vercel
      uses: amondnet/vercel-action@v20
      with:
        vercel-token: ${{ secrets.VERCEL_TOKEN }}
        vercel-org-id: ${{ secrets.ORG_ID }}
        vercel-project-id: ${{ secrets.PROJECT_ID }}
        working-directory: ./
```

## 📱 Mobile App Considerations

If you plan to create a mobile app:

1. **API Design** - Ensure RESTful API design
2. **Authentication** - Use JWT tokens for mobile
3. **Push Notifications** - Implement FCM or APNS
4. **Offline Support** - Consider caching strategies

## 🔄 Updates & Maintenance

### 1. Regular Updates

- Keep dependencies updated
- Monitor security vulnerabilities
- Update Laravel and React versions
- Review and update API documentation

### 2. Backup Strategy

- Database backups
- File storage backups
- Configuration backups
- Code repository backups

### 3. Monitoring

- Set up uptime monitoring
- Monitor API response times
- Track error rates
- Monitor user engagement metrics

---

## 📞 Support

For deployment issues:

1. Check the logs (both frontend and backend)
2. Verify environment variables
3. Test API endpoints manually
4. Check CORS configuration
5. Verify file permissions

**Happy Deploying! 🚀**
