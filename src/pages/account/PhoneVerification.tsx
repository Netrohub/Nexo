import { useState } from "react";
import AccountLayout from "@/components/AccountLayout";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useToast } from "@/hooks/use-toast";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { 
  Smartphone,
  Send,
  CheckCircle2,
  ArrowLeft,
  Shield
} from "lucide-react";
import { Link } from "react-router-dom";

const countries = [
  { code: 'US', name: 'United States', dialCode: '+1', flag: '🇺🇸' },
  { code: 'GB', name: 'United Kingdom', dialCode: '+44', flag: '🇬🇧' },
  { code: 'CA', name: 'Canada', dialCode: '+1', flag: '🇨🇦' },
  { code: 'AU', name: 'Australia', dialCode: '+61', flag: '🇦🇺' },
  { code: 'DE', name: 'Germany', dialCode: '+49', flag: '🇩🇪' },
  { code: 'FR', name: 'France', dialCode: '+33', flag: '🇫🇷' },
  { code: 'IT', name: 'Italy', dialCode: '+39', flag: '🇮🇹' },
  { code: 'ES', name: 'Spain', dialCode: '+34', flag: '🇪🇸' },
  { code: 'NL', name: 'Netherlands', dialCode: '+31', flag: '🇳🇱' },
  { code: 'SE', name: 'Sweden', dialCode: '+46', flag: '🇸🇪' },
  { code: 'NO', name: 'Norway', dialCode: '+47', flag: '🇳🇴' },
  { code: 'DK', name: 'Denmark', dialCode: '+45', flag: '🇩🇰' },
  { code: 'FI', name: 'Finland', dialCode: '+358', flag: '🇫🇮' },
  { code: 'PL', name: 'Poland', dialCode: '+48', flag: '🇵🇱' },
  { code: 'CZ', name: 'Czech Republic', dialCode: '+420', flag: '🇨🇿' },
  { code: 'AT', name: 'Austria', dialCode: '+43', flag: '🇦🇹' },
  { code: 'CH', name: 'Switzerland', dialCode: '+41', flag: '🇨🇭' },
  { code: 'BE', name: 'Belgium', dialCode: '+32', flag: '🇧🇪' },
  { code: 'IE', name: 'Ireland', dialCode: '+353', flag: '🇮🇪' },
  { code: 'PT', name: 'Portugal', dialCode: '+351', flag: '🇵🇹' },
  { code: 'GR', name: 'Greece', dialCode: '+30', flag: '🇬🇷' },
  { code: 'JP', name: 'Japan', dialCode: '+81', flag: '🇯🇵' },
  { code: 'KR', name: 'South Korea', dialCode: '+82', flag: '🇰🇷' },
  { code: 'CN', name: 'China', dialCode: '+86', flag: '🇨🇳' },
  { code: 'IN', name: 'India', dialCode: '+91', flag: '🇮🇳' },
  { code: 'SG', name: 'Singapore', dialCode: '+65', flag: '🇸🇬' },
  { code: 'AE', name: 'United Arab Emirates', dialCode: '+971', flag: '🇦🇪' },
  { code: 'SA', name: 'Saudi Arabia', dialCode: '+966', flag: '🇸🇦' },
  { code: 'ZA', name: 'South Africa', dialCode: '+27', flag: '🇿🇦' },
  { code: 'BR', name: 'Brazil', dialCode: '+55', flag: '🇧🇷' },
  { code: 'MX', name: 'Mexico', dialCode: '+52', flag: '🇲🇽' },
  { code: 'AR', name: 'Argentina', dialCode: '+54', flag: '🇦🇷' },
  { code: 'CL', name: 'Chile', dialCode: '+56', flag: '🇨🇱' },
  { code: 'CO', name: 'Colombia', dialCode: '+57', flag: '🇨🇴' },
  { code: 'NZ', name: 'New Zealand', dialCode: '+64', flag: '🇳🇿' },
];

const PhoneVerification = () => {
  const { toast } = useToast();
  const [step, setStep] = useState<'input' | 'verify' | 'success'>('input');
  const [selectedCountry, setSelectedCountry] = useState(countries[0]); // Default to US
  const [phoneNumber, setPhoneNumber] = useState('');
  const [otp, setOtp] = useState(['', '', '', '', '', '']);
  const [isLoading, setIsLoading] = useState(false);

  const fullPhoneNumber = `${selectedCountry.dialCode} ${phoneNumber}`;

  const handleSendOTP = async () => {
    if (!phoneNumber || phoneNumber.length < 7) {
      toast({
        title: "Invalid Phone Number",
        description: "Please enter a valid phone number",
        variant: "destructive",
      });
      return;
    }

    setIsLoading(true);
    
    // Simulate OTP sending
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    setIsLoading(false);
    setStep('verify');
    
    toast({
      title: "OTP Sent!",
      description: `A 6-digit code has been sent to ${fullPhoneNumber}`,
    });
  };

  const handleOTPChange = (index: number, value: string) => {
    if (value.length > 1) return;
    
    const newOtp = [...otp];
    newOtp[index] = value;
    setOtp(newOtp);

    // Auto-focus next input
    if (value && index < 5) {
      const nextInput = document.getElementById(`otp-${index + 1}`);
      nextInput?.focus();
    }
  };

  const handleVerifyOTP = async () => {
    const otpCode = otp.join('');
    
    if (otpCode.length !== 6) {
      toast({
        title: "Invalid OTP",
        description: "Please enter all 6 digits",
        variant: "destructive",
      });
      return;
    }

    setIsLoading(true);
    
    // Simulate OTP verification
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    setIsLoading(false);
    setStep('success');
    
    toast({
      title: "Phone Verified!",
      description: "Your phone number has been successfully verified.",
    });
  };

  const handleResendOTP = async () => {
    setIsLoading(true);
    
    // Simulate resending OTP
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    setIsLoading(false);
    
    toast({
      title: "OTP Resent",
      description: "A new code has been sent to your phone.",
    });
  };

  return (
    <AccountLayout>
      <div className="space-y-6">
        {/* Header */}
        <div>
          <Link 
            to="/account/kyc" 
            className="inline-flex items-center gap-2 text-sm text-primary hover:text-primary/80 mb-4"
          >
            <ArrowLeft className="h-4 w-4" />
            Back to KYC Verification
          </Link>
          <h1 className="text-3xl font-black bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent mb-2">
            Phone Verification
          </h1>
          <p className="text-foreground/60">Secure your account with phone number verification</p>
        </div>

        {step === 'input' && (
          <Card className="glass-card p-6 max-w-2xl">
            <div className="flex items-start gap-4 mb-6">
              <div className="p-3 rounded-lg bg-primary/10 border border-primary/20">
                <Smartphone className="h-6 w-6 text-primary" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground mb-2">Enter Your Phone Number</h2>
                <p className="text-sm text-foreground/60">
                  We'll send you a 6-digit verification code via SMS
                </p>
              </div>
            </div>

            <div className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="country" className="text-foreground">
                  Country
                </Label>
                <Select 
                  value={selectedCountry.code}
                  onValueChange={(code) => {
                    const country = countries.find(c => c.code === code);
                    if (country) setSelectedCountry(country);
                  }}
                >
                  <SelectTrigger className="glass-card border-border/50 focus:border-primary/50">
                    <SelectValue>
                      <div className="flex items-center gap-2">
                        <span className="text-2xl">{selectedCountry.flag}</span>
                        <span className="font-medium">{selectedCountry.name}</span>
                        <span className="text-foreground/60">({selectedCountry.dialCode})</span>
                      </div>
                    </SelectValue>
                  </SelectTrigger>
                  <SelectContent className="glass-card border-border/50 max-h-[300px]">
                    {countries.map((country) => (
                      <SelectItem key={country.code} value={country.code}>
                        <div className="flex items-center gap-2">
                          <span className="text-xl">{country.flag}</span>
                          <span>{country.name}</span>
                          <span className="text-foreground/60">{country.dialCode}</span>
                        </div>
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>

              <div className="space-y-2">
                <Label htmlFor="phone" className="text-foreground">
                  Phone Number
                </Label>
                <div className="flex gap-2">
                  <div className="flex items-center gap-2 px-3 rounded-lg glass-card border border-border/50 bg-muted/30">
                    <span className="text-xl">{selectedCountry.flag}</span>
                    <span className="font-medium text-foreground">{selectedCountry.dialCode}</span>
                  </div>
                  <div className="relative flex-1">
                    <Smartphone className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                    <Input
                      id="phone"
                      type="tel"
                      placeholder="555 123 4567"
                      value={phoneNumber}
                      onChange={(e) => setPhoneNumber(e.target.value.replace(/[^\d\s]/g, ''))}
                      className="pl-10 glass-card border-border/50 focus:border-primary/50"
                    />
                  </div>
                </div>
                <p className="text-xs text-foreground/50">
                  Standard messaging rates may apply
                </p>
              </div>

              <Button 
                className="btn-glow w-full" 
                onClick={handleSendOTP}
                disabled={isLoading}
              >
                <Send className="h-4 w-4 mr-2" />
                {isLoading ? 'Sending...' : 'Send Verification Code'}
              </Button>
            </div>
          </Card>
        )}

        {step === 'verify' && (
          <Card className="glass-card p-6 max-w-2xl">
            <div className="flex items-start gap-4 mb-6">
              <div className="p-3 rounded-lg bg-primary/10 border border-primary/20">
                <Shield className="h-6 w-6 text-primary" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground mb-2">Enter Verification Code</h2>
                <p className="text-sm text-foreground/60">
                  We sent a 6-digit code to {fullPhoneNumber}
                </p>
              </div>
            </div>

            <div className="space-y-6">
              <div>
                <Label className="text-foreground mb-3 block">Verification Code</Label>
                <div className="flex gap-2 justify-center">
                  {otp.map((digit, index) => (
                    <Input
                      key={index}
                      id={`otp-${index}`}
                      type="text"
                      maxLength={1}
                      value={digit}
                      onChange={(e) => handleOTPChange(index, e.target.value)}
                      className="w-12 h-12 text-center text-lg font-bold glass-card border-border/50 focus:border-primary/50"
                    />
                  ))}
                </div>
              </div>

              <div className="space-y-3">
                <Button 
                  className="btn-glow w-full" 
                  onClick={handleVerifyOTP}
                  disabled={isLoading}
                >
                  {isLoading ? 'Verifying...' : 'Verify Phone Number'}
                </Button>
                
                <div className="text-center">
                  <Button 
                    variant="ghost" 
                    size="sm"
                    onClick={handleResendOTP}
                    disabled={isLoading}
                    className="text-primary hover:text-primary/80"
                  >
                    Didn't receive the code? Resend
                  </Button>
                </div>

                <Button 
                  variant="outline" 
                  className="glass-card border-border/50 w-full"
                  onClick={() => setStep('input')}
                >
                  <ArrowLeft className="h-4 w-4 mr-2" />
                  Change Phone Number
                </Button>
              </div>
            </div>
          </Card>
        )}

        {step === 'success' && (
          <Card className="glass-card p-6 max-w-2xl border border-primary/30">
            <div className="text-center py-8">
              <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-primary/20 border-2 border-primary mb-6">
                <CheckCircle2 className="h-8 w-8 text-primary" />
              </div>
              
              <h2 className="text-2xl font-bold text-foreground mb-2">Phone Verified Successfully!</h2>
              <p className="text-foreground/60 mb-8">
                <span className="inline-flex items-center gap-2">
                  <span className="text-xl">{selectedCountry.flag}</span>
                  <span>Your phone number {fullPhoneNumber} has been verified</span>
                </span>
              </p>

              <div className="space-y-3">
                <Button asChild className="btn-glow w-full">
                  <Link to="/account/kyc">
                    <CheckCircle2 className="h-4 w-4 mr-2" />
                    Continue to KYC Verification
                  </Link>
                </Button>
                
                <Button asChild variant="outline" className="glass-card border-border/50 w-full">
                  <Link to="/account/dashboard">
                    Go to Dashboard
                  </Link>
                </Button>
              </div>
            </div>
          </Card>
        )}

        {/* Security Info */}
        <Card className="glass-card p-6 border border-border/30 max-w-2xl">
          <div className="flex items-start gap-4">
            <div className="p-3 rounded-lg bg-primary/10 border border-primary/20">
              <Shield className="h-6 w-6 text-primary" />
            </div>
            <div>
              <h3 className="text-lg font-bold text-foreground mb-2">Why Verify Your Phone?</h3>
              <div className="space-y-2 text-sm text-foreground/70">
                <p>✓ Enhanced account security with two-factor authentication</p>
                <p>✓ Receive important account notifications via SMS</p>
                <p>✓ Faster account recovery if you forget your password</p>
                <p>✓ Required for completing KYC verification</p>
              </div>
            </div>
          </div>
        </Card>
      </div>
    </AccountLayout>
  );
};

export default PhoneVerification;
