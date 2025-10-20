import AccountLayout from "@/components/AccountLayout";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Link } from "react-router-dom";
import { 
  TrendingUp, 
  ShoppingBag, 
  DollarSign, 
  Star,
  ArrowRight,
  Package,
  Clock
} from "lucide-react";

const stats = [
  {
    label: "Total Orders",
    value: "24",
    change: "+12%",
    icon: ShoppingBag,
    color: "from-blue-500 to-blue-700",
  },
  {
    label: "Wallet Balance",
    value: "$1,249.50",
    change: "+8%",
    icon: DollarSign,
    color: "from-primary to-accent",
  },
  {
    label: "Active Listings",
    value: "8",
    change: "+3",
    icon: Package,
    color: "from-green-500 to-emerald-600",
  },
  {
    label: "Rating",
    value: "4.8",
    change: "★★★★★",
    icon: Star,
    color: "from-yellow-500 to-orange-600",
  },
];

const recentOrders = [
  {
    id: "ORD-001",
    product: "Steam Account - 200+ Games",
    status: "completed",
    amount: 449.99,
    date: "2024-01-20",
  },
  {
    id: "ORD-002",
    product: "Instagram Account - 50K",
    status: "pending",
    amount: 299.99,
    date: "2024-01-19",
  },
  {
    id: "ORD-003",
    product: "PlayStation Plus Premium",
    status: "completed",
    amount: 349.99,
    date: "2024-01-18",
  },
];

const Dashboard = () => {
  return (
    <AccountLayout>
      <div className="space-y-6">
        {/* Header */}
        <div>
          <h1 className="text-3xl font-black bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent mb-2">
            Dashboard
          </h1>
          <p className="text-foreground/60">Welcome back! Here's your account overview</p>
        </div>

        {/* Stats Grid */}
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-4">
          {stats.map((stat) => {
            const Icon = stat.icon;
            return (
              <Card key={stat.label} className="glass-card p-6 relative overflow-hidden group hover:scale-105 transition-all">
                <div className={`absolute top-0 right-0 w-24 h-24 bg-gradient-to-br ${stat.color} opacity-10 rounded-full blur-2xl`} />
                <div className="relative">
                  <div className="flex items-center justify-between mb-3">
                    <div className={`p-2 rounded-lg bg-gradient-to-br ${stat.color}`}>
                      <Icon className="h-5 w-5 text-white" />
                    </div>
                    <Badge variant="secondary" className="bg-primary/10 text-primary border-primary/20 text-xs">
                      {stat.change}
                    </Badge>
                  </div>
                  <p className="text-2xl font-black text-foreground mb-1">{stat.value}</p>
                  <p className="text-sm text-foreground/60">{stat.label}</p>
                </div>
              </Card>
            );
          })}
        </div>

        {/* Quick Actions */}
        <Card className="glass-card p-6">
          <h2 className="text-xl font-bold text-foreground mb-4">Quick Actions</h2>
          <div className="grid md:grid-cols-4 gap-3">
            <Button asChild className="btn-glow justify-start">
              <Link to="/products">
                <ShoppingBag className="h-4 w-4 mr-2" />
                Browse Products
              </Link>
            </Button>
            <Button asChild variant="outline" className="glass-card border-border/50 justify-start">
              <Link to="/seller/products">
                <Package className="h-4 w-4 mr-2" />
                List Product
              </Link>
            </Button>
            <Button asChild variant="outline" className="glass-card border-border/50 justify-start">
              <Link to="/account/wallet">
                <DollarSign className="h-4 w-4 mr-2" />
                Add Funds
              </Link>
            </Button>
            <Button asChild variant="outline" className="glass-card border-border/50 justify-start">
              <Link to="/seller/dashboard">
                <TrendingUp className="h-4 w-4 mr-2" />
                View Analytics
              </Link>
            </Button>
          </div>
        </Card>

        {/* Recent Orders */}
        <Card className="glass-card p-6">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-xl font-bold text-foreground">Recent Orders</h2>
            <Button asChild variant="ghost" size="sm" className="text-primary hover:text-primary/80">
              <Link to="/account/orders">
                View All
                <ArrowRight className="h-4 w-4 ml-2" />
              </Link>
            </Button>
          </div>

          <div className="space-y-3">
            {recentOrders.map((order) => (
              <div
                key={order.id}
                className="flex items-center justify-between p-4 rounded-lg glass-card border border-border/30 hover:border-border/50 transition-colors"
              >
                <div className="flex items-center gap-4">
                  <div className="p-2 rounded-lg bg-primary/10 border border-primary/20">
                    <ShoppingBag className="h-5 w-5 text-primary" />
                  </div>
                  <div>
                    <p className="font-semibold text-foreground">{order.product}</p>
                    <p className="text-sm text-foreground/60">Order #{order.id} • {order.date}</p>
                  </div>
                </div>

                <div className="flex items-center gap-4">
                  <Badge
                    variant="secondary"
                    className={
                      order.status === "completed"
                        ? "bg-primary/10 text-primary border-primary/20"
                        : "bg-yellow-500/10 text-yellow-500 border-yellow-500/20"
                    }
                  >
                    {order.status === "completed" ? "Completed" : "Pending"}
                  </Badge>
                  <p className="text-lg font-bold bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">
                    ${order.amount.toFixed(2)}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </Card>

        {/* Account Status */}
        <Card className="glass-card p-6 border border-primary/30">
          <div className="flex items-start gap-4">
            <div className="p-3 rounded-xl bg-primary/10 border border-primary/20">
              <Star className="h-6 w-6 text-primary" />
            </div>
            <div className="flex-1">
              <h3 className="text-lg font-bold text-foreground mb-2">Upgrade to Pro</h3>
              <p className="text-foreground/60 mb-4">
                Get access to premium features, lower fees, and priority support.
              </p>
              <Button asChild className="btn-glow">
                <Link to="/pricing">
                  Upgrade Now
                  <ArrowRight className="h-4 w-4 ml-2" />
                </Link>
              </Button>
            </div>
          </div>
        </Card>
      </div>
    </AccountLayout>
  );
};

export default Dashboard;
