-- ========================================
-- COMPLETE DATABASE RESET SQL SCRIPT
-- Run this in Render's database console
-- Location: https://dashboard.render.com/d/dpg-d3vpkgmmcj7s73dkige0-a
-- ========================================
-- ⚠️ WARNING: This DELETES ALL DATA!

BEGIN;

-- Drop all tables in correct order (respecting foreign keys)
DROP TABLE IF EXISTS "product_images" CASCADE;
DROP TABLE IF EXISTS "product_reviews" CASCADE;
DROP TABLE IF EXISTS "cart_items" CASCADE;
DROP TABLE IF EXISTS "wishlist_items" CASCADE;
DROP TABLE IF EXISTS "order_items" CASCADE;
DROP TABLE IF EXISTS "transactions" CASCADE;
DROP TABLE IF EXISTS "orders" CASCADE;
DROP TABLE IF EXISTS "products" CASCADE;
DROP TABLE IF EXISTS "categories" CASCADE;
DROP TABLE IF EXISTS "dispute_evidence" CASCADE;
DROP TABLE IF EXISTS "dispute_messages" CASCADE;
DROP TABLE IF EXISTS "disputes" CASCADE;
DROP TABLE IF EXISTS "ticket_messages" CASCADE;
DROP TABLE IF EXISTS "tickets" CASCADE;
DROP TABLE IF EXISTS "coupons" CASCADE;
DROP TABLE IF EXISTS "user_roles" CASCADE;
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
DROP TABLE IF EXISTS "roles" CASCADE;

-- Drop Prisma migration tracking table
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

-- ========================================
-- After running this SQL script:
-- ========================================
-- 1. Go to Render Shell
-- 2. Run: cd /opt/render/project/src/nxoland-backend
-- 3. Run: npx prisma migrate dev --name init
-- 4. Run: npx prisma generate
-- 5. Run: npm run prisma:seed
-- ========================================

-- Verify reset
SELECT 
  'Tables' as type,
  COUNT(*) as count 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name NOT LIKE '_prisma%'
UNION ALL
SELECT 
  'Enums',
  COUNT(*) 
FROM pg_type 
WHERE typname IN (
  'ProductStatus', 'OrderStatus', 'PaymentStatus', 
  'TransactionType', 'TransactionStatus', 'CartStatus',
  'CouponType', 'DisputeStatus', 'DisputePriority',
  'TicketStatus', 'TicketPriority', 'KycType',
  'KycStatus', 'LogLevel', 'PayoutStatus'
);

-- Should return 0 for both if reset was successful

