export interface YearlyHoliday {
  yearlyHolidayId: number;
  title: string;
  startDate: string;
  endDate: string;
  type: string;
  remarks?: string | null;
  isDepandentOnMoon?: boolean;
}

export interface GetYearlyHolidaysResponse {
  holidays: YearlyHoliday[];
}

export interface LeaveBalanceItem {
  LeaveTypeId: number;
  LeaveTypeName: string;
  SerialNo?: number;
  AllottedLeave: number;
  YearlyLeaveTypeAvailed: number;
  YearlyLeaveTypeBalance: number;
}

export interface GetMyLeaveHistoryResponse {
  leaveBalance: LeaveBalanceItem[];
}

export interface LeaveAppliedRecord {
  employeeLeaveRequestId: number;
  title: string;
  appliedTotalDays: number;
  appliedFromDate: string;
  appliedToDate: string;
  stateStatus: string;
  approvalRemarks?: string | null;
}

export interface GetMyLeaveAppliedRecordsResponse {
  leaveAppliedRecords: LeaveAppliedRecord[];
}

export interface SaveLeaveRequestResponse {
  status?: boolean;
  message?: string;
}

