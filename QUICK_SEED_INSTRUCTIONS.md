# 🚀 Quick Seed Instructions

## Option 1: Run Locally (RECOMMENDED)

1. **Get Database Connection String:**
   - Go to: https://dashboard.render.com/d/dpg-d3vpkgmmcj7s73dkige0-a
   - Click **"Connections"** tab
   - Copy the **"Internal Connection String"** (use this if running from your computer)
   - Format: `postgresql://netro:[PASSWORD]@[HOST]:5432/nxoland?sslmode=require`

2. **Run Seed Script:**
   ```bash
   cd nxoland-backend
   DATABASE_URL="postgresql://netro:PASSWORD@HOST:5432/nxoland?sslmode=require" npx ts-node prisma/seed.ts
   ```

   Or use the standalone script:
   ```bash
   cd nxoland-backend
   DATABASE_URL="postgresql://netro:PASSWORD@HOST:5432/nxoland?sslmode=require" node ../seed-render-db.js
   ```

## Option 2: Run via Render Shell

1. Go to: https://dashboard.render.com/web/srv-d3vp7pbipnbc739jr10g
2. Click **"Shell"** tab
3. Run:
   ```bash
   cd /opt/render/project/src/nxoland-backend
   npm run prisma:seed
   ```

