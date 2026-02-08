import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:root_app/models/workshift/employee-work-shift-model.dart';

import 'package:root_app/models/workshift/workshift-model.dart';
import 'package:root_app/network/apis/workshift_api.dart';

import 'package:root_app/network/dio_exceptions.dart';
import 'package:root_app/services/workshift/workshift_repository.dart';

class WorkshiftService implements WorkshiftRepository {
  final WorkshiftApi api;

  WorkshiftService({required this.api});

  @override
  Future<WorkshiftResponsemodel> workshiftlist() async {
    try {
      final response = await api.getEmployees();
      var result =
          WorkshiftResponsemodel.fromJson({'workshiftlist': response.data});
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  // Get weekly shifts
  // Future<List<EmployeeWorkShift>> getWeeklyShifts({int? employeeId}) async {
  //   try {
  //     final response = await api.getWeeklyShifts(employeeId: employeeId);
  //     final List<dynamic> data = response.data;
  //     return data.map((e) => EmployeeWorkShift.fromJson(e)).toList();
  //   } on DioException catch (e) {
  //     debugPrint('Error fetching weekly shifts: ${e.message}');
  //     rethrow;
  //   }
  // }

  Future<List<EmployeeWorkShift>> getWeeklyShifts({int? employeeId}) async {
    try {
      final response = await api.getWeeklyShifts(employeeId: employeeId);
      final List<dynamic> data = response.data;

      return data.map((e) => EmployeeWorkShift.fromJson(e)).toList();
    } on DioException catch (e) {
      debugPrint('❌ Error fetching weekly shifts: ${e.message}');
      rethrow;
    }
  }
}
