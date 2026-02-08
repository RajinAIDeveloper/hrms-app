import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:root_app/models/leave/employee_leave_request_model.dart';
import 'package:root_app/models/leave/holidays_response_model.dart';
import 'package:root_app/models/leave/leave_applied_records_response_model.dart';
import 'package:root_app/models/leave/leave_balance_response_model.dart';
import 'package:root_app/models/leave/leave_hierarchy_response_model.dart';
import 'package:root_app/models/leave/leave_type_dropdown_response_model.dart';
import 'package:root_app/models/leave/leave_type_setting_response_model.dart';
import 'package:root_app/network/apis/leave_api.dart';
import 'package:root_app/network/dio_exceptions.dart';
import 'package:root_app/services/leave/leave_repository.dart';

class LeaveService implements LeaveRepository {
  final LeaveApi api;

  LeaveService({required this.api});

  @override
  Future<HolidaysResponseModel> yearlyHolidays() async {
    try {
      final response = await api.getYearlyHolidays();
      var result = HolidaysResponseModel.fromJson({'holidays': response.data});
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  @override
  Future<LeaveBalanceResponseModel> yearlyLeaveBalance() async {
    try {
      final response = await api.getLeaveBalance();
      var result =
          LeaveBalanceResponseModel.fromJson({'leaveBalance': response.data});
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  @override
  Future<LeaveAppliedRecordsResponseModel> leaveAppliedRecords() async {
    try {
      final response = await api.getLeaveAppliedRecords();
      var result = LeaveAppliedRecordsResponseModel.fromJson(
          {'leaveAppliedRecords': response.data});
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  @override
  Future<LeaveTypeDropdownResponseModel> leaveTypeDropdown(
      int employeeId) async {
    try {
      final response = await api.getEmployeeLeaveBalancesDropdown(employeeId);
      var result = LeaveTypeDropdownResponseModel.fromJson(
          {'leaveTypes': response.data});
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  @override
  Future<LeaveHierarchyResponseModel> leaveHierarchy(int employeeId) async {
    try {
      final response = await api.getEmployeeActiveHierarchy(employeeId);
      var result = LeaveHierarchyResponseModel.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  @override
  Future<LeaveTypeSettingResponseModel> leaveTypeSetting(
      int leaveId, int employeeId) async {
    try {
      final response = await api.getLeaveTypeSetting(leaveId, employeeId);
      var result = LeaveTypeSettingResponseModel.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  ///can be changed
  //@override
  // Future<Map<String, dynamic>> saveEmployeeLeaveRequest(
  //     EmployeeLeaveRequest request, File? attachment) async {
  //   try {
  //     final response = await api.saveEmployeeLeaveRequest(request, attachment);
  //     return response.data;
  //   } on DioException catch (e) {
  //     final errorMessage = DioExceptions.fromDioError(e).toString();
  //     debugPrint(
  //         '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
  //     throw errorMessage;
  //   }
  // }
// API Service Layer
  Future<Map<String, dynamic>> saveEmployeeLeaveRequest(
      EmployeeLeaveRequest request, File? attachment) async {
    try {
      final response = await api.saveEmployeeLeaveRequest(request, attachment);
      return response.data;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    } catch (e) {
      debugPrint(
          '====================>>>>>> Unexpected error: $e  <<<<<<==================');
      throw 'An unexpected error occurred. Please try again later.';
    }
  }
}
