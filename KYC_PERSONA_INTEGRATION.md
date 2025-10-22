# 🔐 KYC Integration Guide - Persona + NXOLand

Complete KYC verification system using **Persona** for identity verification and **NXOLand** for phone/email verification.

---

## 📋 **KYC Workflow:**

### **Step 1: Phone & Email Verification** (NXOLand - In-House)
✅ **Handled by NXOLand Platform:**
- **Phone Verification**: SMS code verification
- **Email Verification**: Email confirmation link
- **Status**: Implemented in your platform

### **Step 2: Identity Verification** (Persona - Third-Party)
🔐 **Handled by Persona KYC Service:**
- **Identity Verification**: Government ID verification
- **Selfie Verification**: Liveness check
- **Address Verification**: Proof of address document
- **Document Validation**: Real-time ID authentication
- **AML/Sanctions Screening**: Compliance checks

---

## 🎯 **Implementation Architecture:**

```
User Registration
    ↓
Email Verification (NXOLand) → Send verification email
    ↓
Phone Verification (NXOLand) → Send SMS code
    ↓
Identity Verification (Persona) → Launch Persona Inquiry
    ↓
KYC Approved → Enable Seller Features
```

---

## 🔧 **Technical Integration:**

### **1. Persona Setup**

#### **A. Get Persona API Keys:**
```bash
# Production
VITE_PERSONA_TEMPLATE_ID=itmpl_xxxxxxxxxxxxx
VITE_PERSONA_ENVIRONMENT_ID=env_xxxxxxxxxxxxx

# Sandbox (for testing)
VITE_PERSONA_TEMPLATE_ID=itmpl_xxxxxxxxxxxxx
VITE_PERSONA_ENVIRONMENT_ID=env_xxxxxxxxxxxxx
VITE_PERSONA_MODE=sandbox
```

#### **B. Add Persona Script to `index.html`:**
```html
<head>
  <!-- Persona Embedded Flow -->
  <script src="https://cdn.withpersona.com/dist/persona-v4.9.0.js"></script>
</head>
```

---

### **2. Frontend Integration (React)**

#### **A. Create Persona Hook (`src/hooks/usePersona.ts`):**
```typescript
import { useEffect, useState } from 'react';

interface PersonaConfig {
  templateId: string;
  environmentId: string;
  referenceId?: string; // User ID
  onComplete?: (inquiryId: string) => void;
  onCancel?: () => void;
  onError?: (error: any) => void;
}

export const usePersona = () => {
  const [isReady, setIsReady] = useState(false);

  useEffect(() => {
    // Check if Persona is loaded
    if (window.Persona) {
      setIsReady(true);
    }
  }, []);

  const launchPersona = (config: PersonaConfig) => {
    if (!window.Persona) {
      console.error('Persona SDK not loaded');
      return;
    }

    const client = new window.Persona.Client({
      templateId: config.templateId,
      environmentId: config.environmentId,
      referenceId: config.referenceId,
      
      onReady: () => {
        console.log('Persona client ready');
        client.open();
      },
      
      onComplete: ({ inquiryId, status, fields }) => {
        console.log('Persona verification complete', { inquiryId, status });
        config.onComplete?.(inquiryId);
      },
      
      onCancel: ({ inquiryId, sessionToken }) => {
        console.log('Persona verification cancelled', { inquiryId });
        config.onCancel?.();
      },
      
      onError: (error) => {
        console.error('Persona error', error);
        config.onError?.(error);
      },
    });
  };

  return { isReady, launchPersona };
};

// Type declaration for Persona SDK
declare global {
  interface Window {
    Persona: any;
  }
}
```

#### **B. Update KYC Page (`src/pages/account/KYC.tsx`):**
```typescript
import { usePersona } from '@/hooks/usePersona';
import { useAuth } from '@/contexts/AuthContext';
import { toast } from 'sonner';

const KYC = () => {
  const { user } = useAuth();
  const { isReady, launchPersona } = usePersona();
  const [verificationStatus, setVerificationStatus] = useState({
    email: user?.emailVerified || false,
    phone: user?.phoneVerified || false,
    identity: user?.kycStatus === 'verified',
  });

  const handleEmailVerification = async () => {
    // Your existing email verification logic
    toast.loading('Sending verification email...');
    // API call to send email
  };

  const handlePhoneVerification = async () => {
    // Your existing phone verification logic
    toast.loading('Sending verification code...');
    // API call to send SMS
  };

  const handleIdentityVerification = () => {
    if (!isReady) {
      toast.error('Verification service not ready. Please refresh the page.');
      return;
    }

    toast.loading('Launching identity verification...');

    launchPersona({
      templateId: import.meta.env.VITE_PERSONA_TEMPLATE_ID,
      environmentId: import.meta.env.VITE_PERSONA_ENVIRONMENT_ID,
      referenceId: user?.id,
      
      onComplete: async (inquiryId: string) => {
        toast.success('Identity verification submitted!');
        
        // Send inquiry ID to your backend
        try {
          const response = await fetch('/api/kyc/persona-callback', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ inquiryId, userId: user?.id }),
          });
          
          if (response.ok) {
            setVerificationStatus(prev => ({ ...prev, identity: true }));
            toast.success('KYC verification complete! You can now sell on NXOLand.');
          }
        } catch (error) {
          toast.error('Failed to submit verification. Please contact support.');
        }
      },
      
      onCancel: () => {
        toast.info('Identity verification cancelled. You can resume anytime.');
      },
      
      onError: (error) => {
        toast.error('Verification error. Please try again or contact support.');
        console.error('Persona error:', error);
      },
    });
  };

  return (
    <AccountLayout>
      <div className="space-y-6">
        {/* Header */}
        <div>
          <h1 className="text-3xl font-black text-foreground mb-2">
            Identity Verification
          </h1>
          <p className="text-foreground/60">
            Complete all verification steps to start selling on NXOLand
          </p>
        </div>

        {/* Verification Steps */}
        <Card className="glass-card p-6">
          <div className="space-y-4">
            {/* Step 1: Email Verification */}
            <div className="flex items-center justify-between p-4 rounded-lg border border-border/50">
              <div className="flex items-center gap-4">
                <Mail className="h-6 w-6 text-primary" />
                <div>
                  <h3 className="font-bold">Email Verification</h3>
                  <p className="text-sm text-foreground/60">Verify your email address</p>
                </div>
              </div>
              {verificationStatus.email ? (
                <Badge className="bg-green-500/20 text-green-400">
                  <CheckCircle className="h-4 w-4 mr-1" />
                  Verified
                </Badge>
              ) : (
                <Button onClick={handleEmailVerification}>Verify Email</Button>
              )}
            </div>

            {/* Step 2: Phone Verification */}
            <div className="flex items-center justify-between p-4 rounded-lg border border-border/50">
              <div className="flex items-center gap-4">
                <Phone className="h-6 w-6 text-primary" />
                <div>
                  <h3 className="font-bold">Phone Verification</h3>
                  <p className="text-sm text-foreground/60">Verify your phone number</p>
                </div>
              </div>
              {verificationStatus.phone ? (
                <Badge className="bg-green-500/20 text-green-400">
                  <CheckCircle className="h-4 w-4 mr-1" />
                  Verified
                </Badge>
              ) : (
                <Button 
                  onClick={handlePhoneVerification}
                  disabled={!verificationStatus.email}
                >
                  Verify Phone
                </Button>
              )}
            </div>

            {/* Step 3: Identity Verification (Persona) */}
            <div className="flex items-center justify-between p-4 rounded-lg border border-border/50">
              <div className="flex items-center gap-4">
                <Shield className="h-6 w-6 text-primary" />
                <div>
                  <h3 className="font-bold">Identity Verification</h3>
                  <p className="text-sm text-foreground/60">
                    Verify your identity with government ID
                  </p>
                </div>
              </div>
              {verificationStatus.identity ? (
                <Badge className="bg-green-500/20 text-green-400">
                  <CheckCircle className="h-4 w-4 mr-1" />
                  Verified
                </Badge>
              ) : (
                <Button 
                  onClick={handleIdentityVerification}
                  disabled={!verificationStatus.email || !verificationStatus.phone}
                  className="btn-glow"
                >
                  Start Verification
                  <ExternalLink className="h-4 w-4 ml-2" />
                </Button>
              )}
            </div>
          </div>
        </Card>

        {/* Information Card */}
        <Card className="glass-card p-6 border-blue-500/30">
          <div className="flex gap-4">
            <Shield className="h-6 w-6 text-blue-400 flex-shrink-0" />
            <div>
              <h3 className="font-bold mb-2">Why do we need this?</h3>
              <ul className="space-y-1 text-sm text-foreground/60">
                <li>• Protect buyers and sellers from fraud</li>
                <li>• Comply with legal and regulatory requirements</li>
                <li>• Ensure secure transactions on the platform</li>
                <li>• Build trust in the NXOLand community</li>
              </ul>
            </div>
          </div>
        </Card>
      </div>
    </AccountLayout>
  );
};
```

---

### **3. Backend Integration (Laravel)**

#### **A. Create Persona Webhook Endpoint:**
```php
// routes/api.php
Route::post('/kyc/persona-webhook', [KYCController::class, 'personaWebhook']);
Route::post('/kyc/persona-callback', [KYCController::class, 'personaCallback'])
    ->middleware('auth:sanctum');
```

#### **B. KYC Controller (`app/Http/Controllers/KYCController.php`):**
```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Log;

class KYCController extends Controller
{
    /**
     * Handle Persona inquiry completion (from frontend)
     */
    public function personaCallback(Request $request)
    {
        $validated = $request->validate([
            'inquiryId' => 'required|string',
            'userId' => 'required|exists:users,id',
        ]);

        $user = User::findOrFail($validated['userId']);
        
        // Store inquiry ID for tracking
        $user->update([
            'persona_inquiry_id' => $validated['inquiryId'],
            'kyc_status' => 'pending', // Waiting for Persona webhook
        ]);

        return response()->json([
            'message' => 'KYC submission received',
            'status' => 'pending',
        ]);
    }

    /**
     * Handle Persona webhook (inquiry status updates)
     */
    public function personaWebhook(Request $request)
    {
        // Verify webhook signature (important for security!)
        $signature = $request->header('Persona-Signature');
        $webhookSecret = config('services.persona.webhook_secret');
        
        if (!$this->verifyWebhookSignature($request->getContent(), $signature, $webhookSecret)) {
            Log::warning('Invalid Persona webhook signature');
            return response()->json(['error' => 'Invalid signature'], 401);
        }

        $payload = $request->all();
        $inquiryId = $payload['data']['id'] ?? null;
        $status = $payload['data']['attributes']['status'] ?? null;

        Log::info('Persona webhook received', [
            'inquiry_id' => $inquiryId,
            'status' => $status,
            'payload' => $payload,
        ]);

        // Find user by inquiry ID
        $user = User::where('persona_inquiry_id', $inquiryId)->first();
        
        if (!$user) {
            Log::warning('User not found for Persona inquiry', ['inquiry_id' => $inquiryId]);
            return response()->json(['message' => 'User not found'], 404);
        }

        // Update KYC status based on Persona result
        switch ($status) {
            case 'completed':
                $user->update([
                    'kyc_status' => 'verified',
                    'kyc_verified_at' => now(),
                ]);
                // Send email notification
                // Mail::to($user)->send(new KYCApprovedMail());
                break;

            case 'failed':
                $user->update([
                    'kyc_status' => 'rejected',
                    'kyc_rejection_reason' => $payload['data']['attributes']['failure-reason'] ?? 'Verification failed',
                ]);
                // Send email notification
                break;

            case 'needs_review':
                $user->update(['kyc_status' => 'under_review']);
                break;

            default:
                $user->update(['kyc_status' => 'pending']);
        }

        return response()->json(['message' => 'Webhook processed']);
    }

    /**
     * Verify Persona webhook signature
     */
    private function verifyWebhookSignature(string $payload, string $signature, string $secret): bool
    {
        $expectedSignature = base64_encode(hash_hmac('sha256', $payload, $secret, true));
        return hash_equals($expectedSignature, $signature);
    }
}
```

#### **C. Update User Model:**
```php
// app/Models/User.php
protected $fillable = [
    'name',
    'email',
    'password',
    'phone',
    'phone_verified_at',
    'email_verified_at',
    'persona_inquiry_id',
    'kyc_status', // incomplete, pending, under_review, verified, rejected
    'kyc_verified_at',
    'kyc_rejection_reason',
];

protected $casts = [
    'email_verified_at' => 'datetime',
    'phone_verified_at' => 'datetime',
    'kyc_verified_at' => 'datetime',
];

// Helper methods
public function hasVerifiedKYC(): bool
{
    return $this->kyc_status === 'verified';
}

public function hasVerifiedPhone(): bool
{
    return !is_null($this->phone_verified_at);
}

public function hasVerifiedEmail(): bool
{
    return !is_null($this->email_verified_at);
}

public function canSell(): bool
{
    return $this->hasVerifiedEmail() 
        && $this->hasVerifiedPhone() 
        && $this->hasVerifiedKYC();
}
```

---

## 🔑 **Environment Variables:**

### **Add to `.env`:**
```bash
# Persona KYC Configuration
VITE_PERSONA_TEMPLATE_ID=itmpl_xxxxxxxxxxxxx
VITE_PERSONA_ENVIRONMENT_ID=env_xxxxxxxxxxxxx
VITE_PERSONA_MODE=production # or 'sandbox' for testing

# Laravel Backend
PERSONA_API_KEY=persona_live_xxxxxxxxxxxxx
PERSONA_WEBHOOK_SECRET=your_webhook_secret_here
```

---

## 📊 **KYC Status Flow:**

```
incomplete → User hasn't started
     ↓
pending → Persona inquiry submitted, waiting for verification
     ↓
under_review → Manual review required
     ↓
verified ✅ → KYC approved, can sell
rejected ❌ → KYC failed, cannot sell
```

---

## 🎯 **Integration Checklist:**

### **Frontend:**
- [ ] Add Persona SDK script to `index.html`
- [ ] Create `usePersona` hook
- [ ] Update KYC page with Persona integration
- [ ] Add environment variables for Persona
- [ ] Test Persona flow in sandbox mode

### **Backend:**
- [ ] Create Persona webhook endpoint
- [ ] Implement webhook signature verification
- [ ] Update User model with KYC fields
- [ ] Create database migration for KYC fields
- [ ] Set up webhook URL in Persona dashboard
- [ ] Configure Persona API keys

### **Testing:**
- [ ] Test email verification flow
- [ ] Test phone verification flow
- [ ] Test Persona identity verification
- [ ] Test webhook status updates
- [ ] Test seller access control

---

## 🚀 **Benefits of This Architecture:**

### **Security:**
- ✅ **Separated concerns** - Each service handles what it does best
- ✅ **Industry standard** - Persona is used by major companies
- ✅ **AML compliance** - Automatic sanctions screening
- ✅ **Fraud prevention** - AI-powered liveness detection

### **User Experience:**
- ✅ **Seamless flow** - Embedded verification (no redirects)
- ✅ **Multi-language** - Persona supports 20+ languages
- ✅ **Mobile optimized** - Works on all devices
- ✅ **Fast verification** - Real-time ID validation

### **Cost Effective:**
- ✅ **Pay per verification** - Only pay for completed verifications
- ✅ **Reduce manual review** - Automated ID validation
- ✅ **Scalable** - Handles high volume
- ✅ **No infrastructure** - Persona handles everything

---

## 📚 **Persona Resources:**

- **Documentation**: https://docs.withpersona.com/
- **Dashboard**: https://dashboard.withpersona.com/
- **Sandbox Testing**: Use test IDs and test documents
- **Pricing**: https://withpersona.com/pricing

---

## ✅ **Summary:**

**Your KYC Flow:**
1. ✅ **Email verification** - NXOLand (in-house)
2. ✅ **Phone verification** - NXOLand (in-house)
3. 🔐 **Identity verification** - Persona (third-party)
4. ✅ **Seller access enabled** - After all verifications complete

**This gives you:**
- Professional identity verification
- Regulatory compliance
- Fraud prevention
- Excellent user experience
- Cost-effective solution

Ready to implement! 🚀

