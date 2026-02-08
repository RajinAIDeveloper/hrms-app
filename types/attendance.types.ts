// Manual Attendance Types

export interface EmployeeManualAttendanceDTO {
  ManualAttendanceId: number;
  ManualAttendanceCode: string;
  EmployeeId: number;
  DepartmentId?: number | null;
  SectionId?: number | null;
  UnitId?: number | null;
  AttendanceDate: string; // ISO date string
  TimeRequestFor: 'Both' | 'In-Time' | 'Out-Time';
  InTime?: string | null; // Format: "HH:mm:ss"
  OutTime?: string | null; // Format: "HH:mm:ss"
  StateStatus: string;
  Reason: string;
  Remarks?: string | null;
}

export interface ManualAttendanceModel extends EmployeeManualAttendanceDTO {
  DesignationId?: number;
  DesignationName?: string;
  DepartmentName?: string;
  SectionName?: string;
  UnitName?: string;
  EmployeeCode?: string;
  EmployeeName?: string;
  IsApproved?: boolean | null;
  CreaterInfo?: string;
  UpdaterInfo?: string;
  ApproverInfo?: string;
  RejecterInfo?: string;
  CheckerInfo?: string;
  CancellerInfo?: string;
  SupervisorId?: number;
  SupervisorName?: string;
  HodId?: number;
  HodName?: string;
}

export interface ManualAttendanceResponse {
  status: boolean;
  message?: string;
}

export interface GetManualAttendanceParams {
  employeeId: number;
  pageNumber?: number;
  pageSize?: number;
}
