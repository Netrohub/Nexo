# Tap Payment Gateway Setup

## 🔐 Sandbox Configuration (Testing)

Add these to your `.env` file:

```env
# Tap Payment Gateway (Sandbox)
VITE_TAP_PUBLIC_KEY=pk_test_sandbox_key
VITE_TAP_SANDBOX=true
```

## 🧪 Test Cards (Sandbox Mode)

Use these test cards for testing payments:

### Visa (Success)
- **Card Number:** `4111 1111 1111 1111`
- **Expiry:** `12/25` (MM/YY format)
- **CVV:** `123`
- **Name:** Any name

### Mastercard (Success)
- **Card Number:** `5200 0000 0000 0007`
- **Expiry:** `12/25`
- **CVV:** `123`
- **Name:** Any name

## 📋 Integration Details

### Features Implemented:
- ✅ Sandbox mode for testing
- ✅ Card payment processing
- ✅ Payment verification
- ✅ Expiry date validation (MM/YY format)
- ✅ Test card validation
- ✅ Loading states and error handling
- ✅ Terms of Service mandatory checkbox

### Checkout Flow:
1. User fills in shipping/billing information
2. User enters card details (sandbox test card)
3. User agrees to Terms of Service (mandatory)
4. Click "Complete Purchase"
5. Payment processes through Tap (2s simulation in sandbox)
6. Success/Error message displayed
7. Redirect on success

## 🚀 Production Setup

When ready for production:

1. Get your real Tap.company API keys from: https://www.tap.company/en-sa
2. Update `.env`:
   ```env
   VITE_TAP_PUBLIC_KEY=pk_live_your_real_key_here
   VITE_TAP_SANDBOX=false
   ```
3. Test with real cards in production

## 📖 Tap.company Documentation
- Website: https://www.tap.company/en-sa
- API Docs: https://developers.tap.company/
- Dashboard: https://dashboard.tap.company/

## 💳 Supported Payment Methods
- Credit Cards (Visa, Mastercard, Amex)
- Debit Cards
- KNET (Kuwait)
- Benefit (Bahrain)
- Fawry (Egypt)
- QPay (Qatar)

## 🔒 Security
- PCI DSS Compliant
- 3D Secure support
- Tokenization
- Fraud detection

## 🐛 Troubleshooting

### "Card declined" error
- Make sure you're using a test card in sandbox mode
- Valid test cards: 4111111111111111 or 5200000000000007
- Check expiry format is MM/YY (e.g., 12/25)
- CVV must be 3 digits

### "Invalid expiry date" error
- Format must be MM/YY
- Example: 01/25 for January 2025
- Month must be 01-12
- Year must be 2 digits

### Payment not processing
- Check VITE_TAP_SANDBOX=true in .env
- Verify test card number is entered correctly
- Check browser console for errors
- Ensure Terms of Service checkbox is checked

## 📞 Support
For Tap.company support: support@tap.company

