# 🔒 Cloudflare Turnstile Setup Guide

Complete guide for setting up and using Cloudflare Turnstile (CAPTCHA) in NXOLand marketplace.

## 📋 What is Cloudflare Turnstile?

Cloudflare Turnstile is a user-friendly CAPTCHA alternative that:
- ✅ Works without solving puzzles (invisible verification)
- ✅ Privacy-focused (no tracking)
- ✅ Fast and lightweight
- ✅ Free tier available
- ✅ Better UX than traditional CAPTCHAs

---

## 🚀 Quick Setup (5 Minutes)

### Step 1: Get Your Turnstile Keys

1. **Go to Cloudflare Dashboard**
   - Visit: https://dash.cloudflare.com
   - Log in to your account

2. **Navigate to Turnstile**
   - Click on your account name
   - Select "Turnstile" from the menu
   - Or visit: https://dash.cloudflare.com/?to=/:account/turnstile

3. **Create a New Site**
   - Click "Add Site"
   - Enter your domain (or `localhost` for development)
   - Choose widget mode:
     - **Managed**: Cloudflare decides when to show challenge
     - **Non-Interactive**: Challenge without user interaction
     - **Invisible**: Completely invisible
   - Click "Create"

4. **Copy Your Keys**
   - **Site Key**: Public key (visible in frontend)
   - **Secret Key**: Private key (use in backend only)

### Step 2: Configure Environment Variables

Update your `.env` file:

```env
# Cloudflare Turnstile Configuration
VITE_TURNSTILE_SITE_KEY=1x00000000000000000000AA
VITE_ENABLE_TURNSTILE=true
VITE_TURNSTILE_THEME=dark
VITE_TURNSTILE_SIZE=normal
```

**Replace with your actual site key!**

### Step 3: Restart Development Server

```bash
# Stop the server (Ctrl+C)
# Start again
npm run dev
```

---

## 🔧 Configuration Options

### Environment Variables

| Variable | Description | Values | Default |
|----------|-------------|--------|---------|
| `VITE_TURNSTILE_SITE_KEY` | Your Cloudflare site key | Your key | `1x00000000000000000000AA` |
| `VITE_ENABLE_TURNSTILE` | Enable/disable Turnstile | `true`, `false` | `true` |
| `VITE_TURNSTILE_THEME` | Widget theme | `light`, `dark`, `auto` | `dark` |
| `VITE_TURNSTILE_SIZE` | Widget size | `normal`, `compact` | `normal` |

### Theme Options

```env
# Dark theme (matches your app)
VITE_TURNSTILE_THEME=dark

# Light theme
VITE_TURNSTILE_THEME=light

# Auto (follows system preference)
VITE_TURNSTILE_THEME=auto
```

### Size Options

```env
# Normal size (300x65px)
VITE_TURNSTILE_SIZE=normal

# Compact size (130x120px)
VITE_TURNSTILE_SIZE=compact
```

---

## 📍 Where Turnstile is Used

Turnstile is automatically integrated in:

1. ✅ **Login Page** (`/login`)
   - Validates before authentication
   - Resets on error

2. ✅ **Register Page** (`/register`)
   - Validates before account creation
   - Resets on error

3. **Future Integration** (optional):
   - Dispute creation
   - Product listing creation
   - Contact forms
   - Password reset

---

## 🧪 Testing

### Development Testing

1. **Test Keys (Already in .env)**
   ```env
   VITE_TURNSTILE_SITE_KEY=1x00000000000000000000AA
   ```
   These keys always pass for testing!

2. **Test Scenarios**
   - Fill login/register form
   - See Turnstile widget appear
   - Submit form (should pass immediately with test key)

### Production Testing

1. **Use Real Keys**
   - Replace test key with your actual site key
   - Test on your staging/production domain

2. **Test Different Scenarios**
   - ✅ Normal user (should pass easily)
   - ✅ Suspicious activity (may show challenge)
   - ✅ Bot behavior (will show challenge)

---

## 🎨 Customization

### Widget Component

The Turnstile widget is in `src/components/TurnstileWidget.tsx`

```typescript
<TurnstileWidget
  ref={turnstileRef}
  onSuccess={(token) => {
    // Called when verification succeeds
    setTurnstileToken(token);
  }}
  onError={() => {
    // Called when verification fails
    setTurnstileToken("");
  }}
  onExpire={() => {
    // Called when token expires (default: 5 minutes)
    setTurnstileToken("");
  }}
/>
```

### Add to Other Forms

```typescript
import TurnstileWidget, { TurnstileWidgetRef } from "@/components/TurnstileWidget";
import { useRef, useState } from "react";

const MyForm = () => {
  const turnstileRef = useRef<TurnstileWidgetRef>(null);
  const [turnstileToken, setTurnstileToken] = useState("");

  const onSubmit = async (data) => {
    // Check Turnstile if enabled
    if (import.meta.env.VITE_ENABLE_TURNSTILE === 'true' && !turnstileToken) {
      alert("Please complete the security verification");
      return;
    }

    // Your form submission logic
    await submitForm(data, turnstileToken);

    // Reset on error
    turnstileRef.current?.reset();
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* Your form fields */}
      
      <TurnstileWidget
        ref={turnstileRef}
        onSuccess={setTurnstileToken}
        onError={() => setTurnstileToken("")}
      />
      
      <button type="submit">Submit</button>
    </form>
  );
};
```

---

## 🔐 Backend Verification (Laravel)

**IMPORTANT**: Always verify the Turnstile token on your backend!

### Laravel Implementation

```php
// In your AuthController or validation middleware

use Illuminate\Support\Facades\Http;

public function login(Request $request)
{
    // Validate Turnstile token
    if (config('services.turnstile.enabled')) {
        $turnstileToken = $request->input('turnstile_token');
        
        if (!$this->verifyTurnstile($turnstileToken)) {
            return response()->json([
                'message' => 'Security verification failed'
            ], 422);
        }
    }
    
    // Continue with login logic
    // ...
}

private function verifyTurnstile($token)
{
    $response = Http::asForm()->post('https://challenges.cloudflare.com/turnstile/v0/siteverify', [
        'secret' => config('services.turnstile.secret_key'),
        'response' => $token,
    ]);
    
    $result = $response->json();
    
    return $result['success'] ?? false;
}
```

### Laravel Configuration

Add to `config/services.php`:

```php
'turnstile' => [
    'site_key' => env('TURNSTILE_SITE_KEY'),
    'secret_key' => env('TURNSTILE_SECRET_KEY'),
    'enabled' => env('TURNSTILE_ENABLED', true),
],
```

Add to Laravel `.env`:

```env
TURNSTILE_SITE_KEY=your_site_key_here
TURNSTILE_SECRET_KEY=your_secret_key_here
TURNSTILE_ENABLED=true
```

### Update API Client

Modify `src/lib/api.ts` to send Turnstile token:

```typescript
async login(credentials: LoginRequest & { turnstile_token?: string }): Promise<AuthResponse> {
  const response = await this.request<AuthResponse>('/auth/login', {
    method: 'POST',
    body: JSON.stringify(credentials),
  });
  
  if (response.data.token) {
    this.setToken(response.data.token);
  }
  
  return response.data;
}
```

---

## 🎯 Best Practices

### 1. **Always Verify Backend**
- ❌ Never trust frontend-only validation
- ✅ Always verify token on backend

### 2. **Handle Errors Gracefully**
```typescript
const onSubmit = async (data) => {
  if (isTurnstileEnabled && !turnstileToken) {
    toast.error("Please complete the security check");
    return;
  }
  
  try {
    await submitForm(data);
  } catch (error) {
    // Reset Turnstile on error
    turnstileRef.current?.reset();
    setTurnstileToken("");
  }
};
```

### 3. **Reset on Errors**
- Always reset Turnstile after failed submissions
- Prevents token reuse

### 4. **Token Expiration**
- Tokens expire after 5 minutes
- Handle `onExpire` callback

### 5. **User Experience**
- Use invisible or managed mode for better UX
- Match theme to your app (dark/light)

---

## 🐛 Troubleshooting

### Widget Not Appearing?

**Check:**
1. ✅ `VITE_ENABLE_TURNSTILE=true` in `.env`
2. ✅ Valid site key (not the default test key)
3. ✅ Dev server restarted after `.env` changes
4. ✅ Console for errors

**Debug:**
```typescript
// Check in browser console
console.log('Turnstile enabled:', import.meta.env.VITE_ENABLE_TURNSTILE);
console.log('Site key:', import.meta.env.VITE_TURNSTILE_SITE_KEY);
```

### Token Not Validating?

**Frontend Issues:**
- Check `turnstileToken` state is set
- Verify `onSuccess` callback is firing
- Check network tab for token in request

**Backend Issues:**
- Verify secret key is correct
- Check backend receives token
- Verify backend validation logic
- Check Cloudflare siteverify endpoint response

### CORS Errors?

Turnstile makes requests to Cloudflare domains. Ensure:
```typescript
// No CORS config needed for Turnstile widget
// It handles its own requests
```

### Rate Limiting?

Cloudflare Turnstile has generous limits:
- Free tier: 1 million verifications/month
- No rate limit issues in normal use

---

## 🔄 Enable/Disable Turnstile

### Temporarily Disable

```env
# In .env
VITE_ENABLE_TURNSTILE=false
```

Restart dev server - forms will work without Turnstile.

### Production Rollout

1. **Start Disabled**
   ```env
   VITE_ENABLE_TURNSTILE=false
   ```

2. **Test Thoroughly**
   - Enable on staging first
   - Test all forms
   - Verify backend validation

3. **Enable Gradually**
   ```env
   VITE_ENABLE_TURNSTILE=true
   ```

---

## 📊 Monitoring

### Cloudflare Dashboard

View analytics in Cloudflare Dashboard:
- Total verifications
- Success rate
- Challenge rate
- Geographic data
- Bot detection stats

### Custom Tracking

Add to your analytics:

```typescript
const handleTurnstileSuccess = (token: string) => {
  setTurnstileToken(token);
  
  // Track success
  analytics.track('turnstile_success', {
    page: 'login',
    timestamp: new Date(),
  });
};
```

---

## 📚 Additional Resources

- **Cloudflare Docs**: https://developers.cloudflare.com/turnstile/
- **Widget Options**: https://developers.cloudflare.com/turnstile/get-started/
- **API Reference**: https://developers.cloudflare.com/turnstile/get-started/server-side-validation/
- **React Package**: https://github.com/marsidev/react-turnstile

---

## ✅ Checklist

- [ ] Created Cloudflare account
- [ ] Added site in Turnstile dashboard
- [ ] Copied site key to `.env`
- [ ] Set `VITE_ENABLE_TURNSTILE=true`
- [ ] Restarted dev server
- [ ] Tested login form
- [ ] Tested register form
- [ ] Implemented backend verification (Laravel)
- [ ] Tested on staging
- [ ] Deployed to production

---

**Cloudflare Turnstile is now protecting your forms! 🛡️**
