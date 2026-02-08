class EarlyDepartureItem {
  final int id;
  final String transactionDate;
  final String appliedDate;
  final String appliedTime;
  final String departureDate;
  final String departureTime;
  final String dayName;
  final String reason;
  final String status;
  final String stateStatus;

  EarlyDepartureItem({
    required this.id,
    required this.transactionDate,
    required this.appliedDate,
    required this.appliedTime,
    required this.departureDate,
    required this.departureTime,
    required this.dayName,
    required this.reason,
    required this.status,
    required this.stateStatus,
  });

  factory EarlyDepartureItem.fromJson(Map<String, dynamic> json) {
    return EarlyDepartureItem(
      id: json['id'] ?? 0,
      transactionDate: json['transactionDate'] ?? '',
      departureDate: json['departureDate'] ?? '',
      departureTime: json['departureTime'] ?? '',
      appliedDate: json['appliedDate'] ?? '',
      appliedTime: json['appliedTime'] ?? '',
      dayName: json['dayName'] ?? '',
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      stateStatus: json['stateStatus'] ?? '',
    );
  }
}
