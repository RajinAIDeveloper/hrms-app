class CheckPunchInPunchOutModel {
  DateTime? checkInTime;
  DateTime? checkOutTime;
  String location;
  final String actionName;

  CheckPunchInPunchOutModel({
    this.checkInTime,
    this.checkOutTime,
    required this.location,
    required this.actionName,
  });

  Map<String, dynamic> toJson() {
    return {
      "checkInTime": checkInTime?.toIso8601String(),
      "checkOutTime": checkOutTime?.toIso8601String(),
      "location": location,
      "ActionName": actionName,
    };
  }
}

class AttendanceModel {
  final bool? punchIn;
  final bool? punchOut;
  final bool? punchInAndPunchOut;
  final String? shiftInTime;
  final String? maxInTime;
  final String? actualInTime;
  final String? earlyInTime;
  final String? lateInTime;
  final String? shiftEndTime;
  final String? actualOutTime;
  final String? earlyGoing;
  final String? overTime;
  final String? inTimeLocation;
  final String? outTimeLocation;
  String? actionName;

  AttendanceModel({
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
    this.actionName,
  });

  // Convert JSON to Model
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      punchIn: json["PunchIn"] ?? false,
      punchOut: json["PunchOut"] ?? false,
      punchInAndPunchOut: json["PunchInAndPunchOut"] ?? false,
      shiftInTime: json["ShiftInTime"] ?? "",
      maxInTime: json["MaxInTime"] ?? "",
      actualInTime: json["ActualInTime"] ?? "",
      earlyInTime: json["EarlyInTime"] ?? "",
      lateInTime: json["LateInTime"] ?? "",
      shiftEndTime: json["ShiftEndTime"] ?? "",
      actualOutTime: json["ActualOutTime"] ?? "",
      earlyGoing: json["EarlyGoing"] ?? "",
      overTime: json["OverTime"] ?? "",
      inTimeLocation: json["InTimeLocation"] ?? "",
      outTimeLocation: json["OutTimeLocation"] ?? "",
    );
  }

  // Convert Model to JSON (if needed for API submission)
  Map<String, dynamic> toJson() {
    return {
      "PunchIn": punchIn,
      "PunchOut": punchOut,
      "PunchInAndPunchOut": punchInAndPunchOut,
      "ShiftInTime": shiftInTime,
      "MaxInTime": maxInTime,
      "ActualInTime": actualInTime,
      "EarlyInTime": earlyInTime,
      "LateInTime": lateInTime,
      "ShiftEndTime": shiftEndTime,
      "ActualOutTime": actualOutTime,
      "EarlyGoing": earlyGoing,
      "OverTime": overTime,
      "InTimeLocation": inTimeLocation,
      "OutTimeLocation": outTimeLocation,
      'actionName': actionName,
    };
  }
}


// class AttendanceModel {
//   String  checkInTime;
//   String  checkOutTime;
//   String location;

//   AttendanceModel({
//      required this.checkInTime,
//      required this.checkOutTime,
//     required this.location,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       "checkInTime": checkInTime?.toIso8601String(),
//       "checkOutTime": checkOutTime?.toIso8601String(),
//       "location": location,
//       punchIn: json['punchIn'] ?? '',
//       punchOut: json['punchOut'] ?? '',
//     };
//   }
// }

