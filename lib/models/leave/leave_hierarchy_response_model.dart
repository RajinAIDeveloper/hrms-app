class LeaveHierarchyResponseModel {
  int? id;
  int? employeeId;
  String? employeeCode;
  String? fullName;
  int? supervisorId;
  String? supervisorCode;
  String? supervisorName;
  int? headOfDepartmentId;
  String? headOfDepartmentCode;
  String? headOfDepartmentName;
  bool? isActive;
  int? organizationId;
  int? companyId;

  LeaveHierarchyResponseModel(
      {this.id,
      this.employeeId,
      this.employeeCode,
      this.fullName,
      this.supervisorId,
      this.supervisorName,
      this.headOfDepartmentId,
      this.headOfDepartmentName,
      this.isActive,
      this.supervisorCode,
      this.headOfDepartmentCode,
      this.organizationId,
      this.companyId});

  LeaveHierarchyResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employeeId'];
    employeeCode = json['employeeCode'];
    fullName = json['fullName'];
    supervisorId = json['supervisorId'];
    supervisorName = json['supervisorName'];
    headOfDepartmentId = json['headOfDepartmentId'];
    headOfDepartmentName = json['headOfDepartmentName'];
    isActive = json['isActive'];
    supervisorCode = json['supervisorCode'];
    headOfDepartmentCode = json['headOfDepartmentCode'];
    organizationId = json['organizationId'];
    companyId = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employeeId'] = employeeId;
    data['employeeCode'] = employeeCode;
    data['fullName'] = fullName;
    data['supervisorId'] = supervisorId;
    data['supervisorName'] = supervisorName;
    data['headOfDepartmentId'] = headOfDepartmentId;
    data['headOfDepartmentName'] = headOfDepartmentName;
    data['isActive'] = isActive;
    data['supervisorCode'] = supervisorCode;
    data['headOfDepartmentCode'] = headOfDepartmentCode;
    data['organizationId'] = organizationId;
    data['companyId'] = companyId;
    return data;
  }
}
