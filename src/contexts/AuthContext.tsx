import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { User } from '@/lib/api';
import { request, get, post } from '@/lib/request';

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (email: string, password: string, remember?: boolean) => Promise<void>;
  register: (name: string, email: string, password: string, passwordConfirmation: string, phone?: string) => Promise<void>;
  logout: () => Promise<void>;
  refreshUser: () => Promise<void>;
  updateKYCStatus: (step: 'email' | 'phone' | 'identity', verified: boolean) => Promise<void>;
  completeKYC: () => Promise<void>;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}

interface AuthProviderProps {
  children: ReactNode;
}

function AuthProvider({ children }: AuthProviderProps) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  const isAuthenticated = !!user;

  useEffect(() => {
  const initAuth = async () => {
    try {
      const token = localStorage.getItem('auth_token');
      if (token) {
        const userData = await get('/api/auth/me');
        setUser(userData);
      }
    } catch (error) {
      console.error('Failed to initialize auth:', error);
      localStorage.removeItem('auth_token');
    } finally {
      setIsLoading(false);
    }
  };

    initAuth();
  }, []);

  const login = async (email: string, password: string, remember = false) => {
    try {
      setIsLoading(true);
      console.log('🔑 AuthContext: Logging in...', { email });
      
      const response = await post('/api/auth/login', { email, password, remember });
      
      console.log('👤 AuthContext: Setting user', response.user);
      setUser(response.user);
      
      console.log('✅ AuthContext: Login complete, user authenticated');
    } catch (error) {
      console.error('❌ AuthContext: Login failed:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const register = async (
    name: string,
    email: string,
    password: string,
    passwordConfirmation: string,
    phone?: string
  ) => {
    try {
      setIsLoading(true);
      const response = await post('/api/auth/register', {
        name,
        email,
        password,
        password_confirmation: passwordConfirmation,
        phone,
      });
      setUser(response.user);
    } catch (error) {
      console.error('Registration failed:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const logout = async () => {
    try {
      await post('/api/auth/logout');
    } catch (error) {
      console.error('Logout failed:', error);
    } finally {
      setUser(null);
      localStorage.removeItem('auth_token');
    }
  };

  const refreshUser = async () => {
    try {
      const token = localStorage.getItem('auth_token');
      if (token) {
        const userData = await get('/api/auth/me');
        setUser(userData);
      }
    } catch (error) {
      console.error('Failed to refresh user:', error);
      setUser(null);
      localStorage.removeItem('auth_token');
    }
  };

  const updateKYCStatus = async (step: 'email' | 'phone' | 'identity', verified: boolean) => {
    try {
      console.log(`🔐 AuthContext: Updating KYC ${step} status to ${verified}`);
      
      // Update local user state immediately for UI responsiveness
      setUser(prev => {
        if (!prev) return prev;
        
        const updatedUser = { ...prev };
        switch (step) {
          case 'email':
            updatedUser.emailVerified = verified;
            break;
          case 'phone':
            updatedUser.phoneVerified = verified;
            break;
          case 'identity':
            updatedUser.kycStatus = verified ? 'verified' : 'incomplete';
            break;
        }
        return updatedUser;
      });

      // Send update to backend
      await post('/api/auth/kyc/update', { step, verified });
      
      console.log(`✅ AuthContext: KYC ${step} status updated successfully`);
    } catch (error) {
      console.error(`❌ AuthContext: Failed to update KYC ${step} status:`, error);
      throw error;
    }
  };

  const completeKYC = async () => {
    try {
      console.log('🎉 AuthContext: Completing KYC verification');
      
      // Update local user state
      setUser(prev => {
        if (!prev) return prev;
        return {
          ...prev,
          emailVerified: true,
          phoneVerified: true,
          kycStatus: 'verified',
          kycCompletedAt: new Date().toISOString(),
        };
      });

      // Send completion to backend
      await post('/api/auth/kyc/complete');
      
      console.log('✅ AuthContext: KYC verification completed successfully');
    } catch (error) {
      console.error('❌ AuthContext: Failed to complete KYC:', error);
      throw error;
    }
  };

  const value: AuthContextType = {
    user,
    isAuthenticated,
    isLoading,
    login,
    register,
    logout,
    refreshUser,
    updateKYCStatus,
    completeKYC,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export { useAuth, AuthProvider };
