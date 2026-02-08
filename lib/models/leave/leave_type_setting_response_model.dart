class LeaveTypeSettingResponseModel {
  String? leavePeriodStart;
  String? leavePeriodEnd;
  String? leaveTypeName;
  int? requestDaysBeforeTakingLeave;
  int? maxDaysLeaveAtATime;
  bool? acquiredViaOffDayWork;
  String? fileAttachedOption;
  bool? showFullCalender;
  bool? isMinimumDaysRequiredForFileAttached;
  int? requiredDaysForFileAttached;
  int? requiredDaysBeforeEDD;
  bool? mandatoryNumberOfDays;
  int? totalLeave;
  int? leaveSettingId;
  int? companyId;
  int? organizationId;

  LeaveTypeSettingResponseModel(
      {this.leavePeriodStart,
      this.leavePeriodEnd,
      this.leaveTypeName,
      this.requestDaysBeforeTakingLeave,
      this.maxDaysLeaveAtATime,
      this.acquiredViaOffDayWork,
      this.fileAttachedOption,
      this.showFullCalender,
      this.isMinimumDaysRequiredForFileAttached,
      this.requiredDaysForFileAttached,
      this.requiredDaysBeforeEDD,
      this.mandatoryNumberOfDays,
      this.totalLeave,
      this.leaveSettingId,
      this.companyId,
      this.organizationId});

  LeaveTypeSettingResponseModel.fromJson(Map<String, dynamic> json) {
    leavePeriodStart = json['leavePeriodStart'];
    leavePeriodEnd = json['leavePeriodEnd'];
    leaveTypeName = json['leaveTypeName'];
    requestDaysBeforeTakingLeave = json['requestDaysBeforeTakingLeave'];
    maxDaysLeaveAtATime = json['maxDaysLeaveAtATime'];
    acquiredViaOffDayWork = json['acquiredViaOffDayWork'];
    fileAttachedOption = json['fileAttachedOption'];
    showFullCalender = json['showFullCalender'];
    isMinimumDaysRequiredForFileAttached =
        json['isMinimumDaysRequiredForFileAttached'];
    requiredDaysForFileAttached = json['requiredDaysForFileAttached'];
    requiredDaysBeforeEDD = json['requiredDaysBeforeEDD'];
    mandatoryNumberOfDays = json['mandatoryNumberOfDays'];
    totalLeave = json['totalLeave'];
    leaveSettingId = json['leaveSettingId'];
    companyId = json['companyId'];
    organizationId = json['organizationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leavePeriodStart'] = leavePeriodStart;
    data['leavePeriodEnd'] = leavePeriodEnd;
    data['leaveTypeName'] = leaveTypeName;
    data['requestDaysBeforeTakingLeave'] = requestDaysBeforeTakingLeave;
    data['maxDaysLeaveAtATime'] = maxDaysLeaveAtATime;
    data['acquiredViaOffDayWork'] = acquiredViaOffDayWork;
    data['fileAttachedOption'] = fileAttachedOption;
    data['showFullCalender'] = showFullCalender;
    data['isMinimumDaysRequiredForFileAttached'] =
        isMinimumDaysRequiredForFileAttached;
    data['requiredDaysForFileAttached'] = requiredDaysForFileAttached;
    data['requiredDaysBeforeEDD'] = requiredDaysBeforeEDD;
    data['mandatoryNumberOfDays'] = mandatoryNumberOfDays;
    data['totalLeave'] = totalLeave;
    data['leaveSettingId'] = leaveSettingId;
    data['companyId'] = companyId;
    data['organizationId'] = organizationId;
    return data;
  }
}
