import AccountLayout from "@/components/AccountLayout";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { 
  User, 
  Mail, 
  Phone, 
  MapPin,
  Upload,
  Save
} from "lucide-react";
import { useState, useRef } from "react";

const Profile = () => {
  const [avatar, setAvatar] = useState<string>("https://api.dicebear.com/7.x/avataaars/svg?seed=user");
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleAvatarUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    if (file.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onload = (e) => {
        if (e.target?.result) {
          setAvatar(e.target.result as string);
        }
      };
      reader.readAsDataURL(file);
    }
  };

  return (
    <AccountLayout>
      <div className="space-y-6">
        {/* Header */}
        <div>
          <h1 className="text-3xl font-black bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent mb-2">
            Profile Settings
          </h1>
          <p className="text-foreground/60">Manage your account information</p>
        </div>

        {/* Profile Picture */}
        <Card className="glass-card p-6">
          <h2 className="text-xl font-bold text-foreground mb-6">Profile Picture</h2>
          <div className="flex items-center gap-6">
            <Avatar className="h-24 w-24 border-2 border-primary/30">
              <AvatarImage src={avatar} />
              <AvatarFallback>UN</AvatarFallback>
            </Avatar>
            <div className="space-y-2">
              <Button 
                variant="outline" 
                className="glass-card border-border/50"
                onClick={() => fileInputRef.current?.click()}
              >
                <Upload className="h-4 w-4 mr-2" />
                Upload New Photo
              </Button>
              <p className="text-sm text-foreground/60">
                JPG, PNG or GIF. Max size 2MB.
              </p>
            </div>
          </div>
        </Card>

        {/* Personal Information */}
        <Card className="glass-card p-6">
          <h2 className="text-xl font-bold text-foreground mb-6">Personal Information</h2>
          <form className="space-y-5">
            <div className="grid md:grid-cols-2 gap-5">
              {/* First Name */}
              <div className="space-y-2">
                <Label htmlFor="firstName" className="text-foreground">
                  First Name
                </Label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                  <Input
                    id="firstName"
                    defaultValue="John"
                    className="pl-10 glass-card border-border/50 focus:border-primary/50"
                  />
                </div>
              </div>

              {/* Last Name */}
              <div className="space-y-2">
                <Label htmlFor="lastName" className="text-foreground">
                  Last Name
                </Label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                  <Input
                    id="lastName"
                    defaultValue="Doe"
                    className="pl-10 glass-card border-border/50 focus:border-primary/50"
                  />
                </div>
              </div>
            </div>

            {/* Username */}
            <div className="space-y-2">
              <Label htmlFor="username" className="text-foreground">
                Username
              </Label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                <Input
                  id="username"
                  defaultValue="johndoe123"
                  className="pl-10 glass-card border-border/50 focus:border-primary/50"
                />
              </div>
            </div>

            {/* Email */}
            <div className="space-y-2">
              <Label htmlFor="email" className="text-foreground">
                Email Address
              </Label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                <Input
                  id="email"
                  type="email"
                  defaultValue="john.doe@example.com"
                  className="pl-10 glass-card border-border/50 focus:border-primary/50"
                />
              </div>
              <p className="text-xs text-foreground/50">
                Email is verified ✓
              </p>
            </div>

            {/* Phone */}
            <div className="space-y-2">
              <Label htmlFor="phone" className="text-foreground">
                Phone Number
              </Label>
              <div className="relative">
                <Phone className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                <Input
                  id="phone"
                  type="tel"
                  defaultValue="+1 (555) 123-4567"
                  className="pl-10 glass-card border-border/50 focus:border-primary/50"
                />
              </div>
            </div>

            {/* Bio */}
            <div className="space-y-2">
              <Label htmlFor="bio" className="text-foreground">
                Bio
              </Label>
              <Textarea
                id="bio"
                placeholder="Tell us about yourself..."
                className="glass-card border-border/50 focus:border-primary/50 min-h-[100px]"
                defaultValue="Passionate gamer and digital content creator."
              />
              <p className="text-xs text-foreground/50">
                Brief description for your profile (max 500 characters)
              </p>
            </div>

            {/* Location */}
            <div className="space-y-2">
              <Label htmlFor="location" className="text-foreground">
                Location
              </Label>
              <div className="relative">
                <MapPin className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-primary/70" />
                <Input
                  id="location"
                  defaultValue="New York, USA"
                  className="pl-10 glass-card border-border/50 focus:border-primary/50"
                />
              </div>
            </div>

            {/* Save Button */}
            <div className="flex gap-3 pt-4">
              <Button type="submit" className="btn-glow">
                <Save className="h-4 w-4 mr-2" />
                Save Changes
              </Button>
              <Button type="button" variant="outline" className="glass-card border-border/50">
                Cancel
              </Button>
            </div>
          </form>
        </Card>

        {/* Security Settings */}
        <Card className="glass-card p-6">
          <h2 className="text-xl font-bold text-foreground mb-6">Security</h2>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 rounded-lg glass-card border border-border/30">
              <div>
                <p className="font-semibold text-foreground mb-1">Password</p>
                <p className="text-sm text-foreground/60">Last changed 30 days ago</p>
              </div>
              <Button variant="outline" size="sm" className="glass-card border-border/50">
                Change Password
              </Button>
            </div>

            <div className="flex items-center justify-between p-4 rounded-lg glass-card border border-border/30">
              <div>
                <p className="font-semibold text-foreground mb-1">Two-Factor Authentication</p>
                <p className="text-sm text-foreground/60">Add an extra layer of security</p>
              </div>
              <Button variant="outline" size="sm" className="glass-card border-border/50">
                Enable 2FA
              </Button>
            </div>
          </div>
        </Card>

        {/* Hidden file input */}
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          onChange={handleAvatarUpload}
          className="hidden"
        />
      </div>
    </AccountLayout>
  );
};

export default Profile;
