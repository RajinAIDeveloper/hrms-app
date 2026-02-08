class EarlyDepartureResponse {
  bool status;
  String? message;
  dynamic data; // Could be validation errors or success data

  EarlyDepartureResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory EarlyDepartureResponse.fromJson(Map<String, dynamic> json) {
    return EarlyDepartureResponse(
      status: json['Status'] ?? false,
      message: json['Message'],
      data: json['Data'],
    );
  }
}
