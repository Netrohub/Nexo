-- ============================================
-- NXOLand Marketplace - MySQL Database Setup
-- ============================================
-- Run this script to create the database and user
-- Execute: mysql -u root -p < setup-mysql.sql

-- Create database
CREATE DATABASE IF NOT EXISTS nxoland 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Create user (optional - for security)
CREATE USER IF NOT EXISTS 'nxoland_user'@'localhost' IDENTIFIED BY 'secure_password_here';

-- Grant privileges
GRANT ALL PRIVILEGES ON nxoland.* TO 'nxoland_user'@'localhost';
GRANT ALL PRIVILEGES ON nxoland.* TO 'root'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Use the database
USE nxoland;

-- Display success message
SELECT 
    'Database created successfully!' AS status,
    DATABASE() AS current_database,
    @@character_set_database AS charset,
    @@collation_database AS collation;

-- Show database info
SHOW CREATE DATABASE nxoland;

-- ============================================
-- Next steps:
-- 1. Update Laravel .env:
--    DB_DATABASE=nxoland
--    DB_USERNAME=root (or nxoland_user)
--    DB_PASSWORD=your_password
--
-- 2. Run Laravel migrations:
--    php artisan migrate
--
-- 3. Seed database:
--    php artisan db:seed
-- ============================================
