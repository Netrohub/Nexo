# NXOLand Database Seeding Guide

This guide explains how to seed the NXOLand database with test users, sellers, and products for development and testing.

## Overview

The seed script creates:
- 1 Admin user
- 3 Seller accounts with products
- 3 Regular user accounts
- 4 Categories
- 5 Sample products

## Quick Start

### 1. Run the Seed Script

```bash
cd nxoland-backend
npm run prisma:seed
```

Or directly with ts-node:

```bash
cd nxoland-backend
npx ts-node prisma/seed.ts
```

### 2. Verify Seeding

Check the console output. You should see:

```
🌱 Starting database seeding...
✅ Created admin user
✅ Created seller: seller1
✅ Created seller: seller2
✅ Created seller: gameseller
✅ Created user: user1
✅ Created user: user2
✅ Created user: buyer123
✅ Created category: Gaming Accounts
✅ Created category: Social Media
✅ Created category: Digital Services
✅ Created category: Gaming Products
✅ Created product: Premium Call of Duty Account - Max Level
✅ Created product: Instagram Account - 50K Followers
✅ Created product: TikTok Creator Account - Verified
✅ Created product: YouTube Channel - 10K Subscribers
✅ Created product: CS:GO Prime Account - Global Elite
🎉 Database seeding completed successfully!
```

## Test Accounts

All accounts use the password: `Password123!`

### Admin Account
- **Email**: admin@nxoland.com
- **Username**: admin
- **Name**: Admin User
- **Roles**: admin
- **KYC Status**: Fully verified

### Seller Accounts

#### Seller 1
- **Email**: seller1@nxoland.com
- **Username**: seller1
- **Name**: John Seller
- **Roles**: user, seller
- **Products**: Gaming accounts

#### Seller 2
- **Email**: seller2@nxoland.com
- **Username**: seller2
- **Name**: Sarah Vendor
- **Roles**: user, seller
- **Products**: Social media accounts

#### Game Seller
- **Email**: gameseller@nxoland.com
- **Username**: gameseller
- **Name**: Game Master
- **Roles**: user, seller
- **Products**: YouTube channels and digital services

### Regular Users

#### User 1
- **Email**: user1@nxoland.com
- **Username**: user1
- **Name**: Test User
- **Roles**: user
- **KYC Status**: Not verified

#### User 2
- **Email**: user2@nxoland.com
- **Username**: user2
- **Name**: Another User
- **Roles**: user
- **KYC Status**: Not verified

#### Buyer
- **Email**: buyer@nxoland.com
- **Username**: buyer123
- **Name**: Regular Buyer
- **Roles**: user
- **KYC Status**: Not verified

## Products Created

1. **Premium Call of Duty Account - Max Level**
   - Category: Gaming Accounts
   - Price: $199.99
   - Seller: seller1

2. **Instagram Account - 50K Followers**
   - Category: Social Media
   - Price: $299.99
   - Seller: seller2

3. **TikTok Creator Account - Verified**
   - Category: Social Media
   - Price: $599.99
   - Seller: seller2

4. **YouTube Channel - 10K Subscribers**
   - Category: Digital Services
   - Price: $799.99
   - Seller: gameseller

5. **CS:GO Prime Account - Global Elite**
   - Category: Gaming Accounts
   - Price: $149.99
   - Seller: seller1

## Seeding on Production Server

To seed the production database:

```bash
# SSH into your server
ssh user@your-server.com

# Navigate to backend directory
cd /path/to/nxoland-backend

# Run the seed script
npm run prisma:seed
```

## Troubleshooting

### Error: User already exists

The seed script uses `upsert` operations, so it's safe to run multiple times. Existing users will be skipped.

### Error: Database connection failed

Make sure your `.env` file has the correct `DATABASE_URL`:

```env
DATABASE_URL="mysql://username:password@localhost:3306/nxoland"
```

### Error: Table doesn't exist

Make sure you've run the database migrations first:

```bash
npx prisma migrate deploy
```

## Customizing Seed Data

To customize the seed data, edit `nxoland-backend/prisma/seed.ts`:

1. Modify user data in the `sellers`, `users` arrays
2. Add or remove products in the `products` array
3. Update categories in the `categories` array

After making changes, run:

```bash
npm run prisma:seed
```

## Resetting the Database

⚠️ **Warning**: This will delete all data!

```bash
# Reset the database (careful!)
npx prisma migrate reset

# Re-run migrations
npx prisma migrate deploy

# Seed the database
npm run prisma:seed
```

## Next Steps

After seeding:

1. **Test the API**: Use the Swagger docs at `/api/docs`
2. **Login**: Try logging in with any of the test accounts
3. **Browse Products**: View products on the homepage
4. **Create Orders**: Test the checkout process
5. **Test Admin Panel**: Log in as admin to access the admin dashboard

## Additional Resources

- [Prisma Documentation](https://www.prisma.io/docs)
- [NestJS Documentation](https://docs.nestjs.com)
- [Database Schema](./nxoland-backend/prisma/schema.prisma)

---

**Last Updated**: January 2025  
**Maintained By**: NXOLand Development Team
