import { QueryClient } from '@tanstack/react-query';
import { mockApi } from './mockApi';

// API Configuration
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8000/api';
const USE_MOCK_API = import.meta.env.VITE_MOCK_API === 'true';

// Log configuration on module load
console.log('🔧 API Configuration:', {
  API_BASE_URL,
  USE_MOCK_API,
  VITE_MOCK_API: import.meta.env.VITE_MOCK_API,
});

// Types
export interface ApiResponse<T = any> {
  data: T;
  message?: string;
  status: 'success' | 'error';
  errors?: Record<string, string[]>;
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  meta: {
    current_page: number;
    last_page: number;
    per_page: number;
    total: number;
    from: number;
    to: number;
  };
  links: {
    first: string;
    last: string;
    prev: string | null;
    next: string | null;
  };
}

// Auth Types
export interface User {
  id: number;
  name: string;
  email: string;
  email_verified_at: string | null;
  phone: string | null;
  phone_verified_at: string | null;
  avatar: string | null;
  roles: string[];
  created_at: string;
  updated_at: string;
}

export interface AuthResponse {
  user: User;
  token: string;
  token_type: string;
  expires_in: number;
}

export interface LoginRequest {
  email: string;
  password: string;
  remember?: boolean;
}

export interface RegisterRequest {
  name: string;
  email: string;
  password: string;
  password_confirmation: string;
  phone?: string;
}

// Product Types
export interface Product {
  id: number;
  title: string;
  description: string;
  price: number;
  discount_price?: number;
  category: string;
  platform?: string;
  game?: string;
  images: string[];
  seller: {
    id: number;
    name: string;
    avatar?: string;
    rating: number;
    verified: boolean;
  };
  rating: number;
  reviews_count: number;
  featured: boolean;
  status: 'active' | 'inactive' | 'pending' | 'rejected';
  created_at: string;
  updated_at: string;
}

export interface ProductFilters {
  category?: string;
  platform?: string;
  game?: string;
  min_price?: number;
  max_price?: number;
  rating?: number;
  featured?: boolean;
  search?: string;
  sort?: 'price_asc' | 'price_desc' | 'rating' | 'newest' | 'oldest';
  page?: number;
  per_page?: number;
}

// Cart Types
export interface CartItem {
  id: number;
  product: Product;
  quantity: number;
  price: number;
  created_at: string;
}

export interface Cart {
  items: CartItem[];
  subtotal: number;
  service_fee: number;
  total: number;
  items_count: number;
}

// Order Types
export interface Order {
  id: number;
  order_number: string;
  status: 'pending' | 'processing' | 'completed' | 'cancelled' | 'refunded';
  total: number;
  items: OrderItem[];
  buyer: User;
  seller: User;
  payment_method: string;
  payment_status: 'pending' | 'paid' | 'failed' | 'refunded';
  created_at: string;
  updated_at: string;
}

export interface OrderItem {
  id: number;
  product: Product;
  quantity: number;
  price: number;
  total: number;
}

// Dispute Types
export interface Dispute {
  id: number;
  order_id: number;
  order: Order;
  type: 'product_not_as_described' | 'product_not_delivered' | 'seller_not_responding' | 'other';
  reason: string;
  description: string;
  status: 'open' | 'in_review' | 'resolved' | 'declined';
  evidence: DisputeEvidence[];
  messages: DisputeMessage[];
  created_by: User;
  assigned_to?: User;
  resolution?: string;
  created_at: string;
  updated_at: string;
}

export interface DisputeEvidence {
  id: number;
  type: 'image' | 'document' | 'text';
  content: string;
  description?: string;
  uploaded_by: User;
  created_at: string;
}

export interface DisputeMessage {
  id: number;
  message: string;
  sender: User;
  is_admin: boolean;
  created_at: string;
}

export interface CreateDisputeRequest {
  order_id: number;
  type: string;
  reason: string;
  description: string;
}

// Seller Types
export interface SellerDashboard {
  total_revenue: number;
  total_orders: number;
  total_products: number;
  average_rating: number;
  pending_orders: number;
  active_products: number;
  monthly_revenue: Array<{
    month: string;
    revenue: number;
  }>;
  recent_orders: Order[];
  top_products: Product[];
}

export interface SellerOrder {
  id: number;
  order_number: string;
  status: string;
  total: number;
  buyer: User;
  items: OrderItem[];
  created_at: string;
}

export interface SellerPayout {
  id: number;
  amount: number;
  status: 'pending' | 'processing' | 'completed' | 'failed';
  method: string;
  reference: string;
  created_at: string;
  processed_at?: string;
}

// API Client Class
class ApiClient {
  private baseURL: string;
  private token: string | null = null;

  constructor(baseURL: string) {
    this.baseURL = baseURL;
    this.token = localStorage.getItem('auth_token');
  }

  private async request<T>(
    endpoint: string,
    options: RequestInit = {}
  ): Promise<ApiResponse<T>> {
    const url = `${this.baseURL}${endpoint}`;
    
    const config: RequestInit = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...(this.token && { Authorization: `Bearer ${this.token}` }),
        ...options.headers,
      },
      ...options,
    };

    try {
      const response = await fetch(url, config);
      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.message || `HTTP error! status: ${response.status}`);
      }

      return data;
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  // Auth Methods
  async login(credentials: LoginRequest): Promise<AuthResponse> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API for login');
      const authResponse = await mockApi.login(credentials.email, credentials.password);
      this.setToken(authResponse.token);
      return authResponse;
    }
    
    const response = await this.request<AuthResponse>('/auth/login', {
      method: 'POST',
      body: JSON.stringify(credentials),
    });
    
    if (response.data.token) {
      this.setToken(response.data.token);
    }
    
    return response.data;
  }

  async register(userData: RegisterRequest): Promise<AuthResponse> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API for registration');
      const authResponse = await mockApi.register(userData);
      this.setToken(authResponse.token);
      return authResponse;
    }
    
    const response = await this.request<AuthResponse>('/auth/register', {
      method: 'POST',
      body: JSON.stringify(userData),
    });
    
    if (response.data.token) {
      this.setToken(response.data.token);
    }
    
    return response.data;
  }

  async logout(): Promise<void> {
    if (USE_MOCK_API) {
      return mockApi.logout();
    }
    
    try {
      await this.request('/auth/logout', { method: 'POST' });
    } finally {
      this.clearToken();
    }
  }

  async getCurrentUser(): Promise<User> {
    if (USE_MOCK_API) {
      return mockApi.getCurrentUser();
    }
    
    const response = await this.request<User>('/auth/me');
    return response.data;
  }

  async verifyPhone(phone: string, code: string): Promise<void> {
    await this.request('/auth/verify-phone', {
      method: 'POST',
      body: JSON.stringify({ phone, code }),
    });
  }

  async submitKYC(data: FormData): Promise<void> {
    await this.request('/auth/kyc', {
      method: 'POST',
      headers: {}, // Let browser set Content-Type for FormData
      body: data,
    });
  }

  // Product Methods
  async getProducts(filters: ProductFilters = {}): Promise<PaginatedResponse<Product>> {
    if (USE_MOCK_API) {
      return mockApi.getProducts(filters);
    }
    
    const params = new URLSearchParams();
    Object.entries(filters).forEach(([key, value]) => {
      if (value !== undefined && value !== null) {
        params.append(key, value.toString());
      }
    });
    
    const response = await this.request<PaginatedResponse<Product>>(`/products?${params}`);
    return response.data;
  }

  async getProduct(id: number): Promise<Product> {
    if (USE_MOCK_API) {
      return mockApi.getProduct(id);
    }
    
    const response = await this.request<Product>(`/products/${id}`);
    return response.data;
  }

  async getFeaturedProducts(): Promise<Product[]> {
    if (USE_MOCK_API) {
      return mockApi.getFeaturedProducts();
    }
    
    const response = await this.request<Product[]>('/products?featured=true');
    return response.data;
  }

  // Cart Methods
  async getCart(): Promise<Cart> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API for cart');
      return mockApi.getCart();
    }
    
    const response = await this.request<Cart>('/cart');
    return response.data;
  }

  async addToCart(productId: number, quantity: number = 1): Promise<void> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API to add to cart');
      return mockApi.addToCart(productId, quantity);
    }
    
    await this.request('/cart', {
      method: 'POST',
      body: JSON.stringify({ product_id: productId, quantity }),
    });
  }

  async updateCartItem(itemId: number, quantity: number): Promise<void> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API to update cart item');
      return mockApi.updateCartItem(itemId, quantity);
    }
    
    await this.request(`/cart/${itemId}`, {
      method: 'PUT',
      body: JSON.stringify({ quantity }),
    });
  }

  async removeFromCart(itemId: number): Promise<void> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API to remove from cart');
      return mockApi.removeFromCart(itemId);
    }
    
    await this.request(`/cart/${itemId}`, { method: 'DELETE' });
  }

  async clearCart(): Promise<void> {
    await this.request('/cart', { method: 'DELETE' });
  }

  // Order Methods
  async createOrder(data: { items: Array<{ product_id: number; quantity: number }> }): Promise<Order> {
    const response = await this.request<Order>('/orders', {
      method: 'POST',
      body: JSON.stringify(data),
    });
    return response.data;
  }

  async getOrders(page: number = 1): Promise<PaginatedResponse<Order>> {
    const response = await this.request<PaginatedResponse<Order>>(`/orders?page=${page}`);
    return response.data;
  }

  async getOrder(id: number): Promise<Order> {
    const response = await this.request<Order>(`/orders/${id}`);
    return response.data;
  }

  // Wishlist Methods
  async getWishlist(): Promise<Product[]> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API for wishlist');
      return mockApi.getWishlist();
    }
    
    const response = await this.request<Product[]>('/wishlist');
    return response.data;
  }

  async addToWishlist(productId: number): Promise<void> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API to add to wishlist');
      return mockApi.addToWishlist(productId);
    }
    
    await this.request('/wishlist', {
      method: 'POST',
      body: JSON.stringify({ product_id: productId }),
    });
  }

  async removeFromWishlist(productId: number): Promise<void> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API to remove from wishlist');
      return mockApi.removeFromWishlist(productId);
    }
    
    await this.request(`/wishlist/${productId}`, { method: 'DELETE' });
  }

  // Dispute Methods
  async getDisputes(): Promise<Dispute[]> {
    const response = await this.request<Dispute[]>('/disputes');
    return response.data;
  }

  async getDispute(id: number): Promise<Dispute> {
    const response = await this.request<Dispute>(`/disputes/${id}`);
    return response.data;
  }

  async createDispute(data: CreateDisputeRequest): Promise<Dispute> {
    const response = await this.request<Dispute>('/disputes', {
      method: 'POST',
      body: JSON.stringify(data),
    });
    return response.data;
  }

  async addDisputeMessage(disputeId: number, message: string): Promise<DisputeMessage> {
    const response = await this.request<DisputeMessage>(`/disputes/${disputeId}/messages`, {
      method: 'POST',
      body: JSON.stringify({ message }),
    });
    return response.data;
  }

  async uploadDisputeEvidence(disputeId: number, evidence: FormData): Promise<DisputeEvidence> {
    const response = await this.request<DisputeEvidence>(`/disputes/${disputeId}/evidence`, {
      method: 'POST',
      headers: {}, // Let browser set Content-Type for FormData
      body: evidence,
    });
    return response.data;
  }

  // Admin Dispute Methods
  async getAdminDisputes(): Promise<Dispute[]> {
    const response = await this.request<Dispute[]>('/admin/disputes');
    return response.data;
  }

  async updateDisputeStatus(disputeId: number, status: string, resolution?: string): Promise<Dispute> {
    const response = await this.request<Dispute>(`/admin/disputes/${disputeId}`, {
      method: 'PUT',
      body: JSON.stringify({ status, resolution }),
    });
    return response.data;
  }

  // Seller Methods
  async getSellerDashboard(): Promise<SellerDashboard> {
    const response = await this.request<SellerDashboard>('/seller/dashboard-metrics');
    return response.data;
  }

  async getSellerProducts(): Promise<Product[]> {
    const response = await this.request<Product[]>('/seller/products');
    return response.data;
  }

  async createProduct(data: FormData): Promise<Product> {
    const response = await this.request<Product>('/seller/products', {
      method: 'POST',
      headers: {}, // Let browser set Content-Type for FormData
      body: data,
    });
    return response.data;
  }

  async updateProduct(id: number, data: FormData): Promise<Product> {
    const response = await this.request<Product>(`/seller/products/${id}`, {
      method: 'PUT',
      headers: {}, // Let browser set Content-Type for FormData
      body: data,
    });
    return response.data;
  }

  async deleteProduct(id: number): Promise<void> {
    await this.request(`/seller/products/${id}`, { method: 'DELETE' });
  }

  async getSellerOrders(): Promise<SellerOrder[]> {
    const response = await this.request<SellerOrder[]>('/seller/orders');
    return response.data;
  }

  async getSellerPayouts(): Promise<SellerPayout[]> {
    const response = await this.request<SellerPayout[]>('/seller/payouts');
    return response.data;
  }

  async getSellerNotifications(): Promise<any[]> {
    const response = await this.request<any[]>('/seller/notifications');
    return response.data;
  }

  async listGamingAccount(data: FormData): Promise<Product> {
    const response = await this.request<Product>('/seller/listing/gaming-account', {
      method: 'POST',
      headers: {}, // Let browser set Content-Type for FormData
      body: data,
    });
    return response.data;
  }

  async listSocialAccount(data: FormData): Promise<Product> {
    const response = await this.request<Product>('/seller/listing/social-account', {
      method: 'POST',
      headers: {}, // Let browser set Content-Type for FormData
      body: data,
    });
    return response.data;
  }

  // Utility Methods
  setToken(token: string): void {
    this.token = token;
    localStorage.setItem('auth_token', token);
  }

  clearToken(): void {
    this.token = null;
    localStorage.removeItem('auth_token');
  }

  isAuthenticated(): boolean {
    return !!this.token;
  }

  // KYC Methods
  async updateKYCStatus(step: 'email' | 'phone' | 'identity', verified: boolean): Promise<void> {
    if (USE_MOCK_API) {
      console.log(`🎭 Using Mock API for KYC ${step} update`);
      return mockApi.updateKYCStatus(step, verified);
    }
    
    await this.request(`/kyc/${step}`, {
      method: 'POST',
      body: JSON.stringify({ verified }),
    });
  }

  async completeKYC(): Promise<void> {
    if (USE_MOCK_API) {
      console.log('🎭 Using Mock API for KYC completion');
      return mockApi.completeKYC();
    }
    
    await this.request('/kyc/complete', {
      method: 'POST',
    });
  }
}

// Create and export API client instance
export const apiClient = new ApiClient(API_BASE_URL);

// React Query keys for consistent caching
export const queryKeys = {
  // Auth
  auth: ['auth'] as const,
  currentUser: () => [...queryKeys.auth, 'me'] as const,
  
  // Products
  products: ['products'] as const,
  product: (id: number) => [...queryKeys.products, id] as const,
  featuredProducts: () => [...queryKeys.products, 'featured'] as const,
  
  // Cart
  cart: ['cart'] as const,
  
  // Orders
  orders: ['orders'] as const,
  order: (id: number) => [...queryKeys.orders, id] as const,
  
  // Wishlist
  wishlist: ['wishlist'] as const,
  
  // Disputes
  disputes: ['disputes'] as const,
  dispute: (id: number) => [...queryKeys.disputes, id] as const,
  adminDisputes: () => [...queryKeys.disputes, 'admin'] as const,
  
  // Seller
  seller: ['seller'] as const,
  sellerDashboard: () => [...queryKeys.seller, 'dashboard'] as const,
  sellerProducts: () => [...queryKeys.seller, 'products'] as const,
  sellerOrders: () => [...queryKeys.seller, 'orders'] as const,
  sellerPayouts: () => [...queryKeys.seller, 'payouts'] as const,
  sellerNotifications: () => [...queryKeys.seller, 'notifications'] as const,
};
