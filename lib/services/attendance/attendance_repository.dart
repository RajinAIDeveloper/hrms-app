import 'package:root_app/models/attendance/attendance_response_model.dart';
import 'package:root_app/models/attendance/employee_manual_attendance_dto.dart';
import 'package:root_app/models/attendance/geolocation_attendance_model.dart';
import 'package:root_app/models/attendance/manual_attendance_model.dart';
import 'package:root_app/models/attendance/submit_attendance.dart';
import 'package:root_app/views/Attendance/components/geo_location.dart';

abstract class AttendanceRepository {
  Future<AttendanceResponseModel> markCheckInOutAttendance();
  Future<List<GeoLocationAttendanceModel>> getGeoLocationAttendance(
      GeoLocationAttendanceModel model);
  Future<bool> submitGeoLocationAttendance(SubmitAttendanceModel model);
  Future<List<Employee>> fetchEmployees();
  Future<List<ManualAttendanceModel>> getEmployeeManualAttendances({
    required int employeeId, // Added as required
    required int pageNumber,
    required int pageSize,
    // String? searchText,
    // String? fromDate,
    // String? toDate,
  });
  Future<bool> saveManualAttendance(EmployeeManualAttendanceDTO model);
}
