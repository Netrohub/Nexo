import React, { useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import Navbar from '@/components/Navbar';
import Footer from '@/components/Footer';
import Starfield from '@/components/Starfield';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Textarea } from '@/components/ui/textarea';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Badge } from '@/components/ui/badge';
import { Progress } from '@/components/ui/progress';
import { 
  Shield, 
  CheckCircle, 
  AlertCircle, 
  Upload, 
  Camera, 
  FileText,
  CreditCard,
  MapPin,
  Phone,
  User,
  ArrowLeft,
  ArrowRight
} from 'lucide-react';
import { useLanguage } from '@/contexts/LanguageContext';
import { useAuth } from '@/contexts/AuthContext';
import { toast } from 'sonner';

const KYC = () => {
  const { t } = useLanguage();
  const { user } = useAuth();
  const { step } = useParams();
  const [currentStep, setCurrentStep] = useState(step || 'overview');
  const [formData, setFormData] = useState({
    identity: {
      firstName: '',
      lastName: '',
      dateOfBirth: '',
      nationality: '',
      idNumber: '',
    },
    address: {
      street: '',
      city: '',
      state: '',
      postalCode: '',
      country: '',
    },
    phone: {
      phoneNumber: '',
      countryCode: '+1',
    },
    documents: {
      idFront: null as File | null,
      idBack: null as File | null,
      selfie: null as File | null,
      proofOfAddress: null as File | null,
    },
    bankAccount: {
      accountHolderName: '',
      bankName: '',
      accountNumber: '',
      routingNumber: '',
      accountType: 'checking',
    },
  });

  const kycSteps = [
    { key: 'overview', title: t('kyc.overview'), icon: Shield },
    { key: 'identity', title: t('kyc.identityVerification'), icon: User },
    { key: 'address', title: t('kyc.addressVerification'), icon: MapPin },
    { key: 'phone', title: t('kyc.phoneVerification'), icon: Phone },
    { key: 'documents', title: t('kyc.documentUpload'), icon: FileText },
    { key: 'bankAccount', title: t('kyc.bankAccountVerification'), icon: CreditCard },
  ];

  const currentStepIndex = kycSteps.findIndex(s => s.key === currentStep);
  const progress = ((currentStepIndex + 1) / kycSteps.length) * 100;

  const handleInputChange = (section: string, field: string, value: string) => {
    setFormData(prev => ({
      ...prev,
      [section]: {
        ...prev[section as keyof typeof prev],
        [field]: value,
      },
    }));
  };

  const handleFileUpload = (field: string, file: File) => {
    setFormData(prev => ({
      ...prev,
      documents: {
        ...prev.documents,
        [field]: file,
      },
    }));
  };

  const handleSubmit = async (section: string) => {
    console.log(`📝 Submitting KYC ${section} step`);
    
    const loadingToast = toast.loading(`📤 Submitting ${section} verification...`);
    
    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      toast.dismiss(loadingToast);
      toast.success(`✅ ${section} verification submitted successfully!`);
      
      // Move to next step
      const nextStepIndex = currentStepIndex + 1;
      if (nextStepIndex < kycSteps.length) {
        setCurrentStep(kycSteps[nextStepIndex].key);
      }
      
    } catch (error) {
      toast.dismiss(loadingToast);
      toast.error(`❌ Failed to submit ${section} verification`);
    }
  };

  const renderStepContent = () => {
    switch (currentStep) {
      case 'overview':
        return (
          <div className="space-y-6">
            <div className="text-center">
              <div className="mx-auto w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mb-4">
                <Shield className="h-8 w-8 text-primary" />
              </div>
              <h2 className="text-2xl font-bold mb-2">{t('kyc.verificationOverview')}</h2>
              <p className="text-foreground/70">{t('kyc.verificationOverviewDescription')}</p>
            </div>

            <div className="grid gap-4">
              {kycSteps.slice(1).map((step, index) => (
                <Card key={step.key} className="glass-card">
                  <CardContent className="p-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
                        <step.icon className="h-5 w-5 text-primary" />
                      </div>
                      <div className="flex-1">
                        <h3 className="font-semibold">{step.title}</h3>
                        <p className="text-sm text-foreground/70">
                          {t(`kyc.${step.key}Description`)}
                        </p>
                      </div>
                      <Badge variant="secondary">Step {index + 1}</Badge>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>

            <div className="p-4 rounded-lg border border-primary/20 bg-primary/5">
              <h4 className="font-semibold text-primary mb-2">{t('kyc.verificationBenefits')}</h4>
              <ul className="text-sm text-foreground/70 space-y-1">
                <li>• {t('kyc.benefit1')}</li>
                <li>• {t('kyc.benefit2')}</li>
                <li>• {t('kyc.benefit3')}</li>
                <li>• {t('kyc.benefit4')}</li>
              </ul>
            </div>

            <Button 
              onClick={() => setCurrentStep('identity')}
              className="w-full btn-glow"
              size="lg"
            >
              {t('kyc.startVerification')}
              <ArrowRight className="h-4 w-4 ml-2" />
            </Button>
          </div>
        );

      case 'identity':
        return (
          <div className="space-y-6">
            <div className="text-center">
              <User className="h-12 w-12 text-primary mx-auto mb-4" />
              <h2 className="text-2xl font-bold mb-2">{t('kyc.identityVerification')}</h2>
              <p className="text-foreground/70">{t('kyc.identityDescription')}</p>
            </div>

            <div className="grid gap-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="firstName">{t('kyc.firstName')}</Label>
                  <Input
                    id="firstName"
                    value={formData.identity.firstName}
                    onChange={(e) => handleInputChange('identity', 'firstName', e.target.value)}
                    placeholder="John"
                  />
                </div>
                <div>
                  <Label htmlFor="lastName">{t('kyc.lastName')}</Label>
                  <Input
                    id="lastName"
                    value={formData.identity.lastName}
                    onChange={(e) => handleInputChange('identity', 'lastName', e.target.value)}
                    placeholder="Doe"
                  />
                </div>
              </div>

              <div>
                <Label htmlFor="dateOfBirth">{t('kyc.dateOfBirth')}</Label>
                <Input
                  id="dateOfBirth"
                  type="date"
                  value={formData.identity.dateOfBirth}
                  onChange={(e) => handleInputChange('identity', 'dateOfBirth', e.target.value)}
                />
              </div>

              <div>
                <Label htmlFor="nationality">{t('kyc.nationality')}</Label>
                <Input
                  id="nationality"
                  value={formData.identity.nationality}
                  onChange={(e) => handleInputChange('identity', 'nationality', e.target.value)}
                  placeholder="United States"
                />
              </div>

              <div>
                <Label htmlFor="idNumber">{t('kyc.idNumber')}</Label>
                <Input
                  id="idNumber"
                  value={formData.identity.idNumber}
                  onChange={(e) => handleInputChange('identity', 'idNumber', e.target.value)}
                  placeholder="123456789"
                />
              </div>
            </div>

            <div className="flex gap-3">
              <Button variant="outline" onClick={() => setCurrentStep('overview')}>
                <ArrowLeft className="h-4 w-4 mr-2" />
                {t('kyc.back')}
              </Button>
              <Button onClick={() => handleSubmit('identity')} className="btn-glow flex-1">
                {t('kyc.continue')}
                <ArrowRight className="h-4 w-4 ml-2" />
              </Button>
            </div>
          </div>
        );

      case 'address':
        return (
          <div className="space-y-6">
            <div className="text-center">
              <MapPin className="h-12 w-12 text-primary mx-auto mb-4" />
              <h2 className="text-2xl font-bold mb-2">{t('kyc.addressVerification')}</h2>
              <p className="text-foreground/70">{t('kyc.addressDescription')}</p>
            </div>

            <div className="grid gap-4">
              <div>
                <Label htmlFor="street">{t('kyc.streetAddress')}</Label>
                <Input
                  id="street"
                  value={formData.address.street}
                  onChange={(e) => handleInputChange('address', 'street', e.target.value)}
                  placeholder="123 Main Street"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="city">{t('kyc.city')}</Label>
                  <Input
                    id="city"
                    value={formData.address.city}
                    onChange={(e) => handleInputChange('address', 'city', e.target.value)}
                    placeholder="New York"
                  />
                </div>
                <div>
                  <Label htmlFor="state">{t('kyc.state')}</Label>
                  <Input
                    id="state"
                    value={formData.address.state}
                    onChange={(e) => handleInputChange('address', 'state', e.target.value)}
                    placeholder="NY"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="postalCode">{t('kyc.postalCode')}</Label>
                  <Input
                    id="postalCode"
                    value={formData.address.postalCode}
                    onChange={(e) => handleInputChange('address', 'postalCode', e.target.value)}
                    placeholder="10001"
                  />
                </div>
                <div>
                  <Label htmlFor="country">{t('kyc.country')}</Label>
                  <Input
                    id="country"
                    value={formData.address.country}
                    onChange={(e) => handleInputChange('address', 'country', e.target.value)}
                    placeholder="United States"
                  />
                </div>
              </div>
            </div>

            <div className="flex gap-3">
              <Button variant="outline" onClick={() => setCurrentStep('identity')}>
                <ArrowLeft className="h-4 w-4 mr-2" />
                {t('kyc.back')}
              </Button>
              <Button onClick={() => handleSubmit('address')} className="btn-glow flex-1">
                {t('kyc.continue')}
                <ArrowRight className="h-4 w-4 ml-2" />
              </Button>
            </div>
          </div>
        );

      case 'phone':
        return (
          <div className="space-y-6">
            <div className="text-center">
              <Phone className="h-12 w-12 text-primary mx-auto mb-4" />
              <h2 className="text-2xl font-bold mb-2">{t('kyc.phoneVerification')}</h2>
              <p className="text-foreground/70">{t('kyc.phoneDescription')}</p>
            </div>

            <div className="grid gap-4">
              <div>
                <Label htmlFor="phoneNumber">{t('kyc.phoneNumber')}</Label>
                <div className="flex gap-2">
                  <Input
                    value={formData.phone.countryCode}
                    onChange={(e) => handleInputChange('phone', 'countryCode', e.target.value)}
                    className="w-20"
                    placeholder="+1"
                  />
                  <Input
                    id="phoneNumber"
                    value={formData.phone.phoneNumber}
                    onChange={(e) => handleInputChange('phone', 'phoneNumber', e.target.value)}
                    placeholder="(555) 123-4567"
                    className="flex-1"
                  />
                </div>
              </div>
            </div>

            <div className="p-4 rounded-lg border border-blue-500/20 bg-blue-500/5">
              <div className="flex items-start gap-3">
                <AlertCircle className="h-5 w-5 text-blue-500 mt-0.5" />
                <div>
                  <h4 className="font-semibold text-blue-500 mb-1">{t('kyc.phoneVerificationNote')}</h4>
                  <p className="text-sm text-blue-500/80">{t('kyc.phoneVerificationNoteDescription')}</p>
                </div>
              </div>
            </div>

            <div className="flex gap-3">
              <Button variant="outline" onClick={() => setCurrentStep('address')}>
                <ArrowLeft className="h-4 w-4 mr-2" />
                {t('kyc.back')}
              </Button>
              <Button onClick={() => handleSubmit('phone')} className="btn-glow flex-1">
                {t('kyc.sendVerificationCode')}
                <ArrowRight className="h-4 w-4 ml-2" />
              </Button>
            </div>
          </div>
        );

      case 'documents':
        return (
          <div className="space-y-6">
            <div className="text-center">
              <FileText className="h-12 w-12 text-primary mx-auto mb-4" />
              <h2 className="text-2xl font-bold mb-2">{t('kyc.documentUpload')}</h2>
              <p className="text-foreground/70">{t('kyc.documentDescription')}</p>
            </div>

            <div className="grid gap-6">
              {[
                { key: 'idFront', label: t('kyc.idFront'), description: t('kyc.idFrontDescription') },
                { key: 'idBack', label: t('kyc.idBack'), description: t('kyc.idBackDescription') },
                { key: 'selfie', label: t('kyc.selfie'), description: t('kyc.selfieDescription') },
                { key: 'proofOfAddress', label: t('kyc.proofOfAddress'), description: t('kyc.proofOfAddressDescription') },
              ].map((doc) => (
                <Card key={doc.key} className="glass-card">
                  <CardContent className="p-4">
                    <div className="space-y-3">
                      <div>
                        <h4 className="font-semibold">{doc.label}</h4>
                        <p className="text-sm text-foreground/70">{doc.description}</p>
                      </div>
                      
                      <div className="border-2 border-dashed border-border rounded-lg p-6 text-center">
                        {formData.documents[doc.key as keyof typeof formData.documents] ? (
                          <div className="space-y-2">
                            <CheckCircle className="h-8 w-8 text-green-500 mx-auto" />
                            <p className="text-sm text-green-500 font-medium">File uploaded</p>
                            <p className="text-xs text-foreground/60">
                              {formData.documents[doc.key as keyof typeof formData.documents]?.name}
                            </p>
                          </div>
                        ) : (
                          <div className="space-y-2">
                            <Upload className="h-8 w-8 text-foreground/40 mx-auto" />
                            <p className="text-sm text-foreground/70">Click to upload or drag and drop</p>
                            <p className="text-xs text-foreground/50">PNG, JPG, PDF up to 10MB</p>
                          </div>
                        )}
                      </div>
                      
                      <Button 
                        variant="outline" 
                        className="w-full"
                        onClick={() => {
                          const input = document.createElement('input');
                          input.type = 'file';
                          input.accept = 'image/*,.pdf';
                          input.onchange = (e) => {
                            const file = (e.target as HTMLInputElement).files?.[0];
                            if (file) handleFileUpload(doc.key, file);
                          };
                          input.click();
                        }}
                      >
                        <Upload className="h-4 w-4 mr-2" />
                        {formData.documents[doc.key as keyof typeof formData.documents] ? 'Change File' : 'Upload File'}
                      </Button>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>

            <div className="flex gap-3">
              <Button variant="outline" onClick={() => setCurrentStep('phone')}>
                <ArrowLeft className="h-4 w-4 mr-2" />
                {t('kyc.back')}
              </Button>
              <Button onClick={() => handleSubmit('documents')} className="btn-glow flex-1">
                {t('kyc.continue')}
                <ArrowRight className="h-4 w-4 ml-2" />
              </Button>
            </div>
          </div>
        );

      case 'bankAccount':
        return (
          <div className="space-y-6">
            <div className="text-center">
              <CreditCard className="h-12 w-12 text-primary mx-auto mb-4" />
              <h2 className="text-2xl font-bold mb-2">{t('kyc.bankAccountVerification')}</h2>
              <p className="text-foreground/70">{t('kyc.bankAccountDescription')}</p>
            </div>

            <div className="grid gap-4">
              <div>
                <Label htmlFor="accountHolderName">{t('kyc.accountHolderName')}</Label>
                <Input
                  id="accountHolderName"
                  value={formData.bankAccount.accountHolderName}
                  onChange={(e) => handleInputChange('bankAccount', 'accountHolderName', e.target.value)}
                  placeholder="John Doe"
                />
              </div>

              <div>
                <Label htmlFor="bankName">{t('kyc.bankName')}</Label>
                <Input
                  id="bankName"
                  value={formData.bankAccount.bankName}
                  onChange={(e) => handleInputChange('bankAccount', 'bankName', e.target.value)}
                  placeholder="Chase Bank"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label htmlFor="accountNumber">{t('kyc.accountNumber')}</Label>
                  <Input
                    id="accountNumber"
                    type="password"
                    value={formData.bankAccount.accountNumber}
                    onChange={(e) => handleInputChange('bankAccount', 'accountNumber', e.target.value)}
                    placeholder="****1234"
                  />
                </div>
                <div>
                  <Label htmlFor="routingNumber">{t('kyc.routingNumber')}</Label>
                  <Input
                    id="routingNumber"
                    value={formData.bankAccount.routingNumber}
                    onChange={(e) => handleInputChange('bankAccount', 'routingNumber', e.target.value)}
                    placeholder="021000021"
                  />
                </div>
              </div>

              <div>
                <Label htmlFor="accountType">{t('kyc.accountType')}</Label>
                <select
                  id="accountType"
                  value={formData.bankAccount.accountType}
                  onChange={(e) => handleInputChange('bankAccount', 'accountType', e.target.value)}
                  className="w-full px-3 py-2 border border-border rounded-md bg-background"
                >
                  <option value="checking">Checking</option>
                  <option value="savings">Savings</option>
                </select>
              </div>
            </div>

            <div className="p-4 rounded-lg border border-green-500/20 bg-green-500/5">
              <div className="flex items-start gap-3">
                <CheckCircle className="h-5 w-5 text-green-500 mt-0.5" />
                <div>
                  <h4 className="font-semibold text-green-500 mb-1">{t('kyc.bankAccountSecurity')}</h4>
                  <p className="text-sm text-green-500/80">{t('kyc.bankAccountSecurityDescription')}</p>
                </div>
              </div>
            </div>

            <div className="flex gap-3">
              <Button variant="outline" onClick={() => setCurrentStep('documents')}>
                <ArrowLeft className="h-4 w-4 mr-2" />
                {t('kyc.back')}
              </Button>
              <Button onClick={() => handleSubmit('bankAccount')} className="btn-glow flex-1">
                {t('kyc.completeVerification')}
                <CheckCircle className="h-4 w-4 ml-2" />
              </Button>
            </div>
          </div>
        );

      default:
        return <div>Step not found</div>;
    }
  };

  return (
    <div className="min-h-screen flex flex-col relative">
      <Starfield />
      <Navbar />
      
      <main className="flex-1 relative z-10">
        <div className="container mx-auto px-4 py-8">
          <div className="max-w-4xl mx-auto">
            {/* Progress Header */}
            <div className="mb-8">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-3">
                  <Shield className="h-6 w-6 text-primary" />
                  <h1 className="text-2xl font-bold">{t('kyc.verification')}</h1>
                </div>
                <Badge variant="secondary">Step {currentStepIndex + 1} of {kycSteps.length}</Badge>
              </div>
              
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span>{kycSteps[currentStepIndex]?.title}</span>
                  <span>{Math.round(progress)}%</span>
                </div>
                <Progress value={progress} className="h-2" />
              </div>
            </div>

            {/* Step Content */}
            <Card className="glass-card">
              <CardContent className="p-8">
                {renderStepContent()}
              </CardContent>
            </Card>
          </div>
        </div>
      </main>
      
      <Footer />
    </div>
  );
};

export default KYC;