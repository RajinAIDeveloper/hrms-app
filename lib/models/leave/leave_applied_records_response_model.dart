import 'package:intl/intl.dart';

class LeaveAppliedRecordsResponseModel {
  List<LeaveAppliedRecord> leaveAppliedRecords = [];
  LeaveAppliedRecordsResponseModel();

  LeaveAppliedRecordsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['leaveAppliedRecords'] != null &&
        json['leaveAppliedRecords'] is List) {
      leaveAppliedRecords = <LeaveAppliedRecord>[];
      json['leaveAppliedRecords'].forEach((v) {
        leaveAppliedRecords.add(LeaveAppliedRecord.fromJson(v));
      });
    } else {
      leaveAppliedRecords = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaveAppliedRecords'] =
        leaveAppliedRecords.map((v) => v.toJson()).toList();
    return data;
  }
}

class LeaveAppliedRecord {
  int? employeeLeaveRequestId;
  String? leaveTypeName;
  double? appliedTotalDays;
  DateTime? appliedFromDate;
  DateTime? appliedToDate;
  String? stateStatus;
  String? approvalRemarks;
  String? date;

  LeaveAppliedRecord(
      {this.employeeLeaveRequestId,
      this.leaveTypeName,
      this.appliedTotalDays,
      this.appliedFromDate,
      this.appliedToDate,
      this.stateStatus,
      this.approvalRemarks,
      this.date});

  LeaveAppliedRecord.fromJson(Map<String, dynamic> json) {
    employeeLeaveRequestId = json['employeeLeaveRequestId'] ?? 0;
    leaveTypeName = json['title'] ?? '-';
    appliedTotalDays = json['appliedTotalDays'] ?? 0.0;
    appliedFromDate = json['appliedFromDate'] != null
        ? DateTime.parse(json['appliedFromDate'])
        : null;
    appliedToDate = json['appliedToDate'] != null
        ? DateTime.parse(json['appliedToDate'])
        : null;
    stateStatus = json['stateStatus'] ?? '-';
    approvalRemarks = json['approvalRemarks'] ?? '-';

    date = getFormattedDate();
  }

  String getFormattedDate() {
    DateFormat formatter = DateFormat('dd-MMM-yy');

    String? safeFormatDate(String? dateString) {
      DateTime? dateTime =
          dateString != null ? DateTime.tryParse(dateString) : null;
      return dateTime != null ? formatter.format(dateTime) : null;
    }

    String? formattedStartDate =
        safeFormatDate(appliedFromDate?.toIso8601String());
    String? formattedEndDate = safeFormatDate(appliedToDate?.toIso8601String());

    String combinedDates;

    if (appliedFromDate != null && appliedFromDate == appliedToDate) {
      combinedDates = formattedStartDate ?? '-';
    } else {
      combinedDates =
          '${formattedStartDate ?? ''}${formattedStartDate != null && formattedEndDate != null ? ' To ' : ''}${formattedEndDate ?? ''}';
    }

    return combinedDates;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeLeaveRequestId'] = employeeLeaveRequestId;
    data['title'] = leaveTypeName;
    data['appliedTotalDays'] = appliedTotalDays;
    data['appliedFromDate'] = appliedFromDate?.toIso8601String();
    data['appliedToDate'] = appliedToDate?.toIso8601String();
    data['stateStatus'] = stateStatus;
    data['approvalRemarks'] = approvalRemarks;

    return data;
  }
}
