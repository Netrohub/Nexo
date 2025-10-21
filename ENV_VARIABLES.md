# 🔧 Environment Variables Guide

Complete list of all environment variables used in the NXOLand marketplace application.

## 📋 Table of Contents

1. [Required Variables](#required-variables)
2. [API Configuration](#api-configuration)
3. [Authentication](#authentication)
4. [Feature Flags](#feature-flags)
5. [UI Configuration](#ui-configuration)
6. [Payment Configuration](#payment-configuration)
7. [Social Media](#social-media)
8. [Support & Contact](#support--contact)
9. [SEO & Analytics](#seo--analytics)
10. [Security](#security)
11. [Development Tools](#development-tools)

---

## ✅ Required Variables

These variables **MUST** be set for the application to work:

```env
# Laravel API URL - REQUIRED
VITE_API_BASE_URL=http://localhost:8000/api

# Application name - REQUIRED
VITE_APP_NAME=NetroHub

# Environment - REQUIRED (development, staging, production)
VITE_APP_ENV=development
```

---

## 🌐 API Configuration

Configure API behavior and limits:

```env
# API request timeout (milliseconds)
VITE_API_TIMEOUT=30000

# Maximum file upload size (MB)
VITE_MAX_FILE_SIZE=5

# Allowed image formats (comma-separated)
VITE_ALLOWED_IMAGE_FORMATS=jpg,jpeg,png,gif,webp

# Allowed document formats (comma-separated)
VITE_ALLOWED_DOCUMENT_FORMATS=pdf,doc,docx
```

**Usage in Code:**
```typescript
const maxSize = import.meta.env.VITE_MAX_FILE_SIZE;
const timeout = import.meta.env.VITE_API_TIMEOUT;
```

---

## 🔐 Authentication

Configure authentication behavior:

```env
# LocalStorage key for auth token
VITE_AUTH_TOKEN_KEY=auth_token

# Session timeout in minutes
VITE_SESSION_TIMEOUT=60
```

**Usage:**
- Tokens are stored in `localStorage` with the key `auth_token`
- Session expires after 60 minutes of inactivity
- Change `VITE_AUTH_TOKEN_KEY` in production for security

---

## ⚡ Feature Flags

Enable or disable features without code changes:

```env
# Social login (Google, Facebook, etc.)
VITE_ENABLE_SOCIAL_LOGIN=false

# Phone verification
VITE_ENABLE_PHONE_VERIFICATION=true

# KYC (Know Your Customer) verification
VITE_ENABLE_KYC=true

# Dispute system
VITE_ENABLE_DISPUTES=true

# Wishlist functionality
VITE_ENABLE_WISHLIST=true

# Shopping cart
VITE_ENABLE_CART=true

# Product reviews
VITE_ENABLE_REVIEWS=true
```

**Usage:**
```typescript
if (import.meta.env.VITE_ENABLE_DISPUTES === 'true') {
  // Show disputes menu
}
```

---

## 🎨 UI Configuration

Control UI behavior and pagination:

```env
# Products per page
VITE_PRODUCTS_PER_PAGE=12

# Orders per page
VITE_ORDERS_PER_PAGE=10

# Disputes per page
VITE_DISPUTES_PER_PAGE=10

# Default language (en, ar)
VITE_DEFAULT_LANGUAGE=en

# Enable RTL by default
VITE_DEFAULT_RTL=false
```

**Usage:**
```typescript
const perPage = import.meta.env.VITE_PRODUCTS_PER_PAGE || 12;
```

---

## 💳 Payment Configuration

Configure payment gateways and fees:

```env
# Payment gateway (stripe, paypal, razorpay)
VITE_PAYMENT_GATEWAY=stripe

# Currency code
VITE_CURRENCY=USD

# Currency symbol
VITE_CURRENCY_SYMBOL=$

# Platform service fee percentage
VITE_SERVICE_FEE_PERCENTAGE=5
```

**Usage:**
```typescript
const currency = import.meta.env.VITE_CURRENCY_SYMBOL;
const serviceFee = import.meta.env.VITE_SERVICE_FEE_PERCENTAGE;
```

---

## 📱 Social Media

Social media links for footer and sharing:

```env
VITE_SOCIAL_FACEBOOK=https://facebook.com/netrohub
VITE_SOCIAL_TWITTER=https://twitter.com/netrohub
VITE_SOCIAL_INSTAGRAM=https://instagram.com/netrohub
VITE_SOCIAL_DISCORD=https://discord.gg/netrohub
VITE_SOCIAL_TELEGRAM=https://t.me/netrohub
```

**Usage:**
```typescript
<a href={import.meta.env.VITE_SOCIAL_FACEBOOK}>Facebook</a>
```

---

## 📞 Support & Contact

Support contact information:

```env
VITE_SUPPORT_EMAIL=support@netrohub.com
VITE_SUPPORT_PHONE=+1234567890
VITE_SUPPORT_WHATSAPP=+1234567890
VITE_CONTACT_EMAIL=contact@netrohub.com
```

**Usage:**
```typescript
<a href={`mailto:${import.meta.env.VITE_SUPPORT_EMAIL}`}>
  Contact Support
</a>
```

---

## 📊 SEO & Analytics

Analytics and tracking configuration:

```env
# Google Analytics tracking ID
VITE_GA_TRACKING_ID=UA-XXXXXXXXX-X

# Facebook Pixel ID
VITE_FB_PIXEL_ID=XXXXXXXXXXXXXXX

# Site URL for SEO
VITE_SITE_URL=https://netrohub.com
```

**Usage:**
```typescript
// In analytics setup
const gaId = import.meta.env.VITE_GA_TRACKING_ID;
if (gaId) {
  // Initialize Google Analytics
}
```

---

## 🖼️ CDN & Assets

Configure CDN and default images:

```env
# CDN URL for static assets (optional)
VITE_CDN_URL=https://cdn.netrohub.com

# Default product image
VITE_DEFAULT_PRODUCT_IMAGE=/placeholder.svg

# Default user avatar
VITE_DEFAULT_USER_AVATAR=/avatar-placeholder.svg
```

**Usage:**
```typescript
const productImage = product.image || import.meta.env.VITE_DEFAULT_PRODUCT_IMAGE;
```

---

## 🛠️ Development Tools

Development-only configuration:

```env
# Enable React Query DevTools
VITE_ENABLE_REACT_QUERY_DEVTOOLS=true

# Enable verbose console logging
VITE_ENABLE_DEBUG_LOGS=true

# Use mock API (for development without backend)
VITE_MOCK_API=false
```

**Usage:**
```typescript
if (import.meta.env.VITE_ENABLE_DEBUG_LOGS === 'true') {
  console.log('Debug information...');
}
```

---

## 🔒 Security

Security-related configuration:

```env
# Cloudflare Turnstile (Modern CAPTCHA alternative)
VITE_TURNSTILE_SITE_KEY=1x00000000000000000000AA
VITE_ENABLE_TURNSTILE=true
VITE_TURNSTILE_THEME=dark
VITE_TURNSTILE_SIZE=normal

# Legacy CAPTCHA (deprecated - use Turnstile instead)
VITE_ENABLE_CAPTCHA=false
VITE_RECAPTCHA_SITE_KEY=your-recaptcha-site-key

# Rate limiting (requests per minute)
VITE_RATE_LIMIT=60
```

**Usage:**
```typescript
// Turnstile (Recommended)
if (import.meta.env.VITE_ENABLE_TURNSTILE === 'true') {
  // Render Turnstile widget
}

// Legacy reCAPTCHA
if (import.meta.env.VITE_ENABLE_CAPTCHA === 'true') {
  // Render reCAPTCHA
}
```

**Get Turnstile Keys:**
Visit https://dash.cloudflare.com/?to=/:account/turnstile

---

## 🔔 Notifications

Notification system configuration:

```env
# Toast duration (milliseconds)
VITE_TOAST_DURATION=3000

# Enable desktop notifications
VITE_ENABLE_DESKTOP_NOTIFICATIONS=false
```

**Usage:**
```typescript
const duration = import.meta.env.VITE_TOAST_DURATION || 3000;
toast.success('Success!', { duration });
```

---

## ⏱️ Cache Configuration

React Query cache settings:

```env
# Cache duration (milliseconds)
VITE_CACHE_DURATION=300000

# Query stale time (milliseconds)
VITE_QUERY_STALE_TIME=60000
```

**Usage:**
```typescript
const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: import.meta.env.VITE_QUERY_STALE_TIME || 60000,
    },
  },
});
```

---

## 💼 Seller Configuration

Seller-specific settings:

```env
# Minimum seller rating
VITE_MIN_SELLER_RATING=3.0

# Max products for free plan
VITE_MAX_PRODUCTS_FREE=3

# Transaction fees by plan
VITE_FEE_FREE=5
VITE_FEE_PRO=3
VITE_FEE_ELITE=1.5
```

---

## ⚖️ Dispute Configuration

Dispute system settings:

```env
# Response time (hours)
VITE_DISPUTE_RESPONSE_TIME=48

# Auto-close time (days)
VITE_DISPUTE_AUTO_CLOSE_DAYS=30
```

---

## 📦 Product Configuration

Product-related settings:

```env
# Maximum images per product
VITE_MAX_PRODUCT_IMAGES=6

# Minimum product price
VITE_MIN_PRODUCT_PRICE=1

# Maximum product price
VITE_MAX_PRODUCT_PRICE=10000

# Available categories
VITE_PRODUCT_CATEGORIES=Social Media,Gaming,Digital Services,Software,Entertainment
```

---

## 📄 Legal Information

Company and legal information:

```env
VITE_COMPANY_NAME=NetroHub
VITE_COMPANY_ADDRESS=123 Digital Street, Tech City, TC 12345
VITE_PRIVACY_POLICY_URL=/privacy
VITE_TERMS_OF_SERVICE_URL=/terms
VITE_REFUND_POLICY_URL=/refund-policy
```

---

## 🌍 Environment-Specific Configuration

### Development
```env
VITE_API_BASE_URL=http://localhost:8000/api
VITE_APP_ENV=development
VITE_ENABLE_REACT_QUERY_DEVTOOLS=true
VITE_ENABLE_DEBUG_LOGS=true
```

### Staging
```env
VITE_API_BASE_URL=https://staging-api.netrohub.com/api
VITE_APP_ENV=staging
VITE_ENABLE_REACT_QUERY_DEVTOOLS=true
VITE_ENABLE_DEBUG_LOGS=false
```

### Production
```env
VITE_API_BASE_URL=https://api.netrohub.com/api
VITE_APP_ENV=production
VITE_ENABLE_REACT_QUERY_DEVTOOLS=false
VITE_ENABLE_DEBUG_LOGS=false
VITE_SITE_URL=https://netrohub.com
```

---

## 🔍 Accessing Environment Variables

### In TypeScript/React

```typescript
// Access any environment variable
const apiUrl = import.meta.env.VITE_API_BASE_URL;
const appName = import.meta.env.VITE_APP_NAME;

// Check if variable exists
if (import.meta.env.VITE_ENABLE_CAPTCHA) {
  // Do something
}

// With default value
const timeout = import.meta.env.VITE_API_TIMEOUT || 30000;
```

### Type Safety

Create a `vite-env.d.ts` file for TypeScript:

```typescript
/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_API_BASE_URL: string;
  readonly VITE_APP_NAME: string;
  readonly VITE_APP_ENV: 'development' | 'staging' | 'production';
  readonly VITE_ENABLE_CAPTCHA: string;
  // Add more as needed
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
```

---

## ⚠️ Important Notes

1. **Naming Convention**: All Vite environment variables must start with `VITE_`
2. **Security**: Never commit `.env` to version control
3. **Build Time**: Environment variables are embedded at build time
4. **Boolean Values**: Vite treats all env vars as strings, check with `=== 'true'`
5. **Public Variables**: All `VITE_*` variables are exposed to the client

---

## 📝 Setup Checklist

- [ ] Copy `.env.example` to `.env`
- [ ] Update `VITE_API_BASE_URL` with your Laravel API URL
- [ ] Set `VITE_APP_ENV` to your environment
- [ ] Configure payment gateway settings
- [ ] Add analytics IDs (optional)
- [ ] Set up social media links
- [ ] Configure support contact info
- [ ] Update company information
- [ ] Test all features with your configuration

---

## 🆘 Troubleshooting

### Variables not working?

1. **Restart dev server** - Changes to `.env` require server restart
2. **Check naming** - Must start with `VITE_`
3. **Check syntax** - No spaces around `=`
4. **Check quotes** - Don't use quotes unless needed
5. **Clear cache** - `rm -rf node_modules/.vite`

### Example Issues

```env
# ❌ Wrong - no VITE_ prefix
API_BASE_URL=http://localhost:8000/api

# ✅ Correct
VITE_API_BASE_URL=http://localhost:8000/api

# ❌ Wrong - spaces
VITE_API_BASE_URL = http://localhost:8000/api

# ✅ Correct
VITE_API_BASE_URL=http://localhost:8000/api
```

---

**Need help?** Check `README.md` or `QUICK_START.md` for more information!
