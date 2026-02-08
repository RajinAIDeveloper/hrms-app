class AdvanceDTO {
  final int employeeId;
  final int requestId;
  final String spendMode;
  final String transactionType;
  final String transactionDate;
  final double advanceAmount;
  final String purpose;
  final String referenceNumber;
  final String flag;
  final String requestDate;

  AdvanceDTO({
    required this.employeeId,
    required this.requestId,
    required this.spendMode,
    required this.transactionType,
    required this.transactionDate,
    required this.advanceAmount,
    required this.purpose,
    required this.referenceNumber,
    required this.flag,
    required this.requestDate,
  });

  Map<String, dynamic> toJson() => {
        "employeeId": employeeId,
        "requestId": requestId,
        "spendMode": spendMode,
        "transactionType": transactionType,
        "transactionDate": transactionDate,
        "advanceAmount": advanceAmount,
        "purpose": purpose,
        "referenceNumber": referenceNumber,
        "flag": flag,
        "requestDate": requestDate,
      };
}
