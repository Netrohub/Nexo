import SellerLayout from "@/components/SellerLayout";
import { Card } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Upload, X, Plus, Save } from "lucide-react";
import { useState, useRef } from "react";

const CreateProduct = () => {
  const [images, setImages] = useState<string[]>([]);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleImageUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files) return;

    Array.from(files).forEach((file) => {
      if (file.type.startsWith('image/')) {
        const reader = new FileReader();
        reader.onload = (e) => {
          if (e.target?.result) {
            setImages(prev => [...prev, e.target.result as string]);
          }
        };
        reader.readAsDataURL(file);
      }
    });
  };

  const removeImage = (index: number) => {
    setImages(images.filter((_, i) => i !== index));
  };

  return (
    <SellerLayout>
      <div className="space-y-6">
        {/* Header */}
        <div>
          <h1 className="text-3xl font-black bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent mb-2">
            Create Product
          </h1>
          <p className="text-foreground/60">List a new product on the marketplace</p>
        </div>

        <form className="space-y-6">
          {/* Basic Information */}
          <Card className="glass-card p-6">
            <h2 className="text-xl font-bold text-foreground mb-6">Basic Information</h2>
            <div className="space-y-5">
              {/* Product Name */}
              <div className="space-y-2">
                <Label htmlFor="productName" className="text-foreground">
                  Product Name *
                </Label>
                <Input
                  id="productName"
                  placeholder="e.g., Steam Account - 500+ Games"
                  className="glass-card border-border/50 focus:border-primary/50"
                />
              </div>

              {/* Category */}
              <div className="space-y-2">
                <Label htmlFor="category" className="text-foreground">
                  Category *
                </Label>
                <Select>
                  <SelectTrigger className="glass-card border-border/50 bg-background">
                    <SelectValue placeholder="Select category" />
                  </SelectTrigger>
                  <SelectContent className="glass-card bg-card border-border z-50">
                    <SelectItem value="gaming">Gaming</SelectItem>
                    <SelectItem value="social-media">Social Media</SelectItem>
                    <SelectItem value="digital-services">Digital Services</SelectItem>
                    <SelectItem value="software">Software</SelectItem>
                    <SelectItem value="entertainment">Entertainment</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Platform/Type */}
              <div className="space-y-2">
                <Label htmlFor="platform" className="text-foreground">
                  Platform/Type *
                </Label>
                <Select>
                  <SelectTrigger className="glass-card border-border/50 bg-background">
                    <SelectValue placeholder="Select platform" />
                  </SelectTrigger>
                  <SelectContent className="glass-card bg-card border-border z-50">
                    <SelectItem value="steam">Steam</SelectItem>
                    <SelectItem value="playstation">PlayStation</SelectItem>
                    <SelectItem value="xbox">Xbox</SelectItem>
                    <SelectItem value="epic">Epic Games</SelectItem>
                    <SelectItem value="instagram">Instagram</SelectItem>
                    <SelectItem value="twitter">Twitter</SelectItem>
                    <SelectItem value="tiktok">TikTok</SelectItem>
                  </SelectContent>
                </Select>
              </div>

              {/* Description */}
              <div className="space-y-2">
                <Label htmlFor="description" className="text-foreground">
                  Description *
                </Label>
                <Textarea
                  id="description"
                  placeholder="Describe your product in detail..."
                  className="glass-card border-border/50 focus:border-primary/50 min-h-[150px]"
                />
                <p className="text-xs text-foreground/50">
                  Provide detailed information about the product, its features, and condition
                </p>
              </div>
            </div>
          </Card>

          {/* Pricing */}
          <Card className="glass-card p-6">
            <h2 className="text-xl font-bold text-foreground mb-6">Pricing & Stock</h2>
            <div className="grid md:grid-cols-2 gap-5">
              {/* Price */}
              <div className="space-y-2">
                <Label htmlFor="price" className="text-foreground">
                  Price (USD) *
                </Label>
                <div className="relative">
                  <span className="absolute left-3 top-1/2 -translate-y-1/2 text-foreground/60">$</span>
                  <Input
                    id="price"
                    type="number"
                    placeholder="0.00"
                    className="pl-8 glass-card border-border/50 focus:border-primary/50"
                    step="0.01"
                    min="0"
                  />
                </div>
              </div>

              {/* Stock */}
              <div className="space-y-2">
                <Label htmlFor="stock" className="text-foreground">
                  Stock Quantity *
                </Label>
                <Input
                  id="stock"
                  type="number"
                  placeholder="0"
                  className="glass-card border-border/50 focus:border-primary/50"
                  min="0"
                />
              </div>
            </div>
          </Card>

          {/* Images */}
          <Card className="glass-card p-6">
            <h2 className="text-xl font-bold text-foreground mb-6">Product Images</h2>
            <div className="space-y-4">
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {images.map((image, index) => (
                  <div key={index} className="relative aspect-square rounded-lg overflow-hidden glass-card border border-border/50 group">
                    <img src={image} alt={`Product ${index + 1}`} className="w-full h-full object-cover" />
                    <button
                      type="button"
                      onClick={() => removeImage(index)}
                      className="absolute top-2 right-2 p-1 rounded-full bg-destructive/90 text-white opacity-0 group-hover:opacity-100 transition-opacity"
                    >
                      <X className="h-4 w-4" />
                    </button>
                  </div>
                ))}
                
                {images.length < 6 && (
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    className="aspect-square rounded-lg glass-card border-2 border-dashed border-border/50 hover:border-primary/50 transition-colors flex flex-col items-center justify-center gap-2 text-foreground/60 hover:text-primary"
                  >
                    <Upload className="h-8 w-8" />
                    <span className="text-sm">Upload Image</span>
                  </button>
                )}
              </div>
              <p className="text-xs text-foreground/50">
                Upload up to 6 images. First image will be the main product image.
              </p>
            </div>
          </Card>

          {/* Product Details */}
          <Card className="glass-card p-6">
            <h2 className="text-xl font-bold text-foreground mb-6">Additional Details</h2>
            <div className="space-y-5">
              <div className="space-y-2">
                <Label htmlFor="features" className="text-foreground">
                  Key Features
                </Label>
                <Textarea
                  id="features"
                  placeholder="List key features (one per line)"
                  className="glass-card border-border/50 focus:border-primary/50 min-h-[100px]"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="deliveryInfo" className="text-foreground">
                  Delivery Information
                </Label>
                <Textarea
                  id="deliveryInfo"
                  placeholder="How will the buyer receive the product?"
                  className="glass-card border-border/50 focus:border-primary/50 min-h-[100px]"
                />
              </div>
            </div>
          </Card>

          {/* Actions */}
          <Card className="glass-card p-6">
            <div className="flex gap-3">
              <Button type="submit" className="btn-glow">
                <Save className="h-4 w-4 mr-2" />
                Publish Product
              </Button>
              <Button type="button" variant="outline" className="glass-card border-border/50">
                Save as Draft
              </Button>
              <Button type="button" variant="ghost">
                Cancel
              </Button>
            </div>
          </Card>
        </form>

        {/* Hidden file input */}
        <input
          ref={fileInputRef}
          type="file"
          accept="image/*"
          multiple
          onChange={handleImageUpload}
          className="hidden"
        />
      </div>
    </SellerLayout>
  );
};

export default CreateProduct;
