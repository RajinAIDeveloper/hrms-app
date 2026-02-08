// class GeoLocationAttendanceModel {
//   final String? date;
//   final String? punchIn;
//   final String? punchOut;
//   // final String attendanceInLocation;
//   // final String attendanceOutLocation;
//   final String? message;
//   final String? status;
//   final String? attendanceInRemarks;
//   final String? attendanceOutRemarks;
//   final int? pageNumber;
//   final int? pageSize;
//   String? actionName; // ✅ Add this field

//   GeoLocationAttendanceModel({
//     this.date,
//     this.punchIn,
//     this.punchOut,
//     //required this.attendanceInLocation,
//     // required this.attendanceOutLocation,
//     this.message,
//     this.status,
//     this.attendanceInRemarks,
//     this.attendanceOutRemarks,
//     this.pageNumber,
//     this.pageSize,
//     this.actionName, // ✅ Initialize here
//   });

//   factory GeoLocationAttendanceModel.fromJson(Map<String, dynamic> json) {
//     return GeoLocationAttendanceModel(
//       date: json['date'] ?? '',
//       punchIn: json['punchIn'] ?? '',
//       punchOut: json['punchOut'] ?? '',
//       // attendanceInLocation: json['attendanceInLocation'] ?? '',
//       // attendanceOutLocation: json['attendanceOutLocation'] ?? '',
//       message: json['message'] ?? '',
//       status: json['status'] ?? '',
//       attendanceInRemarks: json['attendanceInRemarks'] ?? '',
//       attendanceOutRemarks: json['attendanceOutRemarks'] ?? '',
//       pageNumber: json['pageNumber'] ?? 1,
//       pageSize: json['pageSize'] ?? 10,
//       actionName: json["actionName"], // ✅ Parse actionName from response
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'date': date,
//       'punchIn': punchIn,
//       'punchOut': punchOut,
//       // 'attendanceInLocation': attendanceInLocation,
//       // 'attendanceOutLocation': attendanceOutLocation,
//       'message': message,
//       'status': status,
//       'attendanceInRemarks': attendanceInRemarks,
//       'attendanceOutRemarks': attendanceOutRemarks,
//       'pageNumber': pageNumber,
//       'pageSize': pageSize,
//       if (actionName != null)
//         "actionName": actionName, // ✅ Include actionName if present
//     };
//   }

//   @override
//   String toString() {
//     return "GeoLocationAttendanceModel(date: $date, page: $pageNumber, size: $pageSize)";
//   }
// }
class GeoLocationAttendanceModel {
  final int? employeeId; // ✅ Add employeeId
  final String? date;
  final String? punchIn;
  final String? punchOut;
  final String? message;
  final String? status;
  final String? attendanceInRemarks;
  final String? attendanceOutRemarks;
  final int? pageNumber;
  final int? pageSize;
  String? actionName;

  GeoLocationAttendanceModel({
    this.employeeId, // ✅ Initialize here
    this.date,
    this.punchIn,
    this.punchOut,
    this.message,
    this.status,
    this.attendanceInRemarks,
    this.attendanceOutRemarks,
    this.pageNumber,
    this.pageSize,
    this.actionName,
  });

  factory GeoLocationAttendanceModel.fromJson(Map<String, dynamic> json) {
    return GeoLocationAttendanceModel(
      employeeId: json['employeeId'], // ✅ Parse employeeId
      date: json['date']?.toString() ?? '',
      punchIn: json['punchIn']?.toString() ?? '',
      punchOut: json['punchOut']?.toString() ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      attendanceInRemarks: json['attendanceInRemarks'] ?? '',
      attendanceOutRemarks: json['attendanceOutRemarks'] ?? '',
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      actionName: json["actionName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employeeId': employeeId, // ✅ Include employeeId in toJson()
      'date': date,
      'punchIn': punchIn,
      'punchOut': punchOut,
      'message': message,
      'status': status,
      'attendanceInRemarks': attendanceInRemarks,
      'attendanceOutRemarks': attendanceOutRemarks,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      if (actionName != null) "actionName": actionName,
    };
  }

  @override
  String toString() {
    return "GeoLocationAttendanceModel(employeeId: $employeeId, date: $date, page: $pageNumber, size: $pageSize)";
  }
}
