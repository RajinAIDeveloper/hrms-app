class TravelDTO {
  int? requestId;
  DateTime? transactionDate;
  String? transactionType;
  int? employeeId;
  String? referenceNumber;
  DateTime? fromDate;
  DateTime? toDate;
  String? spendMode;
  String? location;
  String? purpose;
  String? transportation;
  double? transportationCosts;
  double? accommodationCosts;
  double? subsistenceCosts;
  double? otherCosts;
  String? description;
  String? stateStatus;
  bool? isApproved;
  String? flag;
  String? fileName;
  String? actualFileName;
  String? fileFormat;
  String? fileSize;
  String? filePath;
  String? commentsUser;
  String? commentsAccount;
  String? accountStatus;
  String? reimburseStatus;

  TravelDTO({
    this.requestId,
    this.transactionDate,
    this.transactionType,
    this.employeeId,
    this.referenceNumber,
    this.fromDate,
    this.toDate,
    this.spendMode,
    this.location,
    this.purpose,
    this.transportation,
    this.transportationCosts,
    this.accommodationCosts,
    this.subsistenceCosts,
    this.otherCosts,
    this.description,
    this.stateStatus,
    this.isApproved,
    this.flag,
    this.fileName,
    this.actualFileName,
    this.fileFormat,
    this.fileSize,
    this.filePath,
    this.commentsUser,
    this.commentsAccount,
    this.accountStatus,
    this.reimburseStatus,
  });

  factory TravelDTO.fromJson(Map<String, dynamic> json) => TravelDTO(
        requestId: json['requestId'],
        transactionDate: json['transactionDate'] != null
            ? DateTime.parse(json['transactionDate'])
            : null,
        transactionType: json['transactionType'],
        employeeId: json['employeeId'],
        referenceNumber: json['referenceNumber'],
        fromDate:
            json['fromDate'] != null ? DateTime.parse(json['fromDate']) : null,
        toDate: json['toDate'] != null ? DateTime.parse(json['toDate']) : null,
        spendMode: json['spendMode'],
        location: json['location'],
        purpose: json['purpose'],
        transportation: json['transportation'],
        transportationCosts: (json['transportationCosts'] != null)
            ? double.tryParse(json['transportationCosts'].toString())
            : null,
        accommodationCosts: (json['accommodationCosts'] != null)
            ? double.tryParse(json['accommodationCosts'].toString())
            : null,
        subsistenceCosts: (json['subsistenceCosts'] != null)
            ? double.tryParse(json['subsistenceCosts'].toString())
            : null,
        otherCosts: (json['otherCosts'] != null)
            ? double.tryParse(json['otherCosts'].toString())
            : null,
        description: json['description'],
        stateStatus: json['stateStatus'],
        isApproved: json['isApproved'],
        flag: json['flag'],
        fileName: json['fileName'],
        actualFileName: json['actualFileName'],
        fileFormat: json['fileFormat'],
        fileSize: json['fileSize'],
        filePath: json['filePath'],
        commentsUser: json['commentsUser'],
        commentsAccount: json['commentsAccount'],
        accountStatus: json['accountStatus'],
        reimburseStatus: json['reimburseStatus'],
      );

  Map<String, dynamic> toJson() => {
        'requestId': requestId,
        'transactionDate': transactionDate?.toIso8601String(),
        'transactionType': transactionType,
        'employeeId': employeeId,
        'referenceNumber': referenceNumber,
        'fromDate': fromDate?.toIso8601String(),
        'toDate': toDate?.toIso8601String(),
        'spendMode': spendMode,
        'location': location,
        'purpose': purpose,
        'transportation': transportation,
        'transportationCosts': transportationCosts,
        'accommodationCosts': accommodationCosts,
        'subsistenceCosts': subsistenceCosts,
        'otherCosts': otherCosts,
        'description': description,
        'stateStatus': stateStatus,
        'isApproved': isApproved,
        'flag': flag,
        'fileName': fileName,
        'actualFileName': actualFileName,
        'fileFormat': fileFormat,
        'fileSize': fileSize,
        'filePath': filePath,
        'commentsUser': commentsUser,
        'commentsAccount': commentsAccount,
        'accountStatus': accountStatus,
        'reimburseStatus': reimburseStatus,
      };
}
