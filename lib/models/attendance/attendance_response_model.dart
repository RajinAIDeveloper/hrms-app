class AttendanceResponseModel {
  bool error;
  String? errorMessage;
  bool? punchIn;
  bool? punchOut;
  bool? punchInAndPunchOut;
  String? shiftInTime;
  String? maxInTime;
  String? actualInTime;
  String? earlyInTime;
  String? lateInTime;
  String? shiftEndTime;
  String? actualOutTime;
  String? earlyGoing;
  String? overTime;
  String? inTimeLocation;
  String? outTimeLocation;

  AttendanceResponseModel({
    this.error = false,
    this.errorMessage,
    this.punchIn,
    this.punchOut,
    this.punchInAndPunchOut,
    this.shiftInTime,
    this.maxInTime,
    this.actualInTime,
    this.earlyInTime,
    this.lateInTime,
    this.shiftEndTime,
    this.actualOutTime,
    this.earlyGoing,
    this.overTime,
    this.inTimeLocation,
    this.outTimeLocation,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    // Since your API response is an array, we'll take the first element
    Map<String, dynamic> data = json is List ? json[0] : json;

    return AttendanceResponseModel(
      error: json['error'] ?? false,
      errorMessage: json['errorMessage'],
      punchIn: data['punchIn'],
      punchOut: data['punchOut'],
      punchInAndPunchOut: data['punchInAndPunchOut'],
      shiftInTime: data['shiftInTime'],
      maxInTime: data['maxInTime'],
      actualInTime: data['actualInTime'],
      earlyInTime: data['earlyInTime'],
      lateInTime: data['lateInTime'],
      shiftEndTime: data['shiftEndTime'],
      actualOutTime: data['actualOutTime'],
      earlyGoing: data['earlyGoing'],
      overTime: data['overTime'],
      inTimeLocation: data['inTimeLocation'],
      outTimeLocation: data['outTimeLocation'],
    );
  }
}

// API response model
class AttendanceResponse {
  bool error;
  String? errorMessage;
  String? punchTime;
  Map<String, dynamic>? data; // For fetch status

  AttendanceResponse({
    required this.error,
    this.errorMessage,
    this.punchTime,
    this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      error: json['error'] ?? false,
      errorMessage: json['errorMessage'],
      punchTime: json['punchTime'],
      data: json['data'],
    );
  }
}
