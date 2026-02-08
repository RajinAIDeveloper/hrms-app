class EmployeeManualAttendanceDTO {
  final int? manualAttendanceId;
  final String? manualAttendanceCode;
  final int employeeId;
  final int? departmentId;
  final int? sectionId;
  final int? unitId;
  final DateTime? attendanceDate;
  final String timeRequestFor; // In / Out / Both
  final String? inTime; // Using String instead of TimeSpan
  final String? outTime; // Using String instead of TimeSpan
  final String? stateStatus;
  final String? reason;
  final String? remarks;

  EmployeeManualAttendanceDTO({
    this.manualAttendanceId,
    this.manualAttendanceCode,
    required this.employeeId,
    this.departmentId,
    this.sectionId,
    this.unitId,
    this.attendanceDate,
    required this.timeRequestFor,
    this.inTime,
    this.outTime,
    this.stateStatus,
    this.reason,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'ManualAttendanceId': manualAttendanceId,
      'ManualAttendanceCode': manualAttendanceCode,
      'EmployeeId': employeeId,
      'DepartmentId': departmentId,
      'SectionId': sectionId,
      'UnitId': unitId,
      'AttendanceDate': attendanceDate?.toIso8601String(),
      'TimeRequestFor': timeRequestFor,
      'InTime': inTime,
      'OutTime': outTime,
      'StateStatus': stateStatus,
      'Reason': reason,
      'Remarks': remarks,
    };
  }

  factory EmployeeManualAttendanceDTO.fromJson(Map<String, dynamic> json) {
    return EmployeeManualAttendanceDTO(
      manualAttendanceId: json['ManualAttendanceId'] as int?,
      manualAttendanceCode: json['ManualAttendanceCode'] as String?,
      employeeId: json['EmployeeId'] as int,
      departmentId: json['DepartmentId'] as int?,
      sectionId: json['SectionId'] as int?,
      unitId: json['UnitId'] as int?,
      attendanceDate: json['AttendanceDate'] != null
          ? DateTime.parse(json['AttendanceDate'] as String)
          : null,
      timeRequestFor: json['TimeRequestFor'] as String,
      inTime: json['InTime'] as String?,
      outTime: json['OutTime'] as String?,
      stateStatus: json['StateStatus'] as String?,
      reason: json['Reason'] as String?,
      remarks: json['Remarks'] as String?,
    );
  }
}
