# 🚀 Seed Render Database - Quick Start

**Status:** Database is empty and ready for seeding! ✅

---

## ⚡ **FASTEST METHOD (Copy & Paste)**

### **Step 1: Get Connection String**
1. Open: https://dashboard.render.com/d/dpg-d3vpkgmmcj7s73dkige0-a
2. Click **"Connections"** tab  
3. Copy **"Internal Connection String"** (looks like: `postgresql://netro:PASSWORD@dpg-xxx.xxx.compute-1.amazonaws.com:5432/nxoland`)

### **Step 2: Run This Command**

**Windows PowerShell:**
```powershell
cd nxoland-backend
$env:DATABASE_URL="YOUR_CONNECTION_STRING_HERE"; npx ts-node prisma/seed.ts
```

**Replace `YOUR_CONNECTION_STRING_HERE` with the connection string you copied.**

---

## 🔍 **OR USE RENDER SHELL (No Connection String Needed)**

1. Go to: https://dashboard.render.com/web/srv-d3vp7pbipnbc739jr10g
2. Click **"Shell"** tab (top right)
3. Paste and run:
   ```bash
   cd /opt/render/project/src/nxoland-backend && npm run prisma:seed
   ```

---

## ✅ **What Will Be Created**

- ✅ 3 Roles (admin, seller, user)
- ✅ 7 Users (1 admin, 3 sellers, 3 regular users)  
- ✅ 4 Categories
- ✅ 5 Sample Products

**Test Accounts:**
- **Admin:** `admin@nxoland.com` / `Password123!`
- **Seller:** `seller1@nxoland.com` / `Password123!`
- **User:** `user1@nxoland.com` / `Password123!`

---

## 🎯 **After Seeding**

I'll verify the data was created successfully using Render MCP.

Just tell me when you've run the seed, and I'll check! ✅

