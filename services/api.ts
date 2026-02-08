import axios, { AxiosError, AxiosInstance, InternalAxiosRequestConfig, AxiosResponse } from 'axios';
import * as SecureStore from 'expo-secure-store';
import { LoginRequest, LoginResponse } from '../types/auth.types';

// API Base URL Configuration
const PRODUCTION_URL = 'http://13.127.139.229:9088/api';

// Automatically select the right URL based on environment
const getBaseUrl = () => {
  // Using production server for both development and production
  return PRODUCTION_URL;
};

const API_BASE_URL = getBaseUrl();

// Create axios instance
const apiClient: AxiosInstance = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
apiClient.interceptors.request.use(
  async (config: InternalAxiosRequestConfig) => {
    try {
      const token = await SecureStore.getItemAsync('token');
      if (token) {
        config.headers.Authorization = `Bearer ${token}`;
      }
    } catch (error) {
      console.log('Error getting token from secure store:', error);
    }
    return config;
  },
  (error: AxiosError) => {
    return Promise.reject(error);
  }
);

// Response interceptor for error handling
apiClient.interceptors.response.use(
  (response: AxiosResponse) => response,
  async (error: AxiosError) => {
    const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean };

    // Handle 401 errors (unauthorized) - attempt token refresh
    if (error.response?.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshToken = await SecureStore.getItemAsync('refreshToken');
        const token = await SecureStore.getItemAsync('token');

        if (refreshToken && token) {
          // Attempt to refresh the token
          const response = await axios.post(`${API_BASE_URL}/tokens/refresh`, {
            token,
            refreshToken,
          });

          const { token: newToken, refreshToken: newRefreshToken } = response.data;

          // Store new tokens
          await SecureStore.setItemAsync('token', newToken);
          await SecureStore.setItemAsync('refreshToken', newRefreshToken);

          // Retry the original request with new token
          originalRequest.headers.Authorization = `Bearer ${newToken}`;
          return apiClient(originalRequest);
        }
      } catch (refreshError) {
        // Refresh failed - user needs to login again
        // Clear all auth data
        await SecureStore.deleteItemAsync('token');
        await SecureStore.deleteItemAsync('refreshToken');
        return Promise.reject(refreshError);
      }
    }

    return Promise.reject(error);
  }
);

// Authentication API endpoints
export const authApi = {
  login: (credentials: LoginRequest) =>
    apiClient.post<LoginResponse>('/controlpanel/access/LoginByMobile', credentials),

  refreshToken: (token: string, refreshToken: string) =>
    apiClient.post('/tokens/refresh', { token, refreshToken }),

  // Forgot password endpoints (for future implementation)
  forgetPassword: (email: string) =>
    apiClient.post('/controlpanel/access/ForgetPassword', { email }),

  forgetPasswordVerification: (data: { email: string; otp: string; newPassword: string }) =>
    apiClient.post('/controlpanel/access/ForgetPasswordVerification', data),
};

// Export API client for other services to use
export default apiClient;
