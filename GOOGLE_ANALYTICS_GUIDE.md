# 📊 Google Analytics Integration Guide

Complete guide for Google Analytics 4 (GA4) integration in NXOLand marketplace.

## ✅ What's Been Done

### 1. **Google Tag Installed** ✅
- **Location**: `index.html` (line 4-11)
- **Tracking ID**: `G-23N0Q9P0S9`
- **Status**: Active and tracking

### 2. **Analytics Utility Created** ✅
- **File**: `src/lib/analytics.ts`
- **Features**: Custom event tracking, e-commerce tracking
- **Functions**: 15+ pre-built tracking functions

### 3. **React Hook Created** ✅
- **File**: `src/hooks/useAnalytics.ts`
- **Features**: Easy access to analytics functions
- **Auto-tracking**: Page view tracking on route changes

### 4. **Auto Page Tracking** ✅
- **Component**: `src/components/AnalyticsProvider.tsx`
- **Integration**: Added to `App.tsx`
- **Behavior**: Automatically tracks every page view

### 5. **Event Tracking Integrated** ✅
- Login tracking in `Login.tsx`
- Sign-up tracking in `Register.tsx`
- Ready for e-commerce tracking

---

## 🎯 What's Being Tracked Automatically

### Page Views
✅ Every route change is automatically tracked:
- Homepage visits
- Product page views
- Account page visits
- Checkout flow
- All other pages

### User Events
✅ Authentication events:
- User sign-ups
- User logins
- Logout events (can be added)

---

## 📊 Available Tracking Functions

### E-commerce Events

```typescript
import { analytics } from '@/lib/analytics';

// View product
analytics.viewProduct({
  id: 123,
  name: 'Steam Account',
  category: 'Gaming',
  price: 299.99
});

// Add to cart
analytics.addToCart({
  id: 123,
  name: 'Steam Account',
  category: 'Gaming',
  price: 299.99,
  quantity: 1
});

// Remove from cart
analytics.removeFromCart({
  id: 123,
  name: 'Steam Account',
  price: 299.99,
  quantity: 1
});

// Begin checkout
analytics.beginCheckout({
  total: 299.99,
  items: [
    {
      id: 123,
      name: 'Steam Account',
      price: 299.99,
      quantity: 1
    }
  ]
});

// Purchase completed
analytics.purchase({
  order_number: 'ORD-12345',
  total: 299.99,
  items: [
    {
      id: 123,
      name: 'Steam Account',
      price: 299.99,
      quantity: 1
    }
  ]
});
```

### User Events

```typescript
// Sign up
analytics.signUp('email');  // or 'google', 'facebook', etc.

// Login
analytics.login('email');

// Search
analytics.search('steam account');

// Add to wishlist
analytics.addToWishlist(123);

// Share product
analytics.shareProduct(123, 'facebook');
```

### Seller Events

```typescript
// List product
analytics.listProduct('Gaming');

// Create dispute
analytics.createDispute('product_not_as_described');
```

### Custom Events

```typescript
// Track any custom event
analytics.customEvent('button_clicked', {
  button_name: 'cta_button',
  page: 'homepage'
});
```

---

## 🔧 How to Add Tracking to Pages

### Example 1: Track Product Views

```typescript
// In ProductDetail.tsx
import { useEffect } from 'react';
import { analytics } from '@/lib/analytics';
import { useProduct } from '@/hooks/useApi';

const ProductDetail = () => {
  const { id } = useParams();
  const { data: product } = useProduct(Number(id));

  useEffect(() => {
    if (product) {
      analytics.viewProduct({
        id: product.id,
        name: product.title,
        category: product.category,
        price: product.price
      });
    }
  }, [product]);

  // ... rest of component
};
```

### Example 2: Track Add to Cart

```typescript
// In ProductCard.tsx or Cart page
import { analytics } from '@/lib/analytics';
import { useAddToCart } from '@/hooks/useApi';

const handleAddToCart = () => {
  addToCartMutation.mutate({ productId: product.id });
  
  // Track the event
  analytics.addToCart({
    id: product.id,
    name: product.title,
    category: product.category,
    price: product.price,
    quantity: 1
  });
};
```

### Example 3: Track Search

```typescript
// In Products.tsx or search component
import { analytics } from '@/lib/analytics';

const handleSearch = (searchTerm: string) => {
  setSearchQuery(searchTerm);
  
  // Track search
  if (searchTerm.length > 2) {
    analytics.search(searchTerm);
  }
};
```

### Example 4: Track Purchase

```typescript
// In Checkout.tsx after successful order
import { analytics } from '@/lib/analytics';

const handleCheckoutSuccess = (order: Order) => {
  analytics.purchase({
    order_number: order.order_number,
    total: order.total,
    items: order.items.map(item => ({
      id: item.product.id,
      name: item.product.title,
      price: item.price,
      quantity: item.quantity
    }))
  });
};
```

---

## 📈 Google Analytics Dashboard

### Where to View Data

1. **Go to Google Analytics**: https://analytics.google.com
2. **Select Property**: G-23N0Q9P0S9
3. **View Reports**:
   - **Realtime**: See live users
   - **Acquisition**: How users find you
   - **Engagement**: Page views, events
   - **Monetization**: E-commerce data
   - **Retention**: User retention

### Key Reports to Check

1. **Realtime Overview**
   - See users on your site right now
   - View current page views
   - See active events

2. **Pages and Screens**
   - Most visited pages
   - Average time on page
   - Bounce rate

3. **Events**
   - Custom events you're tracking
   - Event counts
   - Event parameters

4. **E-commerce Purchases**
   - Total revenue
   - Transactions
   - Product performance

---

## 🎯 Recommended Events to Add

### High Priority

1. **Product Interactions**
   ```typescript
   // In ProductDetail.tsx
   analytics.viewProduct(product);
   
   // In ProductCard.tsx on hover
   analytics.customEvent('product_hover', { product_id: id });
   ```

2. **Cart Actions**
   ```typescript
   // In Cart.tsx
   analytics.addToCart(product);
   analytics.removeFromCart(product);
   
   // In Checkout.tsx
   analytics.beginCheckout(cart);
   analytics.purchase(order);
   ```

3. **Search Behavior**
   ```typescript
   // In Products.tsx
   analytics.search(searchTerm);
   ```

4. **Wishlist**
   ```typescript
   // When adding to wishlist
   analytics.addToWishlist(productId);
   ```

### Medium Priority

5. **Seller Actions**
   ```typescript
   // In CreateProduct.tsx
   analytics.listProduct(category);
   ```

6. **Dispute Events**
   ```typescript
   // In CreateDispute.tsx
   analytics.createDispute(type);
   ```

7. **Social Sharing**
   ```typescript
   // In share buttons
   analytics.shareProduct(productId, 'twitter');
   ```

---

## 🔍 Testing Analytics

### 1. **Test in Development**

```bash
# Start dev server
npm run dev

# Open browser to http://localhost:8080
# Open browser console
# Navigate around the site
```

Check console for:
```javascript
// Should see in console
Google Analytics initialized: G-23N0Q9P0S9
```

### 2. **View in Realtime Report**

1. Go to Google Analytics
2. Select "Realtime" report
3. Navigate your site
4. See events appear in real-time!

### 3. **Debug with GA Debug Extension**

Install: [Google Analytics Debugger](https://chrome.google.com/webstore/detail/google-analytics-debugger)

Then:
- Enable the extension
- Open browser console
- See detailed GA event logs

---

## 🛠️ Advanced Configuration

### Enable Enhanced Measurement

In Google Analytics dashboard:
1. Go to Admin
2. Select Data Streams
3. Click your web stream
4. Toggle "Enhanced measurement" ON

This automatically tracks:
- Scrolls
- Outbound clicks
- Site search
- Video engagement
- File downloads

### Create Custom Conversions

Track important business goals:

1. **Product Purchase**
   - Event: `purchase`
   - Already implemented ✅

2. **User Registration**
   - Event: `sign_up`
   - Already implemented ✅

3. **Product Listing**
   - Event: `list_product`
   - Ready to implement

4. **Dispute Created**
   - Event: `create_dispute`
   - Ready to implement

---

## 🎨 Custom Dimensions (Optional)

Track additional user data:

```typescript
// Set user properties
if (window.gtag) {
  window.gtag('set', 'user_properties', {
    user_role: user.roles[0],
    seller_verified: user.profile?.seller_verified,
    language: language,
  });
}
```

---

## 📱 Mobile App Tracking (Future)

If you build a mobile app, you can use the same GA4 property:

```typescript
// React Native or mobile app
import analytics from '@react-native-firebase/analytics';

await analytics().logEvent('purchase', {
  transaction_id: orderId,
  value: total,
  currency: 'USD',
});
```

---

## 🔒 Privacy Compliance

### GDPR/Privacy Considerations

1. **Cookie Consent** (Optional)
   ```typescript
   // Add cookie consent banner
   // Only initialize GA after consent
   ```

2. **Anonymize IP** (Already enabled in GA4)
   - GA4 doesn't collect IP addresses by default

3. **User Data Deletion**
   ```typescript
   // When user deletes account
   // Request data deletion from Google
   ```

### Privacy Policy

Update your privacy policy to mention:
- Google Analytics usage
- Cookie usage
- Data collection
- User rights

---

## 📊 What You'll See in GA4

### Automatic Reports

1. **User Metrics**
   - Active users
   - New users
   - Sessions
   - Engagement time

2. **Acquisition**
   - Traffic sources
   - Referrers
   - Campaign performance

3. **Engagement**
   - Page views
   - Event counts
   - Session duration

4. **E-commerce** (after implementing tracking)
   - Revenue
   - Transactions
   - Product performance
   - Cart abandonment

---

## ✅ Implementation Checklist

- [x] ✅ Google tag added to `index.html`
- [x] ✅ Analytics utility created (`src/lib/analytics.ts`)
- [x] ✅ Analytics hook created (`src/hooks/useAnalytics.ts`)
- [x] ✅ Auto page tracking enabled
- [x] ✅ Login tracking added
- [x] ✅ Sign-up tracking added
- [x] ✅ Environment variables configured
- [ ] 🔧 Add product view tracking
- [ ] 🔧 Add cart event tracking
- [ ] 🔧 Add purchase tracking
- [ ] 🔧 Add search tracking
- [ ] 🔧 Test in GA4 Realtime
- [ ] 🔧 Set up custom conversions

---

## 🚀 Quick Commands

```bash
# Verify tracking ID in code
grep -r "G-23N0Q9P0S9" .

# Check if analytics is enabled
cat .env | grep VITE_ENABLE_ANALYTICS

# Test in browser console
window.dataLayer  # Should see events array
window.gtag       # Should be a function
```

---

## 🎯 Next Steps

1. **Verify Tracking Works**
   - Visit your site
   - Check GA4 Realtime report
   - Should see your session

2. **Add E-commerce Tracking**
   - Track product views
   - Track add to cart
   - Track purchases

3. **Set Up Conversions**
   - Mark important events as conversions
   - Set up conversion goals

4. **Monitor Performance**
   - Check reports weekly
   - Optimize based on data
   - Track business KPIs

---

## 🆘 Troubleshooting

### Not Seeing Data in GA4?

1. **Check Realtime Report** (data appears immediately)
2. **Wait 24-48 hours** for standard reports
3. **Verify tracking ID**: G-23N0Q9P0S9
4. **Check browser console** for errors
5. **Disable ad blockers** (they block GA)

### Events Not Firing?

```typescript
// Debug in browser console
window.dataLayer.forEach(event => console.log(event));

// Check if gtag is defined
console.log(typeof window.gtag);  // Should be 'function'
```

---

## 📚 Resources

- **GA4 Documentation**: https://support.google.com/analytics/answer/10089681
- **Event Reference**: https://developers.google.com/analytics/devguides/collection/ga4/reference/events
- **E-commerce Tracking**: https://developers.google.com/analytics/devguides/collection/ga4/ecommerce

---

**Google Analytics is now tracking your marketplace! 📊**
