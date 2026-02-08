// Authentication-related TypeScript interfaces

export interface User {
  userId: string;
  username: string;
  employeeId: number;
  employeeCode: string;
  employeeName: string;
  photoPath: string;
  roleId: string;
  roleName: string;
  designationId: number;
  designationName: string;
  companyId: number;
  organizationId: number;
  branchId: number;
  branchName: string;
  divisionId: number;
  divisionName: string;
  departmentId: number;
  departmentName: string;
  sectionId: number;
  sectionName: string;
  subSectionId: number;
  subSectionName: string;
  gradeId: number;
  gradeName: string;
  isActive: boolean;
  isDefaultPassword: boolean;
  defaultCode: string;
  passwordExpiredDate: string;
  remainExpireDays: number;
  siteThumbnailPath: string;
  siteShortName: string;
}

export interface LoginRequest {
  username: string;
  password: string;
  remember?: boolean;
  clientID?: string;
  email?: string;
}

export interface LoginResponse {
  token: string;
  refreshToken: string;
  refreshTokenExpiryTime: string;
  passObj: {
    isDefaultPassword: boolean;
    defaultCode: string;
    isPasswordExpired: boolean;
    remainExpireDays: number;
  };
}

export interface AuthContextType {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  login: (username: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  refreshAccessToken: () => Promise<void>;
  checkAuthState: () => Promise<void>;
}
