import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import AccountLayout from '@/components/AccountLayout';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { 
  Shield, 
  CheckCircle, 
  Mail,
  Phone,
  User,
  ArrowLeft,
  ArrowRight,
  ExternalLink
} from 'lucide-react';
import { useLanguage } from '@/contexts/LanguageContext';
import { useAuth } from '@/contexts/AuthContext';
import { toast } from 'sonner';

const KYC = () => {
  const { t } = useLanguage();
  const { user } = useAuth();
  const [currentStep, setCurrentStep] = useState(1);
  const [verificationStatus, setVerificationStatus] = useState({
    email: user?.emailVerified || false,
    phone: user?.phoneVerified || false,
    identity: user?.kycStatus === 'verified',
  });

  const steps = [
    {
      id: 1,
      title: t('kyc.emailVerification'),
      description: t('kyc.emailDescription'),
      icon: Mail,
      status: verificationStatus.email,
    },
    {
      id: 2,
      title: t('kyc.phoneVerification'),
      description: t('kyc.phoneDescription'),
      icon: Phone,
      status: verificationStatus.phone,
    },
    {
      id: 3,
      title: t('kyc.identityVerification'),
      description: t('kyc.identityDescription'),
      icon: User,
      status: verificationStatus.identity,
    },
  ];

  const getProgressPercentage = () => {
    return (currentStep / steps.length) * 100;
  };

  const handleEmailVerification = async () => {
    try {
      toast.loading(t('kyc.sendingEmail'));
      
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      setVerificationStatus(prev => ({ ...prev, email: true }));
      toast.success(t('kyc.emailSent'));
    } catch (error) {
      toast.error(t('kyc.emailVerificationFailed'));
    }
  };

  const handlePhoneVerification = async () => {
    try {
      toast.loading(t('kyc.sendingCode'));
      
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      setVerificationStatus(prev => ({ ...prev, phone: true }));
      toast.success(t('kyc.phoneVerified'));
    } catch (error) {
      toast.error(t('kyc.phoneVerificationFailed'));
    }
  };

  const handleIdentityVerification = async () => {
    try {
      toast.loading(t('kyc.submittingVerification'));
      
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 3000));
      
      setVerificationStatus(prev => ({ ...prev, identity: true }));
      toast.success(t('kyc.verificationSubmitted'));
    } catch (error) {
      toast.error(t('kyc.verificationFailed'));
    }
  };

  const renderStepContent = () => {
    const currentStepData = steps.find(step => step.id === currentStep);
    
    return (
      <div className="space-y-6">
        <div className="text-center">
          <div className="w-20 h-20 mx-auto mb-6 rounded-full bg-primary/10 flex items-center justify-center">
            {currentStepData?.icon && <currentStepData.icon className="h-10 w-10 text-primary" />}
          </div>
          <h2 className="text-2xl font-bold text-foreground mb-4">
            {currentStepData?.title}
          </h2>
          <p className="text-foreground/60 mb-8">
            {currentStepData?.description}
          </p>
        </div>

        <Card className="glass-card p-6">
          <div className="space-y-4">
            {currentStep === 1 && (
              <div className="space-y-4">
                <div className="text-center">
                  <p className="text-sm text-foreground/60 mb-4">
                    We'll send a verification link to your email address
                  </p>
                  <div className="p-4 bg-primary/5 rounded-lg border border-primary/20">
                    <p className="font-medium">{user?.email}</p>
                  </div>
                </div>
                
                {!verificationStatus.email ? (
                  <Button onClick={handleEmailVerification} className="w-full btn-glow">
                    <Mail className="h-4 w-4 mr-2" />
                    Send Verification Email
                  </Button>
                ) : (
                  <div className="flex items-center justify-center gap-2 text-green-400">
                    <CheckCircle className="h-5 w-5" />
                    <span>Email Verified</span>
                  </div>
                )}
              </div>
            )}

            {currentStep === 2 && (
              <div className="space-y-4">
                <div className="text-center">
                  <p className="text-sm text-foreground/60 mb-4">
                    We'll send a verification code to your phone number
                  </p>
                  <div className="p-4 bg-primary/5 rounded-lg border border-primary/20">
                    <p className="font-medium">{user?.phone || '+1 (555) 123-4567'}</p>
                  </div>
                </div>
                
                {!verificationStatus.phone ? (
                  <Button onClick={handlePhoneVerification} className="w-full btn-glow">
                    <Phone className="h-4 w-4 mr-2" />
                    Send Verification Code
                  </Button>
                ) : (
                  <div className="flex items-center justify-center gap-2 text-green-400">
                    <CheckCircle className="h-5 w-5" />
                    <span>Phone Verified</span>
                  </div>
                )}
              </div>
            )}

            {currentStep === 3 && (
              <div className="space-y-4">
                <div className="text-center">
                  <p className="text-sm text-foreground/60 mb-4">
                    Verify your identity with government ID and selfie
                  </p>
                </div>
                
                {!verificationStatus.identity ? (
                  <Button onClick={handleIdentityVerification} className="w-full btn-glow">
                    <Shield className="h-4 w-4 mr-2" />
                    Start Identity Verification
                    <ExternalLink className="h-4 w-4 ml-2" />
                  </Button>
                ) : (
                  <div className="flex items-center justify-center gap-2 text-green-400">
                    <CheckCircle className="h-5 w-5" />
                    <span>Identity Verified</span>
                  </div>
                )}
              </div>
            )}
          </div>
        </Card>

        {/* Navigation */}
        <div className="flex gap-3">
          {currentStep > 1 && (
            <Button 
              variant="outline" 
              onClick={() => setCurrentStep(currentStep - 1)}
              className="flex-1"
            >
              <ArrowLeft className="h-4 w-4 mr-2" />
              Back
            </Button>
          )}
          
          {currentStep < 3 && (
            <Button 
              onClick={() => setCurrentStep(currentStep + 1)}
              className="flex-1 btn-glow"
              disabled={currentStep === 1 && !verificationStatus.email}
            >
              Next
              <ArrowRight className="h-4 w-4 ml-2" />
            </Button>
          )}
        </div>

        {/* Benefits */}
        <Card className="glass-card p-6 border-primary/30">
          <h3 className="font-semibold text-primary mb-4">Why do we need this?</h3>
          <ul className="space-y-2 text-sm text-foreground/60">
            <li>• Protect buyers and sellers from fraud</li>
            <li>• Comply with legal and regulatory requirements</li>
            <li>• Ensure secure transactions on the platform</li>
            <li>• Build trust in the NXOLand community</li>
          </ul>
        </Card>
      </div>
    );
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

        {/* Progress */}
        <div className="space-y-4">
          <div className="flex items-center justify-between">
            <span className="text-sm font-medium">Progress</span>
            <span className="text-sm text-foreground/60">
              {Math.round(getProgressPercentage())}%
            </span>
          </div>
          <Progress value={getProgressPercentage()} className="h-2" />
        </div>

        {/* Steps Overview */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          {steps.map((step) => (
            <Card 
              key={step.id} 
              className={`glass-card p-4 ${
                currentStep === step.id ? 'border-primary/50 bg-primary/5' : ''
              }`}
            >
              <div className="flex items-center gap-3">
                <div className={`w-8 h-8 rounded-full flex items-center justify-center ${
                  step.status ? 'bg-green-500/20 text-green-400' : 
                  currentStep === step.id ? 'bg-primary/20 text-primary' : 
                  'bg-foreground/10 text-foreground/40'
                }`}>
                  {step.status ? (
                    <CheckCircle className="h-4 w-4" />
                  ) : (
                    <step.icon className="h-4 w-4" />
                  )}
                </div>
                <div className="flex-1">
                  <h3 className="font-semibold text-sm">{step.title}</h3>
                  <p className="text-xs text-foreground/60">{step.description}</p>
                </div>
              </div>
            </Card>
          ))}
        </div>

        {/* Current Step Content */}
        <Card className="glass-card p-8">
          {renderStepContent()}
        </Card>
      </div>
    </AccountLayout>
  );
};

export default KYC;