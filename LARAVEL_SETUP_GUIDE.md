# 🚀 Laravel Backend Setup Guide - NXOLand

Complete guide to setting up the Laravel backend for your NXOLand marketplace.

## 📋 What's Included

I've created complete Laravel backend resources:

### Database
- ✅ **15 migration files** - Complete database schema
- ✅ **8 model files** - Eloquent models with relationships
- ✅ **4 seeder files** - Sample data for testing
- ✅ **Schema documentation** - Complete ERD and relationships

### Files Location
```
laravel-backend/
├── migrations/         # Database migrations (8 files)
├── models/            # Eloquent models (8 files)
└── seeders/           # Database seeders (4 files)
```

---

## 🗄️ Database Schema Overview

### Core Tables (15 Total)

1. **users** - User accounts with authentication
2. **user_profiles** - Extended user information & KYC
3. **roles** - Role definitions (customer, seller, admin)
4. **role_user** - User role assignments (pivot)
5. **categories** - Product categories
6. **products** - Product listings
7. **product_images** - Product image gallery
8. **cart_items** - Shopping cart
9. **orders** - Customer orders
10. **order_items** - Order line items
11. **wishlists** - User wishlists
12. **reviews** - Product reviews & ratings
13. **disputes** - Dispute management
14. **dispute_messages** - Dispute communication
15. **dispute_evidence** - Dispute evidence files

---

## 🚀 Quick Setup (Copy to Laravel Project)

### Step 1: Copy Migration Files

```bash
# From your NXOLand directory, copy migrations to Laravel
cp -r laravel-backend/migrations/* ../your-laravel-project/database/migrations/

# Or manually copy each file to:
# your-laravel-project/database/migrations/
```

### Step 2: Copy Model Files

```bash
# Copy models to Laravel app
cp -r laravel-backend/models/* ../your-laravel-project/app/Models/

# Models location:
# your-laravel-project/app/Models/
```

### Step 3: Copy Seeder Files

```bash
# Copy seeders to Laravel
cp -r laravel-backend/seeders/* ../your-laravel-project/database/seeders/

# Seeders location:
# your-laravel-project/database/seeders/
```

### Step 4: Update User Model

The default Laravel `User.php` needs modifications. Add to your `app/Models/User.php`:

```php
<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Database\Eloquent\SoftDeletes;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable, SoftDeletes;

    protected $fillable = [
        'name',
        'email',
        'password',
        'phone',
        'avatar',
        'status',
        'last_login_at',
        'last_login_ip',
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'phone_verified_at' => 'datetime',
        'last_login_at' => 'datetime',
        'password' => 'hashed',
    ];

    protected $appends = ['roles'];

    /**
     * Get the user's profile
     */
    public function profile()
    {
        return $this->hasOne(UserProfile::class);
    }

    /**
     * Get the user's roles
     */
    public function roles()
    {
        return $this->belongsToMany(Role::class);
    }

    /**
     * Get roles as array for API
     */
    public function getRolesAttribute()
    {
        return $this->roles()->pluck('slug')->toArray();
    }

    /**
     * Check if user has role
     */
    public function hasRole(string $role): bool
    {
        return $this->roles()->where('slug', $role)->exists();
    }

    /**
     * Products listed by seller
     */
    public function products()
    {
        return $this->hasMany(Product::class);
    }

    /**
     * Orders as buyer
     */
    public function purchases()
    {
        return $this->hasMany(Order::class, 'buyer_id');
    }

    /**
     * Orders as seller
     */
    public function sales()
    {
        return $this->hasMany(Order::class, 'seller_id');
    }

    /**
     * Cart items
     */
    public function cartItems()
    {
        return $this->hasMany(CartItem::class);
    }

    /**
     * Wishlist items
     */
    public function wishlist()
    {
        return $this->belongsToMany(Product::class, 'wishlists');
    }

    /**
     * Reviews written by user
     */
    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    /**
     * Disputes created by user
     */
    public function disputes()
    {
        return $this->hasMany(Dispute::class, 'created_by');
    }
}
```

### Step 5: Run Migrations

```bash
# In your Laravel project
php artisan migrate

# If you need to reset
php artisan migrate:fresh
```

### Step 6: Run Seeders

```bash
# Update DatabaseSeeder.php
# Add to database/seeders/DatabaseSeeder.php:

public function run(): void
{
    $this->call([
        RoleSeeder::class,
        CategorySeeder::class,
        // Add more seeders as needed
    ]);
}

# Then run:
php artisan db:seed
```

---

## 🔧 Database Configuration

### Update `.env` in Laravel

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=root
DB_PASSWORD=your_password
```

### Create Database

```sql
-- MySQL
CREATE DATABASE nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Or use Laravel command
php artisan db:create nxoland
```

---

## 📊 Migration Order

Migrations will run in this order (by filename):

1. `2024_01_01_000001_create_user_profiles_table.php`
2. `2024_01_01_000002_create_roles_table.php`
3. `2024_01_01_000003_create_categories_table.php`
4. `2024_01_01_000004_create_products_table.php`
5. `2024_01_01_000005_create_orders_table.php`
6. `2024_01_01_000006_create_cart_and_wishlist_tables.php`
7. `2024_01_01_000007_create_disputes_tables.php`
8. `2024_01_01_000008_create_reviews_table.php`

---

## 🎯 API Resources (Laravel)

Create API resources for consistent JSON responses:

```bash
php artisan make:resource UserResource
php artisan make:resource ProductResource
php artisan make:resource OrderResource
php artisan make:resource DisputeResource
```

### Example: ProductResource.php

```php
<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'description' => $this->description,
            'price' => $this->price,
            'discount_price' => $this->discount_price,
            'category' => $this->category->name,
            'platform' => $this->platform,
            'game' => $this->game,
            'images' => $this->images,
            'seller' => [
                'id' => $this->seller->id,
                'name' => $this->seller->name,
                'avatar' => $this->seller->avatar,
                'rating' => $this->seller->profile->seller_rating ?? 0,
                'verified' => $this->seller->profile->seller_verified ?? false,
            ],
            'rating' => $this->rating,
            'reviews_count' => $this->reviews_count,
            'featured' => $this->featured,
            'status' => $this->status,
            'created_at' => $this->created_at->toISOString(),
            'updated_at' => $this->updated_at->toISOString(),
        ];
    }
}
```

---

## 🧪 Testing the Database

### Create Test Data

```php
// In tinker: php artisan tinker

// Create admin user
$admin = \App\Models\User::create([
    'name' => 'Admin User',
    'email' => 'admin@netrohub.com',
    'password' => bcrypt('password123'),
    'email_verified_at' => now(),
]);

// Assign admin role
$adminRole = \App\Models\Role::where('slug', 'admin')->first();
$admin->roles()->attach($adminRole);

// Create seller
$seller = \App\Models\User::create([
    'name' => 'Test Seller',
    'email' => 'seller@netrohub.com',
    'password' => bcrypt('password123'),
    'email_verified_at' => now(),
]);

$sellerRole = \App\Models\Role::where('slug', 'seller')->first();
$seller->roles()->attach($sellerRole);

// Create product
$category = \App\Models\Category::where('slug', 'gaming')->first();
$product = \App\Models\Product::create([
    'user_id' => $seller->id,
    'category_id' => $category->id,
    'title' => 'Steam Account - 100+ Games',
    'description' => 'Premium Steam account with 100+ games',
    'price' => 299.99,
    'status' => 'active',
    'featured' => true,
]);
```

### Verify Relationships

```php
// Check product relationships
$product = \App\Models\Product::first();
$product->seller;  // Get seller
$product->category;  // Get category
$product->images;  // Get images

// Check user relationships
$user = \App\Models\User::first();
$user->profile;  // Get profile
$user->roles;  // Get roles
$user->products;  // Get products (if seller)
```

---

## 📈 Performance Tips

### Add Indexes After Seeding

```sql
-- Additional indexes for large datasets
ALTER TABLE products ADD INDEX idx_platform (platform);
ALTER TABLE products ADD INDEX idx_game (game);
ALTER TABLE orders ADD INDEX idx_payment_method (payment_method);
```

### Enable Query Caching

```php
// In config/database.php
'mysql' => [
    // ... other config
    'options' => [
        PDO::MYSQL_ATTR_INIT_COMMAND => 'SET SESSION sql_mode=""',
    ],
],
```

---

## 🔒 Security Considerations

### 1. Soft Deletes
- Users and products use soft deletes
- Preserves data integrity
- Allows data recovery

### 2. Foreign Keys
- All relationships use foreign keys
- Cascade deletes where appropriate
- Restrict deletes for important data

### 3. Enum Validation
- Status fields use enums
- Prevents invalid status values
- Database-level validation

### 4. Indexes
- All searchable fields indexed
- Foreign keys indexed
- Performance optimized

---

## 📝 Migration Commands

```bash
# Run all migrations
php artisan migrate

# Run migrations with seeding
php artisan migrate --seed

# Reset and re-run
php artisan migrate:fresh --seed

# Rollback last batch
php artisan migrate:rollback

# Check migration status
php artisan migrate:status

# Create specific migration
php artisan make:migration add_column_to_table
```

---

## 🌱 Seeder Commands

```bash
# Run all seeders
php artisan db:seed

# Run specific seeder
php artisan db:seed --class=RoleSeeder

# Refresh and seed
php artisan migrate:fresh --seed
```

---

## ✅ Setup Checklist

- [ ] Copy migration files to Laravel project
- [ ] Copy model files to Laravel project
- [ ] Copy seeder files to Laravel project
- [ ] Update User model with relationships
- [ ] Configure database in `.env`
- [ ] Create database
- [ ] Run migrations: `php artisan migrate`
- [ ] Run seeders: `php artisan db:seed`
- [ ] Create API resources
- [ ] Test relationships in tinker
- [ ] Implement API controllers
- [ ] Set up API routes
- [ ] Configure CORS
- [ ] Test with frontend

---

## 🎯 Next Steps

1. **Implement Controllers** - See `LARAVEL_CONTROLLERS.md` (to be created)
2. **Set Up Routes** - See `LARAVEL_ROUTES.md` (to be created)
3. **Create API Resources** - Format API responses
4. **Add Validation** - Request validation classes
5. **Test Integration** - Connect with React frontend

---

**Your database schema is ready! Follow the steps above to implement.** 🎉
