# 📋 NXOLand Project Structure Analysis

**Date:** October 28, 2025  
**Purpose:** Organized high-level sections for systematic audit  
**Project:** NXOLand Marketplace (Frontend + Backend)

---

## 🏗️ Project Sections Overview

This document organizes the NXOLand codebase into **15 logical sections** for systematic auditing.

---

## 1️⃣ Authentication & Authorization

**Purpose:** User authentication, registration, and access control

### Frontend
- **Pages:**
  - `Login.tsx` - User login page
  - `Register.tsx` - User registration
  - `AdminLogin.tsx` - Separate admin login
  - `ForgotPassword.tsx` - Password reset flow

- **Components:**
  - `RequireAuth.tsx` - Protected route wrapper
  - `TurnstileWidget.tsx` - Cloudflare Turnstile CAPTCHA
  - `redirects/` - Auth redirect handlers

- **Contexts:**
  - `AuthContext.tsx` - User authentication state
  - `AdminAuthContext.tsx` - Admin authentication state

- **Lib:**
  - `tokenEncryption.ts` - Token security

### Backend
- **Module:** `auth/`
  - `auth.controller.ts` - Auth endpoints
  - `auth.service.ts` - Auth business logic
  - `jwt.strategy.ts` - JWT validation
  - `jwt-auth.guard.ts` - Route protection
  - `roles.guard.ts` - Role-based access
  - `decorators.ts` - Auth decorators
  - DTOs: login, register, password reset

### Key Features
- JWT authentication
- Role-based access control (User/Seller/Admin)
- Password reset flow
- Admin separate authentication
- Protected routes
- Token encryption

---

## 2️⃣ User Management & Profiles

**Purpose:** User accounts, profiles, and public user pages

### Frontend
- **Pages:**
  - `UserProfilePage.tsx` - Public user profile view
  - `Members.tsx` - Browse all members
  - `account/Profile.tsx` - User profile settings
  - `account/PhoneVerification.tsx` - Phone verification

- **Components:**
  - `AccountLayout.tsx` - Account pages layout
  - `UserProfileLink.tsx` - Profile link component
  - `PersonaVerification.tsx` - ID verification

### Backend
- **Module:** `users/`
  - `users.controller.ts` - User management endpoints
  - `users.service.ts` - User business logic
  - `public-users.controller.ts` - Public profile endpoints

### Key Features
- User profiles (public & private)
- Profile editing
- Phone verification
- Member directory
- Username system
- Reserved usernames

---

## 3️⃣ Dashboard (Buyer & Seller)

**Purpose:** Unified dashboard for buyers and sellers

### Frontend
- **Pages:**
  - `Dashboard.tsx` - Main dashboard page

- **Components:**
  - `DashboardLayout.tsx` - Dashboard container
  - `dashboard/OverviewTab.tsx` - Overview section
  - `dashboard/BuyerTab.tsx` - Buyer-specific features
  - `dashboard/SellerTab.tsx` - Seller-specific features
  - `dashboard/shared/` - Shared components
    - `StatCard.tsx` - Statistics cards
    - `SectionHeader.tsx` - Section headers
    - `EmptyState.tsx` - Empty states
    - `DashboardSkeleton.tsx` - Loading states
    - `FeatureFlags.tsx` - Feature toggles

- **Features:**
  - `features/dashboard/DashboardPage.tsx`

### Key Features
- Unified dashboard for all user types
- Tab-based navigation
- Real-time statistics
- Recent activity
- Quick actions
- Role-specific content

---

## 4️⃣ Products & Catalog

**Purpose:** Product browsing, search, and details

### Frontend
- **Pages:**
  - `Index.tsx` - Homepage with featured products
  - `Products.tsx` - Product listing page
  - `ProductDetail.tsx` - Product details page
  - `CategoryLanding.tsx` - Category-specific pages
  - `Games.tsx` - Gaming products category
  - `Compare.tsx` - Product comparison

- **Components:**
  - `ProductCard.tsx` - Product card component
  - `FeaturedProducts.tsx` - Featured products section
  - `CategoryGrid.tsx` - Category grid
  - `ComparisonMobile.tsx` - Mobile comparison view
  - `AdvancedSearch.tsx` - Advanced search filters
  - `ReviewForm.tsx` - Product reviews

- **Lib:**
  - `categoryImages.ts` - Category image mappings

### Backend
- **Module:** `products/`
  - `products.controller.ts` - Product endpoints
  - `products.service.ts` - Product business logic

- **Module:** `categories/`
  - `categories.controller.ts` - Category management
  - `categories.service.ts` - Category logic
  - DTOs: create-category, update-category

### Key Features
- Product listings with filters
- Product search
- Category browsing
- Product comparison
- Product reviews
- Featured products
- Gaming accounts
- Social media accounts

---

## 5️⃣ Shopping Experience (Cart & Wishlist)

**Purpose:** Shopping cart and wishlist management

### Frontend
- **Pages:**
  - `Cart.tsx` - Shopping cart page
  - `Wishlist.tsx` - User wishlist page
  - `account/Wishlist.tsx` - Account wishlist view

### Backend
- **Module:** `cart/`
  - `cart.controller.ts` - Cart endpoints
  - `cart.service.ts` - Cart business logic
  - DTOs: add-to-cart, update-cart-item

- **Module:** `wishlist/`
  - `wishlist.controller.ts` - Wishlist endpoints
  - `wishlist.service.ts` - Wishlist logic

### Key Features
- Add to cart
- Cart management
- Wishlist management
- Quantity updates
- Remove items
- Coupon application

---

## 6️⃣ Orders & Checkout

**Purpose:** Order placement and management

### Frontend
- **Pages:**
  - `Checkout.tsx` - Checkout process
  - `OrderConfirmation.tsx` - Order confirmation
  - `account/Orders.tsx` - Order history
  - `account/OrderDetail.tsx` - Order details

### Backend
- **Module:** `orders/`
  - `orders.controller.ts` - Order endpoints
  - `orders.service.ts` - Order business logic
  - DTOs: create-order, update-order

### Key Features
- Checkout flow
- Order creation
- Order history
- Order tracking
- Order details
- Order status updates

---

## 7️⃣ Seller Features

**Purpose:** Seller-specific functionality

### Frontend
- **Pages:**
  - `Sell.tsx` - List new product
  - `SellerProfile.tsx` - Public seller profile
  - `seller/SellerOnboarding.tsx` - Seller registration
  - `seller/Products.tsx` - Seller products management
  - `seller/CreateProduct.tsx` - Create product
  - `seller/Orders.tsx` - Seller orders
  - `seller/Billing.tsx` - Seller billing
  - `seller/Notifications.tsx` - Seller notifications
  - `seller/Profile.tsx` - Seller profile settings
  - `seller/ListGamingAccount.tsx` - List gaming account
  - `seller/ListSocialAccount.tsx` - List social account
  - `seller/ListSocialAccountComingSoon.tsx` - Coming soon

- **Components:**
  - `SellerLayout.tsx` - Seller pages layout
  - `redirects/SellerDashboardRedirect.tsx`
  - `redirects/SellerProfileRedirect.tsx`

- **Lib:**
  - `sellerApi.ts` - Seller-specific API calls

### Backend
- **Module:** `seller/`
  - `seller.controller.ts` - Seller endpoints
  - `seller.service.ts` - Seller business logic

### Key Features
- Seller onboarding
- Product listing (gaming/social accounts)
- Seller dashboard
- Sales management
- Seller profile
- Seller verification
- Product management

---

## 8️⃣ Payment & Billing

**Purpose:** Payment processing and financial management

### Frontend
- **Pages:**
  - `Checkout.tsx` - Payment processing
  - `account/Billing.tsx` - User billing
  - `account/Wallet.tsx` - User wallet
  - `seller/Billing.tsx` - Seller billing
  - `Pricing.tsx` - Pricing plans

- **Lib:**
  - `tapPayment.ts` - Tap Payment integration

### Backend
- **Module:** `payouts/`
  - `payouts.controller.ts` - Payout endpoints
  - `payouts.service.ts` - Payout logic
  - DTOs: create-payout, update-payout

### Key Features
- Tap Payment integration
- Checkout process
- Wallet management
- Seller payouts
- Pricing plans
- Payment history

---

## 9️⃣ Disputes & Support

**Purpose:** Dispute resolution and customer support

### Frontend
- **Pages:**
  - `disputes/DisputeList.tsx` - User disputes list
  - `disputes/DisputeDetail.tsx` - Dispute details
  - `disputes/CreateDispute.tsx` - Create dispute
  - `disputes/AdminDisputes.tsx` - Admin dispute management
  - `HelpCenter.tsx` - Help center

- **Components:**
  - `disputes/DisputeCard.tsx` - Dispute card
  - `disputes/DisputeForm.tsx` - Dispute form
  - `disputes/MessageThread.tsx` - Dispute messages
  - `disputes/EvidenceUpload.tsx` - Upload evidence
  - `disputes/StatusBadge.tsx` - Status indicator

### Backend
- **Module:** `disputes/`
  - `disputes.controller.ts` - Dispute endpoints
  - `disputes.service.ts` - Dispute logic

- **Module:** `tickets/`
  - `tickets.controller.ts` - Support ticket endpoints
  - `tickets.service.ts` - Ticket logic
  - DTOs: create-ticket, update-ticket

### Key Features
- Dispute creation
- Dispute management
- Message threads
- Evidence upload
- Support tickets
- Help center
- Dispute resolution

---

## 🔟 Admin Panel

**Purpose:** Administrative functions and management

### Frontend
- **Pages:**
  - `admin/AdminPanel.tsx` - Main admin dashboard
  - `admin/AdminDisputes.tsx` - Admin disputes

- **Components:**
  - `admin/EmptyState.tsx` - Empty states
  - `admin/ErrorBoundary.tsx` - Error handling
  - `admin/ErrorDisplay.tsx` - Error display
  - `admin/LoadingSpinner.tsx` - Loading states

- **Layouts:**
  - `AdminLayout.tsx` - Admin pages layout

- **Features:**
  - `features/users/list.tsx` - User management
  - `features/users/create.tsx` - Create user
  - `features/categories/list.tsx` - Category management
  - `features/coupons/list.tsx` - Coupon management
  - `features/audit-logs/list.tsx` - Audit logs
  - `features/listings/list.tsx` - Listing management
  - `features/orders/list.tsx` - Order management
  - `features/payouts/list.tsx` - Payout management
  - `features/tickets/list.tsx` - Ticket management
  - `features/disputes/list.tsx` - Dispute management

- **Constants:**
  - `constants/admin.ts` - Admin constants

- **Lib:**
  - `adminApi.ts` - Admin API calls

- **Refine:**
  - `refine/authProvider.ts` - Refine auth
  - `refine/dataProvider.ts` - Refine data

### Backend
- **Module:** `admin/`
  - `admin.controller.ts` - Admin endpoints
  - `admin.service.ts` - Admin logic

- **Module:** `audit-logs/`
  - `audit-logs.controller.ts` - Audit log endpoints
  - `audit-logs.service.ts` - Audit logic
  - DTOs: query-audit-logs

- **Module:** `coupons/`
  - `coupons.controller.ts` - Coupon management
  - `coupons.service.ts` - Coupon logic
  - DTOs: create-coupon, update-coupon

### Key Features
- User management
- Category management
- Coupon management
- Audit logs
- Dispute management
- Order management
- Payout management
- Ticket management
- System monitoring
- Admin dashboard

---

## 1️⃣1️⃣ KYC & Verification

**Purpose:** Identity verification and compliance

### Frontend
- **Pages:**
  - `account/KYC.tsx` - KYC submission
  - `account/PhoneVerification.tsx` - Phone verification

- **Components:**
  - `KYCStatus.tsx` - KYC status indicator
  - `RequireKYC.tsx` - KYC-protected routes
  - `PersonaVerification.tsx` - Persona integration
  - `SocialVerification.tsx` - Social media verification

### Backend
- **Module:** `kyc/`
  - `kyc.controller.ts` - KYC endpoints
  - `kyc.service.ts` - KYC business logic

### Key Features
- KYC submission
- Document upload
- Persona integration
- Phone verification
- Social media verification
- KYC status tracking
- Verification requirements

---

## 1️⃣2️⃣ Community & Social

**Purpose:** Community features and social interactions

### Frontend
- **Pages:**
  - `Members.tsx` - Member directory
  - `Leaderboard.tsx` - User leaderboard
  - `UserProfilePage.tsx` - Public profiles
  - `SellerProfile.tsx` - Seller profiles
  - `SocialMediaComingSoon.tsx` - Social features preview

### Key Features
- Member directory
- User profiles
- Seller profiles
- Leaderboard
- Social interactions
- Community features

---

## 1️⃣3️⃣ Notifications

**Purpose:** User notifications and alerts

### Frontend
- **Pages:**
  - `account/Notifications.tsx` - User notifications
  - `seller/Notifications.tsx` - Seller notifications

### Backend
- **Module:** `notification/`
  - `notification.module.ts` - Notification system

### Key Features
- Real-time notifications
- Email notifications
- Push notifications
- Notification preferences
- Notification history

---

## 1️⃣4️⃣ Content Pages

**Purpose:** Static and informational pages

### Frontend
- **Pages:**
  - `About.tsx` - About page
  - `Terms.tsx` - Terms of service
  - `Privacy.tsx` - Privacy policy
  - `Pricing.tsx` - Pricing information
  - `HelpCenter.tsx` - Help & FAQ
  - `NotFound.tsx` - 404 page
  - `Unauthorized.tsx` - 401 page

- **Components:**
  - `Hero.tsx` - Homepage hero
  - `Footer.tsx` - Site footer

### Key Features
- About page
- Terms & conditions
- Privacy policy
- Pricing plans
- Help center / FAQ
- Error pages

---

## 1️⃣5️⃣ Shared Infrastructure

**Purpose:** Shared utilities, components, and services

### Frontend

#### Hooks
- `useApi.ts` - API request hook
- `useAnalytics.ts` - Analytics tracking
- `usePrefetch.ts` - Data prefetching
- `use-mobile.tsx` - Mobile detection
- `use-toast.ts` - Toast notifications
- `useAdminList.ts` - Admin list management
- `useAdminMutation.ts` - Admin mutations

#### Lib/Utils
- `api.ts` - Main API client
- `adminApi.ts` - Admin API client
- `sellerApi.ts` - Seller API client
- `utils.ts` - General utilities
- `analytics.ts` - Analytics integration
- `rateLimiter.ts` - Rate limiting
- `sanitize.ts` - Input sanitization
- `display.ts` - Display utilities
- `tokenEncryption.ts` - Token security

#### UI Components (`components/ui/`)
- 50+ Shadcn UI components
- `mobile-icon-button.tsx` - Mobile-optimized button
- `ConfirmDialog.tsx` - Confirmation dialogs
- `DataTable.tsx` - Data tables

#### Layout Components
- `Navbar.tsx` - Main navigation
- `MobileNav.tsx` - Mobile navigation
- `Footer.tsx` - Site footer
- `ConditionalStarfield.tsx` - Background animation
- `Starfield.tsx` - Desktop background
- `ParticleField.tsx` - Particle effects

#### Utility Components
- `OptimizedImage.tsx` - Lazy-loaded images
- `LoadingStates.tsx` - Loading indicators
- `LanguageSwitcher.tsx` - Language selection
- `FileUpload.tsx` - File upload
- `AnalyticsProvider.tsx` - Analytics context

#### Contexts
- `AuthContext.tsx` - Authentication
- `AdminAuthContext.tsx` - Admin authentication
- `LanguageContext.tsx` - Internationalization

### Backend

#### Core Modules
- `common/` - Shared utilities
  - `database-health.service.ts` - Health checks
  - `validation.service.ts` - Input validation
  - `interceptors/prisma-serialize.interceptor.ts` - Data serialization

- `prisma/` - Database layer
  - `prisma.service.ts` - Prisma client
  - `prisma.module.ts` - Prisma module

- `email/` - Email service
  - `email.service.ts` - Email sending
  - `templates/` - Email templates

- `upload/` - File upload
  - `upload.module.ts` - Upload handling

- `health/` - Health checks
  - `health.controller.ts` - Health endpoints
  - `health.module.ts` - Health module

#### Configuration
- `app.module.ts` - Main app module
- `main.ts` - Application entry point
- `types/index.ts` - TypeScript types

### Key Features
- Reusable UI components
- API client abstraction
- Authentication context
- Analytics tracking
- Error handling
- Loading states
- Mobile responsiveness
- Internationalization
- Database connection
- Email service
- File upload
- Health monitoring

---

## 📊 Summary Statistics

### Frontend Structure
```
Total Pages:           55
Total Components:      80+
UI Components:         50+
Features:             12
Hooks:                7
Contexts:             3
Layouts:              2
```

### Backend Structure
```
Total Modules:        20
Controllers:          20+
Services:             20+
DTOs:                30+
Guards:              2
Strategies:          1
```

### Technology Stack
**Frontend:**
- React + TypeScript
- Vite
- TailwindCSS
- Shadcn UI
- React Query
- React Router
- Refine Admin

**Backend:**
- NestJS + TypeScript
- Prisma ORM
- PostgreSQL
- JWT Authentication
- Email Service

---

## 🎯 Audit Recommendations

### Suggested Audit Order

**Phase 1 - Core Functionality:**
1. Authentication & Authorization (security critical)
2. User Management & Profiles
3. Products & Catalog (core business)
4. Shopping Experience (Cart & Wishlist)

**Phase 2 - Transaction Flow:**
5. Orders & Checkout (revenue critical)
6. Payment & Billing (financial)
7. Seller Features (platform growth)

**Phase 3 - Support & Admin:**
8. Disputes & Support
9. Admin Panel (operational efficiency)
10. KYC & Verification (compliance)

**Phase 4 - Community & Polish:**
11. Community & Social
12. Notifications
13. Content Pages
14. Shared Infrastructure (optimization)

### Audit Focus Areas Per Section

Each section should be audited for:
- ✅ **Functionality:** Does it work as expected?
- ✅ **Security:** Are there vulnerabilities?
- ✅ **Performance:** Is it optimized?
- ✅ **UX/UI:** Is the experience good?
- ✅ **Code Quality:** Is it maintainable?
- ✅ **Testing:** Is it tested?
- ✅ **Documentation:** Is it documented?
- ✅ **Mobile:** Is it mobile-friendly?
- ✅ **Accessibility:** Is it accessible?
- ✅ **Error Handling:** Are errors handled?

---

## 📝 Next Steps

1. **Review this structure** - Confirm sections are logical
2. **Select audit section** - Choose where to start
3. **Deep dive analysis** - Comprehensive audit of selected section
4. **Document findings** - Record issues and improvements
5. **Implement fixes** - Apply necessary changes
6. **Repeat** - Move to next section

---

**Document Version:** 1.0  
**Last Updated:** October 28, 2025  
**Status:** Ready for Section-by-Section Audit  

---

**🎯 PROJECT STRUCTURE: ORGANIZED & READY FOR AUDIT! 🎯**

