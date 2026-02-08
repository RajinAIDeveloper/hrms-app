import 'package:dio/dio.dart';
import 'package:root_app/network/dio_client.dart';

class WorkshiftApi {
  final DioClient dioClient;
  WorkshiftApi({required this.dioClient});

  Future<Response> getEmployees() async {
    try {
      final response = await dioClient.get(
        "/hrms/dashboard/CommonDashboard/GetEmployeeContact",
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Future<Response> getWeeklyShifts({int? employeeId}) async {
  //   // final body = {
  //   //   if (employeeId != null) 'employeeId': employeeId,
  //   // };

  //   final body = {
  //     if (employeeId != null && employeeId != 0) 'EmployeeId': employeeId,
  //   };

  //   return dioClient.post(
  //     "/hrms/dashboard/Workshift/GetWeeklyShifts",
  //     data: body,
  //   );
  // }
  Future<Response> getWeeklyShifts({int? employeeId}) async {
    final body = <String, dynamic>{};
    if (employeeId != null && employeeId != 0) {
      body['EmployeeId'] = employeeId; // Must match backend property
    }

    return dioClient.post(
      "/hrms/Attendance/EmployeeShift/GetWeeklyShifts",
      data: body,
    );
  }
}
