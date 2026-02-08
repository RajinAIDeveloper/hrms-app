class RequestFilter {
  final int employeeId;
  final String? transactionType;
  final String? spendMode;
  final String? status;
  final String? accountStatus;

  RequestFilter({
    required this.employeeId,
    this.transactionType,
    this.spendMode,
    this.status,
    this.accountStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      "EmployeeId": employeeId,
      "TransactionType": transactionType,
      "SpendMode": spendMode,
      "Status": status,
      "AccountStatus": accountStatus,
    };
  }
}
