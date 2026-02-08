import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class SignInResponseModel {
  String? token;
  PassObj? passObj;
  String? refreshToken;
  bool? isTokenExpired;
  String? refreshTokenExpiryTime;
  UserInfo? userInfo;

  SignInResponseModel(
      {this.token,
      this.refreshToken,
      this.refreshTokenExpiryTime,
      this.isTokenExpired = false,
      this.userInfo,
      this.passObj});

  SignInResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    passObj =
        json['passObj'] != null ? PassObj.fromJson(json['passObj']) : null;

    refreshToken = json['refreshToken'];
    refreshTokenExpiryTime = json['refreshTokenExpiryTime'];
    userInfo = UserInfo();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      var jsonUserInfo = jsonDecode(decodedToken['userinfo']);
      userInfo = UserInfo.fromJson({'userInfo': jsonUserInfo});
      isTokenExpired = JwtDecoder.isExpired(token!);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (passObj != null) {
      data['passObj'] = passObj!.toJson();
    }

    data['refreshToken'] = refreshToken;
    data['isTokenExpired'] = isTokenExpired;
    data['refreshTokenExpiryTime'] = refreshTokenExpiryTime;
    data['userInfo'] = userInfo;

    return data;
  }
}

class PassObj {
  bool? isDefaultPassword;
  String? defaultCode;
  bool? isPasswordExpired;
  int? remainExpireDays;

  PassObj(
      {this.isDefaultPassword = false,
      this.defaultCode,
      this.isPasswordExpired = false,
      this.remainExpireDays = 0});

  PassObj.fromJson(Map<String, dynamic> json) {
    isDefaultPassword = json['isDefaultPassword'] ?? false;
    defaultCode = json['defaultCode'];
    isPasswordExpired = json['isPasswordExpired'] ?? false;
    remainExpireDays = json['remainExpireDays'] ?? 0;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isDefaultPassword'] = isDefaultPassword;
    data['defaultCode'] = defaultCode;
    data['isPasswordExpired'] = isPasswordExpired;
    data['remainExpireDays'] = remainExpireDays;
    return data;
  }
}

class UserInfo {
  String? userId;
  String? username;
  String? roleId;
  String? roleName;
  int? divisionId;
  String? divisionName;
  int? branchId;
  String? branchName;
  int? employeeId;
  String? employeeCode;
  String? employeeName;
  int? gradeId;
  String? gradeName;
  int? designationId;
  String? designationName;
  int? departmentId;
  String? departmentName;
  int? sectionId;
  String? sectionName;
  int? subSectionId;
  String? subSectionName;
  int? companyId;
  int? organizationId;
  bool? isDefaultPassword;
  String? defaultCode;
  String? passwordExpiredDate;
  int? remainExpireDays;
  bool? isActive;
  String? siteThumbnailPath;
  String? siteShortName;
  String? photoPath;

  UserInfo(
      {this.userId,
      this.username,
      this.roleId,
      this.roleName,
      this.divisionId,
      this.divisionName,
      this.branchId,
      this.branchName,
      this.employeeId,
      this.employeeCode,
      this.employeeName,
      this.gradeId,
      this.gradeName,
      this.designationId,
      this.designationName,
      this.departmentId,
      this.departmentName,
      this.sectionId,
      this.sectionName,
      this.subSectionId,
      this.subSectionName,
      this.companyId,
      this.organizationId,
      this.isDefaultPassword = false,
      this.defaultCode,
      this.passwordExpiredDate,
      this.remainExpireDays,
      this.isActive = false,
      this.siteThumbnailPath,
      this.siteShortName,
      this.photoPath});

  UserInfo.fromJson(Map<String, dynamic> jsonObj) {
    var json = jsonObj['userInfo'];
    userId = json['userId'];
    username = json['username'];
    roleId = json['roleId'];
    roleName = json['roleName'];
    divisionId = json['divisionId'];
    divisionName = json['divisionName'];
    branchId = json['branchId'];
    branchName = json['branchName'];
    employeeId = json['employeeId'];
    employeeCode = json['employeeCode'];
    employeeName = json['employeeName'];
    gradeId = json['gradeId'];
    gradeName = json['gradeName'];
    designationId = json['designationId'];
    designationName = json['designationName'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    sectionId = json['sectionId'];
    sectionName = json['sectionName'];
    subSectionId = json['subSectionId'];
    subSectionName = json['subSectionName'];
    companyId = json['companyId'];
    organizationId = json['organizationId'];
    isDefaultPassword = json['isDefaultPassword'] ?? false;
    defaultCode = json['defaultCode'];
    passwordExpiredDate = json['passwordExpiredDate'];
    remainExpireDays = json['remainExpireDays'];
    isActive = json['isActive'] ?? false;
    siteThumbnailPath = json['siteThumbnailPath'];
    siteShortName = json['siteShortName'];
    photoPath = json['photoPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['username'] = username;
    data['roleId'] = roleId;
    data['roleName'] = roleName;
    data['divisionId'] = divisionId;
    data['divisionName'] = divisionName;
    data['branchId'] = branchId;
    data['branchName'] = branchName;
    data['employeeId'] = employeeId;
    data['employeeCode'] = employeeCode;
    data['employeeName'] = employeeName;
    data['gradeId'] = gradeId;
    data['gradeName'] = gradeName;
    data['designationId'] = designationId;
    data['designationName'] = designationName;
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    data['sectionId'] = sectionId;
    data['sectionName'] = sectionName;
    data['subSectionId'] = subSectionId;
    data['subSectionName'] = subSectionName;
    data['companyId'] = companyId;
    data['organizationId'] = organizationId;
    data['isDefaultPassword'] = isDefaultPassword;
    data['defaultCode'] = defaultCode;
    data['passwordExpiredDate'] = passwordExpiredDate;
    data['remainExpireDays'] = remainExpireDays;
    data['isActive'] = isActive;
    data['siteThumbnailPath'] = siteThumbnailPath;
    data['siteShortName'] = siteShortName;
    data['photoPath'] = photoPath;
    return data;
  }
}
