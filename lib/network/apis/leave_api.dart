import 'dart:io';

import 'package:dio/dio.dart';
import 'package:root_app/models/leave/employee_leave_request_model.dart';
import 'package:root_app/network/dio_client.dart';

class LeaveApi {
  final DioClient dioClient;
  LeaveApi({required this.dioClient});

  Future<Response> getYearlyHolidays() async {
    try {
      final response = await dioClient.get(
        "/HRMS/Attendance/YearlyHoliday/GetYearlyHolidays",
        // "/hrms/dashboard/CommonDashboard/GetCompanyHolidayAndEvents"
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getLeaveBalance() async {
    try {
      var today = DateTime.now();
      String queryParam = "?ToYear=${today.year}&ToMonth=${today.month}";
      final response = await dioClient.get(
        "/hrms/dashboard/MyLeaveHistory/GetMyLeaveHistory$queryParam",
        // "/HRMS/Leave/LeaveRequest/GetMyLeaveHistory$queryParam",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getLeaveAppliedRecords() async {
    try {
      //String queryParam = "?pageNumber=1&pageSize=5";
      final response = await dioClient.get(
        "/hrms/dashboard/LeaveCommonDashboard/GetMyLeaveAppliedRecords", //$queryParam
        // "/HRMS/Leave/LeaveRequest/GetMyLeaveAppliedRecords",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getEmployeeLeaveBalancesDropdown(int employeeId) async {
    try {
      String queryParam = "?employeeId=$employeeId";
      final response = await dioClient.get(
        "/hrms/leave/employeeLeaveBalance/GetEmployeeLeaveBalancesDropdown$queryParam",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getEmployeeActiveHierarchy(int id) async {
    try {
      String queryParam = "?id=$id";
      final response = await dioClient.get(
        "/hrms/Employee/Hierarchy/GetEmployeeActiveHierarchy$queryParam",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getLeaveTypeSetting(int leaveTypeId, int employeeId) async {
    try {
      String queryParam = "?leaveTypeId=$leaveTypeId&employeeId=$employeeId";
      final response = await dioClient.get(
        "/hrms/leave/leaveSetting/GetLeaveTypeSetting$queryParam",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ///can be changed
  // Future<Response> saveEmployeeLeaveRequest(
  //     EmployeeLeaveRequest request, File? attachment) async {
  //   try {
  //     final formData = FormData.fromMap(request.toJson());

  //     if (attachment != null) {
  //       formData.files.add(MapEntry(
  //         'File',
  //         await MultipartFile.fromFile(
  //           attachment.path,
  //           filename: attachment.path.split('/').last,
  //         ),
  //       ));
  //     }

  //     final response = await dioClient.post(
  //       "/hrms/leave/LeaveRequest/SaveEmployeeLeaveRequest3",
  //       data: formData,
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Dio Client Layer
  Future<Response> saveEmployeeLeaveRequest(
      EmployeeLeaveRequest request, File? attachment) async {
    try {
      final formData = FormData.fromMap(request.toJson());

      if (attachment != null) {
        formData.files.add(MapEntry(
          'File',
          await MultipartFile.fromFile(
            attachment.path,
            filename: attachment.path.split('/').last,
          ),
        ));
      }

      final response = await dioClient.post(
        "/hrms/leave/LeaveRequest/SaveEmployeeLeaveRequest3",
        data: formData,
      );
      return response;
    } on DioException {
      rethrow; // Let the service layer handle Dio exceptions
    } catch (e) {
      // Convert any other exceptions to a string message
      throw 'Error processing request: $e';
    }
  }
}
