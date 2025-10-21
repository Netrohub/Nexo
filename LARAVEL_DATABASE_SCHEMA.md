# 🗄️ Laravel Database Schema - NXOLand Marketplace

Complete database schema and migrations for the NXOLand marketplace backend.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Database Tables](#database-tables)
3. [Relationships](#relationships)
4. [Migrations](#migrations)
5. [Models](#models)
6. [Seeders](#seeders)
7. [Indexes & Performance](#indexes--performance)

---

## 🎯 Overview

### Database Design Philosophy
- **Normalized**: Reduce redundancy
- **Scalable**: Handle millions of records
- **Performant**: Proper indexing
- **Secure**: Soft deletes, audit trails
- **Flexible**: JSON columns for metadata

### Tables Count: **15 Core Tables**

1. `users` - User accounts
2. `user_profiles` - Extended user information
3. `roles` - User roles
4. `role_user` - Role assignments
5. `products` - Product listings
6. `product_images` - Product images
7. `categories` - Product categories
8. `cart_items` - Shopping cart
9. `orders` - Customer orders
10. `order_items` - Order line items
11. `wishlists` - User wishlists
12. `reviews` - Product reviews
13. `disputes` - Dispute system
14. `dispute_messages` - Dispute communications
15. `dispute_evidence` - Dispute evidence files

---

## 📊 Database Tables

### 1. **users** (Authentication & Core)

```sql
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    email_verified_at TIMESTAMP NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NULL,
    phone_verified_at TIMESTAMP NULL,
    avatar VARCHAR(255) NULL,
    status ENUM('active', 'inactive', 'suspended', 'banned') DEFAULT 'active',
    last_login_at TIMESTAMP NULL,
    last_login_ip VARCHAR(45) NULL,
    remember_token VARCHAR(100) NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_status (status)
);
```

### 2. **user_profiles** (Extended User Info)

```sql
CREATE TABLE user_profiles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED UNIQUE NOT NULL,
    bio TEXT NULL,
    country VARCHAR(2) NULL,
    city VARCHAR(100) NULL,
    address TEXT NULL,
    postal_code VARCHAR(20) NULL,
    date_of_birth DATE NULL,
    gender ENUM('male', 'female', 'other') NULL,
    language VARCHAR(5) DEFAULT 'en',
    timezone VARCHAR(50) DEFAULT 'UTC',
    kyc_status ENUM('pending', 'verified', 'rejected') DEFAULT 'pending',
    kyc_document_type VARCHAR(50) NULL,
    kyc_document_number VARCHAR(100) NULL,
    kyc_document_url VARCHAR(255) NULL,
    kyc_verified_at TIMESTAMP NULL,
    seller_rating DECIMAL(3,2) DEFAULT 0.00,
    seller_verified BOOLEAN DEFAULT FALSE,
    seller_verified_at TIMESTAMP NULL,
    total_sales INT DEFAULT 0,
    total_revenue DECIMAL(15,2) DEFAULT 0.00,
    metadata JSON NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_kyc_status (kyc_status),
    INDEX idx_seller_rating (seller_rating)
);
```

### 3. **roles** (Role-Based Access Control)

```sql
CREATE TABLE roles (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    description TEXT NULL,
    permissions JSON NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    INDEX idx_slug (slug)
);

-- Default roles: customer, seller, admin, moderator
```

### 4. **role_user** (Pivot Table)

```sql
CREATE TABLE role_user (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    role_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_role (user_id, role_id),
    INDEX idx_user_id (user_id),
    INDEX idx_role_id (role_id)
);
```

### 5. **categories** (Product Categories)

```sql
CREATE TABLE categories (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT NULL,
    icon VARCHAR(50) NULL,
    image VARCHAR(255) NULL,
    parent_id BIGINT UNSIGNED NULL,
    order_index INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    metadata JSON NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_parent_id (parent_id),
    INDEX idx_is_active (is_active)
);
```

### 6. **products** (Product Listings)

```sql
CREATE TABLE products (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL COMMENT 'Seller ID',
    category_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount_price DECIMAL(10,2) NULL,
    platform VARCHAR(100) NULL COMMENT 'Gaming/Social platform',
    game VARCHAR(100) NULL COMMENT 'Game name for gaming accounts',
    account_level VARCHAR(50) NULL,
    account_username VARCHAR(100) NULL,
    setup_instructions TEXT NULL,
    delivery_time VARCHAR(50) DEFAULT 'instant',
    stock_quantity INT DEFAULT 1,
    status ENUM('draft', 'pending', 'active', 'sold', 'inactive', 'rejected') DEFAULT 'pending',
    featured BOOLEAN DEFAULT FALSE,
    featured_until TIMESTAMP NULL,
    views_count INT DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0.00,
    reviews_count INT DEFAULT 0,
    sales_count INT DEFAULT 0,
    metadata JSON NULL COMMENT 'Additional product attributes',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    INDEX idx_user_id (user_id),
    INDEX idx_category_id (category_id),
    INDEX idx_slug (slug),
    INDEX idx_status (status),
    INDEX idx_featured (featured),
    INDEX idx_price (price),
    INDEX idx_rating (rating),
    FULLTEXT idx_search (title, description)
);
```

### 7. **product_images** (Product Images)

```sql
CREATE TABLE product_images (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED NOT NULL,
    url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255) NULL,
    order_index INT DEFAULT 0,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_is_primary (is_primary)
);
```

### 8. **cart_items** (Shopping Cart)

```sql
CREATE TABLE cart_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    quantity INT DEFAULT 1,
    price DECIMAL(10,2) NOT NULL COMMENT 'Price at time of adding',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_user_id (user_id)
);
```

### 9. **orders** (Customer Orders)

```sql
CREATE TABLE orders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    buyer_id BIGINT UNSIGNED NOT NULL,
    seller_id BIGINT UNSIGNED NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    service_fee DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'cancelled', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50) NOT NULL,
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    payment_transaction_id VARCHAR(255) NULL,
    buyer_email VARCHAR(255) NULL,
    buyer_phone VARCHAR(20) NULL,
    notes TEXT NULL,
    completed_at TIMESTAMP NULL,
    cancelled_at TIMESTAMP NULL,
    refunded_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (buyer_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (seller_id) REFERENCES users(id) ON DELETE RESTRICT,
    INDEX idx_order_number (order_number),
    INDEX idx_buyer_id (buyer_id),
    INDEX idx_seller_id (seller_id),
    INDEX idx_status (status),
    INDEX idx_payment_status (payment_status),
    INDEX idx_created_at (created_at)
);
```

### 10. **order_items** (Order Line Items)

```sql
CREATE TABLE order_items (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    product_title VARCHAR(255) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    metadata JSON NULL COMMENT 'Product snapshot at purchase time',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
);
```

### 11. **wishlists** (User Wishlists)

```sql
CREATE TABLE wishlists (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    product_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product (user_id, product_id),
    INDEX idx_user_id (user_id)
);
```

### 12. **reviews** (Product Reviews)

```sql
CREATE TABLE reviews (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    order_id BIGINT UNSIGNED NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    title VARCHAR(255) NULL,
    comment TEXT NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    helpful_count INT DEFAULT 0,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_product_order (user_id, product_id, order_id),
    INDEX idx_product_id (product_id),
    INDEX idx_rating (rating)
);
```

### 13. **disputes** (Dispute System)

```sql
CREATE TABLE disputes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT UNSIGNED NOT NULL,
    created_by BIGINT UNSIGNED NOT NULL,
    assigned_to BIGINT UNSIGNED NULL COMMENT 'Admin ID',
    type ENUM('product_not_as_described', 'product_not_delivered', 'seller_not_responding', 'other') NOT NULL,
    reason VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('open', 'in_review', 'resolved', 'declined') DEFAULT 'open',
    resolution TEXT NULL,
    resolved_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_order_id (order_id),
    INDEX idx_created_by (created_by),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);
```

### 14. **dispute_messages** (Dispute Communication)

```sql
CREATE TABLE dispute_messages (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    dispute_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    message TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT FALSE COMMENT 'Admin-only notes',
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    
    FOREIGN KEY (dispute_id) REFERENCES disputes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_dispute_id (dispute_id),
    INDEX idx_created_at (created_at)
);
```

### 15. **dispute_evidence** (Dispute Evidence Files)

```sql
CREATE TABLE dispute_evidence (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    dispute_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    type ENUM('image', 'document', 'text') NOT NULL,
    content TEXT NOT NULL COMMENT 'URL for files, text for notes',
    description TEXT NULL,
    created_at TIMESTAMP NULL,
    
    FOREIGN KEY (dispute_id) REFERENCES disputes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_dispute_id (dispute_id)
);
```

---

## 🔗 Entity Relationships

```
users (1) ──< (many) products
users (1) ──< (many) orders (as buyer)
users (1) ──< (many) orders (as seller)
users (many) ><(many) roles (via role_user)
products (1) ──< (many) product_images
products (1) ──< (many) reviews
products (many) ><(1) categories
orders (1) ──< (many) order_items
orders (1) ──< (many) disputes
disputes (1) ──< (many) dispute_messages
disputes (1) ──< (many) dispute_evidence
```

---

## 📝 Laravel Migrations

### Create Migrations Directory Structure

```bash
# In your Laravel project root
php artisan make:migration create_users_table
php artisan make:migration create_user_profiles_table
php artisan make:migration create_roles_table
php artisan make:migration create_role_user_table
php artisan make:migration create_categories_table
php artisan make:migration create_products_table
php artisan make:migration create_product_images_table
php artisan make:migration create_cart_items_table
php artisan make:migration create_orders_table
php artisan make:migration create_order_items_table
php artisan make:migration create_wishlists_table
php artisan make:migration create_reviews_table
php artisan make:migration create_disputes_table
php artisan make:migration create_dispute_messages_table
php artisan make:migration create_dispute_evidence_table
```

### Example Migration Files (See LARAVEL_MIGRATIONS folder)

I'll create a separate file with all migration code...

---

## 🎯 Performance Indexes

### Primary Indexes
- All `id` columns (auto-created as PRIMARY KEY)
- All foreign keys (for JOIN performance)

### Search Indexes
- `products.title, description` (FULLTEXT for search)
- `users.email` (UNIQUE, for login)
- `products.slug` (UNIQUE, for URLs)

### Query Optimization Indexes
- `products.status` (filter by active/sold)
- `products.featured` (featured products)
- `orders.status` (filter by status)
- `orders.created_at` (sort by date)

---

## 📦 Model Relationships (Laravel)

See the `LARAVEL_MODELS.md` file for complete model definitions with:
- Fillable attributes
- Relationships
- Scopes
- Accessors/Mutators
- API Resources

---

## 🌱 Database Seeders

### Create Seeders

```bash
php artisan make:seeder RoleSeeder
php artisan make:seeder CategorySeeder
php artisan make:seeder UserSeeder
php artisan make:seeder ProductSeeder
```

### Run Seeders

```bash
php artisan db:seed
```

---

## 🚀 Quick Setup

```bash
# 1. Create all migrations
php artisan make:migration create_all_tables

# 2. Run migrations
php artisan migrate

# 3. Seed database
php artisan db:seed

# 4. Verify
php artisan tinker
>>> \App\Models\User::count()
>>> \App\Models\Product::count()
```

---

## 📊 Database Size Estimates

### Expected Growth
- **Users**: 10,000 - 100,000
- **Products**: 50,000 - 500,000
- **Orders**: 100,000 - 1,000,000
- **Reviews**: 200,000+
- **Disputes**: 5,000 - 50,000

### Storage Requirements
- **Initial**: ~500MB
- **6 Months**: ~5GB
- **1 Year**: ~10GB
- **3 Years**: ~50GB

---

## 🔧 Maintenance

### Regular Tasks

```sql
-- Optimize tables
OPTIMIZE TABLE products, orders, users;

-- Analyze query performance
EXPLAIN SELECT * FROM products WHERE status = 'active';

-- Clean old data
DELETE FROM cart_items WHERE created_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
```

### Backup Strategy

```bash
# Daily backups
mysqldump -u root -p nxoland > backup_$(date +%Y%m%d).sql

# Automated backups
php artisan backup:run
```

---

**Ready to implement! See the migration files next.** 🚀
