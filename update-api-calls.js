// Script to update all API calls in useApi.ts
import fs from 'fs';

const filePath = 'src/hooks/useApi.ts';
let content = fs.readFileSync(filePath, 'utf8');

// Replace all apiClient calls with the new request helper
const replacements = [
  // Auth calls
  { from: 'apiClient.login({', to: "post('/api/auth/login', {" },
  { from: 'apiClient.register({', to: "post('/api/auth/register', {" },
  { from: 'apiClient.logout()', to: "post('/api/auth/logout')" },
  { from: 'apiClient.getCurrentUser()', to: "get('/api/auth/me')" },
  
  // Product calls
  { from: 'apiClient.getProducts(', to: "get('/api/products" },
  { from: 'apiClient.getProduct(', to: "get('/api/products/" },
  { from: 'apiClient.getFeaturedProducts()', to: "get('/api/products/featured')" },
  
  // Cart calls
  { from: 'apiClient.getCart()', to: "get('/api/cart')" },
  { from: 'apiClient.addToCart(', to: "post('/api/cart/add', " },
  { from: 'apiClient.updateCartItem(', to: "put('/api/cart/update', " },
  { from: 'apiClient.removeFromCart(', to: "del('/api/cart/remove', " },
  { from: 'apiClient.clearCart()', to: "del('/api/cart/clear')" },
  
  // Order calls
  { from: 'apiClient.getOrders(', to: "get('/api/orders" },
  { from: 'apiClient.getOrder(', to: "get('/api/orders/" },
  { from: 'apiClient.createOrder(', to: "post('/api/orders', " },
  { from: 'apiClient.cancelOrder(', to: "put('/api/orders/cancel', " },
  
  // Member calls
  { from: 'apiClient.getMembers(', to: "get('/api/members" },
  { from: 'apiClient.getMember(', to: "get('/api/members/" },
  
  // Dispute calls
  { from: 'apiClient.getDisputes(', to: "get('/api/disputes" },
  { from: 'apiClient.getDispute(', to: "get('/api/disputes/" },
  { from: 'apiClient.createDispute(', to: "post('/api/disputes', " },
  { from: 'apiClient.updateDispute(', to: "put('/api/disputes/update', " },
  
  // Seller calls
  { from: 'apiClient.getSellerDashboard()', to: "get('/api/seller/dashboard')" },
  { from: 'apiClient.getSellerProducts(', to: "get('/api/seller/products" },
  { from: 'apiClient.getSellerOrders(', to: "get('/api/seller/orders" },
  
  // Wishlist calls
  { from: 'apiClient.getWishlist()', to: "get('/api/wishlist')" },
  { from: 'apiClient.addToWishlist(', to: "post('/api/wishlist/add', " },
  { from: 'apiClient.removeFromWishlist(', to: "del('/api/wishlist/remove', " },
];

// Apply replacements
replacements.forEach(({ from, to }) => {
  content = content.replace(new RegExp(from.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), to);
});

// Write the updated content
fs.writeFileSync(filePath, content);
console.log('✅ Updated API calls in useApi.ts');
