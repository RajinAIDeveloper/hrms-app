// class ExpenseRequestModel {
//   final int requestId;
//   final String transactionType;
//   final String spendMode;
//   final String? purpose;
//   final String? stateStatus;
//   final String? accountStatus;
//   final String? reimburseStatus;
//   final String? referenceNumber;
//   final double? transactionAmount;
//   final String? requestDate;

//   ExpenseRequestModel({
//     required this.requestId,
//     required this.transactionType,
//     required this.spendMode,
//     this.purpose,
//     this.stateStatus,
//     this.accountStatus,
//     this.reimburseStatus,
//     this.referenceNumber,
//     this.transactionAmount,
//     this.requestDate,
//   });

//   factory ExpenseRequestModel.fromJson(Map<String, dynamic> json) {
//     return ExpenseRequestModel(
//       requestId: json['requestId'] ?? 0,
//       transactionType: json['transactionType'] ?? '',
//       spendMode: json['spendMode'] ?? '',
//       purpose: json['purpose'],
//       stateStatus: json['stateStatus'],
//       accountStatus: json['accountStatus'],
//       reimburseStatus: json['reimburseStatus'],
//       referenceNumber: json['referenceNumber'],
//       transactionAmount: (json['transactionAmount'] ?? 0).toDouble(),
//       requestDate: json['requestDate'],
//     );
//   }

// }
class ExpenseRequestModel {
  final int requestId;
  final DateTime? transactionDate;
  final String transactionType;
  final int employeeId;
  final String referenceNumber;
  final String? stateStatus;
  final bool isApproved;
  final DateTime? requestDate;
  final String? spendMode;
  final String? purpose;
  final String? description;
  final String? companyName;
  final double? cost;
  final double? advanceAmount;
  final String? flag;
  final String? fileName;
  final String? actualFileName;
  final String? fileSize;
  final String? filePath;
  final String? fileFormat;
  final String? commentsUser;
  final String? commentsAccount;
  final String? accountStatus;
  final String? reimburseStatus;
  final String? userStatus;
  final bool approved;
  final String? cancelRemarks;
  final String? attachmentPath;
  final int purchaseDetailId;
  final String? purchases;
  final int conveyanceDetailId;
  final String? destination;
  final String? mode;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? location;
  final double? accommodationCosts;
  final double? subsistenceCosts;
  final double? otherCosts;
  final String? transportation;
  final double? transportationCosts;
  final int entertainmentDetailId;
  final String? item;
  final double? quantity;
  final double? price;
  final double? amount;
  final String? entertainments;
  final int expatDetailId;
  final String? billType;
  final String? particular;
  final String? expat;
  final String? institutionName;
  final String? course;
  final DateTime? admissionDate;
  final String? duration;
  final double? trainingCosts;
  final int expensesDetailId;
  final String? expenseType;
  final String? particulars;
  final String? expensesData;
  final double? transactionAmount;
  final double? transactionCount;
  final String? urgency;
  final String? issueType;
  final String? employeeCode;
  final String? employeeName;
  final String? departmentName;
  final String? designationName;
  final String? grade;

  ExpenseRequestModel({
    required this.requestId,
    this.transactionDate,
    required this.transactionType,
    required this.employeeId,
    required this.referenceNumber,
    this.stateStatus,
    required this.isApproved,
    this.requestDate,
    this.spendMode,
    this.purpose,
    this.description,
    this.companyName,
    this.cost,
    this.advanceAmount,
    this.flag,
    this.fileName,
    this.actualFileName,
    this.fileSize,
    this.filePath,
    this.fileFormat,
    this.commentsUser,
    this.commentsAccount,
    this.accountStatus,
    this.reimburseStatus,
    this.userStatus,
    required this.approved,
    this.cancelRemarks,
    this.attachmentPath,
    required this.purchaseDetailId,
    this.purchases,
    required this.conveyanceDetailId,
    this.destination,
    this.mode,
    this.fromDate,
    this.toDate,
    this.location,
    this.accommodationCosts,
    this.subsistenceCosts,
    this.otherCosts,
    this.transportation,
    this.transportationCosts,
    required this.entertainmentDetailId,
    this.item,
    this.quantity,
    this.price,
    this.amount,
    this.entertainments,
    required this.expatDetailId,
    this.billType,
    this.particular,
    this.expat,
    this.institutionName,
    this.course,
    this.admissionDate,
    this.duration,
    this.trainingCosts,
    required this.expensesDetailId,
    this.expenseType,
    this.particulars,
    this.expensesData,
    this.transactionAmount,
    this.transactionCount,
    this.urgency,
    this.issueType,
    this.employeeCode,
    this.employeeName,
    this.departmentName,
    this.designationName,
    this.grade,
  });

  factory ExpenseRequestModel.fromJson(Map<String, dynamic> json) {
    return ExpenseRequestModel(
      requestId: json['requestId'] ?? 0,
      transactionDate: json['transactionDate'] != null
          ? DateTime.parse(json['transactionDate'])
          : null,
      transactionType: json['transactionType'] ?? '',
      employeeId: json['employeeId'] ?? 0,
      referenceNumber: json['referenceNumber'] ?? '',
      stateStatus: json['stateStatus'],
      isApproved: json['isApproved'] ?? false,
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : null,
      spendMode: json['spendMode'],
      purpose: json['purpose'],
      description: json['description'],
      companyName: json['companyName'],
      cost: (json['cost'] ?? 0).toDouble(),
      advanceAmount: (json['advanceAmount'] ?? 0).toDouble(),
      flag: json['flag'],
      fileName: json['fileName'],
      actualFileName: json['actualFileName'],
      fileSize: json['fileSize'],
      filePath: json['filePath'],
      fileFormat: json['fileFormat'],
      commentsUser: json['commentsUser'],
      commentsAccount: json['commentsAccount'],
      accountStatus: json['accountStatus'],
      reimburseStatus: json['reimburseStatus'],
      userStatus: json['userStatus'],
      approved: json['approved'] ?? false,
      cancelRemarks: json['cancelRemarks'],
      attachmentPath: json['attachmentPath'],
      purchaseDetailId: json['purchaseDetailId'] ?? 0,
      purchases: json['purchases'],
      conveyanceDetailId: json['conveyanceDetailId'] ?? 0,
      destination: json['destination'],
      mode: json['mode'],
      fromDate:
          json['fromDate'] != null ? DateTime.parse(json['fromDate']) : null,
      toDate: json['toDate'] != null ? DateTime.parse(json['toDate']) : null,
      location: json['location'],
      accommodationCosts: (json['accommodationCosts'] ?? 0).toDouble(),
      subsistenceCosts: (json['subsistenceCosts'] ?? 0).toDouble(),
      otherCosts: (json['otherCosts'] ?? 0).toDouble(),
      transportation: json['transportation'],
      transportationCosts: (json['transportationCosts'] ?? 0).toDouble(),
      entertainmentDetailId: json['entertainmentDetailId'] ?? 0,
      item: json['item'],
      quantity: (json['quantity'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      entertainments: json['entertainments'],
      expatDetailId: json['expatDetailId'] ?? 0,
      billType: json['billType'],
      particular: json['particular'],
      expat: json['expat'],
      institutionName: json['institutionName'],
      course: json['course'],
      admissionDate: json['admissionDate'] != null
          ? DateTime.parse(json['admissionDate'])
          : null,
      duration: json['duration'],
      trainingCosts: (json['trainingCosts'] ?? 0).toDouble(),
      expensesDetailId: json['expensesDetailId'] ?? 0,
      expenseType: json['expenseType'],
      particulars: json['particulars'],
      expensesData: json['expensesData'],
      transactionAmount: (json['transactionAmount'] ?? 0).toDouble(),
      transactionCount: (json['transactionCount'] ?? 0).toDouble(),
      urgency: json['urgency'],
      issueType: json['issueType'],
      employeeCode: json['employeeCode'],
      employeeName: json['employeeName'],
      departmentName: json['departmentName'],
      designationName: json['designationName'],
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'transactionDate': transactionDate?.toIso8601String(),
      'transactionType': transactionType,
      'employeeId': employeeId,
      'referenceNumber': referenceNumber,
      'stateStatus': stateStatus,
      'isApproved': isApproved,
      'requestDate': requestDate?.toIso8601String(),
      'spendMode': spendMode,
      'purpose': purpose,
      'description': description,
      'companyName': companyName,
      'cost': cost,
      'advanceAmount': advanceAmount,
      'flag': flag,
      'fileName': fileName,
      'actualFileName': actualFileName,
      'fileSize': fileSize,
      'filePath': filePath,
      'fileFormat': fileFormat,
      'commentsUser': commentsUser,
      'commentsAccount': commentsAccount,
      'accountStatus': accountStatus,
      'reimburseStatus': reimburseStatus,
      'userStatus': userStatus,
      'approved': approved,
      'cancelRemarks': cancelRemarks,
      'attachmentPath': attachmentPath,
      'purchaseDetailId': purchaseDetailId,
      'purchases': purchases,
      'conveyanceDetailId': conveyanceDetailId,
      'destination': destination,
      'mode': mode,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
      'location': location,
      'accommodationCosts': accommodationCosts,
      'subsistenceCosts': subsistenceCosts,
      'otherCosts': otherCosts,
      'transportation': transportation,
      'transportationCosts': transportationCosts,
      'entertainmentDetailId': entertainmentDetailId,
      'item': item,
      'quantity': quantity,
      'price': price,
      'amount': amount,
      'entertainments': entertainments,
      'expatDetailId': expatDetailId,
      'billType': billType,
      'particular': particular,
      'expat': expat,
      'institutionName': institutionName,
      'course': course,
      'admissionDate': admissionDate?.toIso8601String(),
      'duration': duration,
      'trainingCosts': trainingCosts,
      'expensesDetailId': expensesDetailId,
      'expenseType': expenseType,
      'particulars': particulars,
      'expensesData': expensesData,
      'transactionAmount': transactionAmount,
      'transactionCount': transactionCount,
      'urgency': urgency,
      'issueType': issueType,
      'employeeCode': employeeCode,
      'employeeName': employeeName,
      'departmentName': departmentName,
      'designationName': designationName,
      'grade': grade,
    };
  }
}
