import { request } from './request';

// Safe admin API client using the request helper
export const adminApiClient = {
  async get<T>(url: string): Promise<T> {
    return request(`/admin${url}`, { method: 'GET' });
  },
  
  async post<T>(url: string, data?: any): Promise<T> {
    return request(`/admin${url}`, {
      method: 'POST',
      body: data ? JSON.stringify(data) : undefined,
    });
  },
  
  async put<T>(url: string, data?: any): Promise<T> {
    return request(`/admin${url}`, {
      method: 'PUT',
      body: data ? JSON.stringify(data) : undefined,
    });
  },
  
  async delete<T>(url: string): Promise<T> {
    return request(`/admin${url}`, { method: 'DELETE' });
  },
  
  async patch<T>(url: string, data?: any): Promise<T> {
    return request(`/admin${url}`, {
      method: 'PATCH',
      body: data ? JSON.stringify(data) : undefined,
    });
  }
};

export default adminApiClient;
