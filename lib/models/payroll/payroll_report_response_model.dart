class PayrollReportResponseModel {
  bool? error;
  String? errorMessage;

  PayrollReportResponseModel({
    this.error = false,
    this.errorMessage = '',
  });

  PayrollReportResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'] ?? false;
    errorMessage = json['errorMessage'] ?? '';
  }
}
