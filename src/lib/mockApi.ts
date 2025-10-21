/**
 * Mock API for testing without backend/database
 * Set VITE_MOCK_API=true in .env to enable
 */

import { Product, User, Order, Cart, Dispute } from './api';

// Mock delay to simulate network
const delay = (ms: number = 500) => new Promise(resolve => setTimeout(resolve, ms));

// Mock user data
const mockUser: User = {
  id: 1,
  name: 'John Doe',
  email: 'john@nxoland.com',
  email_verified_at: new Date().toISOString(),
  phone: '+1234567890',
  phone_verified_at: new Date().toISOString(),
  avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=John',
  roles: ['customer', 'seller'],
  created_at: new Date().toISOString(),
  updated_at: new Date().toISOString(),
};

// Mock products
const mockProducts: Product[] = [
  {
    id: 1,
    title: 'Premium Instagram Account - 50K Followers',
    description: 'Verified Instagram account with 50K real followers, high engagement rate, perfect for influencers.',
    price: 299.99,
    discount_price: 249.99,
    category: 'Social Media',
    platform: 'Instagram',
    images: ['https://images.unsplash.com/photo-1611162617474-5b21e879e113?w=800&q=80'],
    seller: {
      id: 2,
      name: 'Sarah Johnson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah',
      rating: 4.9,
      verified: true,
    },
    rating: 4.9,
    reviews_count: 145,
    featured: true,
    status: 'active',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  },
  {
    id: 2,
    title: 'Steam Account - 200+ Games',
    description: 'Premium Steam account with 200+ games including AAA titles, level 50+, rare items.',
    price: 449.99,
    category: 'Gaming',
    platform: 'Steam',
    game: 'Multiple',
    images: ['https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=800&q=80'],
    seller: {
      id: 3,
      name: 'Mike Chen',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Mike',
      rating: 4.8,
      verified: true,
    },
    rating: 4.8,
    reviews_count: 234,
    featured: true,
    status: 'active',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  },
  {
    id: 3,
    title: 'TikTok Creator Account - Verified',
    description: 'Verified TikTok account with 100K+ followers, great engagement, monetization enabled.',
    price: 599.99,
    category: 'Social Media',
    platform: 'TikTok',
    images: ['https://images.unsplash.com/photo-1611162616305-c69b3fa7fbe0?w=800&q=80'],
    seller: {
      id: 2,
      name: 'Sarah Johnson',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah',
      rating: 4.9,
      verified: true,
    },
    rating: 4.7,
    reviews_count: 89,
    featured: false,
    status: 'active',
    created_at: new Date().toISOString(),
    updated_at: new Date().toISOString(),
  },
];

// Mock cart
const mockCart: Cart = {
  items: [],
  subtotal: 0,
  service_fee: 0,
  total: 0,
  items_count: 0,
};

// Mock API implementation
export const mockApi = {
  // Auth
  async login(email: string, password: string) {
    await delay();
    const token = 'mock_token_12345';
    localStorage.setItem('auth_token', token);
    
    console.log('🎭 Mock API: Login successful', { email, user: mockUser.name });
    
    return {
      user: mockUser,
      token: token,
      token_type: 'Bearer',
      expires_in: 3600,
    };
  },

  async register(data: any) {
    await delay();
    const token = 'mock_token_12345';
    localStorage.setItem('auth_token', token);
    
    console.log('🎭 Mock API: Registration successful', { name: data.name });
    
    return {
      user: { ...mockUser, name: data.name, email: data.email },
      token: token,
      token_type: 'Bearer',
      expires_in: 3600,
    };
  },

  async getCurrentUser() {
    await delay(300);
    console.log('🎭 Mock API: Get current user', mockUser.name);
    return mockUser;
  },

  async logout() {
    await delay(200);
    localStorage.removeItem('auth_token');
    console.log('🎭 Mock API: Logout successful');
  },

  // Products
  async getProducts(filters: any = {}) {
    await delay();
    let filtered = [...mockProducts];

    // Apply filters
    if (filters.search) {
      filtered = filtered.filter(p =>
        p.title.toLowerCase().includes(filters.search.toLowerCase())
      );
    }

    if (filters.category && filters.category !== 'all-products') {
      filtered = filtered.filter(p => p.category === filters.category);
    }

    if (filters.min_price) {
      filtered = filtered.filter(p => p.price >= filters.min_price);
    }

    if (filters.max_price) {
      filtered = filtered.filter(p => p.price <= filters.max_price);
    }

    return {
      data: filtered,
      meta: {
        current_page: 1,
        last_page: 1,
        per_page: 12,
        total: filtered.length,
        from: 1,
        to: filtered.length,
      },
      links: {
        first: '',
        last: '',
        prev: null,
        next: null,
      },
    };
  },

  async getProduct(id: number) {
    await delay();
    return mockProducts.find(p => p.id === id) || mockProducts[0];
  },

  async getFeaturedProducts() {
    await delay();
    return mockProducts.filter(p => p.featured);
  },

  // Cart
  async getCart() {
    await delay();
    return mockCart;
  },

  async addToCart(productId: number, quantity: number) {
    await delay();
    console.log('Added to cart:', productId, quantity);
  },

  // Orders
  async getOrders() {
    await delay();
    return {
      data: [],
      meta: {
        current_page: 1,
        last_page: 1,
        per_page: 10,
        total: 0,
        from: 0,
        to: 0,
      },
    };
  },

  // Wishlist
  async getWishlist() {
    await delay();
    return [];
  },

  // Disputes
  async getDisputes() {
    await delay();
    return [];
  },

  // Seller
  async getSellerDashboard() {
    await delay();
    return {
      total_revenue: 5432.10,
      total_orders: 89,
      total_products: 12,
      average_rating: 4.8,
      pending_orders: 3,
      active_products: 9,
      monthly_revenue: [
        { month: 'Jan', revenue: 1200 },
        { month: 'Feb', revenue: 1800 },
        { month: 'Mar', revenue: 2432.10 },
      ],
      recent_orders: [],
      top_products: [],
    };
  },
};
