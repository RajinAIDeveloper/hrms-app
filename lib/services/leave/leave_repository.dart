import 'dart:io';

import 'package:root_app/models/leave/employee_leave_request_model.dart';
import 'package:root_app/models/leave/holidays_response_model.dart';
import 'package:root_app/models/leave/leave_applied_records_response_model.dart';
import 'package:root_app/models/leave/leave_balance_response_model.dart';
import 'package:root_app/models/leave/leave_hierarchy_response_model.dart';
import 'package:root_app/models/leave/leave_type_dropdown_response_model.dart';
import 'package:root_app/models/leave/leave_type_setting_response_model.dart';

abstract class LeaveRepository {
  Future<HolidaysResponseModel> yearlyHolidays();
  Future<LeaveBalanceResponseModel> yearlyLeaveBalance();
  Future<LeaveAppliedRecordsResponseModel> leaveAppliedRecords();
  Future<LeaveTypeDropdownResponseModel> leaveTypeDropdown(int employeeId);
  Future<LeaveHierarchyResponseModel> leaveHierarchy(int employeeId);
  Future<LeaveTypeSettingResponseModel> leaveTypeSetting(
      int leaveId, int employeeId);
  //new
  Future<Map<String, dynamic>> saveEmployeeLeaveRequest(
      EmployeeLeaveRequest request, File? attachment);
}
