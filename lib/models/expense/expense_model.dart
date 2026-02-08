// models/expenses/expenses_dto.dart
class ExpensesDTO {
  int? requestId;
  int? expensesDetailId;
  String? transactionDate;
  String transactionType;
  int employeeId;
  String referenceNumber;
  String? requestDate;
  String spendMode;
  String? description;
  String expensesData; // JSON string of expense items
  bool isApproved;
  String flag;
  String? fileName;
  String? actualFileName;
  String? fileSize;
  String? filePath;
  String? fileFormat;

  ExpensesDTO({
    this.requestId,
    this.expensesDetailId,
    this.transactionDate,
    required this.transactionType,
    required this.employeeId,
    required this.referenceNumber,
    this.requestDate,
    required this.spendMode,
    this.description,
    required this.expensesData,
    this.isApproved = false,
    required this.flag,
    this.fileName,
    this.actualFileName,
    this.fileSize,
    this.filePath,
    this.fileFormat,
  });

  factory ExpensesDTO.fromJson(Map<String, dynamic> json) {
    return ExpensesDTO(
      requestId: json['RequestId'],
      expensesDetailId: json['ExpensesDetailId'],
      transactionDate: json['TransactionDate'],
      transactionType: json['TransactionType'],
      employeeId: json['EmployeeId'],
      referenceNumber: json['ReferenceNumber'],
      requestDate: json['RequestDate'],
      spendMode: json['SpendMode'],
      description: json['Description'],
      expensesData: json['ExpensesData'],
      isApproved: json['IsApproved'] ?? false,
      flag: json['Flag'],
      fileName: json['FileName'],
      actualFileName: json['ActualFileName'],
      fileSize: json['FileSize'],
      filePath: json['FilePath'],
      fileFormat: json['FileFormat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RequestId': requestId,
      'ExpensesDetailId': expensesDetailId,
      'TransactionDate': transactionDate,
      'TransactionType': transactionType,
      'EmployeeId': employeeId,
      'ReferenceNumber': referenceNumber,
      'RequestDate': requestDate,
      'SpendMode': spendMode,
      'Description': description,
      'ExpensesData': expensesData,
      'IsApproved': isApproved,
      'Flag': flag,
      'FileName': fileName,
      'ActualFileName': actualFileName,
      'FileSize': fileSize,
      'FilePath': filePath,
      'FileFormat': fileFormat,
    };
  }
}