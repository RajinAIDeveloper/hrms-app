class TravelResponseModel {
  bool? error;
  String? errorMessage;
  dynamic data;

  TravelResponseModel({this.error = false, this.errorMessage, this.data});

  factory TravelResponseModel.fromJson(Map<String, dynamic> json) {
    return TravelResponseModel(
      error: json['error'] ?? false,
      errorMessage: json['errorMessage'],
      data: json['data'],
    );
  }
}
