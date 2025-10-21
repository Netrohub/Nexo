# 🚀 Step-by-Step Migration Guide - NXOLand

Complete guide to set up your Laravel backend and run database migrations.

## 📋 Overview

You have:
- ✅ **Frontend**: NXOLand React app (current directory)
- ❓ **Backend**: Laravel project (need to set up or connect)
- ❓ **Database**: MySQL with name `nxoland`

---

## 🎯 Choose Your Setup Method

### Method 1: New Laravel Project (Recommended if starting fresh)
### Method 2: Existing Laravel Project (If you already have one)
### Method 3: Laravel in Subdirectory (Frontend + Backend together)

---

## 🆕 Method 1: Create New Laravel Project

### Step 1: Create Laravel Project (in parent directory)

```bash
# Go to parent directory
cd ..

# Create new Laravel project
composer create-project laravel/laravel nxoland-backend

# Or if you prefer
composer create-project laravel/laravel netrohub-api
```

**Directory structure will be:**
```
Desktop/
├── NXOLand/           # Your React frontend (current)
└── nxoland-backend/   # New Laravel backend
```

### Step 2: Copy Database Files to Laravel

```bash
# Copy migrations
cp NXOLand/laravel-backend/migrations/* nxoland-backend/database/migrations/

# Copy models
cp NXOLand/laravel-backend/models/* nxoland-backend/app/Models/

# Copy seeders
cp NXOLand/laravel-backend/seeders/* nxoland-backend/database/seeders/

# Copy .env example
cp NXOLand/laravel-backend/laravel.env.example nxoland-backend/.env.example
```

### Step 3: Configure Database

```bash
# Edit Laravel .env file
cd nxoland-backend
notepad .env  # Or use your preferred editor

# Update these lines:
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=root
DB_PASSWORD=your_mysql_password
```

### Step 4: Create Database

```bash
# Option A: Use the SQL script
cd ../NXOLand
mysql -u root -p < laravel-backend/setup-mysql.sql

# Option B: Manual creation
mysql -u root -p
> CREATE DATABASE nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
> EXIT;
```

### Step 5: Install Laravel Sanctum

```bash
# In Laravel project
cd ../nxoland-backend

# Install Sanctum for API authentication
composer require laravel/sanctum

# Publish Sanctum configuration
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
```

### Step 6: Run Migrations

```bash
# Still in Laravel project
php artisan migrate

# You should see:
# Migrating: 2024_01_01_000001_create_user_profiles_table
# Migrated:  2024_01_01_000001_create_user_profiles_table
# ... (and 7 more migrations)
```

### Step 7: Seed Database

```bash
# Update DatabaseSeeder.php first
notepad database/seeders/DatabaseSeeder.php

# Add this to the run() method:
public function run(): void
{
    $this->call([
        RoleSeeder::class,
        CategorySeeder::class,
    ]);
}

# Then run seeders
php artisan db:seed
```

### Step 8: Start Laravel Server

```bash
# Start Laravel development server
php artisan serve

# Server will start at:
# http://127.0.0.1:8000
```

### Step 9: Update React Frontend .env

```bash
# Go back to React project
cd ../NXOLand

# Your .env already has:
VITE_API_BASE_URL=http://localhost:8000/api

# Perfect! No changes needed.
```

---

## 📁 Method 2: Use Existing Laravel Project

### Step 1: Copy Files to Existing Project

```bash
# Assuming your Laravel project is at: ../your-laravel-project

# Copy migrations
cp laravel-backend/migrations/* ../your-laravel-project/database/migrations/

# Copy models
cp laravel-backend/models/* ../your-laravel-project/app/Models/

# Copy seeders
cp laravel-backend/seeders/* ../your-laravel-project/database/seeders/
```

### Step 2: Update Laravel .env

```bash
cd ../your-laravel-project
notepad .env

# Set database name
DB_DATABASE=nxoland
```

### Step 3: Create Database (if not exists)

```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### Step 4: Run Migrations

```bash
php artisan migrate
php artisan db:seed
```

---

## 🏠 Method 3: Laravel in Same Directory (Monorepo)

### Step 1: Create Laravel API in Subdirectory

```bash
# In NXOLand directory
composer create-project laravel/laravel api

# Directory structure:
# NXOLand/
# ├── src/              # React frontend
# ├── api/              # Laravel backend
# └── laravel-backend/  # Migration files
```

### Step 2: Copy Files

```bash
# Copy migrations
cp laravel-backend/migrations/* api/database/migrations/

# Copy models
cp laravel-backend/models/* api/app/Models/

# Copy seeders
cp laravel-backend/seeders/* api/database/seeders/
```

### Step 3: Configure Database

```bash
cd api
notepad .env

# Update:
DB_DATABASE=nxoland
```

### Step 4: Run Migrations

```bash
# Create database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Run migrations
php artisan migrate
php artisan db:seed

# Start server
php artisan serve
```

---

## ⚡ **Quick Migration (Copy-Paste Commands)**

### If you don't have Laravel yet:

```powershell
# 1. Go to parent directory
cd ..

# 2. Create Laravel project
composer create-project laravel/laravel nxoland-backend

# 3. Go to Laravel project
cd nxoland-backend

# 4. Install Sanctum
composer require laravel/sanctum
php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"

# 5. Copy migration files from NXOLand
Copy-Item -Path ..\NXOLand\laravel-backend\migrations\* -Destination .\database\migrations\
Copy-Item -Path ..\NXOLand\laravel-backend\models\* -Destination .\app\Models\
Copy-Item -Path ..\NXOLand\laravel-backend\seeders\* -Destination .\database\seeders\

# 6. Update .env (manually edit)
notepad .env
# Set: DB_DATABASE=nxoland

# 7. Create database
mysql -u root -p -e "CREATE DATABASE nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 8. Run migrations
php artisan migrate

# 9. Update DatabaseSeeder.php (manually)
notepad database\seeders\DatabaseSeeder.php
# Add: RoleSeeder::class, CategorySeeder::class

# 10. Seed database
php artisan db:seed

# 11. Start server
php artisan serve
```

---

## 🔍 **Verify Migrations Worked:**

```bash
# In Laravel project directory
php artisan migrate:status

# Should show:
# ✅ Ran: 2024_01_01_000001_create_user_profiles_table
# ✅ Ran: 2024_01_01_000002_create_roles_table
# ✅ Ran: 2024_01_01_000003_create_categories_table
# ✅ Ran: 2024_01_01_000004_create_products_table
# ✅ Ran: 2024_01_01_000005_create_orders_table
# ✅ Ran: 2024_01_01_000006_create_cart_and_wishlist_tables
# ✅ Ran: 2024_01_01_000007_create_disputes_tables
# ✅ Ran: 2024_01_01_000008_create_reviews_table

# Check tables exist
php artisan tinker
>>> \DB::table('users')->count()
>>> \DB::table('products')->count()
>>> \App\Models\Role::count()  # Should be 4
>>> \App\Models\Category::count()  # Should be 5
```

---

## 🗂️ **File Locations:**

### **In NXOLand (Current Directory):**
```
NXOLand/
├── laravel-backend/
│   ├── migrations/        # ← 8 migration files
│   ├── models/           # ← 4 model files
│   ├── seeders/          # ← 2 seeder files
│   ├── setup-mysql.sql   # ← Database creation script
│   └── laravel.env.example  # ← Laravel .env template
└── (rest of React app)
```

### **Copy To Laravel Project:**
```
your-laravel-project/
├── database/
│   ├── migrations/       # ← Copy migration files here
│   └── seeders/         # ← Copy seeder files here
├── app/
│   └── Models/          # ← Copy model files here
└── .env                 # ← Update with DB_DATABASE=nxoland
```

---

## 🎯 **What Each Migration Creates:**

1. **`000001_create_user_profiles_table.php`**
   - `user_profiles` table (KYC, seller info)

2. **`000002_create_roles_table.php`**
   - `roles` table
   - `role_user` pivot table

3. **`000003_create_categories_table.php`**
   - `categories` table

4. **`000004_create_products_table.php`**
   - `products` table
   - `product_images` table

5. **`000005_create_orders_table.php`**
   - `orders` table
   - `order_items` table

6. **`000006_create_cart_and_wishlist_tables.php`**
   - `cart_items` table
   - `wishlists` table

7. **`000007_create_disputes_tables.php`**
   - `disputes` table
   - `dispute_messages` table
   - `dispute_evidence` table

8. **`000008_create_reviews_table.php`**
   - `reviews` table

---

## 🐛 **Common Issues & Solutions:**

### Issue: "Database does not exist"

**Solution:**
```bash
mysql -u root -p -e "CREATE DATABASE nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

### Issue: "Could not find driver"

**Solution:**
```bash
# Enable MySQL extension in php.ini
extension=pdo_mysql
extension=mysqli

# Restart PHP/Apache
```

### Issue: "Migration not found"

**Solution:**
```bash
# Make sure files are in correct location:
# Laravel: database/migrations/
# Not: database/migrations/migrations/

# List migrations
ls database/migrations/

# Should see your migration files
```

### Issue: "Foreign key constraint fails"

**Solution:**
```bash
# Run migrations in fresh state
php artisan migrate:fresh --seed

# Or rollback and re-run
php artisan migrate:rollback
php artisan migrate
```

---

## 📝 **Update DatabaseSeeder.php:**

```php
<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        $this->call([
            RoleSeeder::class,
            CategorySeeder::class,
        ]);
        
        $this->command->info('✅ Database seeded successfully!');
    }
}
```

---

## 🧪 **Test the Database:**

```bash
# In Laravel project
php artisan tinker

# Check roles were seeded
>>> \App\Models\Role::all()->pluck('name')
# Should show: ["Customer", "Seller", "Admin", "Moderator"]

# Check categories
>>> \App\Models\Category::all()->pluck('name')
# Should show: ["Social Media", "Gaming", "Digital Services", "Software", "Entertainment"]

# Create test user
>>> $user = \App\Models\User::create([
    'name' => 'Test User',
    'email' => 'test@nxoland.com',
    'password' => bcrypt('password123'),
    'email_verified_at' => now()
]);

# Assign role
>>> $role = \App\Models\Role::where('slug', 'customer')->first();
>>> $user->roles()->attach($role);

# Verify
>>> $user->roles->pluck('name')
# Should show: ["Customer"]

# Exit
>>> exit
```

---

## 🎯 **Recommended Approach:**

I recommend **Method 1** (separate Laravel project):

```
Desktop/
├── NXOLand/              # React frontend (port 8080)
│   ├── src/
│   ├── laravel-backend/  # Migration files to copy
│   └── .env (VITE_API_BASE_URL=http://localhost:8000/api)
│
└── nxoland-backend/      # Laravel API (port 8000)
    ├── database/migrations/
    ├── app/Models/
    └── .env (DB_DATABASE=nxoland)
```

---

## ✅ **Complete Setup Checklist:**

### **Part 1: Laravel Project Setup**
- [ ] Create Laravel project (or use existing)
- [ ] Install Laravel Sanctum (`composer require laravel/sanctum`)
- [ ] Copy migration files to `database/migrations/`
- [ ] Copy model files to `app/Models/`
- [ ] Copy seeder files to `database/seeders/`

### **Part 2: Database Setup**
- [ ] Create MySQL database `nxoland`
- [ ] Update Laravel `.env` with `DB_DATABASE=nxoland`
- [ ] Update Laravel `.env` with MySQL credentials
- [ ] Test connection: `php artisan migrate:status`

### **Part 3: Run Migrations**
- [ ] Run: `php artisan migrate`
- [ ] Verify: All 8 migrations ran successfully
- [ ] Update `DatabaseSeeder.php`
- [ ] Run: `php artisan db:seed`
- [ ] Verify: Roles and categories exist

### **Part 4: Test with Tinker**
- [ ] Run: `php artisan tinker`
- [ ] Check: `\App\Models\Role::count()` returns 4
- [ ] Check: `\App\Models\Category::count()` returns 5
- [ ] Create test user and assign role

### **Part 5: Start Server**
- [ ] Run: `php artisan serve`
- [ ] Server starts on: `http://localhost:8000`
- [ ] Test: Visit `http://localhost:8000`

### **Part 6: Connect Frontend**
- [ ] React `.env` has: `VITE_API_BASE_URL=http://localhost:8000/api`
- [ ] Configure CORS in Laravel
- [ ] Test API connection from React

---

## 🔧 **If You Already Have Laravel Running:**

```bash
# 1. Find your Laravel project
cd ../your-laravel-project

# 2. Copy migration files
# (From Windows PowerShell in NXOLand directory)
Copy-Item -Path .\laravel-backend\migrations\* -Destination ..\your-laravel-project\database\migrations\
Copy-Item -Path .\laravel-backend\models\* -Destination ..\your-laravel-project\app\Models\
Copy-Item -Path .\laravel-backend\seeders\* -Destination ..\your-laravel-project\database\seeders\

# 3. Update .env
DB_DATABASE=nxoland

# 4. Create database
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 5. Run migrations
php artisan migrate

# 6. Seed
php artisan db:seed
```

---

## 💡 **Pro Tips:**

### **Use Laravel Sail (Docker)**

If you don't want to install MySQL locally:

```bash
# In Laravel project
composer require laravel/sail --dev
php artisan sail:install

# Start Sail (includes MySQL)
./vendor/bin/sail up -d

# MySQL will be available at localhost:3306
# Database name: nxoland
# Username: sail
# Password: password

# Run migrations with Sail
./vendor/bin/sail artisan migrate
./vendor/bin/sail artisan db:seed
```

### **Fresh Start (Reset Everything)**

```bash
# In Laravel project
php artisan migrate:fresh --seed

# This will:
# - Drop all tables
# - Re-run all migrations
# - Seed the database
```

---

## 📊 **Expected Output:**

### When running migrations:

```bash
$ php artisan migrate

   INFO  Preparing database.

  Creating migration table ................................ 32ms DONE

   INFO  Running migrations.

  2024_01_01_000001_create_user_profiles_table .......... 45ms DONE
  2024_01_01_000002_create_roles_table .................. 28ms DONE
  2024_01_01_000003_create_categories_table ............. 31ms DONE
  2024_01_01_000004_create_products_table ............... 52ms DONE
  2024_01_01_000005_create_orders_table ................. 41ms DONE
  2024_01_01_000006_create_cart_and_wishlist_tables .... 35ms DONE
  2024_01_01_000007_create_disputes_tables .............. 38ms DONE
  2024_01_01_000008_create_reviews_table ................ 29ms DONE

✅ All migrations completed!
```

### When seeding:

```bash
$ php artisan db:seed

   INFO  Seeding database.

  Database\Seeders\RoleSeeder ............................ RUNNING
  ✅ Roles seeded successfully!
  Database\Seeders\RoleSeeder ............................ 125ms DONE

  Database\Seeders\CategorySeeder ........................ RUNNING
  ✅ Categories seeded successfully!
  Database\Seeders\CategorySeeder ........................ 98ms DONE

✅ Database seeded!
```

---

## 🆘 **Need Help?**

### **Check Laravel can connect to MySQL:**

```bash
# In Laravel project
php artisan tinker
>>> \DB::connection()->getPdo()
# If successful, shows PDO connection object

>>> \DB::select('SELECT DATABASE()')
# Should show: nxoland
```

### **Check MySQL is running:**

```bash
# Windows
mysql --version

# Try to connect
mysql -u root -p

# Show databases
SHOW DATABASES;

# Should see 'nxoland' in the list
```

---

## 📚 **Documentation References:**

- `LARAVEL_DATABASE_SCHEMA.md` - Complete schema details
- `LARAVEL_SETUP_GUIDE.md` - Full setup instructions
- `DATABASE_QUICK_START.md` - Quick reference
- `laravel-backend/setup-mysql.sql` - Database creation script

---

## 🎉 **You're Ready When:**

- ✅ Laravel project created/located
- ✅ Migration files copied
- ✅ Database `nxoland` created
- ✅ Laravel `.env` configured
- ✅ `php artisan migrate` completed successfully
- ✅ `php artisan db:seed` completed successfully
- ✅ Laravel server running (`php artisan serve`)
- ✅ React app points to Laravel API

---

**Need me to help with a specific step? Just let me know!** 🚀
