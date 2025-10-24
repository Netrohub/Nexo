// Examples of using the safe request helper
import { request, get, post, put, del } from './request';

// Example usage of the safe request helper

// ✅ Correct: hits https://api.nxoland.com/api/members
export async function getMembers() {
  return get('/api/members');
}

// ✅ Correct: hits https://api.nxoland.com/api/products
export async function getProducts() {
  return get('/api/products');
}

// ✅ Correct: hits https://api.nxoland.com/api/auth/login
export async function loginUser(credentials: { email: string; password: string }) {
  return post('/api/auth/login', credentials);
}

// ✅ Correct: hits https://api.nxoland.com/api/products/123
export async function getProduct(id: number) {
  return get(`/api/products/${id}`);
}

// ✅ Correct: hits https://api.nxoland.com/api/cart
export async function getCart() {
  return get('/api/cart');
}

// ✅ Correct: hits https://api.nxoland.com/api/orders
export async function createOrder(orderData: any) {
  return post('/api/orders', orderData);
}

// ✅ Correct: hits https://api.nxoland.com/api/products/123
export async function updateProduct(id: number, data: any) {
  return put(`/api/products/${id}`, data);
}

// ✅ Correct: hits https://api.nxoland.com/api/products/123
export async function deleteProduct(id: number) {
  return del(`/api/products/${id}`);
}

// ✅ Using the base request function for custom requests
export async function uploadFile(file: File) {
  const formData = new FormData();
  formData.append('file', file);
  
  return request('/api/upload', {
    method: 'POST',
    body: formData,
    // Don't set Content-Type, let browser set it for FormData
    headers: {}
  });
}

// ✅ Example with query parameters
export async function searchProducts(query: string, filters?: any) {
  const params = new URLSearchParams();
  params.append('q', query);
  if (filters) {
    Object.entries(filters).forEach(([key, value]) => {
      if (value !== undefined && value !== null) {
        params.append(key, value.toString());
      }
    });
  }
  
  return get(`/api/products/search?${params}`);
}
