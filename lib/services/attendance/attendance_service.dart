import 'package:dio/dio.dart';
import 'package:root_app/models/attendance/attendance_response_model.dart';
import 'package:root_app/models/attendance/employee_manual_attendance_dto.dart';
import 'package:root_app/models/attendance/geolocation_attendance_model.dart';
import 'package:root_app/models/attendance/manual_attendance_model.dart';
import 'package:root_app/models/attendance/submit_attendance.dart';
import 'package:root_app/network/apis/attendance_api.dart';
import 'package:root_app/services/attendance/attendance_repository.dart';
import 'package:root_app/views/Attendance/components/geo_location.dart';

class AttendanceService implements AttendanceRepository {
  final AttendanceApi api;

  AttendanceService({required this.api});

  @override
  Future<AttendanceResponseModel> markCheckInOutAttendance() async {
    try {
      final response = await api.checkAttendance();

      return AttendanceResponseModel.fromJson(response.data[0]);
    } catch (e) {
      return AttendanceResponseModel(error: true, errorMessage: e.toString());
    }
  }

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await api.getEmployees();
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch employees: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<GeoLocationAttendanceModel>> getGeoLocationAttendance(
      GeoLocationAttendanceModel model) async {
    try {
      final response = await api.fetchGeoLocationAttendance(model.toJson());

      if (response.statusCode == 200) {
        // ✅ Ensure response.data is correctly decoded
        final List<dynamic> responseData = response.data;

        return responseData
            .map((item) => GeoLocationAttendanceModel.fromJson(
                item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Service Error: $e");
    }
  }

  @override
  Future<bool> submitGeoLocationAttendance(SubmitAttendanceModel model) async {
    try {
      final response = await api.submitGeoLocationAttendanceapi(model.toJson());
      if (response.statusCode == 200) {
        return true; // ✅ Submission successful
      } else {
        print("Submission failed: ${response.statusCode} - ${response.data}");
        return false; // ❌ Submission failed
      }
    } catch (e) {
      print("Repository Submission Error: $e");
      return false; // 🚨 Ensure all cases return a value
    }
  }

  @override
  Future<List<ManualAttendanceModel>> getEmployeeManualAttendances({
    required int employeeId, // Added as required
    required int pageNumber,
    required int pageSize,
    // String? searchText,
    // String? fromDate,
    // String? toDate,
  }) async {
    try {
      // Construct the filter map with employeeId
      final Map<String, dynamic> filter = {
        'employeeId': employeeId, // Include employeeId
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        // if (searchText != null) 'searchText': searchText,
        // if (fromDate != null) 'fromDate': fromDate,
        // if (toDate != null) 'toDate': toDate,
      };

      // Log the filter for debugging
      print("Sending filter to API: $filter");

      // Make the API call
      final response = await api.getEmployeeManualAttendances(filter);

      // Check response status
      if (response.statusCode == 200) {
        final List<dynamic> responseData = response.data;
        return responseData
            .map((item) =>
                ManualAttendanceModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("API Error: ${response.statusCode} - ${response.data}");
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors with detailed response info
      final errorMessage = e.response != null
          ? "Dio Error: ${e.response?.statusCode} - ${e.response?.data}"
          : "Dio Error: ${e.message}";
      throw Exception(errorMessage);
    } catch (e) {
      // Catch any other unexpected errors
      throw Exception("Service Error: $e");
    }
  }

  @override
  Future<bool> saveManualAttendance(EmployeeManualAttendanceDTO model) async {
    try {
      final response = await api.saveManualAttendance(model.toJson());

      if (response.statusCode == 200) {
        final data = response.data;
        return data['status'] == true;
      }
      return false;
    } catch (e) {
      print("Error saving manual attendance: $e");
      return false;
    }
  }
}
