-- NXOLand Database Seed Script
-- Run this directly in Render's database console/query interface
-- Location: https://dashboard.render.com/d/dpg-d3vpkgmmcj7s73dkige0-a
--
-- IMPORTANT: All test accounts use password: Password123!
-- Fixed: Multi-row SELECT INTO issue resolved
--
-- Test Accounts Created:
--   Admin: admin@nxoland.com / Password123!
--   Seller: seller1@nxoland.com / Password123!
--   User: user1@nxoland.com / Password123!

-- ========================================
-- 1. CREATE ROLES
-- ========================================
INSERT INTO roles (name, slug, description, is_active, created_at, updated_at, permissions)
VALUES 
  ('Administrator', 'admin', 'System administrator with full access', true, NOW(), NOW(), '{"all": true}'::jsonb),
  ('Seller', 'seller', 'Seller can create and manage products', true, NOW(), NOW(), '{"create_product": true, "manage_own_products": true, "view_own_orders": true}'::jsonb),
  ('User', 'user', 'Regular user can browse and purchase', true, NOW(), NOW(), '{"browse": true, "purchase": true, "create_ticket": true}'::jsonb)
ON CONFLICT (slug) DO NOTHING;

-- Get role IDs for later use
DO $$
DECLARE
    admin_role_id INT;
    seller_role_id INT;
    user_role_id INT;
    admin_user_id INT;
    seller1_id INT;
    seller2_id INT;
    seller3_id INT;
    user1_id INT;
    user2_id INT;
    user3_id INT;
    gaming_cat_id INT;
    social_cat_id INT;
    digital_cat_id INT;
    gaming_prod_cat_id INT;
    hashed_pw TEXT := '$2b$12$pnnvSY1FEuoGkfEwr8XaauOBNuNILchoj186HHTJxYamr7yYuuKWC'; -- Password123!
BEGIN
    -- Get role IDs
    SELECT id INTO admin_role_id FROM roles WHERE slug = 'admin';
    SELECT id INTO seller_role_id FROM roles WHERE slug = 'seller';
    SELECT id INTO user_role_id FROM roles WHERE slug = 'user';

    -- ========================================
    -- 2. CREATE ADMIN USER
    -- ========================================
    INSERT INTO users (username, name, email, password, is_active, email_verified_at, created_at, updated_at)
    VALUES ('admin', 'Admin User', 'admin@nxoland.com', hashed_pw, true, NOW(), NOW(), NOW())
    ON CONFLICT (email) DO UPDATE SET password = hashed_pw
    RETURNING id INTO admin_user_id;

    -- Assign admin role
    INSERT INTO user_roles (user_id, role_id, granted_at, created_at)
    VALUES (admin_user_id, admin_role_id, NOW(), NOW())
    ON CONFLICT (user_id, role_id) DO NOTHING;

    -- ========================================
    -- 3. CREATE SELLER USERS
    -- ========================================
    INSERT INTO users (username, name, email, password, is_active, email_verified_at, created_at, updated_at)
    VALUES 
      ('seller1', 'John Seller', 'seller1@nxoland.com', hashed_pw, true, NOW(), NOW(), NOW()),
      ('seller2', 'Sarah Vendor', 'seller2@nxoland.com', hashed_pw, true, NOW(), NOW(), NOW()),
      ('gameseller', 'Game Master', 'gameseller@nxoland.com', hashed_pw, true, NOW(), NOW(), NOW())
    ON CONFLICT (email) DO UPDATE SET password = hashed_pw;

    -- Get seller IDs individually
    SELECT id INTO seller1_id FROM users WHERE email = 'seller1@nxoland.com';
    SELECT id INTO seller2_id FROM users WHERE email = 'seller2@nxoland.com';
    SELECT id INTO seller3_id FROM users WHERE email = 'gameseller@nxoland.com';

    -- Assign seller and user roles to sellers
    INSERT INTO user_roles (user_id, role_id, granted_at, created_at)
    SELECT u.id, r.id, NOW(), NOW()
    FROM users u, roles r
    WHERE u.email IN ('seller1@nxoland.com', 'seller2@nxoland.com', 'gameseller@nxoland.com')
      AND r.slug IN ('seller', 'user')
    ON CONFLICT (user_id, role_id) DO NOTHING;

    -- ========================================
    -- 4. CREATE REGULAR USERS
    -- ========================================
    INSERT INTO users (username, name, email, password, is_active, created_at, updated_at)
    VALUES 
      ('user1', 'Test User', 'user1@nxoland.com', hashed_pw, true, NOW(), NOW()),
      ('user2', 'Another User', 'user2@nxoland.com', hashed_pw, true, NOW(), NOW()),
      ('buyer123', 'Regular Buyer', 'buyer@nxoland.com', hashed_pw, true, NOW(), NOW())
    ON CONFLICT (email) DO UPDATE SET password = hashed_pw;

    -- Get user IDs individually
    SELECT id INTO user1_id FROM users WHERE email = 'user1@nxoland.com';
    SELECT id INTO user2_id FROM users WHERE email = 'user2@nxoland.com';
    SELECT id INTO user3_id FROM users WHERE email = 'buyer@nxoland.com';

    -- Assign user role
    INSERT INTO user_roles (user_id, role_id, granted_at, created_at)
    SELECT u.id, user_role_id, NOW(), NOW()
    FROM users u
    WHERE u.email IN ('user1@nxoland.com', 'user2@nxoland.com', 'buyer@nxoland.com')
    ON CONFLICT (user_id, role_id) DO NOTHING;

    -- ========================================
    -- 5. CREATE CATEGORIES
    -- ========================================
    INSERT INTO categories (name, slug, description, is_active, sort_order, created_at, updated_at)
    VALUES 
      ('Gaming Accounts', 'gaming-accounts', 'High-level gaming accounts and rare items', true, 0, NOW(), NOW()),
      ('Social Media', 'social-media', 'Premium social media accounts', true, 0, NOW(), NOW()),
      ('Digital Services', 'digital-services', 'Various digital services and tools', true, 0, NOW(), NOW()),
      ('Gaming Products', 'gaming-products', 'Gaming assets, in-game items, and accounts', true, 0, NOW(), NOW())
    ON CONFLICT (slug) DO NOTHING;

    -- Get category IDs (verify they exist)
    SELECT id INTO gaming_cat_id FROM categories WHERE slug = 'gaming-accounts';
    SELECT id INTO social_cat_id FROM categories WHERE slug = 'social-media';
    SELECT id INTO digital_cat_id FROM categories WHERE slug = 'digital-services';
    SELECT id INTO gaming_prod_cat_id FROM categories WHERE slug = 'gaming-products';

    -- ========================================
    -- 6. CREATE PRODUCTS
    -- ========================================
    INSERT INTO products (name, slug, description, price, category_id, seller_id, platform, game, account_level, status, stock_quantity, delivery_time, created_at, updated_at)
    VALUES 
      (
        'Premium Call of Duty Account - Max Level',
        'premium-call-of-duty-account-max-level',
        'Fully maxed out COD account with all weapons and camos. Battle-tested and verified.',
        199.99,
        gaming_cat_id,
        seller1_id,
        'PlayStation',
        'Call of Duty',
        'Max Level',
        'ACTIVE',
        1,
        'instant',
        NOW(),
        NOW()
      ),
      (
        'Instagram Account - 50K Followers',
        'instagram-account-50k-followers',
        'Authentic Instagram account with real followers and engagement. Niche: Gaming',
        299.99,
        social_cat_id,
        seller2_id,
        'Instagram',
        NULL,
        '50K Followers',
        'ACTIVE',
        1,
        'instant',
        NOW(),
        NOW()
      ),
      (
        'TikTok Creator Account - Verified',
        'tiktok-creator-account-verified',
        'Verified TikTok creator account with 100K+ followers. High engagement rate.',
        599.99,
        social_cat_id,
        seller2_id,
        'TikTok',
        NULL,
        '100K+ Followers',
        'ACTIVE',
        1,
        'instant',
        NOW(),
        NOW()
      ),
      (
        'YouTube Channel - 10K Subscribers',
        'youtube-channel-10k-subscribers',
        'Gaming YouTube channel with 10K real subscribers. Monetization ready.',
        799.99,
        digital_cat_id,
        seller3_id,
        'YouTube',
        NULL,
        '10K Subscribers',
        'ACTIVE',
        1,
        'instant',
        NOW(),
        NOW()
      ),
      (
        'CS:GO Prime Account - Global Elite',
        'csgo-prime-account-global-elite',
        'Prime CS:GO account with Global Elite rank and rare items in inventory.',
        149.99,
        gaming_cat_id,
        seller1_id,
        'Steam',
        'CS:GO',
        'Global Elite',
        'ACTIVE',
        1,
        'instant',
        NOW(),
        NOW()
      )
    ON CONFLICT (slug) DO NOTHING;

    -- ========================================
    -- 7. CREATE PRODUCT IMAGES
    -- ========================================
    INSERT INTO product_images (product_id, image_url, alt_text, is_primary, sort_order, created_at)
    SELECT 
      p.id,
      'https://images.unsplash.com/photo-1607853554439-0069ec1ca922?w=800&q=80',
      p.name,
      true,
      0,
      NOW()
    FROM products p
    WHERE p.slug IN (
      'premium-call-of-duty-account-max-level',
      'instagram-account-50k-followers',
      'tiktok-creator-account-verified',
      'youtube-channel-10k-subscribers',
      'csgo-prime-account-global-elite'
    )
    AND NOT EXISTS (
      SELECT 1 FROM product_images WHERE product_id = p.id
    );

    RAISE NOTICE '🎉 Database seeding completed successfully!';
    RAISE NOTICE '📧 Test Accounts:';
    RAISE NOTICE '  Admin: admin@nxoland.com / Password123!';
    RAISE NOTICE '  Seller: seller1@nxoland.com / Password123!';
    RAISE NOTICE '  User: user1@nxoland.com / Password123!';
END $$;

-- Verify seeding
SELECT 
  'Users' as type, COUNT(*) as count FROM users
UNION ALL
SELECT 'Roles', COUNT(*) FROM roles
UNION ALL
SELECT 'User Roles', COUNT(*) FROM user_roles
UNION ALL
SELECT 'Categories', COUNT(*) FROM categories
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Product Images', COUNT(*) FROM product_images;

