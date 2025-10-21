# 🚀 Database Quick Start - NXOLand

Get your MySQL database up and running in 5 minutes!

## ⚡ Super Quick Setup

### 1️⃣ **Create Database**

```bash
# Open MySQL terminal
mysql -u root -p

# Then run:
CREATE DATABASE nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EXIT;
```

**Or use the provided script:**
```bash
# From NXOLand directory
mysql -u root -p < laravel-backend/setup-mysql.sql
```

### 2️⃣ **Configure Laravel**

In your Laravel project's `.env` file:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=nxoland
DB_USERNAME=root
DB_PASSWORD=your_mysql_password
```

### 3️⃣ **Copy Migration Files**

```bash
# From NXOLand directory
cp laravel-backend/migrations/* ../your-laravel-project/database/migrations/
cp laravel-backend/models/* ../your-laravel-project/app/Models/
cp laravel-backend/seeders/* ../your-laravel-project/database/seeders/
```

### 4️⃣ **Run Migrations**

```bash
# Go to your Laravel project
cd ../your-laravel-project

# Run migrations
php artisan migrate

# Seed initial data (roles & categories)
php artisan db:seed
```

---

## ✅ **That's It!**

Your database is now ready with:
- ✅ Database `nxoland` created
- ✅ 15 tables created
- ✅ Relationships configured
- ✅ Indexes optimized
- ✅ Sample data seeded

---

## 🔍 **Verify Setup**

```bash
# In Laravel project
php artisan tinker

# Check tables
>>> \App\Models\Role::count()
# Should return: 4

>>> \App\Models\Category::count()
# Should return: 5

# Create test user
>>> $user = \App\Models\User::create([
    'name' => 'Test User',
    'email' => 'test@nxoland.com',
    'password' => bcrypt('password123'),
    'email_verified_at' => now()
]);

# Assign customer role
>>> $role = \App\Models\Role::where('slug', 'customer')->first();
>>> $user->roles()->attach($role);

# Verify
>>> $user->fresh()->roles
```

---

## 📊 **Database Info**

### Database Name
```
nxoland
```

### Tables Created (15)
```
✅ users
✅ user_profiles
✅ roles
✅ role_user
✅ categories
✅ products
✅ product_images
✅ cart_items
✅ orders
✅ order_items
✅ wishlists
✅ reviews
✅ disputes
✅ dispute_messages
✅ dispute_evidence
```

### Default Data (After Seeding)
```
4 Roles:
  - customer
  - seller
  - admin
  - moderator

5 Categories:
  - Social Media
  - Gaming
  - Digital Services
  - Software
  - Entertainment
```

---

## 🔧 **Common MySQL Commands**

```bash
# Show all databases
mysql -u root -p -e "SHOW DATABASES;"

# Show tables in nxoland
mysql -u root -p -e "USE nxoland; SHOW TABLES;"

# Show table structure
mysql -u root -p -e "USE nxoland; DESCRIBE users;"

# Count records
mysql -u root -p -e "USE nxoland; SELECT COUNT(*) FROM users;"

# Backup database
mysqldump -u root -p nxoland > nxoland_backup.sql

# Restore database
mysql -u root -p nxoland < nxoland_backup.sql

# Drop and recreate (⚠️ WARNING: Deletes all data)
mysql -u root -p -e "DROP DATABASE IF EXISTS nxoland; CREATE DATABASE nxoland CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
```

---

## 🐛 **Troubleshooting**

### Can't connect to MySQL?

```bash
# Check MySQL is running
mysql --version

# Try connecting
mysql -u root -p

# If using Docker
docker ps | grep mysql
```

### Migration errors?

```bash
# Check Laravel can connect
php artisan migrate:status

# Reset and retry
php artisan migrate:fresh --seed
```

### Wrong database name?

```bash
# In Laravel .env, make sure it's:
DB_DATABASE=nxoland

# Not:
DB_DATABASE=netrohub
DB_DATABASE=laravel
```

---

## 🎯 **Next Steps After Database Setup**

1. ✅ **Database created** → `nxoland`
2. ✅ **Migrations run** → 15 tables
3. ✅ **Data seeded** → Roles & categories
4. **Create API Controllers** → Handle requests
5. **Set up API Routes** → Define endpoints
6. **Configure CORS** → Allow frontend access
7. **Test with frontend** → Connect React app

---

## 📞 **Need Help?**

Check these files:
- `LARAVEL_DATABASE_SCHEMA.md` - Complete schema
- `LARAVEL_SETUP_GUIDE.md` - Detailed setup
- `laravel-backend/setup-mysql.sql` - SQL script

---

**Your database `nxoland` is ready! 🎉**
