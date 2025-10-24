// Safe request helper for API calls
const API_BASE = (import.meta.env.VITE_API_BASE_URL || 'https://api.nxoland.com').replace(/\/$/, '');

export async function request(path: string, options?: RequestInit) {
  const url = `${API_BASE}${path.startsWith('/') ? '' : '/'}${path}`;
  
  // Only log in development
  if (import.meta.env.DEV) {
    console.log('🌐 Making API request to:', url);
  }
  
  const res = await fetch(url, {
    headers: { 'Content-Type': 'application/json' },
    ...options,
  });
  
  // Only log in development
  if (import.meta.env.DEV) {
    console.log('📡 API response status:', res.status);
    console.log('📡 API response headers:', Object.fromEntries(res.headers.entries()));
  }
  
  if (!res.ok) {
    // surface clearer errors in React Query devtools/console
    const text = await res.text().catch(() => '');
    if (import.meta.env.DEV) {
      console.error('❌ API request failed:', text);
    }
    throw new Error(`HTTP ${res.status} on ${url}: ${text || res.statusText}`);
  }
  
  const contentType = res.headers.get('content-type');
  if (import.meta.env.DEV) {
    console.log('📄 Content-Type:', contentType);
  }
  
  if (contentType?.includes('application/json')) {
    return res.json();
  } else {
    const text = await res.text();
    if (import.meta.env.DEV) {
      console.log('📄 Non-JSON response:', text.substring(0, 100));
    }
    throw new Error(`Expected JSON but got ${contentType}: ${text.substring(0, 100)}`);
  }
}

// Helper for GET requests
export async function get<T>(path: string): Promise<T> {
  return request(path, { method: 'GET' });
}

// Helper for POST requests
export async function post<T>(path: string, data?: any): Promise<T> {
  return request(path, {
    method: 'POST',
    body: data ? JSON.stringify(data) : undefined,
  });
}

// Helper for PUT requests
export async function put<T>(path: string, data?: any): Promise<T> {
  return request(path, {
    method: 'PUT',
    body: data ? JSON.stringify(data) : undefined,
  });
}

// Helper for DELETE requests
export async function del<T>(path: string): Promise<T> {
  return request(path, { method: 'DELETE' });
}

// Helper for PATCH requests
export async function patch<T>(path: string, data?: any): Promise<T> {
  return request(path, {
    method: 'PATCH',
    body: data ? JSON.stringify(data) : undefined,
  });
}
