import React, { createContext, useState, useContext, useEffect, ReactNode } from 'react';
import * as SecureStore from 'expo-secure-store';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { jwtDecode } from 'jwt-decode';
import { router } from 'expo-router';
import { authApi } from '../services/api';
import { User, AuthContextType } from '../types/auth.types';

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  // Check authentication state on app load
  const checkAuthState = async () => {
    try {
      setIsLoading(true);

      // Get token and user data from storage
      const storedToken = await SecureStore.getItemAsync('token');
      const storedUserData = await AsyncStorage.getItem('userData');

      if (storedToken && storedUserData) {
        const userData = JSON.parse(storedUserData);

        console.log('Loaded cached user data:', userData);

        // Check password expiry (30 days from login)
        const passwordExpiry = new Date(userData.passwordExpiry);
        const now = new Date();

        if (passwordExpiry < now) {
          // Password expired, clear storage and logout
          await logout();
          return;
        }

        // Valid token and user data found
        setToken(storedToken);
        setUser(userData);
        setIsAuthenticated(true);
      } else {
        // No valid auth data found
        setIsAuthenticated(false);
      }
    } catch (error) {
      console.error('Error checking auth state:', error);
      setIsAuthenticated(false);
    } finally {
      setIsLoading(false);
    }
  };

  // Login function
  const login = async (username: string, password: string) => {
    try {
      setIsLoading(true);

      // Call login API
      const response = await authApi.login({ username, password, remember: true });

      // Log the response to see the actual structure
      console.log('Login API Response:', JSON.stringify(response.data, null, 2));

      const { token: jwtToken, refreshToken } = response.data;

      // Validate JWT token is a string and not null/undefined
      if (!jwtToken || typeof jwtToken !== 'string') {
        console.error('Token validation failed:', { jwtToken, type: typeof jwtToken });
        throw new Error('Invalid token received from server');
      }

      // RefreshToken is optional - some APIs don't provide it
      // We'll only store it if it's a valid string
      const hasValidRefreshToken = refreshToken && typeof refreshToken === 'string';

      // Decode JWT to extract user information
      const decodedToken: any = jwtDecode(jwtToken);

      // The JWT has a 'userinfo' field that's a JSON string - we need to parse it
      let userInfo: any = {};
      if (decodedToken.userinfo) {
        try {
          userInfo = JSON.parse(decodedToken.userinfo);
        } catch (e) {
          console.error('Error parsing userinfo from JWT:', e);
          // Fallback to using decodedToken directly
          userInfo = decodedToken;
        }
      } else {
        // Fallback to using decodedToken directly if no userinfo field
        userInfo = decodedToken;
      }

      // Extract user data from parsed userinfo
      const userData: User = {
        userId: userInfo.userId || decodedToken.sub || '',
        username: userInfo.username || decodedToken.unique_name || username,
        employeeId: parseInt(userInfo.employeeId) || 0,
        employeeCode: userInfo.employeeCode || '',
        employeeName: userInfo.employeeName || '',
        photoPath: userInfo.photoPath || '',
        roleId: userInfo.roleId || '',
        roleName: userInfo.roleName || '',
        designationId: parseInt(userInfo.designationId) || 0,
        designationName: userInfo.designationName || '',
        companyId: parseInt(userInfo.companyId) || 0,
        organizationId: parseInt(userInfo.organizationId) || 0,
        branchId: parseInt(userInfo.branchId) || 0,
        branchName: userInfo.branchName || '',
        divisionId: parseInt(userInfo.divisionId) || 0,
        divisionName: userInfo.divisionName || '',
        departmentId: parseInt(userInfo.departmentId) || 0,
        departmentName: userInfo.departmentName || '',
        sectionId: parseInt(userInfo.sectionId) || 0,
        sectionName: userInfo.sectionName || '',
        subSectionId: parseInt(userInfo.subSectionId) || 0,
        subSectionName: userInfo.subSectionName || '',
        gradeId: parseInt(userInfo.gradeId) || 0,
        gradeName: userInfo.gradeName || '',
        isActive: userInfo.isActive === 'true' || userInfo.isActive === true,
        isDefaultPassword: userInfo.isDefaultPassword === 'true' || userInfo.isDefaultPassword === true,
        defaultCode: userInfo.defaultCode || '',
        passwordExpiredDate: userInfo.passwordExpiredDate || '',
        remainExpireDays: parseInt(userInfo.remainExpireDays) || 30,
        siteThumbnailPath: userInfo.siteThumbnailPath || '',
        siteShortName: userInfo.siteShortName || '',
      };

      console.log('Extracted user data:', userData);
      console.log('Photo Path from API:', userInfo.photoPath);
      console.log('Photo Path type:', typeof userInfo.photoPath);
      console.log('Photo Path is null?', userInfo.photoPath === null);
      console.log('Photo Path is undefined?', userInfo.photoPath === undefined);
      console.log('Photo Path is empty string?', userInfo.photoPath === '');

      // Set password expiry (30 days from now)
      const passwordExpiry = new Date();
      passwordExpiry.setDate(passwordExpiry.getDate() + 30);

      // Store tokens securely
      await SecureStore.setItemAsync('token', jwtToken);

      // Only store refresh token if it's valid
      if (hasValidRefreshToken) {
        await SecureStore.setItemAsync('refreshToken', refreshToken);
      } else {
        // Clear any existing refresh token if new one is not valid
        await SecureStore.deleteItemAsync('refreshToken').catch(() => {});
        console.warn('No valid refresh token provided by API');
      }

      // Store user data in AsyncStorage (with password expiry)
      const userDataWithExpiry = { ...userData, passwordExpiry: passwordExpiry.toISOString() };
      await AsyncStorage.setItem('userData', JSON.stringify(userDataWithExpiry));

      // Update state
      setToken(jwtToken);
      setUser(userData);
      setIsAuthenticated(true);

      // Navigate to main app
      router.replace('/(tabs)');
    } catch (error: any) {
      console.error('Login error:', error);

      // Handle specific error cases
      if (error.response) {
        // Server responded with error
        const statusCode = error.response.status;
        const errorMessage = error.response.data?.message || error.response.data?.error;

        if (statusCode === 401) {
          throw new Error('Invalid username or password');
        } else if (statusCode === 404) {
          throw new Error('User not found');
        } else if (errorMessage) {
          throw new Error(errorMessage);
        }
      } else if (error.request) {
        // Request made but no response
        throw new Error('Network error. Please check your connection.');
      }

      throw new Error('Login failed. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  // Logout function
  const logout = async () => {
    try {
      // Clear all auth data from storage
      await SecureStore.deleteItemAsync('token');
      await SecureStore.deleteItemAsync('refreshToken');
      await AsyncStorage.removeItem('userData');

      // Clear state
      setToken(null);
      setUser(null);
      setIsAuthenticated(false);

      // Navigate to login
      router.replace('/auth/login');
    } catch (error) {
      console.error('Logout error:', error);
    }
  };

  // Refresh access token
  const refreshAccessToken = async () => {
    try {
      const storedToken = await SecureStore.getItemAsync('token');
      const storedRefreshToken = await SecureStore.getItemAsync('refreshToken');

      if (!storedToken || !storedRefreshToken) {
        throw new Error('No tokens found');
      }

      const response = await authApi.refreshToken(storedToken, storedRefreshToken);
      const { token: newToken, refreshToken: newRefreshToken } = response.data;

      // Validate new tokens are strings
      if (!newToken || typeof newToken !== 'string') {
        throw new Error('Invalid token received during refresh');
      }
      if (!newRefreshToken || typeof newRefreshToken !== 'string') {
        throw new Error('Invalid refresh token received during refresh');
      }

      // Store new tokens
      await SecureStore.setItemAsync('token', newToken);
      await SecureStore.setItemAsync('refreshToken', newRefreshToken);

      setToken(newToken);
    } catch (error) {
      console.error('Token refresh error:', error);
      // If refresh fails, logout the user
      await logout();
    }
  };

  // Check auth state on mount
  useEffect(() => {
    checkAuthState();
  }, []);

  return (
    <AuthContext.Provider
      value={{
        user,
        token,
        isAuthenticated,
        isLoading,
        login,
        logout,
        refreshAccessToken,
        checkAuthState,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

// Custom hook to use auth context
export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};
