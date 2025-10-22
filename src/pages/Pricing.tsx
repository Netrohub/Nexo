import { useState } from "react";
import { useNavigate } from "react-router-dom";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import Starfield from "@/components/Starfield";
import { Button } from "@/components/ui/button";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { Check, Zap, Crown, Sparkles } from "lucide-react";
import { useLanguage } from "@/contexts/LanguageContext";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";

const plans = [
  {
    name: "Free",
    price: "$0",
    period: "forever",
    description: "Perfect for getting started",
    features: [
      "List up to 3 products",
      "5% transaction fee",
      "Basic seller profile",
      "Community support",
      "Standard verification",
    ],
    notIncluded: [
      "Featured listings",
      "Priority support",
      "Advanced analytics",
      "Custom branding",
    ],
    icon: Sparkles,
    color: "from-gray-500 to-gray-700",
    popular: false,
  },
  {
    name: "Pro",
    price: "$29",
    period: "per month",
    description: "For serious sellers",
    features: [
      "Unlimited product listings",
      "3% transaction fee",
      "Enhanced seller profile",
      "Priority support",
      "Fast-track verification",
      "Featured listings (5/month)",
      "Advanced analytics",
      "Custom profile banner",
    ],
    notIncluded: [
      "Dedicated account manager",
      "API access",
    ],
    icon: Zap,
    color: "from-primary to-accent",
    popular: true,
  },
  {
    name: "Elite",
    price: "$99",
    period: "per month",
    description: "For top-tier sellers",
    features: [
      "Everything in Pro",
      "1.5% transaction fee",
      "Verified badge",
      "Dedicated account manager",
      "Unlimited featured listings",
      "API access",
      "Custom branding",
      "Early access to features",
      "Premium support (24/7)",
      "Promoted in leaderboard",
    ],
    notIncluded: [],
    icon: Crown,
    color: "from-yellow-500 to-orange-600",
    popular: false,
  },
];

const Pricing = () => {
  const { t } = useLanguage();
  const navigate = useNavigate();
  const { toast } = useToast();
  const { user, isAuthenticated } = useAuth();
  const [upgradeDialogOpen, setUpgradeDialogOpen] = useState(false);
  const [selectedPlan, setSelectedPlan] = useState<typeof plans[0] | null>(null);
  const [currentPlan] = useState("Pro"); // Mock current plan

  // Calculate prorated upgrade cost
  const calculateUpgradeCost = (newPlan: string) => {
    const planPrices: Record<string, number> = { Free: 0, Pro: 29, Elite: 99 };
    const currentPrice = planPrices[currentPlan] || 0;
    const newPrice = planPrices[newPlan] || 0;
    
    // Days remaining in current billing cycle (mock: 15 days out of 30)
    const daysRemaining = 15;
    const daysInMonth = 30;
    
    // Calculate prorated credit from current plan
    const proratedCredit = (currentPrice / daysInMonth) * daysRemaining;
    
    // Calculate cost for new plan for remaining days
    const proratedNewCost = (newPrice / daysInMonth) * daysRemaining;
    
    // Final cost is difference
    const upgradeCost = Math.max(0, proratedNewCost - proratedCredit);
    
    return {
      upgradeCost: upgradeCost.toFixed(2),
      daysRemaining,
      proratedCredit: proratedCredit.toFixed(2),
      newMonthlyPrice: newPrice,
    };
  };

  const handleUpgradeClick = (plan: typeof plans[0]) => {
    if (!isAuthenticated) {
      toast({
        title: "Login required",
        description: "Please login to upgrade your plan.",
      });
      navigate('/login');
      return;
    }

    if (plan.name === currentPlan) {
      toast({
        title: "Current plan",
        description: "You're already on this plan!",
      });
      return;
    }

    setSelectedPlan(plan);
    setUpgradeDialogOpen(true);
  };

  const handleConfirmUpgrade = async () => {
    if (!selectedPlan) return;

    try {
      toast({
        title: "Processing upgrade...",
        description: "Please wait while we process your upgrade.",
      });

      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));

      toast({
        title: "Plan upgraded! 🎉",
        description: `You're now on the ${selectedPlan.name} plan!`,
      });

      setUpgradeDialogOpen(false);
      setSelectedPlan(null);
    } catch (error) {
      toast({
        title: "Upgrade failed",
        description: "Failed to upgrade plan. Please try again.",
        variant: "destructive",
      });
    }
  };
  
  return (
    <div className="min-h-screen flex flex-col relative">
      <Starfield />
      <Navbar />
      
      <main className="flex-1 relative z-10">
        {/* Hero Section */}
        <section className="relative py-16 md:py-24 overflow-hidden border-b border-border/30">
          <div className="absolute inset-0 gradient-nebula opacity-60" />
          <div className="absolute top-1/4 left-1/3 w-96 h-96 bg-accent/20 rounded-full blur-[120px]" />
          
          <div className="container mx-auto px-4 relative z-10">
            <div className="text-center space-y-4 max-w-3xl mx-auto">
              <Badge className="badge-glow border-0 mb-4">
                Seller Plans
              </Badge>
              
              <h1 className="text-4xl md:text-6xl font-black bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">
                Start Selling Today
              </h1>
              <p className="text-lg text-foreground/60">
                Choose the perfect plan for your business. Upgrade or downgrade anytime.
              </p>
            </div>
          </div>
        </section>

        {/* Pricing Cards */}
        <section className="py-16">
          <div className="container mx-auto px-4">
            <div className="grid md:grid-cols-3 gap-8 max-w-7xl mx-auto">
              {plans.map((plan) => {
                const Icon = plan.icon;
                return (
                  <Card
                    key={plan.name}
                    className={`glass-card relative overflow-hidden ${
                      plan.popular ? "border-primary/50 shadow-2xl scale-105" : ""
                    }`}
                  >
                    {plan.popular && (
                      <div className="absolute top-0 right-0 bg-gradient-primary text-primary-foreground text-xs font-bold px-4 py-1 rounded-bl-lg">
                        MOST POPULAR
                      </div>
                    )}

                    <div className="p-8 space-y-6">
                      {/* Icon and Name */}
                      <div className="space-y-4">
                        <div className={`inline-flex p-3 rounded-xl bg-gradient-to-br ${plan.color}`}>
                          <Icon className="h-6 w-6 text-white" />
                        </div>
                        <div>
                          <h3 className="text-2xl font-black text-foreground mb-1">
                            {plan.name}
                          </h3>
                          <p className="text-sm text-foreground/60">{plan.description}</p>
                        </div>
                      </div>

                      {/* Price */}
                      <div className="space-y-1">
                        <div className="flex items-baseline gap-2">
                          <span className="text-5xl font-black bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">
                            {plan.price}
                          </span>
                          <span className="text-foreground/60">/{plan.period}</span>
                        </div>
                      </div>

                      {/* CTA Button */}
                      <Button
                        className={`w-full ${
                          plan.popular ? "btn-glow" : "glass-card border-primary/30"
                        }`}
                        size="lg"
                        variant={plan.popular ? "default" : "outline"}
                        onClick={() => handleUpgradeClick(plan)}
                      >
                        {plan.name === currentPlan ? "Current Plan" : plan.name === "Free" ? "Get Started" : "Upgrade Now"}
                      </Button>

                      {/* Features */}
                      <div className="space-y-3 pt-4 border-t border-border/30">
                        <p className="text-sm font-semibold text-foreground/80">
                          What's included:
                        </p>
                        <ul className="space-y-3">
                          {plan.features.map((feature) => (
                            <li key={feature} className="flex items-start gap-3 text-sm">
                              <Check className="h-5 w-5 text-primary flex-shrink-0 mt-0.5" />
                              <span className="text-foreground/70">{feature}</span>
                            </li>
                          ))}
                          {plan.notIncluded.map((feature) => (
                            <li key={feature} className="flex items-start gap-3 text-sm opacity-50">
                              <div className="h-5 w-5 flex-shrink-0 mt-0.5 flex items-center justify-center">
                                <div className="h-3 w-0.5 bg-foreground/30 rotate-45" />
                              </div>
                              <span className="text-foreground/50 line-through">{feature}</span>
                            </li>
                          ))}
                        </ul>
                      </div>
                    </div>
                  </Card>
                );
              })}
            </div>

            {/* FAQ Section */}
            <div className="mt-20 max-w-3xl mx-auto">
              <h2 className="text-3xl font-black text-center mb-12 bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">
                Frequently Asked Questions
              </h2>
              <div className="space-y-4">
                <Card className="glass-card p-6">
                  <h3 className="font-bold text-lg mb-2 text-foreground">
                    Can I change plans anytime?
                  </h3>
                  <p className="text-foreground/60">
                    Yes! You can upgrade or downgrade your plan at any time. Changes take effect immediately.
                  </p>
                </Card>
                <Card className="glass-card p-6">
                  <h3 className="font-bold text-lg mb-2 text-foreground">
                    What payment methods do you accept?
                  </h3>
                  <p className="text-foreground/60">
                    We accept all major credit cards, PayPal, and cryptocurrency payments.
                  </p>
                </Card>
                <Card className="glass-card p-6">
                  <h3 className="font-bold text-lg mb-2 text-foreground">
                    Is there a refund policy?
                  </h3>
                  <p className="text-foreground/60">
                    Yes, we offer a 30-day money-back guarantee if you're not satisfied with your plan.
                  </p>
                </Card>
              </div>
            </div>
          </div>
        </section>
      </main>
      
      <Footer />

      {/* Upgrade Confirmation Dialog */}
      <Dialog open={upgradeDialogOpen} onOpenChange={setUpgradeDialogOpen}>
        <DialogContent className="glass-card border-border/50">
          <DialogHeader>
            <DialogTitle>Upgrade to {selectedPlan?.name} Plan</DialogTitle>
            <DialogDescription>
              Review your upgrade details and confirm
            </DialogDescription>
          </DialogHeader>
          {selectedPlan && (() => {
            const costs = calculateUpgradeCost(selectedPlan.name);
            return (
              <div className="space-y-4 py-4">
                <div className="space-y-2 p-4 rounded-lg bg-primary/5 border border-primary/20">
                  <div className="flex justify-between text-sm">
                    <span className="text-foreground/70">Current Plan:</span>
                    <span className="font-semibold">{currentPlan}</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-foreground/70">New Plan:</span>
                    <span className="font-semibold text-primary">{selectedPlan.name}</span>
                  </div>
                  <div className="border-t border-border/30 my-2 pt-2">
                    <div className="flex justify-between text-sm">
                      <span className="text-foreground/70">Days Remaining:</span>
                      <span className="font-semibold">{costs.daysRemaining} days</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-foreground/70">Prorated Credit:</span>
                      <span className="font-semibold text-green-500">-${costs.proratedCredit}</span>
                    </div>
                    <div className="flex justify-between text-sm font-bold mt-2">
                      <span>Due Today:</span>
                      <span className="text-lg bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">
                        ${costs.upgradeCost}
                      </span>
                    </div>
                    <div className="flex justify-between text-xs text-foreground/50 mt-1">
                      <span>Starting next month:</span>
                      <span>${costs.newMonthlyPrice}/month</span>
                    </div>
                  </div>
                </div>
                <p className="text-sm text-foreground/60">
                  You'll be charged the prorated amount for the remaining {costs.daysRemaining} days of this billing cycle.
                  Starting next month, you'll be charged ${costs.newMonthlyPrice}/month.
                </p>
              </div>
            );
          })()}
          <DialogFooter>
            <Button variant="outline" onClick={() => setUpgradeDialogOpen(false)}>
              Cancel
            </Button>
            <Button className="btn-glow" onClick={handleConfirmUpgrade}>
              Confirm Upgrade
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};

export default Pricing;
