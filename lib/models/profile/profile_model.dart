class ProfileModel {
  int? employeeId;
  int? branchId;
  String? employeeCode = '';
  String? employeeName = '';
  String? branchName = '';
  String? gradeName = '';
  String? designationName = '';
  String? departmentName = '';
  String? divisionName = '';
  String? sectionName = '';
  String? subSectionName = '';
  DateTime? dateOfJoining;
  DateTime? dateOfBirth;
  String? workshift = '';
  String? officeMobile = '';
  String? officeEmail = '';
  String? referenceNo = '';
  String? fingerId = '';
  String? jobType = '';
  bool? isActive;
  String? stateStatus = '';
  String? gender = '';
  String? photoPath = '';

  ProfileModel({
    this.employeeId,
    this.branchId,
    this.employeeCode,
    this.employeeName,
    this.branchName,
    this.gradeName,
    this.designationName,
    this.departmentName,
    this.divisionName,
    this.sectionName,
    this.subSectionName,
    this.dateOfJoining,
    this.dateOfBirth,
    this.workshift,
    this.officeMobile,
    this.officeEmail,
    this.referenceNo,
    this.fingerId,
    this.jobType,
    this.stateStatus,
    this.gender,
    this.isActive = false,
    this.photoPath,
  });

  // From JSON
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      employeeId: json['employeeId'],
      branchId: json['branchId'],
      employeeCode: json['employeeCode'],
      employeeName: json['employeeName'],
      branchName: json['branchName'],
      gradeName: json['gradeName'],
      designationName: json['designationName'],
      departmentName: json['departmentName'],
      divisionName: json['divisionName'],
      sectionName: json['sectionName'],
      subSectionName: json['subSectionName'],
      dateOfJoining: json['dateOfJoining'] != null
          ? DateTime.parse(json['dateOfJoining'])
          : null,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      workshift: json['workshift'],
      officeMobile: json['officeMobile'],
      officeEmail: json['officeEmail'],
      referenceNo: json['referenceNo'],
      fingerId: json['fingerId'],
      jobType: json['jobType'],
      isActive: json['isActive'] ?? false,
      stateStatus: json['stateStatus'],
      gender: json['gender'],
      photoPath: json['photoPath'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId,
      'branchId': branchId,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'branchName': branchName,
      'gradeName': gradeName,
      'designationName': designationName,
      'departmentName': departmentName,
      'divisionName': divisionName,
      'sectionName': sectionName,
      'subSectionName': subSectionName,
      'dateOfJoining': dateOfJoining?.toIso8601String(),
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'workshift': workshift,
      'officeMobile': officeMobile,
      'officeEmail': officeEmail,
      'referenceNo': referenceNo,
      'fingerId': fingerId,
      'jobType': jobType,
      'isActive': isActive,
      'stateStatus': stateStatus,
      'gender': gender,
      'photoPath': photoPath,
    };
  }
}
