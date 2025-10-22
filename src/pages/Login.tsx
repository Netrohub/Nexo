import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import Starfield from "@/components/Starfield";
import TurnstileWidget, { TurnstileWidgetRef } from "@/components/TurnstileWidget";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { Link, useNavigate, useLocation } from "react-router-dom";
import { Mail, Lock, ArrowRight, Smartphone, Loader2 } from "lucide-react";
import { useLanguage } from "@/contexts/LanguageContext";
import { useAuth } from "@/contexts/AuthContext";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useRef, useState } from "react";
import { analytics } from "@/lib/analytics";
import { toast } from "sonner";

// Form validation schema - accepts email, phone, or username
const loginSchema = z.object({
  identifier: z.string().min(3, "Please enter your email, phone, or username"),
  password: z.string().min(6, "Password must be at least 6 characters"),
  remember: z.boolean().optional(),
});

type LoginFormData = z.infer<typeof loginSchema>;

const Login = () => {
  const { t } = useLanguage();
  const navigate = useNavigate();
  const location = useLocation();
  const { login, isLoading } = useAuth();
  const turnstileRef = useRef<TurnstileWidgetRef>(null);
  const [turnstileToken, setTurnstileToken] = useState<string>("");
  const isTurnstileEnabled = import.meta.env.VITE_ENABLE_TURNSTILE === 'true';

  const from = location.state?.from?.pathname || "/";

  const {
    register,
    handleSubmit,
    formState: { errors },
    setValue,
    watch,
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      remember: false,
    },
  });

  const rememberMe = watch('remember');

  const handleTurnstileSuccess = (token: string) => {
    setTurnstileToken(token);
  };

  const handleTurnstileError = () => {
    setTurnstileToken("");
  };

  const onSubmit = async (data: LoginFormData) => {
    console.log('🔐 Login form submitted', { email: data.email });
    
    // Check Turnstile validation if enabled (skip in mock mode)
    const isMockMode = import.meta.env.VITE_MOCK_API === 'true';
    if (isTurnstileEnabled && !turnstileToken && !isMockMode) {
      console.warn('⚠️ Turnstile validation required but token missing');
      toast.error('⚠️ Please complete the security verification');
      return;
    }

    try {
      console.log('📡 Calling login API...');
      
      // Show loading toast
      const loadingToast = toast.loading('🔐 Signing in...');
      
      // Detect input type and login accordingly
      await login(data.identifier, data.password, data.remember);
      
      console.log('✅ Login successful! User is now authenticated.');
      
      // Dismiss loading toast
      toast.dismiss(loadingToast);
      
      // Show success with animation
      toast.success('✅ Welcome back!', {
        description: `Logged in as ${data.identifier}`,
        duration: 2000,
      });
      
      // Track successful login (detect type)
      const loginType = data.identifier.includes('@') ? 'email' : 
                       /^\+?[\d\s-]+$/.test(data.identifier) ? 'phone' : 'username';
      analytics.login(loginType);
      
      // Small delay for user to see success message
      setTimeout(() => {
        navigate(from, { replace: true });
      }, 500);
      
    } catch (error: any) {
      console.error('❌ Login failed:', error);
      toast.error('❌ Login failed', {
        description: error?.message || 'Please check your credentials and try again.',
        duration: 4000,
      });
      
      // Reset Turnstile on error
      if (isTurnstileEnabled) {
        turnstileRef.current?.reset();
        setTurnstileToken("");
      }
    }
  };
  
  return (
    <div className="min-h-screen flex flex-col relative">
      <Starfield />
      <Navbar />
      
      <main className="flex-1 relative z-10 flex items-center justify-center py-16">
        <div className="container mx-auto px-4">
          <div className="max-w-md mx-auto">
            <Card className="glass-card p-8">
              {/* Header */}
              <div className="text-center mb-8">
                <div className="inline-flex p-3 rounded-xl gradient-primary mb-4">
                  <Lock className="h-6 w-6 text-white" />
                </div>
                <h1 className="text-3xl font-black bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent mb-2">
                  {t('welcomeBack')}
                </h1>
                <p className="text-foreground/60">
                  {t('signInToAccount')}
                </p>
              </div>

              {/* Login Form */}
              <form 
                onSubmit={(e) => {
                  console.log('📋 Form onSubmit triggered');
                  handleSubmit(onSubmit)(e);
                }} 
                className="space-y-5"
              >
                {/* Email / Phone / Username */}
                <div className="space-y-2">
                  <Label htmlFor="identifier" className="text-foreground">
                    {t('emailPhoneOrUsername') || 'Email, Phone, or Username'} <span className="text-destructive">*</span>
                  </Label>
                  <div className="relative">
                    <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                    <Input
                      id="identifier"
                      type="text"
                      placeholder="your@email.com, +1234567890, or username"
                      className="pl-10 glass-card border-border/50 focus:border-primary/50"
                      {...register("identifier")}
                    />
                  </div>
                  {errors.identifier && (
                    <p className="text-sm text-destructive">{errors.identifier.message}</p>
                  )}
                </div>

                {/* Password */}
                <div className="space-y-2">
                  <Label htmlFor="password" className="text-foreground">
                    {t('password')} <span className="text-destructive">*</span>
                  </Label>
                  <div className="relative">
                    <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                    <Input
                      id="password"
                      type="password"
                      placeholder="••••••••"
                      className="pl-10 glass-card border-border/50 focus:border-primary/50"
                      {...register("password")}
                    />
                  </div>
                  {errors.password && (
                    <p className="text-sm text-destructive">{errors.password.message}</p>
                  )}
                </div>

                {/* Remember & Forgot */}
                <div className="flex items-center justify-between">
                  <div className="flex items-center space-x-2">
                    <Checkbox 
                      id="remember"
                      checked={rememberMe}
                      onCheckedChange={(checked) => setValue('remember', checked as boolean)}
                    />
                    <label
                      htmlFor="remember"
                      className="text-sm text-foreground/70 cursor-pointer"
                    >
                      {t('rememberMe')}
                    </label>
                  </div>
                  <Link
                    to="/forgot-password"
                    className="text-sm text-primary hover:text-primary/80 transition-colors"
                  >
                    {t('forgotPassword')}
                  </Link>
                </div>

                {/* Cloudflare Turnstile CAPTCHA */}
                <TurnstileWidget
                  ref={turnstileRef}
                  onSuccess={handleTurnstileSuccess}
                  onError={handleTurnstileError}
                  onExpire={handleTurnstileError}
                />

                {/* Submit Button */}
                <Button 
                  type="submit" 
                  className="w-full btn-glow" 
                  size="lg"
                  disabled={isLoading}
                  onClick={() => console.log('🖱️ Sign in button clicked')}
                >
                  {isLoading ? (
                    <>
                      <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                      Signing in...
                    </>
                  ) : (
                    <>
                      {t('signIn')}
                      <ArrowRight className="h-4 w-4 ml-2" />
                    </>
                  )}
                </Button>
              </form>

              {/* Divider */}
              <div className="relative my-6">
                <div className="absolute inset-0 flex items-center">
                  <div className="w-full border-t border-border/50" />
                </div>
                <div className="relative flex justify-center text-sm">
                  <span className="px-4 bg-card text-foreground/60">{t('orContinueWith')}</span>
                </div>
              </div>

              {/* Alternative Login */}
              <div className="space-y-3">
                <Button
                  type="button"
                  variant="outline"
                  className="w-full glass-card border-border/50 hover:border-primary/50"
                  size="lg"
                >
                  <Smartphone className="h-5 w-5 mr-2" />
                  {t('phoneNumber')}
                </Button>
              </div>

              {/* Sign Up Link */}
              <p className="text-center text-sm text-foreground/60 mt-6">
                {t('dontHaveAccount')}{" "}
                <Link
                  to="/register"
                  className="text-primary hover:text-primary/80 font-semibold transition-colors"
                >
                  {t('createAccount')}
                </Link>
              </p>
            </Card>
          </div>
        </div>
      </main>
      
      <Footer />
    </div>
  );
};

export default Login;
