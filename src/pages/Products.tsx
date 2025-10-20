import { useState, useMemo } from "react";
import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import Starfield from "@/components/Starfield";
import ProductCard from "@/components/ProductCard";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { 
  Search, 
  SlidersHorizontal,
  Grid3x3,
  List,
  ChevronDown
} from "lucide-react";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useLanguage } from "@/contexts/LanguageContext";

const products = [
  {
    id: "p1",
    name: "Premium Instagram Account - 50K",
    price: 299.99,
    image: "https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=800&q=80",
    category: "Social Media",
    rating: 4.9,
    reviews: 145,
    featured: true,
  },
  {
    id: "p2",
    name: "Steam Account - 200+ Games",
    price: 449.99,
    image: "https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=800&q=80",
    category: "Gaming",
    rating: 4.8,
    reviews: 234,
    featured: true,
  },
  {
    id: "p3",
    name: "TikTok Creator Account - Verified",
    price: 599.99,
    image: "https://images.unsplash.com/photo-1611162616305-c69b3fa7fbe0?w=800&q=80",
    category: "Social Media",
    rating: 4.9,
    reviews: 189,
    featured: false,
  },
  {
    id: "p4",
    name: "YouTube Channel - 10K Subscribers",
    price: 799.99,
    image: "https://images.unsplash.com/photo-1611162616475-46b635cb6868?w=800&q=80",
    category: "Social Media",
    rating: 4.7,
    reviews: 156,
    featured: false,
  },
  {
    id: "p5",
    name: "PlayStation Plus - 3 Years Premium",
    price: 349.99,
    image: "https://images.unsplash.com/photo-1606813907291-d86efa9b94db?w=800&q=80",
    category: "Gaming",
    rating: 4.8,
    reviews: 298,
    featured: false,
  },
  {
    id: "p6",
    name: "Twitter Verified Account",
    price: 899.99,
    image: "https://images.unsplash.com/photo-1611605698335-8b1569810432?w=800&q=80",
    category: "Social Media",
    rating: 4.9,
    reviews: 167,
    featured: true,
  },
  {
    id: "p7",
    name: "Discord Server - 5K Members",
    price: 199.99,
    image: "https://images.unsplash.com/photo-1614680376593-902f74cf0d41?w=800&q=80",
    category: "Social Media",
    rating: 4.6,
    reviews: 123,
    featured: false,
  },
  {
    id: "p8",
    name: "Epic Games - Fortnite Rare Account",
    price: 699.99,
    image: "https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80",
    category: "Gaming",
    rating: 4.8,
    reviews: 342,
    featured: false,
  },
  {
    id: "p9",
    name: "Spotify Premium Family - 2 Years",
    price: 149.99,
    image: "https://images.unsplash.com/photo-1614680376408-81e91ffe3db7?w=800&q=80",
    category: "Digital Services",
    rating: 4.7,
    reviews: 234,
    featured: false,
  },
];

const categories = [
  "All Products",
  "Social Media",
  "Gaming",
  "Digital Services",
  "Software",
  "Entertainment",
];

const priceRanges = [
  "All Prices",
  "Under $100",
  "$100 - $300",
  "$300 - $500",
  "Over $500",
];

const Products = () => {
  const { t } = useLanguage();
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("all-products");
  const [selectedPriceRange, setSelectedPriceRange] = useState("all-prices");
  const [sortBy, setSortBy] = useState("featured");

  const filteredAndSortedProducts = useMemo(() => {
    let filtered = [...products];

    // Search filter
    if (searchQuery) {
      filtered = filtered.filter(product =>
        product.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
        product.category.toLowerCase().includes(searchQuery.toLowerCase())
      );
    }

    // Category filter
    if (selectedCategory !== "all-products") {
      const categoryName = categories.find(cat => 
        cat.toLowerCase().replace(" ", "-") === selectedCategory
      );
      if (categoryName) {
        filtered = filtered.filter(product => product.category === categoryName);
      }
    }

    // Price filter
    if (selectedPriceRange !== "all-prices") {
      filtered = filtered.filter(product => {
        switch (selectedPriceRange) {
          case "under-$100":
            return product.price < 100;
          case "$100---$300":
            return product.price >= 100 && product.price <= 300;
          case "$300---$500":
            return product.price >= 300 && product.price <= 500;
          case "over-$500":
            return product.price > 500;
          default:
            return true;
        }
      });
    }

    // Sort
    switch (sortBy) {
      case "price-low":
        filtered.sort((a, b) => a.price - b.price);
        break;
      case "price-high":
        filtered.sort((a, b) => b.price - a.price);
        break;
      case "rating":
        filtered.sort((a, b) => b.rating - a.rating);
        break;
      case "featured":
        filtered.sort((a, b) => (b.featured ? 1 : 0) - (a.featured ? 1 : 0));
        break;
    }

    return filtered;
  }, [searchQuery, selectedCategory, selectedPriceRange, sortBy]);

  const clearFilter = (filterType: string) => {
    if (filterType === "category") setSelectedCategory("all-products");
    if (filterType === "price") setSelectedPriceRange("all-prices");
  };

  const activeFilters = [];
  if (selectedCategory !== "all-products") {
    const categoryName = categories.find(cat => 
      cat.toLowerCase().replace(" ", "-") === selectedCategory
    );
    if (categoryName) activeFilters.push({ type: "category", label: categoryName });
  }
  if (selectedPriceRange !== "all-prices") {
    const priceName = priceRanges.find(range => 
      range.toLowerCase().replace(" ", "-") === selectedPriceRange
    );
    if (priceName) activeFilters.push({ type: "price", label: priceName });
  }

  return (
    <div className="min-h-screen flex flex-col relative">
      <Starfield />
      <Navbar />
      
      <main className="flex-1 relative z-10">
        {/* Hero Section */}
        <section className="relative py-12 overflow-hidden border-b border-border/30">
          <div className="absolute inset-0 gradient-nebula opacity-40" />
          
          <div className="container mx-auto px-4 relative z-10">
            <div className="max-w-4xl mx-auto">
              <h1 className="text-4xl md:text-5xl font-black bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent mb-4 text-center">
                {t('allProducts')}
              </h1>
              <p className="text-center text-foreground/60 mb-8">
                {t('browseProducts')}
              </p>

              {/* Search Bar */}
              <div className="relative mb-6">
                <Search className="absolute left-4 top-1/2 h-5 w-5 -translate-y-1/2 text-primary/70" />
                <Input
                  type="search"
                  placeholder={t('searchPlaceholder')}
                  className="w-full pl-12 pr-4 h-12 glass-card border-primary/30 focus:border-primary/50"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>
            </div>
          </div>
        </section>

        {/* Filters and Products */}
        <section className="py-8">
          <div className="container mx-auto px-4">
            {/* Filter Bar */}
            <div className="mb-8 glass-card p-4 rounded-lg">
              <div className="flex flex-wrap gap-4 items-center justify-between">
                <div className="flex flex-wrap gap-3 items-center">
                  <Button variant="outline" size="sm" className="glass-card border-primary/30">
                    <SlidersHorizontal className="h-4 w-4 mr-2" />
                    {t('filters')}
                  </Button>
                  
                  <Select value={selectedCategory} onValueChange={setSelectedCategory}>
                    <SelectTrigger className="w-[180px] glass-card border-primary/30">
                      <SelectValue placeholder="Category" />
                    </SelectTrigger>
                    <SelectContent className="glass-card">
                      {categories.map((cat) => (
                        <SelectItem key={cat} value={cat.toLowerCase().replace(" ", "-")}>
                          {cat}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>

                  <Select value={selectedPriceRange} onValueChange={setSelectedPriceRange}>
                    <SelectTrigger className="w-[180px] glass-card border-primary/30">
                      <SelectValue placeholder="Price Range" />
                    </SelectTrigger>
                    <SelectContent className="glass-card">
                      {priceRanges.map((range) => (
                        <SelectItem key={range} value={range.toLowerCase().replace(" ", "-")}>
                          {range}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>

                <div className="flex items-center gap-3">
                  <Select value={sortBy} onValueChange={setSortBy}>
                    <SelectTrigger className="w-[180px] glass-card border-primary/30">
                      <SelectValue placeholder={t('sortBy')} />
                    </SelectTrigger>
                    <SelectContent className="glass-card">
                      <SelectItem value="featured">{t('featured')}</SelectItem>
                      <SelectItem value="price-low">{t('priceLowToHigh')}</SelectItem>
                      <SelectItem value="price-high">{t('priceHighToLow')}</SelectItem>
                      <SelectItem value="rating">{t('highestRated')}</SelectItem>
                      <SelectItem value="newest">{t('newestFirst')}</SelectItem>
                    </SelectContent>
                  </Select>

                  <div className="hidden md:flex gap-2">
                    <Button size="icon" variant="outline" className="glass-card border-primary/50">
                      <Grid3x3 className="h-4 w-4" />
                    </Button>
                    <Button size="icon" variant="ghost">
                      <List className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              </div>

              {/* Active Filters */}
              {activeFilters.length > 0 && (
                <div className="flex flex-wrap gap-2 mt-4">
                  {activeFilters.map((filter) => (
                    <Badge key={filter.type} variant="secondary" className="bg-primary/10 text-primary border-primary/20">
                      {filter.label}
                      <button 
                        className="ml-2 hover:text-primary/70"
                        onClick={() => clearFilter(filter.type)}
                      >
                        ×
                      </button>
                    </Badge>
                  ))}
                </div>
              )}
            </div>

            {/* Results Count */}
            <div className="mb-6 flex items-center justify-between">
              <p className="text-foreground/60">
                {t('showing')} <span className="text-foreground font-semibold">{filteredAndSortedProducts.length}</span> {t('productsText')}
              </p>
            </div>

            {/* Products Grid */}
            {filteredAndSortedProducts.length > 0 ? (
              <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                {filteredAndSortedProducts.map((product) => (
                  <ProductCard key={product.id} {...product} />
                ))}
              </div>
            ) : (
              <div className="text-center py-12">
                <p className="text-foreground/60 text-lg">{t('noProductsFound')}</p>
              </div>
            )}

            {/* Load More */}
            <div className="mt-12 text-center">
              <Button size="lg" className="btn-glow">
                {t('loadMore')}
                <ChevronDown className="h-4 w-4 ml-2" />
              </Button>
            </div>
          </div>
        </section>
      </main>
      
      <Footer />
    </div>
  );
};

export default Products;
