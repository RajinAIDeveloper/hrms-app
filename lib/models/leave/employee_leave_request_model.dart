import 'dart:convert';

class EmployeeLeaveRequest {
  int employeeLeaveRequestId;
  String? employeeLeaveCode;
  int employeeId;
  int? unitId;
  int leaveTypeId;
  String? leaveTypeName;
  String? dayLeaveType;
  String? halfDayType;
  DateTime? appliedFromDate;
  DateTime? appliedToDate;
  double appliedTotalDays;
  String leavePurpose;
  String? emergencyPhoneNo;
  String? addressDuringLeave;
  String? remarks;
  List<EmployeeLeaveDay>? leaveDays;
  String? filePath;
  String? flag;
  DateTime? estimatedDeliveryDate;

  EmployeeLeaveRequest({
    this.employeeLeaveRequestId = 0,
    this.employeeLeaveCode,
    required this.employeeId,
    this.unitId,
    required this.leaveTypeId,
    this.leaveTypeName,
    this.dayLeaveType,
    this.halfDayType,
    this.appliedFromDate,
    this.appliedToDate,
    required this.appliedTotalDays,
    required this.leavePurpose,
    this.emergencyPhoneNo,
    this.addressDuringLeave,
    this.remarks,
    this.leaveDays,
    this.filePath,
    this.flag,
    this.estimatedDeliveryDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'EmployeeLeaveRequestId': employeeLeaveRequestId,
      'EmployeeLeaveCode': employeeLeaveCode,
      'EmployeeId': employeeId,
      'UnitId': unitId,
      'LeaveTypeId': leaveTypeId,
      'LeaveTypeName': leaveTypeName,
      'DayLeaveType': dayLeaveType,
      'HalfDayType': halfDayType,
      'AppliedFromDate': appliedFromDate?.toIso8601String(),
      'AppliedToDate': appliedToDate?.toIso8601String(),
      'AppliedTotalDays': appliedTotalDays,
      'LeavePurpose': leavePurpose,
      'EmergencyPhoneNo': emergencyPhoneNo,
      'AddressDuringLeave': addressDuringLeave,
      'Remarks': remarks,
      'LeaveDaysJson': leaveDays != null
          ? jsonEncode(leaveDays!.map((e) => e.toJson()).toList())
          : null,
      'FilePath': filePath,
      'Flag': flag,
      'EstimatedDeliveryDate': estimatedDeliveryDate?.toIso8601String(),
    };
  }
}

class EmployeeLeaveDay {
  DateTime date;
  double days;

  EmployeeLeaveDay({required this.date, required this.days});

  Map<String, dynamic> toJson() {
    return {
      'Date': date.toIso8601String(),
      'Days': days,
    };
  }
}
