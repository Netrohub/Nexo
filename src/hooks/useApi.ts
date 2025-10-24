import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { queryKeys, type Product, type ProductFilters, type Cart, type Order, type Dispute, type CreateDisputeRequest, type SellerDashboard, type User } from '@/lib/api';
import { get, post, put, del } from '@/lib/request';
import { toast } from 'sonner';

// Auth Hooks
export const useCurrentUser = () => {
  return useQuery({
    queryKey: queryKeys.currentUser(),
    queryFn: () => get('/api/auth/me'),
    enabled: !!localStorage.getItem('auth_token'),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

export const useLogin = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ email, password, remember }: { email: string; password: string; remember?: boolean }) =>
      post('/api/auth/login', { email, password, remember }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.currentUser() });
      toast.success('Login successful!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Login failed');
    },
  });
};

export const useRegister = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ name, email, password, passwordConfirmation, phone }: {
      name: string;
      email: string;
      password: string;
      passwordConfirmation: string;
      phone?: string;
    }) => post('/api/auth/register', { name, email, password, password_confirmation: passwordConfirmation, phone }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.currentUser() });
      toast.success('Registration successful!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Registration failed');
    },
  });
};

export const useLogout = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: () => post('/api/auth/logout'),
    onSuccess: () => {
      queryClient.clear();
      toast.success('Logged out successfully');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Logout failed');
    },
  });
};

// Product Hooks
export const useProducts = (filters: ProductFilters = {}) => {
  return useQuery({
    queryKey: [...queryKeys.products, filters],
      queryFn: () => get('/api/products'),
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useProduct = (id: number) => {
  return useQuery({
    queryKey: queryKeys.product(id),
      queryFn: () => get(`/api/products/${id}`),
    enabled: !!id,
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

export const useFeaturedProducts = () => {
  return useQuery({
    queryKey: queryKeys.featuredProducts(),
    queryFn: () => get('/api/products/featured'),
    staleTime: 10 * 60 * 1000, // 10 minutes
  });
};

// Cart Hooks
export const useCart = () => {
  return useQuery({
    queryKey: queryKeys.cart,
    queryFn: () => get('/api/cart'),
    staleTime: 30 * 1000, // 30 seconds
  });
};

export const useAddToCart = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ productId, quantity }: { productId: number; quantity?: number }) =>
      post('/api/cart/add', productId, quantity),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.cart });
      toast.success('Added to cart!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to add to cart');
    },
  });
};

export const useUpdateCartItem = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ itemId, quantity }: { itemId: number; quantity: number }) =>
      put('/api/cart/update', itemId, quantity),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.cart });
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to update cart item');
    },
  });
};

export const useRemoveFromCart = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (itemId: number) => del('/api/cart/remove', itemId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.cart });
      toast.success('Removed from cart');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to remove from cart');
    },
  });
};

export const useClearCart = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: () => del('/api/cart/clear'),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.cart });
      toast.success('Cart cleared');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to clear cart');
    },
  });
};

// Order Hooks
export const useOrders = (page = 1) => {
  return useQuery({
    queryKey: [...queryKeys.orders, page],
    queryFn: () => get('/api/orders'),
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useOrder = (id: number) => {
  return useQuery({
    queryKey: queryKeys.order(id),
    queryFn: () => get(`/api/orders/${id}`),
    enabled: !!id,
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

export const useCreateOrder = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: { items: Array<{ product_id: number; quantity: number }> }) =>
      post('/api/orders', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.orders });
      queryClient.invalidateQueries({ queryKey: queryKeys.cart });
      toast.success('Order created successfully!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to create order');
    },
  });
};

// Wishlist Hooks
export const useWishlist = () => {
  return useQuery({
    queryKey: queryKeys.wishlist,
    queryFn: () => get('/api/wishlist'),
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useAddToWishlist = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (productId: number) => post('/api/wishlist/add', productId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.wishlist });
      toast.success('Added to wishlist!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to add to wishlist');
    },
  });
};

export const useRemoveFromWishlist = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (productId: number) => del('/api/wishlist/remove', productId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.wishlist });
      toast.success('Removed from wishlist');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to remove from wishlist');
    },
  });
};

// Dispute Hooks
export const useDisputes = () => {
  return useQuery({
    queryKey: queryKeys.disputes,
    queryFn: () => get('/api/disputes'),
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useDispute = (id: number) => {
  return useQuery({
    queryKey: queryKeys.dispute(id),
    queryFn: () => get(`/api/disputes/${id}`),
    enabled: !!id,
    staleTime: 1 * 60 * 1000, // 1 minute
  });
};

export const useCreateDispute = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: CreateDisputeRequest) => post('/api/disputes', data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.disputes });
      toast.success('Dispute created successfully!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to create dispute');
    },
  });
};

export const useAddDisputeMessage = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ disputeId, message }: { disputeId: number; message: string }) =>
      apiClient.addDisputeMessage(disputeId, message),
    onSuccess: (_, { disputeId }) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.dispute(disputeId) });
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to send message');
    },
  });
};

export const useUploadDisputeEvidence = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ disputeId, evidence }: { disputeId: number; evidence: FormData }) =>
      apiClient.uploadDisputeEvidence(disputeId, evidence),
    onSuccess: (_, { disputeId }) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.dispute(disputeId) });
      toast.success('Evidence uploaded successfully!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to upload evidence');
    },
  });
};

// Admin Dispute Hooks
export const useAdminDisputes = () => {
  return useQuery({
    queryKey: queryKeys.adminDisputes(),
    queryFn: () => apiClient.getAdminDisputes(),
    staleTime: 1 * 60 * 1000, // 1 minute
  });
};

export const useUpdateDisputeStatus = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ disputeId, status, resolution }: {
      disputeId: number;
      status: string;
      resolution?: string;
    }) => apiClient.updateDisputeStatus(disputeId, status, resolution),
    onSuccess: (_, { disputeId }) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.dispute(disputeId) });
      queryClient.invalidateQueries({ queryKey: queryKeys.adminDisputes() });
      toast.success('Dispute status updated!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to update dispute status');
    },
  });
};

// Seller Hooks
export const useSellerDashboard = () => {
  return useQuery({
    queryKey: queryKeys.sellerDashboard(),
    queryFn: () => get('/api/seller/dashboard'),
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useSellerProducts = () => {
  return useQuery({
    queryKey: queryKeys.sellerProducts(),
    queryFn: () => get('/api/seller/products'),
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useCreateProduct = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: FormData) => apiClient.createProduct(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.sellerProducts() });
      toast.success('Product created successfully!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to create product');
    },
  });
};

export const useUpdateProduct = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: FormData }) => apiClient.updateProduct(id, data),
    onSuccess: (_, { id }) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.product(id) });
      queryClient.invalidateQueries({ queryKey: queryKeys.sellerProducts() });
      toast.success('Product updated successfully!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to update product');
    },
  });
};

export const useDeleteProduct = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (id: number) => apiClient.deleteProduct(id),
    onSuccess: (_, id) => {
      queryClient.invalidateQueries({ queryKey: queryKeys.product(id) });
      queryClient.invalidateQueries({ queryKey: queryKeys.sellerProducts() });
      toast.success('Product deleted successfully!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to delete product');
    },
  });
};

export const useSellerOrders = () => {
  return useQuery({
    queryKey: queryKeys.sellerOrders(),
    queryFn: () => get('/api/seller/orders'),
    staleTime: 2 * 60 * 1000, // 2 minutes
  });
};

export const useSellerPayouts = () => {
  return useQuery({
    queryKey: queryKeys.sellerPayouts(),
    queryFn: () => apiClient.getSellerPayouts(),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};

export const useSellerNotifications = () => {
  return useQuery({
    queryKey: queryKeys.sellerNotifications(),
    queryFn: () => apiClient.getSellerNotifications(),
    staleTime: 1 * 60 * 1000, // 1 minute
  });
};

export const useListGamingAccount = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: FormData) => apiClient.listGamingAccount(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.sellerProducts() });
      toast.success('Gaming account listed successfully!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to list gaming account');
    },
  });
};

export const useListSocialAccount = () => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (data: FormData) => apiClient.listSocialAccount(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: queryKeys.sellerProducts() });
      toast.success('Social account listed successfully!');
    },
    onError: (error: any) => {
      toast.error(error.message || 'Failed to list social account');
    },
  });
};

// Members Hooks
export const useMembers = () => {
  return useQuery({
    queryKey: queryKeys.members,
    queryFn: () => get('/api/members'),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
};
