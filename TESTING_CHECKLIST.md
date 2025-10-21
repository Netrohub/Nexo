# ✅ Testing Checklist - Sign In Button Not Working?

Quick troubleshooting guide to get your sign in working!

## 🔍 **Step-by-Step Debug:**

### **1. Check Browser Console**

```bash
# Start the dev server
npm run dev

# Open browser to: http://localhost:8080/login
# Press F12 to open Developer Tools
# Click "Console" tab
```

**You should see:**
```
🔧 API Configuration: {
  API_BASE_URL: "http://localhost:8000/api",
  USE_MOCK_API: true,
  VITE_MOCK_API: "true"
}
```

If `USE_MOCK_API: true` → ✅ Mock API is enabled!

---

### **2. Test Sign In**

```bash
# On login page:
Email: test@test.com
Password: password123

# Click "Sign In"
```

**Check console for:**
```
🎭 Using Mock API for login
🎭 Mock API: Login successful {email: "test@test.com", user: "John Doe"}
```

If you see this → ✅ Mock API is working!

---

### **3. Common Issues & Fixes:**

#### **Issue: Button does nothing**

**Fix 1: Hard Reload**
```bash
# Press Ctrl + Shift + R (Windows)
# Or Cmd + Shift + R (Mac)
# This clears cache and reloads
```

**Fix 2: Clear localStorage**
```javascript
// In browser console
localStorage.clear()
location.reload()
```

**Fix 3: Check for JavaScript errors**
```bash
# In console, look for red errors
# Any errors? Share them with me!
```

#### **Issue: "Invalid email" or validation error**

**Fix: Use valid email format**
```
❌ Bad: test
❌ Bad: test@
✅ Good: test@test.com
✅ Good: anything@example.com
```

#### **Issue: Network error / API error**

**This means mock API is disabled!**

**Fix: Enable mock API**
```bash
# 1. Stop dev server (Ctrl+C)

# 2. Check .env file
notepad .env

# 3. Make sure this line exists:
VITE_MOCK_API=true

# 4. Restart dev server
npm run dev
```

---

### **4. Verify Mock API is Enabled:**

**Open browser console and type:**
```javascript
// Check environment variable
import.meta.env.VITE_MOCK_API

// Should show: "true"
```

---

## ✅ **Quick Test:**

### **Option 1: Login with Mock API**

1. Visit: http://localhost:8080/login
2. Email: `test@nxoland.com`
3. Password: `password`
4. Click "Sign In"
5. Should redirect to homepage (logged in!)

### **Option 2: Register New Account**

1. Visit: http://localhost:8080/register
2. Name: `Your Name`
3. Email: `you@test.com`
4. Password: `password123`
5. Confirm: `password123`
6. Check "I agree" checkbox
7. Click "Create Account"
8. Should redirect to homepage (logged in!)

---

## 🎯 **What to Look For:**

### **Success Signs:**
- ✅ Console shows "🎭 Mock API" messages
- ✅ Form shows loading spinner briefly
- ✅ Success toast appears
- ✅ Redirects to homepage
- ✅ Navbar shows user avatar/name
- ✅ Can access /account/dashboard

### **Problem Signs:**
- ❌ Red error in console
- ❌ Network error message
- ❌ Button does nothing (no spinner)
- ❌ No console messages

---

## 🔧 **Restart Dev Server:**

```bash
# Stop current server
# Press Ctrl+C in terminal

# Restart
npm run dev

# Wait for:
# "VITE v5.x.x ready in XXXms"
# "➜ Local: http://localhost:XXXX/"

# Then try again
```

---

## 🎭 **Verify Mock Mode:**

Run this in browser console after page loads:

```javascript
// Check configuration
console.log('Mock API?', import.meta.env.VITE_MOCK_API === 'true');

// Test localStorage
localStorage.setItem('test', 'works');
console.log('localStorage works:', localStorage.getItem('test'));
localStorage.removeItem('test');

// Check if auth token exists
console.log('Auth token:', localStorage.getItem('auth_token'));
```

---

## 🚀 **Fresh Start (If Nothing Works):**

```bash
# 1. Clear browser data
# Press Ctrl+Shift+Delete
# Clear "Cached images and files" and "Cookies"

# 2. Close ALL browser tabs

# 3. Stop dev server
# Press Ctrl+C

# 4. Clear Vite cache
rm -r node_modules/.vite

# 5. Restart
npm run dev

# 6. Open new incognito window
# Visit: http://localhost:8080/login

# 7. Try logging in
```

---

## 📞 **Still Not Working?**

### **Tell me:**

1. **What happens when you click "Sign In"?**
   - Nothing?
   - Error message?
   - Loading spinner then nothing?

2. **Any errors in console?**
   - Open F12 → Console tab
   - Any red errors?
   - Copy and share them

3. **What's in the Network tab?**
   - F12 → Network tab
   - Click "Sign In"
   - See any requests?
   - Any failed requests (red)?

---

## 🎯 **Expected Behavior:**

1. Click "Sign In" button
2. Button shows loading spinner
3. Console logs: "🎭 Mock API: Login successful"
4. Success toast appears
5. Redirects to homepage
6. Navbar shows user menu with avatar
7. ✅ You're logged in!

---

**Try the steps above and let me know what you see!** 🔍
