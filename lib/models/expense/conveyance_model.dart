class ConveyanceDTO {
  int? requestId;
  int? conveyanceDetailId;
  String? transactionType;
  String? transactionDate;
  int? employeeId;
  String? referenceNumber;
  String? requestDate;
  String? companyName;
  String? spendMode;
  String? purpose;
  String? description;
  String? transportation;
  String? stateStatus;
  double? advanceAmount;
  String? destination;
  String? mode;
  double? cost;
  bool? isApproved;
  bool? approved;
  String? flag;
  String? userStatus;
  String? fileName;
  String? actualFileName;
  String? fileFormat;
  String? fileSize;
  String? filePath;
  String? commentsUser;
  String? commentsAccount;
  String? accountStatus;
  String? reimburseStatus;
  String? cancelRemarks;
  String? attachmentPath;
  int? purchaseDetailId;
  List<dynamic>? purchases;
  String? fromDate;
  String? toDate;
  String? location;
  double? accommodationCosts;
  double? subsistenceCosts;
  double? otherCosts;
  double? transportationCosts;

  ConveyanceDTO({
    this.requestId,
    this.conveyanceDetailId,
    this.transactionType,
    this.transactionDate,
    this.employeeId,
    this.referenceNumber,
    this.requestDate,
    this.companyName,
    this.spendMode,
    this.purpose,
    this.description,
    this.transportation,
    this.stateStatus,
    this.advanceAmount,
    this.destination,
    this.mode,
    this.cost,
    this.isApproved,
    this.approved,
    this.flag,
    this.userStatus,
    this.fileName,
    this.actualFileName,
    this.fileFormat,
    this.fileSize,
    this.filePath,
    this.commentsUser,
    this.commentsAccount,
    this.accountStatus,
    this.reimburseStatus,
    this.cancelRemarks,
    this.attachmentPath,
    this.purchaseDetailId,
    this.purchases,
    this.fromDate,
    this.toDate,
    this.location,
    this.accommodationCosts,
    this.subsistenceCosts,
    this.otherCosts,
    this.transportationCosts,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'RequestId': requestId ?? 0,
      'TransactionType': transactionType,
      'TransactionDate': transactionDate,
      'EmployeeId': employeeId,
      'ReferenceNumber': referenceNumber,
      'RequestDate': requestDate,
      'CompanyName': companyName,
      'SpendMode': spendMode,
      'Purpose': purpose,
      'IsApproved': isApproved ?? false,
      'Flag': flag,
    };

    // Add optional fields only if they have meaningful values
    if (conveyanceDetailId != null) {
      json['ConveyanceDetailId'] = conveyanceDetailId;
    }
    
    if (description != null && description!.isNotEmpty) {
      json['Description'] = description;
    }
    
    if (transportation != null && transportation!.isNotEmpty) {
      json['Transportation'] = transportation;
    }
    
    if (stateStatus != null && stateStatus!.isNotEmpty) {
      json['StateStatus'] = stateStatus;
    }
    
    if (advanceAmount != null && advanceAmount! > 0) {
      json['AdvanceAmount'] = double.parse(advanceAmount!.toStringAsFixed(2));
    } else {
      json['AdvanceAmount'] = 0.0;
    }
    
    if (destination != null && destination!.isNotEmpty) {
      json['Destination'] = destination;
    }
    
    if (mode != null && mode!.isNotEmpty) {
      json['Mode'] = mode;
    }
    
    if (cost != null && cost! > 0) {
      json['Cost'] = double.parse(cost!.toStringAsFixed(2));
    } else {
      json['Cost'] = 0.0;
    }
    
    if (approved != null) {
      json['Approved'] = approved;
    }
    
    if (userStatus != null && userStatus!.isNotEmpty) {
      json['UserStatus'] = userStatus;
    }
    
    if (fileName != null && fileName!.isNotEmpty) {
      json['FileName'] = fileName;
    }
    
    if (actualFileName != null && actualFileName!.isNotEmpty) {
      json['ActualFileName'] = actualFileName;
    }
    
    if (fileFormat != null && fileFormat!.isNotEmpty) {
      json['FileFormat'] = fileFormat;
    }
    
    if (fileSize != null && fileSize!.isNotEmpty) {
      json['FileSize'] = fileSize;
    }
    
    if (filePath != null && filePath!.isNotEmpty) {
      json['FilePath'] = filePath;
    }
    
    if (commentsUser != null && commentsUser!.isNotEmpty) {
      json['CommentsUser'] = commentsUser;
    }
    
    if (commentsAccount != null && commentsAccount!.isNotEmpty) {
      json['CommentsAccount'] = commentsAccount;
    }
    
    if (accountStatus != null && accountStatus!.isNotEmpty) {
      json['AccountStatus'] = accountStatus;
    }
    
    if (reimburseStatus != null && reimburseStatus!.isNotEmpty) {
      json['ReimburseStatus'] = reimburseStatus;
    }
    
    if (cancelRemarks != null && cancelRemarks!.isNotEmpty) {
      json['CancelRemarks'] = cancelRemarks;
    }
    
    if (attachmentPath != null && attachmentPath!.isNotEmpty) {
      json['AttachmentPath'] = attachmentPath;
    }
    
    // Only include dates if they are actually provided
    if (fromDate != null && fromDate!.isNotEmpty && fromDate != "1900-01-01T00:00:00") {
      json['FromDate'] = fromDate;
    }
    
    if (toDate != null && toDate!.isNotEmpty && toDate != "1900-01-01T00:00:00") {
      json['ToDate'] = toDate;
    }
    
    if (location != null && location!.isNotEmpty) {
      json['Location'] = location;
    }

    return json;
  }
}