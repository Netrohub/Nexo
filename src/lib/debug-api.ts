// Debug API calls to troubleshoot the frontend-backend connection
import { request, get } from './request';

// Test function to debug API calls
export async function debugApiCalls() {
  console.log('🔍 Starting API debug...');
  
  // Test 1: Check environment variable
  console.log('🌍 VITE_API_BASE_URL:', import.meta.env.VITE_API_BASE_URL);
  
  // Test 2: Test ping endpoint
  try {
    console.log('🧪 Testing /api/ping...');
    const pingResult = await get('/api/ping');
    console.log('✅ Ping result:', pingResult);
  } catch (error) {
    console.error('❌ Ping failed:', error);
  }
  
  // Test 3: Test products endpoint
  try {
    console.log('🧪 Testing /api/products...');
    const productsResult = await get('/api/products');
    console.log('✅ Products result:', productsResult);
  } catch (error) {
    console.error('❌ Products failed:', error);
  }
  
  // Test 4: Test direct fetch
  try {
    console.log('🧪 Testing direct fetch...');
    const response = await fetch('https://api.nxoland.com/api/ping');
    console.log('📡 Direct fetch status:', response.status);
    console.log('📡 Direct fetch headers:', Object.fromEntries(response.headers.entries()));
    const text = await response.text();
    console.log('📄 Direct fetch response:', text);
  } catch (error) {
    console.error('❌ Direct fetch failed:', error);
  }
}

// Export for use in components
export { debugApiCalls };
