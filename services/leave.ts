import apiClient from './api';
import {
  GetMyLeaveAppliedRecordsResponse,
  GetMyLeaveHistoryResponse,
  GetYearlyHolidaysResponse,
  SaveLeaveRequestResponse,
} from '../types/leave.types';

export const leaveApi = {
  getYearlyHolidays: () =>
    apiClient.get<GetYearlyHolidaysResponse>('/HRMS/Attendance/YearlyHoliday/GetYearlyHolidays'),

  getLeaveBalance: (params: { ToYear: number; ToMonth: number }) =>
    apiClient.get<GetMyLeaveHistoryResponse>('/hrms/dashboard/MyLeaveHistory/GetMyLeaveHistory', { params }),

  getLeaveAppliedRecords: () =>
    apiClient.get<GetMyLeaveAppliedRecordsResponse>(
      '/hrms/dashboard/LeaveCommonDashboard/GetMyLeaveAppliedRecords'
    ),

  saveLeaveRequest: (data: FormData) =>
    apiClient.post<SaveLeaveRequestResponse>(
      '/hrms/leave/LeaveRequest/SaveEmployeeLeaveRequest3',
      data,
      {
        headers: { 'Content-Type': 'multipart/form-data' },
      }
    ),
};

export default leaveApi;

