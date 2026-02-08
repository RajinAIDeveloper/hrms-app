class EarlyDepartureRequest {
  // int? earlyDepartureId;
  int? employeeId;
  DateTime? appliedDate;
  String?
      appliedTime; // TimeSpan in Dart can be represented as a string (e.g., "HH:mm")
  String? reason;
  String? cancelRemarks;
  String? stateStatus;

  EarlyDepartureRequest({
    // this.earlyDepartureId,
    this.employeeId,
    this.appliedDate,
    this.appliedTime,
    this.reason,
    this.cancelRemarks,
    this.stateStatus,
  });

  Map<String, dynamic> toJson() => {
        // 'EarlyDepartureId': earlyDepartureId ?? 0, // Default to 0 if new
        'EmployeeId': employeeId,
        'AppliedDate':
            appliedDate?.toIso8601String().split('T')[0], // Date only
        'AppliedTime': appliedTime,
        'Reason': reason,
        'CancelRemarks': cancelRemarks,
        'StateStatus': stateStatus,
      };
}
