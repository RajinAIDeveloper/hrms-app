class ManualAttendanceModel {
  final int? manualAttendanceId;
  final String? manualAttendanceCode;
  final int employeeId;
  final int? designationId;
  final int? departmentId;
  final int? sectionId;
  final int? unitId;
  final DateTime attendanceDate;
  final String timeRequestFor; // In / Out / Both
  final String? inTime;
  final String? outTime;
  final String? stateStatus;
  final String reason;
  final String? remarks;
  final bool? isApproved;

  // Custom Properties
  final String? employeeCode;
  final String? employeeName;
  final String? designationName;
  final String? departmentName;
  final String? sectionName;
  final String? unitName;

  final String? createrInfo;
  final String? updaterInfo;
  final String? approverInfo;
  final String? rejecterInfo;
  final String? checkerInfo;
  final String? cancellerInfo;
  final int? supervisorId;
  final String? supervisorName;
  final int? hodId;
  final String? hodName;

  ManualAttendanceModel({
    this.manualAttendanceId,
    this.manualAttendanceCode,
    required this.employeeId,
    this.designationId,
    this.departmentId,
    this.sectionId,
    this.unitId,
    required this.attendanceDate,
    required this.timeRequestFor,
    this.inTime,
    this.outTime,
    this.stateStatus,
    required this.reason,
    this.remarks,
    this.isApproved = false,
    this.employeeCode,
    this.employeeName,
    this.designationName,
    this.departmentName,
    this.sectionName,
    this.unitName,
    this.createrInfo,
    this.updaterInfo,
    this.approverInfo,
    this.rejecterInfo,
    this.checkerInfo,
    this.cancellerInfo,
    this.supervisorId,
    this.supervisorName,
    this.hodId,
    this.hodName,
  });

  // Factory constructor to create a ManualAttendanceModel from JSON
  factory ManualAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ManualAttendanceModel(
      manualAttendanceId: json['manualAttendanceId'] as int?,
      manualAttendanceCode: json['manualAttendanceCode'] as String?,
      employeeId: json['employeeId'] as int,
      designationId: json['designationId'] as int?,
      departmentId: json['departmentId'] as int?,
      sectionId: json['sectionId'] as int?,
      unitId: json['unitId'] as int?,
      attendanceDate: DateTime.parse(json['attendanceDate'] as String),
      timeRequestFor: json['timeRequestFor'] as String,
      inTime: json['inTime'] as String?,
      outTime: json['outTime'] as String?,
      stateStatus: json['stateStatus'] as String?,
      reason: json['reason'] as String,
      remarks: json['remarks'] as String?,
      isApproved: json['isApproved'] as bool?,
      employeeCode: json['employeeCode'] as String?,
      employeeName: json['employeeName'] as String?,
      designationName: json['designationName'] as String?,
      departmentName: json['departmentName'] as String?,
      sectionName: json['sectionName'] as String?,
      unitName: json['unitName'] as String?,
      createrInfo: json['createrInfo'] as String?,
      updaterInfo: json['updaterInfo'] as String?,
      approverInfo: json['approverInfo'] as String?,
      rejecterInfo: json['rejecterInfo'] as String?,
      checkerInfo: json['checkerInfo'] as String?,
      cancellerInfo: json['cancellerInfo'] as String?,
      supervisorId: json['supervisorId'] as int?,
      supervisorName: json['supervisorName'] as String?,
      hodId: json['hodId'] as int?,
      hodName: json['hodName'] as String?,
    );
  }

  // Method to convert ManualAttendanceModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'manualAttendanceId': manualAttendanceId,
      'manualAttendanceCode': manualAttendanceCode,
      'employeeId': employeeId,
      'designationId': designationId,
      'departmentId': departmentId,
      'sectionId': sectionId,
      'unitId': unitId,
      'attendanceDate': attendanceDate.toIso8601String(),
      'timeRequestFor': timeRequestFor,
      'inTime': inTime,
      'outTime': outTime,
      'stateStatus': stateStatus,
      'reason': reason,
      'remarks': remarks,
      'isApproved': isApproved,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'designationName': designationName,
      'departmentName': departmentName,
      'sectionName': sectionName,
      'unitName': unitName,
      'createrInfo': createrInfo,
      'updaterInfo': updaterInfo,
      'approverInfo': approverInfo,
      'rejecterInfo': rejecterInfo,
      'checkerInfo': checkerInfo,
      'cancellerInfo': cancellerInfo,
      'supervisorId': supervisorId,
      'supervisorName': supervisorName,
      'hodId': hodId,
      'hodName': hodName,
    };
  }

  // // Create a copy of ManualAttendanceModel with some fields updated
  // ManualAttendanceModel copyWith({
  //   int? manualAttendanceId,
  //   String? manualAttendanceCode,
  //   int? employeeId,
  //   int? designationId,
  //   int? departmentId,
  //   int? sectionId,
  //   int? unitId,
  //   DateTime? attendanceDate,
  //   String? timeRequestFor,
  //   String? inTime,
  //   String? outTime,
  //   String? stateStatus,
  //   String? reason,
  //   String? remarks,
  //   bool? isApproved,
  //   String? employeeCode,
  //   String? employeeName,
  //   String? designationName,
  //   String? departmentName,
  //   String? sectionName,
  //   String? unitName,
  //   String? createrInfo,
  //   String? updaterInfo,
  //   String? approverInfo,
  //   String? rejecterInfo,
  //   String? checkerInfo,
  //   String? cancellerInfo,
  //   int? supervisorId,
  //   String? supervisorName,
  //   int? hodId,
  //   String? hodName,
  // }) {
  //   return ManualAttendanceModel(
  //     manualAttendanceId: manualAttendanceId ?? this.manualAttendanceId,
  //     manualAttendanceCode: manualAttendanceCode ?? this.manualAttendanceCode,
  //     employeeId: employeeId ?? this.employeeId,
  //     designationId: designationId ?? this.designationId,
  //     departmentId: departmentId ?? this.departmentId,
  //     sectionId: sectionId ?? this.sectionId,
  //     unitId: unitId ?? this.unitId,
  //     attendanceDate: attendanceDate ?? this.attendanceDate,
  //     timeRequestFor: timeRequestFor ?? this.timeRequestFor,
  //     inTime: inTime ?? this.inTime,
  //     outTime: outTime ?? this.outTime,
  //     stateStatus: stateStatus ?? this.stateStatus,
  //     reason: reason ?? this.reason,
  //     remarks: remarks ?? this.remarks,
  //     isApproved: isApproved ?? this.isApproved,
  //     employeeCode: employeeCode ?? this.employeeCode,
  //     employeeName: employeeName ?? this.employeeName,
  //     designationName: designationName ?? this.designationName,
  //     departmentName: departmentName ?? this.departmentName,
  //     sectionName: sectionName ?? this.sectionName,
  //     unitName: unitName ?? this.unitName,
  //     createrInfo: createrInfo ?? this.createrInfo,
  //     updaterInfo: updaterInfo ?? this.updaterInfo,
  //     approverInfo: approverInfo ?? this.approverInfo,
  //     rejecterInfo: rejecterInfo ?? this.rejecterInfo,
  //     checkerInfo: checkerInfo ?? this.checkerInfo,
  //     cancellerInfo: cancellerInfo ?? this.cancellerInfo,
  //     supervisorId: supervisorId ?? this.supervisorId,
  //     supervisorName: supervisorName ?? this.supervisorName,
  //     hodId: hodId ?? this.hodId,
  //     hodName: hodName ?? this.hodName,
  //   );
  // }
}
