# 🚀 Quick Testing Checklist

**Quick reference for rapid testing**

---

## ✅ **CRITICAL FEATURES TO TEST FIRST**

### 🔐 Authentication (PRIORITY 1)
- [ ] Login works
- [ ] Register works
- [ ] Logout works
- [ ] Cloudflare Turnstile works

### 📸 Photo Uploads (PRIORITY 1)
- [ ] Profile avatar upload works
- [ ] Product images upload works
- [ ] Social account screenshots upload works

### 🏪 KYC Verification (PRIORITY 1)
- [ ] Email verification works
- [ ] Phone verification works
- [ ] Identity verification works
- [ ] Status persists after refresh
- [ ] Seller routes blocked without KYC

### 🛒 Core Shopping (PRIORITY 2)
- [ ] Browse products
- [ ] View product details
- [ ] Add to cart
- [ ] Checkout process
- [ ] Order placement

### 🏪 Seller Functions (PRIORITY 2)
- [ ] Create product
- [ ] Upload product images
- [ ] View seller dashboard
- [ ] Manage orders

### 🌐 Global Features (PRIORITY 3)
- [ ] Language switching (EN ↔ AR)
- [ ] RTL layout for Arabic
- [ ] Navigation works
- [ ] Mobile responsive

---

## 📄 **ALL PAGES QUICK LIST**

### Public Pages (No Login Required)
1. [ ] / (Home)
2. [ ] /products (Products List)
3. [ ] /products/:id (Product Detail)
4. [ ] /cart (Shopping Cart)
5. [ ] /checkout (Checkout)
6. [ ] /pricing (Pricing Plans)
7. [ ] /about (About Us)
8. [ ] /help (Help/FAQ)
9. [ ] /privacy (Privacy Policy)
10. [ ] /terms (Terms of Service)

### Auth Pages
11. [ ] /login (Login)
12. [ ] /register (Register)

### Account Pages (Login Required)
13. [ ] /account/dashboard (Account Dashboard)
14. [ ] /account/profile (Profile Settings)
15. [ ] /account/orders (Orders List)
16. [ ] /account/orders/:id (Order Detail)
17. [ ] /account/wishlist (Wishlist)
18. [ ] /account/billing (Billing & Payment)
19. [ ] /account/wallet (Wallet)
20. [ ] /account/notifications (Notifications)
21. [ ] /account/kyc (KYC Verification)

### Seller Pages (Login + Seller Role + KYC)
22. [ ] /seller/dashboard (Seller Dashboard)
23. [ ] /seller/products (Products Management)
24. [ ] /seller/create-product (Create Product)
25. [ ] /seller/products/:id/edit (Edit Product)
26. [ ] /seller/orders (Seller Orders)
27. [ ] /seller/billing (Seller Billing)
28. [ ] /seller/profile (Shop Profile)
29. [ ] /seller/list-gaming-account (List Gaming Account)
30. [ ] /seller/list-social-account (List Social Account)

### Disputes Pages
31. [ ] /disputes (Disputes List)
32. [ ] /disputes/create (Create Dispute)
33. [ ] /disputes/:id (Dispute Detail)

### Admin Pages (Admin Role)
34. [ ] /admin/disputes (Admin Disputes Management)

---

## 🐛 **Common Issues to Check**

- [ ] Console errors in browser DevTools
- [ ] Broken images or missing assets
- [ ] Buttons that don't respond to clicks
- [ ] Forms that don't submit
- [ ] Validation errors not showing
- [ ] Toasts/notifications not appearing
- [ ] Redirects not working
- [ ] Data not persisting after refresh
- [ ] Infinite loading states
- [ ] Broken links (404 errors)
- [ ] Layout breaks on mobile
- [ ] Text overflow or truncation issues
- [ ] API errors in network tab

---

## 📱 **Quick Responsive Check**

### Desktop
- [ ] 1920x1080 - Everything fits
- [ ] 1366x768 - No horizontal scroll

### Tablet  
- [ ] 768x1024 - Readable and usable

### Mobile
- [ ] 375x667 - All features accessible
- [ ] Touch targets large enough

---

## 🌐 **Quick Browser Check**

- [ ] Chrome - Works
- [ ] Firefox - Works
- [ ] Safari - Works
- [ ] Edge - Works

---

## ✅ **Photo Upload Test Checklist**

### Profile Avatar
1. [ ] Go to /account/profile
2. [ ] Click "Upload New Photo"
3. [ ] Select an image file
4. [ ] Avatar preview updates immediately
5. [ ] Image displays correctly

### Product Images
1. [ ] Go to /seller/create-product
2. [ ] Click "Upload Image" button
3. [ ] Select multiple images (up to 6)
4. [ ] All images preview immediately
5. [ ] Click X to remove an image
6. [ ] Image removal works

### Social Account Screenshots
1. [ ] Go to /seller/list-social-account
2. [ ] Scroll to screenshots section
3. [ ] Click "Upload Image"
4. [ ] Select multiple screenshots
5. [ ] All preview correctly
6. [ ] Remove button works

---

## ✅ **KYC Verification Test**

1. [ ] Login as user
2. [ ] Go to /account/kyc
3. [ ] **Email Verification:**
   - [ ] Click "Send Verification Email"
   - [ ] Loading state shows
   - [ ] Success toast appears
   - [ ] Email step marked complete
4. [ ] **Phone Verification:**
   - [ ] Select country code
   - [ ] Enter phone number
   - [ ] Click "Send SMS Code"
   - [ ] Success toast appears
   - [ ] Phone step marked complete
5. [ ] **Identity Verification:**
   - [ ] Click "Start Verification"
   - [ ] Loading state shows
   - [ ] Success toast appears
   - [ ] Identity step marked complete
6. [ ] **Completion Check:**
   - [ ] Completion screen appears
   - [ ] All 3 steps shown as verified
   - [ ] Verification tabs disappear
   - [ ] Refresh page - status persists
   - [ ] Can now access /seller/* routes

---

## 🚀 **Quick Test Flow (5 Minutes)**

1. **Load Homepage** → Check animations and layout
2. **Browse Products** → Click a product → View details
3. **Login** → Enter credentials → Check redirect
4. **Upload Photo** → Profile page → Upload avatar
5. **Create Product** → Upload images → Check preview
6. **Switch Language** → EN to AR → Check RTL
7. **Check Mobile** → Resize browser → Test menu
8. **Logout** → Confirm logout → Redirect to home

---

## 📊 **Quick Status**

**Date:** _______________  
**Browser:** _______________  
**Status:** [ ] ✅ PASS [ ] ❌ FAIL [ ] ⚠️ ISSUES

**Critical Bugs:** ______  
**Minor Issues:** ______  

**Notes:** _______________________________________________

