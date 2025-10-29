# 🌱 Seed Render Database Guide

**Date:** October 29, 2025  
**Database:** `nxoland` on Render (PostgreSQL)

---

## 📊 **DATABASE STATUS**

✅ **Database Found:** `nxoland` (PostgreSQL 17)  
📊 **Current Users:** 0 (Database is empty - ready for seeding)  
🔗 **Database ID:** `dpg-d3vpkgmmcj7s73dkige0-a`

---

## ✅ **WHAT'S ALREADY DONE**

1. ✅ **Seed Script Updated** - `nxoland-backend/prisma/seed.ts` now matches current schema
2. ✅ **Schema Compatible** - Script uses correct models:
   - `Role` and `UserRole` for role management
   - `Category` with `is_active` field
   - `Product` with `ProductStatus` enum
   - Proper relations and foreign keys

---

## 🚀 **METHOD 1: Seed via Render Shell (RECOMMENDED)**

### **Step 1: Connect to Render Shell**

1. Go to: https://dashboard.render.com/web/srv-d3vp7pbipnbc739jr10g
2. Click **"Shell"** tab (or use SSH)
3. Or SSH directly:
   ```bash
   ssh srv-d3vp7pbipnbc739jr10g@ssh.frankfurt.render.com
   ```

### **Step 2: Navigate to Backend Directory**

```bash
cd /opt/render/project/src  # or wherever your backend code is
cd nxoland-backend  # if in subdirectory
```

### **Step 3: Run Seed Command**

```bash
# Make sure DATABASE_URL environment variable is set
# It should already be set in Render, but verify:
echo $DATABASE_URL

# Run the seed script
npx prisma db seed

# Or directly:
npm run prisma:seed

# Or with ts-node:
npx ts-node prisma/seed.ts
```

---

## 🖥️ **METHOD 2: Seed from Local Machine**

### **Prerequisites:**

1. **Get Render Database Connection String:**
   - Go to: https://dashboard.render.com/d/dpg-d3vpkgmmcj7s73dkige0-a
   - Click **"Connections"** tab
   - Copy the **"External Connection String"** (if allowed) or **"Internal Connection String"**

2. **Update `.env` file locally:**

```bash
cd nxoland-backend
```

Create/update `.env`:
```env
DATABASE_URL="postgresql://netro:[PASSWORD]@[HOST]:5432/nxoland?sslmode=require"
```

Replace:
- `[PASSWORD]` with your database password (found in Render dashboard)
- `[HOST]` with the database host

### **Run Seed:**

```bash
# From nxoland-backend directory
npx prisma generate  # Generate Prisma client
npx prisma db seed   # Run seed

# Or:
npm run prisma:seed
```

---

## 📡 **METHOD 3: Seed via Temporary API Endpoint**

### **Option A: Add Seed Endpoint (Development Only)**

**⚠️ WARNING:** Only use this in development! Remove after seeding.

Add to `nxoland-backend/src/admin/admin.controller.ts`:

```typescript
@Post('seed')
async seedDatabase() {
  return this.adminService.seedDatabase();
}
```

Add to `nxoland-backend/src/admin/admin.service.ts`:

```typescript
async seedDatabase() {
  // Run seed script
  const { execSync } = require('child_process');
  execSync('npx ts-node prisma/seed.ts', { stdio: 'inherit' });
  return { message: 'Database seeded successfully' };
}
```

Then call:
```bash
curl -X POST https://back-g6gc.onrender.com/api/admin/seed \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN"
```

**Remember to remove this endpoint after seeding!**

---

## 📋 **WHAT THE SEED SCRIPT CREATES**

### **Roles:**
- ✅ `admin` - Administrator role
- ✅ `seller` - Seller role  
- ✅ `user` - User role

### **Users:**
- ✅ `admin@nxoland.com` (admin role)
- ✅ `seller1@nxoland.com` (seller + user roles)
- ✅ `seller2@nxoland.com` (seller + user roles)
- ✅ `gameseller@nxoland.com` (seller + user roles)
- ✅ `user1@nxoland.com` (user role)
- ✅ `user2@nxoland.com` (user role)
- ✅ `buyer@nxoland.com` (user role)

**All passwords:** `Password123!`

### **Categories:**
- ✅ Gaming Accounts
- ✅ Social Media
- ✅ Digital Services
- ✅ Gaming Products

### **Products:**
- ✅ Premium Call of Duty Account - Max Level
- ✅ Instagram Account - 50K Followers
- ✅ TikTok Creator Account - Verified
- ✅ YouTube Channel - 10K Subscribers
- ✅ CS:GO Prime Account - Global Elite

---

## 🔍 **VERIFY SEEDING SUCCESS**

After running the seed, verify it worked:

```sql
-- Check users
SELECT id, username, email FROM users LIMIT 10;

-- Check roles
SELECT * FROM roles;

-- Check user roles
SELECT u.username, r.slug 
FROM users u
JOIN user_roles ur ON u.id = ur.user_id
JOIN roles r ON ur.role_id = r.id
LIMIT 10;

-- Check categories
SELECT * FROM categories;

-- Check products
SELECT id, name, status FROM products LIMIT 10;
```

Or use Render MCP to query:
```
"Query my Render database: SELECT COUNT(*) as user_count FROM users;"
```

---

## 🛠️ **TROUBLESHOOTING**

### **Issue: "Cannot find module '@prisma/client'"**

**Solution:**
```bash
npx prisma generate
npm install
```

### **Issue: "DATABASE_URL is not set"**

**Solution:**
- Render sets this automatically for your service
- Verify in Render dashboard: Service → Environment
- Or set manually: `export DATABASE_URL="your_connection_string"`

### **Issue: "Connection refused"**

**Possible causes:**
1. Database is suspended (free tier)
2. IP not allowed (check IP allowlist in Render)
3. Wrong connection string

**Solution:**
- Check database status in Render dashboard
- Verify connection string format
- Use internal connection string if on same Render network

### **Issue: "Schema mismatch"**

**Solution:**
```bash
# Ensure schema is up to date
npx prisma migrate deploy

# Or push schema
npx prisma db push
```

---

## ✅ **QUICK START (Render Shell Method)**

```bash
# 1. SSH into Render service
ssh srv-d3vp7pbipnbc739jr10g@ssh.frankfurt.render.com

# 2. Navigate to backend (adjust path as needed)
cd /opt/render/project/src/nxoland-backend

# 3. Verify DATABASE_URL is set
echo $DATABASE_URL

# 4. Generate Prisma client (if needed)
npx prisma generate

# 5. Run seed
npm run prisma:seed

# 6. Verify success
# You should see:
# ✅ Created admin user with admin role
# ✅ Created seller: seller1 with seller and user roles
# ... etc
```

---

## 🎯 **RECOMMENDED APPROACH**

**For Production:**
1. ✅ Use **Method 1 (Render Shell)** for one-time seeding
2. ✅ Verify data after seeding
3. ✅ Test login with seeded accounts
4. ✅ Remove seed script or protect it after use

**For Development:**
1. ✅ Use **Method 2 (Local Machine)** for frequent seeding
2. ✅ Keep seed script in version control
3. ✅ Document any changes to seed data

---

## 📝 **POST-SEED CHECKLIST**

After seeding:

- [ ] ✅ Verify users were created (check count)
- [ ] ✅ Test admin login: `admin@nxoland.com / Password123!`
- [ ] ✅ Test seller login: `seller1@nxoland.com / Password123!`
- [ ] ✅ Test user login: `user1@nxoland.com / Password123!`
- [ ] ✅ Verify categories appear in frontend
- [ ] ✅ Verify products appear in listings
- [ ] ✅ Check that roles are properly assigned
- [ ] ✅ Remove any temporary seeding endpoints

---

## 🔐 **SECURITY NOTES**

1. **Change Default Passwords**
   - After first login, change all default passwords
   - Especially for admin account!

2. **Remove Seed Endpoints**
   - If you added temporary seeding endpoints, remove them
   - Never expose seeding functionality in production

3. **Limit Access**
   - Seed script contains sensitive data
   - Keep it in `.gitignore` if it contains production passwords

---

## 🎉 **YOU'RE READY!**

Once seeded, your Render database will have:
- ✅ Complete user structure with roles
- ✅ Sample categories and products
- ✅ Test accounts ready for development/testing

**Next Steps:**
1. Seed the database using Method 1
2. Verify data was created
3. Test login with seeded accounts
4. Start developing! 🚀

---

**Need help?** Check Render logs or database console for errors.

