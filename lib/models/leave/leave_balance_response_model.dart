class LeaveBalanceResponseModel {
  List<LeaveBalance> leaveBalance = [];
  LeaveBalanceResponseModel();

  LeaveBalanceResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['leaveBalance'] != null && json['leaveBalance'] is List) {
      leaveBalance = <LeaveBalance>[];
      json['leaveBalance'].forEach((v) {
        leaveBalance.add(LeaveBalance.fromJson(v));
      });
    } else {
      leaveBalance = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['leaveBalance'] = leaveBalance.map((v) => v.toJson()).toList();
    return data;
  }
}

class LeaveBalance {
  int? leaveTypeId;
  String? leaveTypeName;
  int? serialNo;
  double? allottedLeave;
  double? yearlyLeaveTypeAvailed;
  double? yearlyLeaveTypeBalance;

  LeaveBalance({
    this.leaveTypeId,
    this.leaveTypeName,
    this.allottedLeave,
    this.serialNo,
    this.yearlyLeaveTypeAvailed,
    this.yearlyLeaveTypeBalance,
  });

  LeaveBalance.fromJson(Map<String, dynamic> json) {
    leaveTypeId = json['LeaveTypeId'] ?? 0;
    leaveTypeName = json['LeaveTypeName'] ?? '-';
    allottedLeave = json['AllottedLeave'] ?? 0.0;
    serialNo = json['SerialNo'] ?? 0;
    yearlyLeaveTypeAvailed = json['YearlyLeaveTypeAvailed'] ?? 0.0;
    yearlyLeaveTypeBalance = json['YearlyLeaveTypeBalance'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LeaveTypeId'] = leaveTypeId;
    data['LeaveTypeName'] = leaveTypeName;
    data['AllottedLeave'] = allottedLeave;
    data['SerialNo'] = serialNo;
    data['YearlyLeaveTypeAvailed'] = yearlyLeaveTypeAvailed;
    data['YearlyLeaveTypeBalance'] = yearlyLeaveTypeBalance;

    return data;
  }
}
