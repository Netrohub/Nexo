// Debug script to test frontend API calls
// Run this in your browser console to debug the issue

console.log('🔍 Debugging Frontend API Calls...');

// Check environment variables
console.log('🌍 VITE_API_BASE_URL:', import.meta.env.VITE_API_BASE_URL);
console.log('🌍 VITE_APP_NAME:', import.meta.env.VITE_APP_NAME);
console.log('🌍 VITE_APP_ENV:', import.meta.env.VITE_APP_ENV);

// Test direct fetch to API endpoints
async function testApiEndpoints() {
  const endpoints = [
    '/api/ping',
    '/api/products',
    '/api/members',
    '/api/orders',
    '/api/cart'
  ];
  
  for (const endpoint of endpoints) {
    try {
      console.log(`🧪 Testing ${endpoint}...`);
      const response = await fetch(`https://api.nxoland.com${endpoint}`);
      console.log(`📡 Status: ${response.status}`);
      console.log(`📡 Headers:`, Object.fromEntries(response.headers.entries()));
      
      const text = await response.text();
      console.log(`📄 Response:`, text.substring(0, 200));
      
      if (text.startsWith('<!doctype') || text.startsWith('<html')) {
        console.error(`❌ ${endpoint} returned HTML instead of JSON`);
      } else {
        console.log(`✅ ${endpoint} returned JSON`);
      }
    } catch (error) {
      console.error(`❌ ${endpoint} failed:`, error);
    }
    console.log('---');
  }
}

// Test the request helper
async function testRequestHelper() {
  try {
    console.log('🧪 Testing request helper...');
    
    // Import the request helper (you'll need to adjust this path)
    const { request } = await import('./src/lib/request.ts');
    
    console.log('📡 Testing /api/ping with request helper...');
    const result = await request('/api/ping');
    console.log('✅ Request helper result:', result);
  } catch (error) {
    console.error('❌ Request helper failed:', error);
  }
}

// Run the tests
testApiEndpoints();
testRequestHelper();
