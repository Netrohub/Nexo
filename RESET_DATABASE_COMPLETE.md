# 🔄 Complete Database Reset & Migration Guide

**Purpose:** Completely reset Render database and apply fresh migrations  
**Date:** October 29, 2025

---

## ⚠️ **WARNING: This will DELETE ALL DATA!**

This process will:
- ❌ Delete all existing tables
- ❌ Remove all data (users, products, orders, etc.)
- ✅ Recreate database from schema
- ✅ Apply fresh migrations
- ✅ Seed with initial data

---

## 🚀 **METHOD 1: Via Render Shell (RECOMMENDED)**

### **Step 1: Connect to Render Shell**

1. Go to: https://dashboard.render.com/web/srv-d3vp7pbipnbc739jr10g
2. Click **"Shell"** tab
3. Or SSH: `ssh srv-d3vp7pbipnbc739jr10g@ssh.frankfurt.render.com`

### **Step 2: Reset and Migrate**

```bash
# Navigate to backend
cd /opt/render/project/src/nxoland-backend

# Reset database (DANGER: Drops all tables)
npx prisma migrate reset --force

# OR manually reset:
# 1. Drop all tables (if migrate reset doesn't work)
npx prisma migrate resolve --rolled-back _prisma_migrations

# 2. Push schema fresh
npx prisma db push --force-reset

# 3. Generate Prisma client
npx prisma generate

# 4. Create initial migration
npx prisma migrate dev --name init

# 5. Seed database
npm run prisma:seed
```

---

## 🛠️ **METHOD 2: SQL Reset Script**

If you prefer to reset via SQL directly, use this script:

### **Complete Reset SQL Script**

Run this in Render's database console: https://dashboard.render.com/d/dpg-d3vpkgmmcj7s73dkige0-a

```sql
-- ========================================
-- COMPLETE DATABASE RESET
-- ========================================
-- WARNING: This deletes ALL data!

BEGIN;

-- Drop all tables (cascade to handle foreign keys)
DROP TABLE IF EXISTS "product_images" CASCADE;
DROP TABLE IF EXISTS "product_reviews" CASCADE;
DROP TABLE IF EXISTS "cart_items" CASCADE;
DROP TABLE IF EXISTS "wishlist_items" CASCADE;
DROP TABLE IF EXISTS "order_items" CASCADE;
DROP TABLE IF EXISTS "orders" CASCADE;
DROP TABLE IF EXISTS "transactions" CASCADE;
DROP TABLE IF EXISTS "products" CASCADE;
DROP TABLE IF EXISTS "categories" CASCADE;
DROP TABLE IF EXISTS "dispute_evidence" CASCADE;
DROP TABLE IF EXISTS "dispute_messages" CASCADE;
DROP TABLE IF EXISTS "disputes" CASCADE;
DROP TABLE IF EXISTS "ticket_messages" CASCADE;
DROP TABLE IF EXISTS "tickets" CASCADE;
DROP TABLE IF EXISTS "coupons" CASCADE;
DROP TABLE IF EXISTS "user_roles" CASCADE;
DROP TABLE IF EXISTS "roles" CASCADE;
DROP TABLE IF EXISTS "kyc_verifications" CASCADE;
DROP TABLE IF EXISTS "password_resets" CASCADE;
DROP TABLE IF EXISTS "user_sessions" CASCADE;
DROP TABLE IF EXISTS "notifications" CASCADE;
DROP TABLE IF EXISTS "admin_actions" CASCADE;
DROP TABLE IF EXISTS "audit_logs" CASCADE;
DROP TABLE IF EXISTS "system_logs" CASCADE;
DROP TABLE IF EXISTS "admin_invites" CASCADE;
DROP TABLE IF EXISTS "payouts" CASCADE;
DROP TABLE IF EXISTS "users" CASCADE;

-- Drop Prisma migration table
DROP TABLE IF EXISTS "_prisma_migrations" CASCADE;

-- Drop all enum types
DROP TYPE IF EXISTS "ProductStatus" CASCADE;
DROP TYPE IF EXISTS "OrderStatus" CASCADE;
DROP TYPE IF EXISTS "PaymentStatus" CASCADE;
DROP TYPE IF EXISTS "TransactionType" CASCADE;
DROP TYPE IF EXISTS "TransactionStatus" CASCADE;
DROP TYPE IF EXISTS "CartStatus" CASCADE;
DROP TYPE IF EXISTS "CouponType" CASCADE;
DROP TYPE IF EXISTS "DisputeStatus" CASCADE;
DROP TYPE IF EXISTS "DisputePriority" CASCADE;
DROP TYPE IF EXISTS "TicketStatus" CASCADE;
DROP TYPE IF EXISTS "TicketPriority" CASCADE;
DROP TYPE IF EXISTS "KycType" CASCADE;
DROP TYPE IF EXISTS "KycStatus" CASCADE;
DROP TYPE IF EXISTS "LogLevel" CASCADE;
DROP TYPE IF EXISTS "PayoutStatus" CASCADE;

COMMIT;

-- After running this, run Prisma migrations:
-- npx prisma migrate dev --name init
-- OR
-- npx prisma db push
```

---

## 📋 **METHOD 3: Prisma Migrate Reset (Safest)**

This is the recommended Prisma way:

```bash
# In Render Shell or locally
cd nxoland-backend

# Reset database (drops all, recreates, runs migrations, seeds)
npx prisma migrate reset

# This command:
# 1. Drops all tables
# 2. Recreates database
# 3. Applies all migrations
# 4. Runs seed script (if configured)
```

**Note:** If seed doesn't run automatically, run:
```bash
npm run prisma:seed
```

---

## 🔧 **Step-by-Step Complete Reset**

### **1. Reset Database**

```bash
cd nxoland-backend

# Option A: Reset and re-seed automatically
npx prisma migrate reset

# Option B: Manual reset
npx prisma migrate reset --skip-seed  # Reset without seeding
npx prisma generate                   # Regenerate client
npm run prisma:seed                   # Seed manually
```

### **2. Verify Schema Matches**

```bash
# Check schema is up to date
npx prisma validate

# See current database state
npx prisma studio
```

### **3. Create New Migration (if needed)**

```bash
# Create new migration if schema changed
npx prisma migrate dev --name add_new_features

# Or push schema directly (development only)
npx prisma db push
```

### **4. Seed Database**

```bash
# Seed with test data
npm run prisma:seed
```

---

## ✅ **VERIFICATION CHECKLIST**

After reset and migration, verify:

1. **Tables Created:**
   ```sql
   SELECT COUNT(*) FROM information_schema.tables 
   WHERE table_schema = 'public' 
   AND table_name NOT LIKE '_prisma%';
   -- Should return 27+ tables
   ```

2. **Roles Exist:**
   ```sql
   SELECT * FROM roles;
   -- Should have: admin, seller, user
   ```

3. **Users Created:**
   ```sql
   SELECT COUNT(*) FROM users;
   -- Should be 7 after seeding
   ```

4. **Categories Created:**
   ```sql
   SELECT * FROM categories;
   -- Should be 4 categories
   ```

5. **Products Created:**
   ```sql
   SELECT COUNT(*) FROM products;
   -- Should be 5 products after seeding
   ```

---

## 🎯 **RECOMMENDED APPROACH**

**For Production (Render):**

1. ✅ Use **Render Shell**
2. ✅ Run: `npx prisma migrate reset` (auto-resets, migrates, seeds)
3. ✅ Or: `npx prisma migrate reset --skip-seed` then `npm run prisma:seed`

**For Development:**

1. ✅ Run locally with Render's DATABASE_URL
2. ✅ Same commands work
3. ✅ Faster iteration

---

## 🔍 **TROUBLESHOOTING**

### **Issue: "Migration table doesn't exist"**

**Solution:**
```bash
npx prisma migrate dev --name init
```

### **Issue: "Schema drift detected"**

**Solution:**
```bash
# Reset completely
npx prisma migrate reset

# Or manually resolve
npx prisma migrate resolve --applied <migration_name>
```

### **Issue: "Foreign key constraint error"**

**Solution:**
The reset script uses `CASCADE` which should handle this. If issues persist:
```bash
# Drop everything manually via SQL first (see METHOD 2)
# Then run migrations fresh
npx prisma migrate dev
```

### **Issue: "Enum type already exists"**

**Solution:**
The SQL reset script drops all enum types first. If you get this error:
```sql
DROP TYPE IF EXISTS "ProductStatus" CASCADE;
-- Repeat for all enum types
```

---

## 📝 **Quick Reference Commands**

```bash
# Complete reset (recommended)
cd nxoland-backend
npx prisma migrate reset

# Manual reset
npx prisma migrate reset --skip-seed
npx prisma generate
npm run prisma:seed

# Check status
npx prisma migrate status

# View database
npx prisma studio

# Validate schema
npx prisma validate
```

---

## 🎉 **AFTER RESET**

Once reset is complete:

1. ✅ Database is fresh and clean
2. ✅ All migrations applied
3. ✅ Schema matches `schema.prisma`
4. ✅ Test data seeded (if you ran seed)
5. ✅ Ready for development/production

**Next Steps:**
- Test API endpoints
- Verify user login
- Check admin panel
- Test product creation

---

## 📌 **IMPORTANT NOTES**

1. **Backup First:** If you have important data, export it before reset
2. **Migration History:** `migrate reset` clears migration history - fine for dev
3. **Production Caution:** Always backup production databases before reset
4. **Prisma Migrations:** Keep migrations in version control
5. **Schema Changes:** Always create migrations for schema changes, don't use `db push` in production

---

**Ready to reset? Follow METHOD 1 (Render Shell) for the safest approach!** 🚀

