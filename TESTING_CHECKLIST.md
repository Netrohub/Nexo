# NXOLand Website Testing Checklist

## 📋 Complete Page-by-Page Testing Guide

**Date:** _______________  
**Tester:** _______________  
**Browser:** _______________  
**Device:** _______________

---

## 🏠 **PUBLIC PAGES**

### ✅ Home Page (/)
- [ ] Page loads successfully
- [ ] Hero section displays correctly
- [ ] Animations work (Starfield/Particle effects)
- [ ] "Get Started" button works
- [ ] Navigation menu visible
- [ ] Language switcher works (EN ↔ AR)
- [ ] Featured products display
- [ ] Category grid shows all categories
- [ ] Footer links work
- [ ] RTL layout works for Arabic
- [ ] Responsive on mobile/tablet

**Notes:** _______________________________________________

---

### ✅ Products Page (/products)
- [ ] Product grid loads
- [ ] Search bar works
- [ ] Category filters work
- [ ] Price range slider works
- [ ] Sort dropdown works
- [ ] Pagination works
- [ ] Product cards display correctly
- [ ] Product images load
- [ ] "View Details" button works
- [ ] Wishlist heart icon works
- [ ] Loading states show properly
- [ ] Empty state shows if no products
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Product Detail Page (/products/:id)
- [ ] Product details load
- [ ] Image gallery works
- [ ] Main image changes on thumbnail click
- [ ] Zoom functionality works
- [ ] Price displays correctly
- [ ] Discount badge shows (if applicable)
- [ ] "Add to Cart" button works
- [ ] Quantity selector works
- [ ] Seller info displays
- [ ] Seller rating shows
- [ ] Reviews section loads
- [ ] Related products show
- [ ] Share buttons work
- [ ] Wishlist button works
- [ ] Responsive design

**Notes:** _______________________________________________

---

### ✅ Cart Page (/cart)
- [ ] Cart items display
- [ ] Item images show
- [ ] Quantity update works (+/-)
- [ ] Remove item works
- [ ] Subtotal calculates correctly
- [ ] Total amount correct
- [ ] "Continue Shopping" works
- [ ] "Proceed to Checkout" works
- [ ] Empty cart message shows
- [ ] Cart persists on refresh
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Checkout Page (/checkout)
- [ ] Checkout form loads
- [ ] Billing address fields work
- [ ] Shipping address fields work
- [ ] "Same as billing" checkbox works
- [ ] Payment method selection works
- [ ] Order summary displays
- [ ] Total amount correct
- [ ] Form validation works
- [ ] "Place Order" button works
- [ ] Loading state during submission
- [ ] Success redirect works
- [ ] Error handling works

**Notes:** _______________________________________________

---

### ✅ Pricing Page (/pricing)
- [ ] Pricing cards display
- [ ] Feature lists show
- [ ] "Choose Plan" buttons work
- [ ] Comparison table works
- [ ] FAQ section loads
- [ ] Responsive design

**Notes:** _______________________________________________

---

### ✅ About Page (/about)
- [ ] Content loads
- [ ] Team section displays
- [ ] Mission/vision shows
- [ ] Images load
- [ ] Links work
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Help/FAQ Page (/help)
- [ ] FAQ sections display
- [ ] Accordion items work
- [ ] Search functionality works
- [ ] Contact form works (if present)
- [ ] Categories filter FAQs
- [ ] Responsive design

**Notes:** _______________________________________________

---

### ✅ Privacy Policy (/privacy)
- [ ] Content loads
- [ ] Sections are readable
- [ ] Navigation works (if present)
- [ ] Links work
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Terms of Service (/terms)
- [ ] Content loads
- [ ] Sections are readable
- [ ] Navigation works (if present)
- [ ] Links work
- [ ] Responsive layout

**Notes:** _______________________________________________

---

## 🔐 **AUTHENTICATION PAGES**

### ✅ Login Page (/login)
- [ ] Form displays correctly
- [ ] Email field works
- [ ] Password field works
- [ ] Show/hide password works
- [ ] "Remember me" checkbox works
- [ ] Cloudflare Turnstile loads
- [ ] Turnstile challenge works
- [ ] Form validation works
- [ ] Error messages display
- [ ] "Sign In" button works
- [ ] Loading toast shows
- [ ] Success toast shows
- [ ] Redirect to dashboard works
- [ ] "Forgot password?" link works
- [ ] "Create account" link works
- [ ] Country code selector works (phone)
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Register Page (/register)
- [ ] Form displays correctly
- [ ] Name field works
- [ ] Email field works
- [ ] Phone field works
- [ ] Country code selector works
- [ ] Password field works
- [ ] Confirm password field works
- [ ] Show/hide password works
- [ ] Terms checkbox works
- [ ] Cloudflare Turnstile loads
- [ ] Turnstile challenge works
- [ ] Form validation works
- [ ] Password strength indicator works
- [ ] Error messages display
- [ ] "Create Account" button works
- [ ] Loading toast shows
- [ ] Success toast shows
- [ ] Redirect after registration
- [ ] "Sign in" link works
- [ ] Responsive layout

**Notes:** _______________________________________________

---

## 👤 **ACCOUNT PAGES** (Requires Login)

### ✅ Account Dashboard (/account/dashboard)
- [ ] Dashboard loads
- [ ] User info displays
- [ ] Order summary shows
- [ ] Recent orders list
- [ ] Wishlist count shows
- [ ] Account balance displays
- [ ] Quick action buttons work
- [ ] Navigation menu works
- [ ] Logout button works
- [ ] KYC status badge shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Profile Page (/account/profile)
- [ ] Profile form loads
- [ ] Avatar displays
- [ ] "Upload Photo" button works
- [ ] File dialog opens
- [ ] Image preview works
- [ ] Personal info fields show
- [ ] Name field works
- [ ] Email field works (readonly)
- [ ] Phone field works
- [ ] Address fields work
- [ ] Bio/description works
- [ ] "Save Changes" button works
- [ ] Success toast shows
- [ ] Form validation works
- [ ] Changes persist after refresh
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Orders Page (/account/orders)
- [ ] Orders list loads
- [ ] Order cards display
- [ ] Order status shows
- [ ] Order date displays
- [ ] Total amount shows
- [ ] "View Details" works
- [ ] Order tracking works
- [ ] Filter by status works
- [ ] Search orders works
- [ ] Pagination works
- [ ] Empty state shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Order Detail Page (/account/orders/:id)
- [ ] Order details load
- [ ] Order number shows
- [ ] Order status displays
- [ ] Product items list
- [ ] Product images show
- [ ] Quantities correct
- [ ] Prices correct
- [ ] Subtotal correct
- [ ] Shipping info shows
- [ ] Payment info shows
- [ ] Tracking info shows
- [ ] Download invoice works
- [ ] "Contact Seller" works
- [ ] Dispute button shows (if applicable)
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Wishlist Page (/account/wishlist)
- [ ] Wishlist loads
- [ ] Product cards display
- [ ] Product images show
- [ ] "Add to Cart" works
- [ ] "Remove" button works
- [ ] Empty state shows
- [ ] View product details works
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Billing Page (/account/billing)
- [ ] Payment methods list
- [ ] Credit cards display
- [ ] "Add Card" button works
- [ ] Card form works
- [ ] Save card works
- [ ] Delete card works
- [ ] Set default card works
- [ ] Transaction history shows
- [ ] Invoices list
- [ ] Download invoice works
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Wallet Page (/account/wallet)
- [ ] Balance displays
- [ ] Transaction history loads
- [ ] "Add Funds" button works
- [ ] "Withdraw" button works
- [ ] Amount input works
- [ ] Transaction filters work
- [ ] Date range filter works
- [ ] Export transactions works
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Notifications Page (/account/notifications)
- [ ] Notifications list loads
- [ ] Unread count shows
- [ ] "Mark as read" works
- [ ] "Mark all read" works
- [ ] Delete notification works
- [ ] Filter by type works
- [ ] Notification links work
- [ ] Empty state shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ KYC Verification Page (/account/kyc)
- [ ] KYC page loads
- [ ] Progress indicator shows
- [ ] Step 1: Email Verification
  - [ ] Email field displays
  - [ ] "Send Verification Email" works
  - [ ] Loading state shows
  - [ ] Success toast shows
  - [ ] Email verified badge shows
- [ ] Step 2: Phone Verification
  - [ ] Country code selector works
  - [ ] Phone input works
  - [ ] "Send SMS Code" works
  - [ ] Loading state shows
  - [ ] Success toast shows
  - [ ] Phone verified badge shows
- [ ] Step 3: Identity Verification
  - [ ] Persona widget loads (or info)
  - [ ] "Start Verification" works
  - [ ] Loading state shows
  - [ ] Success toast shows
  - [ ] Identity verified badge shows
- [ ] Completion Screen
  - [ ] Shows when all 3 steps done
  - [ ] Success message displays
  - [ ] All steps marked complete
  - [ ] "Go to Dashboard" works
  - [ ] Verification tabs hidden
- [ ] Status persists after refresh
- [ ] Responsive layout

**Notes:** _______________________________________________

---

## 🏪 **SELLER PAGES** (Requires Login + Seller Role)

### ✅ Seller Dashboard (/seller/dashboard)
- [ ] Dashboard loads
- [ ] KYC check redirects if incomplete
- [ ] Revenue card shows
- [ ] Total views shows
- [ ] Active products count
- [ ] Average rating shows
- [ ] Revenue chart displays
- [ ] Recent orders list
- [ ] Top products list
- [ ] Quick actions work
- [ ] Notifications show
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Seller Products Page (/seller/products)
- [ ] Products list loads
- [ ] Product cards display
- [ ] Product images show
- [ ] Status badges show
- [ ] "Edit" button works
- [ ] "Delete" button works
- [ ] Delete confirmation works
- [ ] "Create Product" works
- [ ] Search products works
- [ ] Filter by status works
- [ ] Sort options work
- [ ] Pagination works
- [ ] Empty state shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Create Product Page (/seller/create-product)
- [ ] Form loads
- [ ] Title field works
- [ ] Description textarea works
- [ ] Category selector works
- [ ] Platform selector works
- [ ] Price field works
- [ ] Discount field works
- [ ] Stock quantity works
- [ ] **Image Upload Section:**
  - [ ] "Upload Image" button works
  - [ ] File dialog opens
  - [ ] Multiple images can be selected
  - [ ] Image preview shows immediately
  - [ ] Up to 6 images allowed
  - [ ] Remove image (X) button works
  - [ ] Images display in grid
  - [ ] First image marked as main
- [ ] Product details fields work
- [ ] Tags input works
- [ ] Form validation works
- [ ] "Save Draft" works
- [ ] "Publish" button works
- [ ] Success toast shows
- [ ] Redirect after save
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Edit Product Page (/seller/products/:id/edit)
- [ ] Product data loads
- [ ] All fields populate
- [ ] Images load correctly
- [ ] Edit functionality same as create
- [ ] "Update" button works
- [ ] Changes persist
- [ ] Success toast shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Seller Orders Page (/seller/orders)
- [ ] Orders list loads
- [ ] Order cards display
- [ ] Customer info shows
- [ ] Order status shows
- [ ] "View Details" works
- [ ] Update status works
- [ ] Filter orders works
- [ ] Search orders works
- [ ] Export orders works
- [ ] Pagination works
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Seller Billing Page (/seller/billing)
- [ ] Earnings summary shows
- [ ] Payout schedule displays
- [ ] Bank info shows
- [ ] "Request Payout" works
- [ ] Transaction history loads
- [ ] Download statements works
- [ ] Tax forms section shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Seller Profile Page (/seller/profile)
- [ ] Shop info loads
- [ ] Shop name field works
- [ ] Shop description works
- [ ] Shop logo upload works
- [ ] Banner upload works
- [ ] Contact info fields work
- [ ] Business info works
- [ ] Verification status shows
- [ ] "Save Changes" works
- [ ] Success toast shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ List Gaming Account (/seller/list-gaming-account)
- [ ] Form loads
- [ ] Platform selector works
- [ ] Game selector works
- [ ] Account level field works
- [ ] Rank/tier selector works
- [ ] Items/skins field works
- [ ] Account age field works
- [ ] Price field works
- [ ] Description works
- [ ] **Image Upload Section:**
  - [ ] Upload button works
  - [ ] Multiple screenshots upload
  - [ ] Image preview shows
  - [ ] Remove images works
- [ ] Terms checkbox works
- [ ] Form validation works
- [ ] "Submit" button works
- [ ] Success redirect
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ List Social Account (/seller/list-social-account)
- [ ] Form loads
- [ ] Platform selector works
- [ ] Username field works
- [ ] Followers field works
- [ ] Engagement rate works
- [ ] Niche/category works
- [ ] Price field works
- [ ] Description works
- [ ] **Image Upload Section:**
  - [ ] Upload button works
  - [ ] Multiple screenshots upload
  - [ ] Image preview shows
  - [ ] Remove images works
- [ ] Terms checkbox 1 works
- [ ] Terms checkbox 2 works
- [ ] Form validation works
- [ ] "Submit" button works
- [ ] Success redirect
- [ ] Responsive layout

**Notes:** _______________________________________________

---

## ⚖️ **DISPUTES PAGES**

### ✅ Disputes List (/disputes)
- [ ] Disputes list loads
- [ ] Status tabs work (Open/In Review/Resolved)
- [ ] Dispute cards display
- [ ] Order info shows
- [ ] Status badges show
- [ ] "View Details" works
- [ ] Filter disputes works
- [ ] Search disputes works
- [ ] Empty state shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Create Dispute (/disputes/create)
- [ ] Form loads
- [ ] Order selector works
- [ ] Reason selector works
- [ ] Description textarea works
- [ ] Evidence upload works
- [ ] File validation works
- [ ] "Submit Dispute" works
- [ ] Success toast shows
- [ ] Redirect to dispute detail
- [ ] Form validation works
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Dispute Detail (/disputes/:id)
- [ ] Dispute details load
- [ ] Order info displays
- [ ] Status timeline shows
- [ ] Messages thread loads
- [ ] Message input works
- [ ] Send message works
- [ ] Evidence section shows
- [ ] Upload evidence works
- [ ] Download evidence works
- [ ] Admin actions show (if admin)
- [ ] Status update works (if admin)
- [ ] Real-time updates work
- [ ] Responsive layout

**Notes:** _______________________________________________

---

## 🔧 **ADMIN PAGES** (Requires Admin Role)

### ✅ Admin Disputes (/admin/disputes)
- [ ] All disputes list loads
- [ ] Filter options work
- [ ] Status tabs work
- [ ] Bulk actions work
- [ ] Assign to admin works
- [ ] Update status works
- [ ] Priority badges show
- [ ] Search works
- [ ] Export works
- [ ] Responsive layout

**Notes:** _______________________________________________

---

## 🌐 **GLOBAL FEATURES**

### ✅ Navigation Bar
- [ ] Logo displays
- [ ] Logo link works
- [ ] Search bar works
- [ ] Cart icon shows count
- [ ] Cart dropdown works
- [ ] Language switcher works
- [ ] User dropdown works (when logged in)
- [ ] Login/Register buttons show (when logged out)
- [ ] Logout works
- [ ] Mobile menu works
- [ ] Sticky on scroll
- [ ] Responsive design

**Notes:** _______________________________________________

---

### ✅ Footer
- [ ] All links work
- [ ] Social media icons work
- [ ] Newsletter signup works
- [ ] Copyright info shows
- [ ] Responsive layout

**Notes:** _______________________________________________

---

### ✅ Language Switching (EN ↔ AR)
- [ ] English displays correctly
- [ ] Arabic displays correctly
- [ ] RTL layout works for Arabic
- [ ] LTR layout works for English
- [ ] All text translates
- [ ] Language persists on refresh
- [ ] Date formats change
- [ ] Number formats change

**Notes:** _______________________________________________

---

### ✅ Notifications/Toasts
- [ ] Success toasts show
- [ ] Error toasts show
- [ ] Loading toasts show
- [ ] Info toasts show
- [ ] Toast auto-dismiss works
- [ ] Toast positioning correct
- [ ] Multiple toasts stack

**Notes:** _______________________________________________

---

### ✅ Loading States
- [ ] Skeleton loaders show
- [ ] Spinners work
- [ ] Progress bars work
- [ ] Buttons show loading state
- [ ] Page transitions smooth

**Notes:** _______________________________________________

---

### ✅ Error Handling
- [ ] 404 page shows for invalid routes
- [ ] Error messages clear
- [ ] Form validation messages show
- [ ] API error handling works
- [ ] Network error handling works

**Notes:** _______________________________________________

---

### ✅ Security Features
- [ ] Cloudflare Turnstile loads
- [ ] CAPTCHA works on login/register
- [ ] Protected routes redirect
- [ ] KYC enforcement works
- [ ] Role-based access works
- [ ] Token management works
- [ ] Auto-logout on token expire

**Notes:** _______________________________________________

---

### ✅ Google Analytics
- [ ] GA4 tracking ID configured
- [ ] Page views tracked
- [ ] Events tracked
- [ ] User interactions logged
- [ ] No console errors from GA

**Notes:** _______________________________________________

---

## 📱 **RESPONSIVE DESIGN**

### ✅ Desktop (1920x1080)
- [ ] All pages display correctly
- [ ] Layouts not broken
- [ ] Images scale properly
- [ ] Navigation works
- [ ] No horizontal scroll

**Notes:** _______________________________________________

---

### ✅ Laptop (1366x768)
- [ ] All pages display correctly
- [ ] Layouts adapt
- [ ] No content cut off
- [ ] Navigation works

**Notes:** _______________________________________________

---

### ✅ Tablet (768x1024)
- [ ] All pages display correctly
- [ ] Touch interactions work
- [ ] Menu adapts
- [ ] Grids reflow properly
- [ ] Forms usable

**Notes:** _______________________________________________

---

### ✅ Mobile (375x667)
- [ ] All pages display correctly
- [ ] Mobile menu works
- [ ] Touch targets large enough
- [ ] Forms usable
- [ ] No horizontal scroll
- [ ] Images responsive
- [ ] Text readable

**Notes:** _______________________________________________

---

## 🌐 **BROWSER COMPATIBILITY**

### ✅ Chrome
- [ ] All features work
- [ ] No console errors
- [ ] Smooth performance

**Notes:** _______________________________________________

---

### ✅ Firefox
- [ ] All features work
- [ ] No console errors
- [ ] Smooth performance

**Notes:** _______________________________________________

---

### ✅ Safari
- [ ] All features work
- [ ] No console errors
- [ ] Smooth performance

**Notes:** _______________________________________________

---

### ✅ Edge
- [ ] All features work
- [ ] No console errors
- [ ] Smooth performance

**Notes:** _______________________________________________

---

## 🐛 **BUGS FOUND**

| Page | Issue Description | Severity | Status |
|------|------------------|----------|--------|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

---

## ✅ **OVERALL SUMMARY**

**Total Pages Tested:** ______ / 50+  
**Pages Passed:** ______  
**Pages Failed:** ______  
**Critical Issues:** ______  
**Minor Issues:** ______  

**Overall Status:** [ ] PASS [ ] FAIL [ ] NEEDS WORK

---

## 📝 **ADDITIONAL NOTES**

____________________________________________________________________________

____________________________________________________________________________

____________________________________________________________________________

____________________________________________________________________________

---

**Tested By:** _______________  
**Date Completed:** _______________  
**Sign-off:** _______________
