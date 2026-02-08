class ConveyanceResponseModel {
  bool error;
  String? errorMessage;
  String? message;
  dynamic data;

  ConveyanceResponseModel({
    this.error = false,
    this.errorMessage,
    this.message,
    this.data,
  });

  factory ConveyanceResponseModel.fromJson(Map<String, dynamic> json) {
    // Determine error state from multiple possible fields
    final bool isError = json['error'] == true || 
                        json['status'] == false ||
                        json['errorMsg'] != null ||
                        json['errorMessage'] != null;
    
    // Extract error message from multiple possible fields (prioritize errorMsg)
    String? errorMsg;
    if (json['errorMsg'] != null && json['errorMsg'].toString().isNotEmpty) {
      errorMsg = json['errorMsg'].toString();
    } else if (json['errorMessage'] != null && json['errorMessage'].toString().isNotEmpty) {
      errorMsg = json['errorMessage'].toString();
    } else if (json['msg'] != null && json['msg'].toString().isNotEmpty) {
      errorMsg = json['msg'].toString();
    } else if (json['message'] != null && json['message'].toString().isNotEmpty) {
      errorMsg = json['message'].toString();
    }

    // Extract success message
    String? successMsg;
    if (!isError) {
      successMsg = json['message']?.toString() ?? json['msg']?.toString();
    }

    return ConveyanceResponseModel(
      error: isError,
      errorMessage: errorMsg,
      message: successMsg,
      data: json['data'],
    );
  }
}
