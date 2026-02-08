class SubmitAttendanceModel {
  final String? attendanceDate;
  final String? attendanceTime;
  final String attendanceLocation;
  final String attendanceRemarks;
  final String actionName;
  final String attendanceType;
  final String? selectedEmployeeId;

  SubmitAttendanceModel({
    required this.attendanceDate,
    required this.attendanceTime,
    required this.attendanceLocation,
    required this.attendanceRemarks,
    required this.actionName,
    required this.attendanceType,
    this.selectedEmployeeId,
  });

  // Convert model to JSON (for API request)
  Map<String, dynamic> toJson() {
    return {
      "AttendanceDate": attendanceDate,
      "AttendanceTime": attendanceTime,
      "AttendanceLocation": attendanceLocation,
      "AttendanceRemarks": attendanceRemarks,
      "ActionName": actionName,
      "AttendanceType": attendanceType,
      "SelectedEmployeeId": selectedEmployeeId,
    };
  }

  // Convert JSON response to Dart model
  factory SubmitAttendanceModel.fromJson(Map<String, dynamic> json) {
    return SubmitAttendanceModel(
      attendanceDate: json["AttendanceDate"] ?? "",
      attendanceTime: json["AttendanceTime"] ?? "",
      attendanceLocation: json["AttendanceLocation"] ?? "",
      attendanceRemarks: json["AttendanceRemarks"] ?? "",
      actionName: json["ActionName"] ?? "",
      attendanceType: json["AttendanceType"] ?? "",
      selectedEmployeeId: json["SelectedEmployeeId"] ?? "",
    );
  }
}
