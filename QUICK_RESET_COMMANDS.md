# ⚡ Quick Reset Commands

**Fastest way to reset and migrate Render database**

---

## 🚀 **ONE-LINER COMMANDS**

### **Complete Reset (All-in-One)**
```bash
cd nxoland-backend && npx prisma migrate reset
```
This does everything: drops tables, recreates, migrates, and seeds!

---

### **Reset Without Seeding**
```bash
cd nxoland-backend && npx prisma migrate reset --skip-seed && npm run prisma:seed
```

---

### **Manual Step-by-Step**
```bash
cd nxoland-backend
npx prisma migrate reset --skip-seed    # Reset DB
npx prisma generate                      # Generate client
npx prisma migrate dev --name init        # Create migration
npm run prisma:seed                      # Seed data
```

---

## 📍 **WHERE TO RUN**

### **Option 1: Render Shell (RECOMMENDED)**
1. Go to: https://dashboard.render.com/web/srv-d3vp7pbipnbc739jr10g
2. Click **"Shell"** tab
3. Run commands above

### **Option 2: Local Machine**
```bash
# Set DATABASE_URL first
export DATABASE_URL="postgresql://netro:PASSWORD@HOST:5432/nxoland"
cd nxoland-backend
npx prisma migrate reset
```

---

## ✅ **VERIFICATION**

After reset, verify:
```bash
# Check tables
npx prisma studio

# Or query via Render MCP
"Query my Render database: SELECT COUNT(*) FROM users;"
```

---

**That's it! One command to rule them all:** `npx prisma migrate reset` 🎯

