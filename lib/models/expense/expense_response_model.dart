class ExpenseResponseModel {
  int? requestId;
  int? advanceId;
  String? transactionDate;
  int? employeeId;
  String? referenceNumber;
  String? requestDate;
  String? purpose;
  String? spendMode;
  double? advanceAmount;
  String? commentsUser;
  String? commentsAccount;
  String? stateStatus;
  String? accountStatus;
  String? reimburseStatus;
  String? userStatus;
  bool? isApproved;
  double? expensesAmount;

  bool error;
  String? errorMessage;

  ExpenseResponseModel({
    this.requestId,
    this.advanceId,
    this.transactionDate,
    this.employeeId,
    this.referenceNumber,
    this.requestDate,
    this.purpose,
    this.spendMode,
    this.advanceAmount,
    this.commentsUser,
    this.commentsAccount,
    this.stateStatus,
    this.accountStatus,
    this.reimburseStatus,
    this.userStatus,
    this.isApproved,
    this.expensesAmount,
    this.error = false,
    this.errorMessage,
  });

  factory ExpenseResponseModel.fromJson(Map<String, dynamic> json) {
    // Determine error state from multiple possible fields
    final bool isError = json['error'] == true || 
                        json['status'] == false ||
                        json['errorMsg'] != null ||
                        json['errorMessage'] != null;
    
    // Extract error message from multiple possible fields (prioritize errorMsg)
    String? errorMsg;
    if (json['errorMsg'] != null && json['errorMsg'].toString().isNotEmpty) {
      errorMsg = json['errorMsg'].toString();
    } else if (json['errorMessage'] != null && json['errorMessage'].toString().isNotEmpty) {
      errorMsg = json['errorMessage'].toString();
    } else if (json['msg'] != null && json['msg'].toString().isNotEmpty) {
      errorMsg = json['msg'].toString();
    } else if (json['message'] != null && json['message'].toString().isNotEmpty) {
      errorMsg = json['message'].toString();
    }

    return ExpenseResponseModel(
      requestId: json['requestId'],
      advanceId: json['advanceId'],
      transactionDate: json['transactionDate'],
      employeeId: json['employeeId'],
      referenceNumber: json['referenceNumber'],
      requestDate: json['requestDate'],
      purpose: json['purpose'],
      spendMode: json['spendMode'],
      advanceAmount: json['advanceAmount'] != null 
          ? (json['advanceAmount'] is int 
              ? (json['advanceAmount'] as int).toDouble()
              : json['advanceAmount'] as double)
          : 0.0,
      commentsUser: json['commentsUser'],
      commentsAccount: json['commentsAccount'],
      stateStatus: json['stateStatus'],
      accountStatus: json['accountStatus'],
      reimburseStatus: json['reimburseStatus'],
      userStatus: json['userStatus'],
      isApproved: json['isApproved'] ?? false,
      expensesAmount: json['expensesAmount'] != null
          ? (json['expensesAmount'] is int
              ? (json['expensesAmount'] as int).toDouble()
              : json['expensesAmount'] as double)
          : 0.0,
      error: isError,
      errorMessage: errorMsg,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'advanceId': advanceId,
      'transactionDate': transactionDate,
      'employeeId': employeeId,
      'referenceNumber': referenceNumber,
      'requestDate': requestDate,
      'purpose': purpose,
      'spendMode': spendMode,
      'advanceAmount': advanceAmount,
      'commentsUser': commentsUser,
      'commentsAccount': commentsAccount,
      'stateStatus': stateStatus,
      'accountStatus': accountStatus,
      'reimburseStatus': reimburseStatus,
      'userStatus': userStatus,
      'isApproved': isApproved,
      'expensesAmount': expensesAmount,
      'error': error,
      'errorMessage': errorMessage,
    };
  }
}
