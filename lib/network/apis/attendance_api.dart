import 'package:dio/dio.dart';
import 'package:root_app/network/dio_client.dart';

class AttendanceApi {
  final DioClient dioClient;
  AttendanceApi({required this.dioClient});

  Future<Response> checkAttendance() async {
    try {
      final response = await dioClient.get(
        "/hrms/dashboard/AttendanceCommonDashboard/CheckPunchInAndPunchOut",
        queryParameters: {},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getEmployees() async {
    try {
      final response = await dioClient.get(
        "/hrms/dashboard/EmployeeLeaveDetails/GetEmployees", // Adjust based on your actual endpoint
        queryParameters: {}, // Add query params if needed
      );
      return response;
    } catch (e) {
      rethrow; // Propagate errors to the service layer
    }
  }

  // Future<Response> getGeoLocationAttendance(
  //     GeoLocationAttendanceModel model) async {
  //   try {
  //     final response = await dioClient.get(
  //       "/hrms/dashboard/AttendanceCommonDashboard/GetMyGeoLocationAttendance",
  //       queryParameters: model.toJson(),
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  Future<Response> fetchGeoLocationAttendance(
      Map<String, dynamic> params) async {
    try {
      return await dioClient.get(
        "/hrms/dashboard/AttendanceCommonDashboard/GetMyGeoLocationAttendance",
        queryParameters: params,
      );
    } catch (e) {
      throw Exception("API Error: $e");
    }
  }

  /// Submit GeoLocation Attendance Data
  Future<Response> submitGeoLocationAttendanceapi(
      Map<String, dynamic> data) async {
    try {
      return await dioClient.get(
        "/hrms/dashboard/AttendanceCommonDashboard/GetGeoLocationAttendanceData",
        queryParameters: data,
      );
    } catch (e) {
      throw Exception("API Submission Error: $e");
    }
  }

  Future<Response> getEmployeeManualAttendances(
      Map<String, dynamic> filter) async {
    try {
      return await dioClient.get(
        "/HRMS/Attendance/ManualAttendance/GetEmployeeManualAttendances",
        queryParameters: filter,
      );
    } catch (e) {
      throw Exception("API Error: $e");
    }
  }

  Future<Response> saveManualAttendance(Map<String, dynamic> data) async {
    try {
      // Convert any DateTime objects to ISO string format
      if (data['AttendanceDate'] is DateTime) {
        data['AttendanceDate'] = data['AttendanceDate'].toIso8601String();
      }

      return await dioClient.post(
        "/HRMS/Attendance/ManualAttendance/SaveManualAttendanceApp",
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );
    } catch (e) {
      throw Exception("API Error: $e");
    }
  }
}
