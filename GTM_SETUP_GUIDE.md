# 📊 Google Tag Manager (GTM) + GA4 Setup Guide

**Project:** NXOLand Marketplace  
**Date:** October 28, 2025  
**Purpose:** Complete GTM and GA4 integration documentation

---

## 🎯 Overview

NXOLand now uses **Google Tag Manager (GTM)** as the primary analytics platform, allowing flexible tag management without code changes. GA4 is configured through GTM for comprehensive analytics tracking.

### Benefits
✅ **Flexible** - Add/modify tracking tags without code deployments  
✅ **Centralized** - Manage all marketing tags in one place  
✅ **Non-blocking** - Async script loading doesn't affect page performance  
✅ **Device-aware** - Tracks desktop vs mobile usage  
✅ **Privacy-compliant** - Cookie consent friendly  
✅ **Production-only** - Disabled in development mode  

---

## 🚀 Quick Setup

### Step 1: Get Your GTM Container ID

1. Go to [Google Tag Manager](https://tagmanager.google.com/)
2. Create a new account/container or use existing
3. Your container ID will look like: `GTM-XXXXXXX`

### Step 2: Add GTM ID to Environment

Edit your `.env` file:

```bash
# Google Tag Manager Container ID
VITE_GTM_ID=GTM-XXXXXXX
```

### Step 3: Link GA4 in GTM Console

1. Open your GTM container
2. Click **Tags** → **New**
3. Click **Tag Configuration**
4. Select **Google Analytics: GA4 Configuration**
5. Enter your **Measurement ID** (G-XXXXXXXXXX)
6. Set **Triggering** to **All Pages**
7. Click **Save** and then **Submit** to publish

**That's it!** GTM is now tracking your site and sending data to GA4.

---

## 📋 Tracked Events

### Automatic Events (No Code Needed)

These events are automatically tracked:

#### Page Views
- **Event:** `page_view`
- **Triggers:** Every route change
- **Data:** URL, title, device type, timestamp

### E-Commerce Events

#### Product Viewing
- **Event:** `view_item`
- **Triggers:** User views product detail page
- **Data:** Product ID, name, category, price

#### Cart Actions
- **Event:** `add_to_cart`, `remove_from_cart`, `view_cart`
- **Triggers:** Cart modifications
- **Data:** Product details, quantities, total value

#### Checkout Flow
- **Event:** `begin_checkout`, `add_payment_info`, `purchase`
- **Triggers:** Checkout steps
- **Data:** Cart items, totals, transaction ID

#### Wishlist
- **Event:** `add_to_wishlist`, `remove_from_wishlist`
- **Triggers:** Wishlist modifications
- **Data:** Product details

### User Events

#### Authentication
- **Event:** `login`, `sign_up`, `logout`
- **Triggers:** User authentication actions
- **Data:** Method (email/social), user ID

#### Search
- **Event:** `search`
- **Triggers:** Product search
- **Data:** Search term, results count

### Seller Events

#### Product Listing
- **Event:** `seller_list_product`
- **Triggers:** Seller creates product listing
- **Data:** Category, type, price

#### Seller Onboarding
- **Event:** `seller_onboarding_start`, `seller_onboarding_complete`
- **Triggers:** Seller registration flow
- **Data:** Onboarding stage

### KYC Events

- **Event:** `kyc_verification_start`, `kyc_verification_submit`, `kyc_verification_complete`
- **Triggers:** KYC verification process
- **Data:** Verification type, status

### Social Events

- **Event:** `share`, `view_profile`
- **Triggers:** Social interactions
- **Data:** Content type, method, user ID

### Dispute Events

- **Event:** `dispute_create`
- **Triggers:** Dispute creation
- **Data:** Order ID, dispute type

---

## 💻 Implementation Examples

### Using the Hook (Recommended)

```tsx
import { useGTM } from '@/hooks/useGTM';

function ProductPage() {
  const { trackViewProduct, trackAddToCart } = useGTM();
  
  useEffect(() => {
    // Track product view
    trackViewProduct({
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
    });
  }, [product]);
  
  const handleAddToCart = () => {
    // Track add to cart
    trackAddToCart({
      id: product.id,
      name: product.name,
      category: product.category,
      price: product.price,
      quantity: 1,
    });
  };
}
```

### Using Direct Import

```tsx
import gtmAnalytics from '@/lib/gtm';

// Track login
gtmAnalytics.login('email', userId);

// Track purchase
gtmAnalytics.purchase({
  order_id: '12345',
  total: 299.99,
  items: [
    {
      id: 'prod_123',
      name: 'Premium Gaming Account',
      category: 'Gaming',
      price: 299.99,
      quantity: 1,
    },
  ],
});

// Track custom event
gtmAnalytics.customEvent('custom_action', {
  action_type: 'specific_action',
  value: 123,
});
```

### Legacy Analytics Support

The old `analytics.ts` file still works and now routes through GTM:

```tsx
import { analytics } from '@/lib/analytics';

// All these work and route through GTM
analytics.viewProduct(product);
analytics.addToCart(product);
analytics.purchase(order);
```

---

## 🔧 GTM Configuration

### Setting Up GA4 in GTM

1. **Create GA4 Configuration Tag:**
   - Tag Type: Google Analytics: GA4 Configuration
   - Measurement ID: Your GA4 Measurement ID (G-XXXXXXXXXX)
   - Trigger: All Pages

2. **Enhanced E-commerce Setup:**
   - Enable **Enhanced Ecommerce** in GA4
   - GTM automatically passes e-commerce data from dataLayer
   - No additional configuration needed

3. **Custom Dimensions (Optional):**
   - Device Type: `{{deviceType}}`
   - User Agent: `{{userAgent}}`
   - User ID: `{{user_id}}`

### Testing Your Setup

1. **Preview Mode:**
   - In GTM, click **Preview**
   - Enter your site URL
   - Browse your site and verify events fire

2. **Debug in Console:**
   ```javascript
   // Check dataLayer
   console.log(window.dataLayer);
   
   // Check GTM is loaded
   console.log(window.google_tag_manager);
   ```

3. **Real-time Reports:**
   - Open GA4 → Reports → Realtime
   - Navigate your site
   - Verify events appear in real-time

---

## 📱 Device Tracking

Every event includes device information:

```javascript
{
  deviceType: 'mobile',  // mobile | tablet | desktop
  userAgent: 'mobile',   // mobile | tablet | desktop
  timestamp: '2025-10-28T12:00:00.000Z'
}
```

### Use in GTM

Create triggers based on device:
- Variable: `{{deviceType}}`
- Use in trigger conditions or custom dimensions

---

## 🔒 Privacy & Compliance

### Cookie Consent

GTM is configured to respect cookie consent:

```typescript
// Example: Disable tracking until consent
window.dataLayer = window.dataLayer || [];
window.dataLayer.push({
  'gtm.start': new Date().getTime(),
  event: 'gtm.js'
});

// Later, when user consents:
window.dataLayer.push({
  event: 'cookie_consent_granted',
  consent_type: 'analytics'
});
```

### GDPR Compliance

1. **Consent Mode:** Configure in GTM
2. **IP Anonymization:** Enable in GA4 settings
3. **Data Retention:** Configure in GA4 (default: 14 months)

---

## 🛠️ Development vs Production

### Development Mode
- GTM is **disabled** in development
- Events are logged to console
- No actual tracking occurs

### Production Mode
- GTM is **enabled**
- Events sent to GTM dataLayer
- Full tracking active

### Environment Detection

```typescript
const IS_PRODUCTION = import.meta.env.PROD;
const GTM_ID = import.meta.env.VITE_GTM_ID;
const IS_ENABLED = GTM_ID && IS_PRODUCTION;
```

---

## 📊 Available Data

### User Properties
- User ID (when authenticated)
- Device type
- User agent
- Session data

### E-commerce Data
- Product views
- Cart modifications
- Checkout steps
- Purchases
- Revenue

### Engagement Metrics
- Page views
- Session duration
- Bounce rate
- Custom events

---

## 🔍 Debugging

### Check GTM Loading

```javascript
// In browser console
console.log('GTM Loaded:', !!window.google_tag_manager);
console.log('dataLayer:', window.dataLayer);
```

### View dataLayer Events

```javascript
// Log all dataLayer pushes
window.dataLayer.push = function(...args) {
  console.log('dataLayer push:', args);
  Array.prototype.push.apply(this, args);
};
```

### Common Issues

**GTM not loading:**
- Check `VITE_GTM_ID` is set in `.env`
- Verify you're in production mode (`npm run build`)
- Check browser console for errors

**Events not showing in GA4:**
- Wait 24-48 hours for data to appear in standard reports
- Check Real-time reports for immediate verification
- Verify GA4 tag is configured in GTM
- Check GA4 Measurement ID is correct

---

## 🎓 Best Practices

### 1. Use Descriptive Event Names
```typescript
// Good
gtmAnalytics.customEvent('product_comparison_viewed', {...});

// Bad
gtmAnalytics.customEvent('event1', {...});
```

### 2. Include Relevant Context
```typescript
gtmAnalytics.customEvent('video_played', {
  video_id: 'abc123',
  video_name: 'Product Demo',
  video_duration: 180,
  playback_position: 45,
});
```

### 3. Track Business Goals
```typescript
// Track seller conversion funnel
gtmAnalytics.becomeSellerStart();
// ... onboarding steps ...
gtmAnalytics.becomeSellerComplete();
```

### 4. Use Standard E-commerce Events
Follow GA4 recommended events for better reports

---

## 📈 Key Metrics to Monitor

### Revenue Metrics
- Total revenue
- Average order value
- Revenue per user

### Conversion Metrics
- Purchase conversion rate
- Cart abandonment rate
- Checkout completion rate

### Engagement Metrics
- Pages per session
- Session duration
- Bounce rate

### User Metrics
- New vs returning users
- User retention
- User lifetime value

---

## 🆘 Support

### Resources
- [GTM Documentation](https://developers.google.com/tag-manager)
- [GA4 Documentation](https://support.google.com/analytics/answer/10089681)
- [Enhanced E-commerce](https://developers.google.com/analytics/devguides/collection/ga4/ecommerce)

### Contact
- Development Team: dev@nxoland.com
- Analytics Questions: analytics@nxoland.com

---

## ✅ Checklist

After setup, verify:

- [ ] GTM container created
- [ ] GTM ID added to `.env`
- [ ] GA4 tag configured in GTM
- [ ] GA4 Measurement ID added to GTM
- [ ] GTM published (not just saved)
- [ ] Preview mode tested
- [ ] Real-time events verified in GA4
- [ ] Production deployment completed
- [ ] Data flowing to GA4 (check after 24-48 hours)

---

**Status:** ✅ COMPLETE  
**Last Updated:** October 28, 2025  
**Version:** 1.0

**🎯 GTM + GA4 SETUP GUIDE COMPLETE! 🎯**

