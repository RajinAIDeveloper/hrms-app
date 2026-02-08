import apiClient from './api';
import {
  EmployeeManualAttendanceDTO,
  ManualAttendanceModel,
  ManualAttendanceResponse,
  GetManualAttendanceParams
} from '../types/attendance.types';

// Manual Attendance API endpoints
export const attendanceApi = {
  // Submit manual attendance request
  saveManualAttendance: (data: EmployeeManualAttendanceDTO) =>
    apiClient.post<ManualAttendanceResponse>(
      '/HRMS/Attendance/ManualAttendance/SaveManualAttendanceApp',
      data
    ),

  // Get employee manual attendance records
  getManualAttendances: (params: GetManualAttendanceParams) =>
    apiClient.get<ManualAttendanceModel[]>(
      '/HRMS/Attendance/ManualAttendance/GetEmployeeManualAttendances',
      { params }
    ),
};

export default attendanceApi;
