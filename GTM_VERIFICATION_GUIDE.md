# GTM Verification Guide - Quick Reference

## 🎯 Quick Verification Checklist

Use this guide after deploying to verify GTM is working correctly on production.

## 1️⃣ Browser DevTools - Network Tab

**URL**: https://www.nxoland.com

### What to Check:
1. Open DevTools (F12) → Network tab
2. Reload the page
3. Filter: `gtm`

### Expected Results:
✅ **SHOULD see**:
- `gtm.js?id=GTM-THXQ6Q9V` (Status: 200 OK)
- From: `www.googletagmanager.com`

❌ **Should NOT see**:
- `gtag/js?id=G-...` (legacy Google Analytics)
- Direct `collect` calls to `www.google-analytics.com`

### Screenshot Checklist:
- [ ] `gtm.js` loads successfully
- [ ] No legacy GA scripts

---

## 2️⃣ Browser DevTools - Console

### What to Check:
1. Open DevTools (F12) → Console tab
2. Reload the page
3. Look for initialization message

### Expected Output:
```
GTM dataLayer initialized: GTM-THXQ6Q9V
```

### Additional Console Commands:

**Check dataLayer contents:**
```javascript
window.dataLayer
```

**Expected output:**
```javascript
[
  { 'gtm.start': 1730123456789, event: 'gtm.js' },
  { event: 'app_initialized', deviceType: 'desktop', userAgent: 'desktop' },
  { event: 'page_view', page_path: '/', page_title: 'NXOLand - Gaming Marketplace', page_location: 'https://www.nxoland.com/', deviceType: 'desktop', timestamp: '2025-10-28T...' },
  // ... more events
]
```

**Filter to page_view events only:**
```javascript
window.dataLayer.filter(e => e.event === 'page_view')
```

**Filter to custom events (login, signup, etc.):**
```javascript
window.dataLayer.filter(e => e.event !== 'page_view' && e.event !== 'gtm.js')
```

### Screenshot Checklist:
- [ ] Initialization message appears
- [ ] dataLayer contains events
- [ ] No GTM-related errors

---

## 3️⃣ GTM Preview Mode (Tag Assistant)

**Prerequisites**: GTM account access to container `GTM-THXQ6Q9V`

### Steps:
1. Go to [Google Tag Manager](https://tagmanager.google.com)
2. Select container **GTM-THXQ6Q9V**
3. Click **Preview** button (top right)
4. In the Tag Assistant Connect tab:
   - Enter URL: `https://www.nxoland.com`
   - Click **Connect**
5. New tab opens with Tag Assistant overlay

### What to Verify:

#### On Page Load:
✅ **Events to check**:
- `Container Loaded` - GTM container initialized
- `app_initialized` - App started (custom event)
- `page_view` - Initial page view

#### Navigate to Different Pages:
1. Click on navigation links (e.g., Products, Pricing, Login)
2. For each navigation:
   ✅ **Should see**: `page_view` event with:
   - `page_path`: new path (e.g., `/products`)
   - `page_title`: page title
   - `page_location`: full URL
   - `deviceType`: mobile/tablet/desktop
   - `timestamp`: ISO timestamp

#### Test User Actions:

**Registration Flow** (`/register`):
1. Fill registration form
2. Submit
3. ✅ **Expected event**: `sign_up` with `method: 'email'`

**Login Flow** (`/login`):
1. Fill login form
2. Submit
3. ✅ **Expected event**: `login` with `method: 'email'` or `'username'`

**Search** (navbar):
1. Enter search query in navbar
2. Submit
3. ✅ **Expected event**: `search` with `search_term`

**Logout** (navbar dropdown):
1. Click logout
2. ✅ **Expected event**: `logout`

### Screenshot Checklist:
- [ ] Container loads successfully
- [ ] `page_view` fires on navigation
- [ ] `sign_up` fires on registration
- [ ] `login` fires on login
- [ ] `search` fires on search
- [ ] `logout` fires on logout
- [ ] No duplicate events
- [ ] No errors in Tag Assistant

---

## 4️⃣ GA4 Realtime Reports

**Prerequisites**: GA4 property connected to GTM container

### Steps:
1. Go to [Google Analytics 4](https://analytics.google.com)
2. Select your property
3. Navigate to **Reports → Realtime**

### What to Verify:

#### Active Users:
✅ **Should see**:
- At least 1 active user (you)
- Updates in real-time as you navigate

#### Events:
✅ **Should see events**:
- `page_view` - On every page navigation
- `session_start` - On initial visit
- `first_visit` - If first time (or cleared cookies)

#### Custom Events (if GTM tags configured):
✅ **Should see** (if you trigger them):
- `login` - After successful login
- `sign_up` - After registration
- `search` - After search
- `add_to_cart` - After adding to cart
- `purchase` - After completing order

#### By Page:
✅ **Should see pages**:
- `/` (home)
- `/products` (browse products)
- `/login` (login page)
- etc.

### Screenshot Checklist:
- [ ] Active users show up
- [ ] `page_view` events tracked
- [ ] Custom events tracked (if configured)
- [ ] Page paths correct

---

## 5️⃣ Source Code Verification

### index.html Verification:
1. Visit: https://www.nxoland.com
2. Right-click → View Page Source
3. Search for: `GTM-THXQ6Q9V`

✅ **Should see** (in `<head>`):
```html
<!-- Google Tag Manager -->
<script>
(function(w,d,s,l,i){w[l]=w[l]||[];
 w[l].push({'gtm.start':new Date().getTime(),event:'gtm.js'});
 var f=d.getElementsByTagName(s)[0], j=d.createElement(s), dl=l!='dataLayer'?'&l='+l:'';
 j.async=true; j.src='https://www.googletagmanager.com/gtm.js?id='+i+dl;
 f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-THXQ6Q9V');
</script>
<!-- End Google Tag Manager -->
```

✅ **Should see** (after `<body>`):
```html
<!-- Google Tag Manager (noscript) -->
<noscript>
  <iframe src="https://www.googletagmanager.com/ns.html?id=GTM-THXQ6Q9V"
          height="0" width="0" style="display:none;visibility:hidden"></iframe>
</noscript>
<!-- End Google Tag Manager (noscript) -->
```

❌ **Should NOT see**:
- `gtag('config', 'G-...` (legacy GA)
- `ga('create', ...` (Universal Analytics)
- Any direct GA measurement IDs

### Screenshot Checklist:
- [ ] GTM snippet in `<head>`
- [ ] GTM noscript after `<body>`
- [ ] No legacy GA code

---

## 6️⃣ Mobile Testing

Test on actual mobile devices (iOS & Android) or use browser DevTools device emulation.

### Device Emulation:
1. Open DevTools (F12)
2. Click device toggle icon (or Ctrl+Shift+M)
3. Select device: iPhone 12, Pixel 5, etc.

### What to Verify:
1. Navigate through site
2. Check Console for GTM initialization
3. Verify `deviceType` in dataLayer:
   ```javascript
   window.dataLayer.filter(e => e.deviceType === 'mobile')
   ```
4. Perform actions (login, search, etc.)
5. Verify events fire correctly

### Screenshot Checklist:
- [ ] GTM works on mobile
- [ ] `deviceType: 'mobile'` in events
- [ ] All events fire correctly

---

## 🚨 Common Issues & Solutions

### Issue: GTM script not loading
**Symptoms**: Network tab shows 404 for `gtm.js`
**Solution**:
- Check if Cloudflare cache was purged
- Verify `index.html` was deployed correctly
- Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)

### Issue: dataLayer is empty
**Symptoms**: `window.dataLayer` returns `undefined` or `[]`
**Solution**:
- GTM script may not have loaded yet
- Check Network tab for GTM script errors
- Verify no ad blockers are blocking GTM

### Issue: page_view events not firing on navigation
**Symptoms**: Only first `page_view` fires, no events on subsequent navigation
**Solution**:
- Check browser console for JavaScript errors
- Verify AnalyticsProvider is mounted in App.tsx
- Check if React Router is working (URL changes?)

### Issue: Events show in GTM Preview but not in GA4
**Symptoms**: Events appear in Tag Assistant but not in GA4 Realtime
**Solution**:
- Verify GA4 Configuration tag is set up in GTM
- Check if GA4 Configuration tag has correct Measurement ID
- Ensure GA4 Configuration tag trigger is "All Pages"
- Publish GTM container (not just Preview mode)

### Issue: Duplicate page_view events
**Symptoms**: Two `page_view` events fire on each navigation
**Solution**:
- Check if GTM History Change trigger is configured
- If so, remove `trackPageView` from AnalyticsProvider.tsx
- Use either code-based OR GTM-based tracking, not both

---

## 📋 Quick Test Script

Run these steps in order to verify everything works:

1. [ ] **Load homepage**: https://www.nxoland.com
   - Check: GTM loads, `page_view` fires
   
2. [ ] **Navigate to Products**: Click "Products" in navbar
   - Check: `page_view` fires with `page_path: '/products'`
   
3. [ ] **Search**: Type "fortnite" in search bar, submit
   - Check: `search` event fires with `search_term: 'fortnite'`
   
4. [ ] **Navigate to Login**: Click "Login"
   - Check: `page_view` fires with `page_path: '/login'`
   
5. [ ] **Login**: Enter credentials, submit
   - Check: `login` event fires with `method: 'email'`
   
6. [ ] **Navigate to Register**: Click "Register"
   - Check: `page_view` fires with `page_path: '/register'`
   
7. [ ] **Register**: Fill form, submit
   - Check: `sign_up` event fires with `method: 'email'`
   
8. [ ] **Logout**: Click user dropdown → Logout
   - Check: `logout` event fires

**All 8 steps passed?** → ✅ GTM is working correctly!

---

## 📸 Screenshot Requirements for PR

### Required Screenshots:
1. **GTM Preview - Container Loading**
   - Show container `GTM-THXQ6Q9V` loaded successfully
   
2. **GTM Preview - page_view Events**
   - Show `page_view` events firing on navigation
   - Highlight event parameters (page_path, page_title, etc.)
   
3. **GTM Preview - Custom Events**
   - Show at least one custom event (login, search, etc.)
   
4. **GA4 Realtime - Active Users**
   - Show active users in Realtime report
   
5. **GA4 Realtime - Events**
   - Show `page_view` and custom events in event list
   
6. **Browser DevTools - Network Tab**
   - Show `gtm.js` loading successfully
   - Show NO legacy GA scripts
   
7. **Browser DevTools - Console**
   - Show GTM initialization message
   - Show dataLayer contents

### Optional Screenshots:
- Mobile device testing
- Different browsers (Chrome, Firefox, Safari)
- Error-free console on production

---

## 🎉 Success Criteria

All of the following should be true:

- ✅ GTM container `GTM-THXQ6Q9V` loads on every page
- ✅ `page_view` events fire on client-side route changes
- ✅ No duplicate events
- ✅ Custom events fire correctly (login, signup, search, logout)
- ✅ No legacy GA scripts in Network tab
- ✅ No GTM-related errors in Console
- ✅ GA4 Realtime shows active users and events
- ✅ GTM Preview shows all expected events
- ✅ Mobile devices work correctly

**All criteria met?** → 🚀 **Ready for production!**

---

**Document Version**: 1.0  
**Last Updated**: October 28, 2025  
**Container**: GTM-THXQ6Q9V

