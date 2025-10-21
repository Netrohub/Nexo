import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ShoppingCart, Star } from "lucide-react";
import { getCategoryImage } from "@/lib/categoryImages";
import { useLanguage } from "@/contexts/LanguageContext";
import { usePrefetch } from "@/hooks/usePrefetch";
import { Link } from "react-router-dom";

interface ProductCardProps {
  id: string | number;
  name: string;
  price: number;
  image: string;
  category: string;
  rating: number;
  reviews: number;
  featured?: boolean;
}

const ProductCard = ({ id, name, price, image, category, rating, reviews, featured }: ProductCardProps) => {
  const { t } = useLanguage();
  const { prefetchProduct } = usePrefetch();
  
  // Use category-based image instead of product-specific image
  const displayImage = getCategoryImage(category, image);
  
  // Prefetch product data on hover
  const handleMouseEnter = () => {
    if (typeof id === 'number') {
      prefetchProduct(id);
    }
  };
  
  return (
    <Link to={`/products/${id}`} onMouseEnter={handleMouseEnter}>
      <Card className="glass-card overflow-hidden group cursor-pointer">
      <CardContent className="p-0">
        <div className="relative aspect-square overflow-hidden bg-muted/30">
          <img
            src={displayImage}
            alt={category}
            className="h-full w-full object-cover transition-all duration-500 group-hover:scale-110"
          />
          {featured && (
            <Badge className="absolute left-3 top-3 badge-glow border-0 font-semibold">
              ⭐ {t('featured')}
            </Badge>
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-background/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
        </div>
        <div className="p-4 space-y-3">
          <div className="flex items-center justify-between">
            <Badge variant="secondary" className="text-xs bg-primary/10 text-primary border-primary/20 hover:bg-primary/20">
              {category}
            </Badge>
            <div className="flex items-center gap-1 text-sm">
              <Star className="h-3.5 w-3.5 fill-primary text-primary" />
              <span className="font-semibold text-foreground">{rating}</span>
              <span className="text-muted-foreground">({reviews})</span>
            </div>
          </div>
          <h3 className="line-clamp-2 font-semibold text-base group-hover:text-primary transition-colors">{name}</h3>
          <div className="flex items-baseline gap-2">
            <p className="text-2xl font-bold bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">
              ${price.toFixed(2)}
            </p>
          </div>
        </div>
      </CardContent>
      <CardFooter className="p-4 pt-0">
        <Button className="w-full gap-2 btn-glow">
          <ShoppingCart className="h-4 w-4" />
          {t('addToCart')}
        </Button>
      </CardFooter>
    </Card>
    </Link>
  );
};

export default ProductCard;
