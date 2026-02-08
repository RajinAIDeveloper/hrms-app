class ForgotPasswordResponseModel {
  bool status;
  String message;
  String? token;

  ForgotPasswordResponseModel({
    required this.status,
    required this.message,
    this.token,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      status: json['Status'] ?? false,
      message: json['ErrorMsg'] ?? 'Something went wrong',
      token: json['token'],
    );
  }
}

class OTPVerificationResponseModel {
  bool status;
  String message;
  String? token;

  OTPVerificationResponseModel({
    required this.status,
    required this.message,
    this.token,
  });

  factory OTPVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return OTPVerificationResponseModel(
      status: json['status'] ??
          false, // Ensure lowercase 'status' if API sends it like this
      message: json['msg'] ??
          json['errorMsg'] ??
          'Something went wrong', // Handle different key names
      token: json['token'],
    );
  }
}
