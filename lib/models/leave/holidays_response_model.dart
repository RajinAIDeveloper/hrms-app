import 'package:intl/intl.dart';

class HolidaysResponseModel {
  List<Holiday> holidays = [];
  HolidaysResponseModel();

  HolidaysResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['holidays'] != null && json['holidays'] is List) {
      holidays = <Holiday>[];
      json['holidays'].forEach((v) {
        holidays.add(Holiday.fromJson(v));
      });
    } else {
      holidays = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['holidays'] = holidays.map((v) => v.toJson()).toList();
    return data;
  }
}

class Holiday {
  int? yearlyHolidayId;
  String? title;
  String? startDate;
  String? endDate;
  String? type;
  String? remarks;
  bool? isDepandentOnMoon;
  String? date;

  Holiday(
      {this.yearlyHolidayId = 0,
      this.title,
      this.startDate,
      this.endDate,
      this.type,
      this.remarks,
      this.isDepandentOnMoon = false,
      this.date});

  Holiday.fromJson(Map<String, dynamic> json) {
    yearlyHolidayId = json['yearlyHolidayId'] ?? 0;
    title = json['title'] ?? '-';
    startDate = json['startDate'];
    endDate = json['endDate'];
    type = json['type'] ?? '-';
    remarks = json['remarks'] ?? '-';
    isDepandentOnMoon = json['isDepandentOnMoon'] ?? false;

    date = getFormattedDate();
  }

  String getFormattedDate() {
    DateFormat formatter = DateFormat('EEE, dd-MMM-yyyy');

    String? safeFormatDate(String? dateString) {
      DateTime? dateTime =
          dateString != null ? DateTime.tryParse(dateString) : null;
      return dateTime != null ? formatter.format(dateTime) : null;
    }

    DateTime? startDateTime =
        startDate != null ? DateTime.tryParse(startDate!) : null;
    DateTime? endDateTime =
        endDate != null ? DateTime.tryParse(endDate!) : null;

    String? formattedStartDate = safeFormatDate(startDate);
    String? formattedEndDate = safeFormatDate(endDate);

    String combinedDates;

    if (startDateTime != null && startDateTime == endDateTime) {
      combinedDates = formattedStartDate ?? '-';
    } else {
      combinedDates =
          '${formattedStartDate ?? ''}${formattedStartDate != null && formattedEndDate != null ? ' - ' : ''}${formattedEndDate ?? ''}';
    }

    //debugPrint(combinedDates);
    // If both are the same: Output: Mon, 12-Feb-2024
    // If both are valid and different: Output: Mon, 12-Feb-2024 - Thu, 15-Feb-2024
    // If startDate is valid and endDate is invalid: Output: Mon, 12-Feb-2024
    // If both are invalid: Output: (empty string)
    return combinedDates;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yearlyHolidayId'] = yearlyHolidayId;
    data['title'] = title;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['type'] = type;
    data['remarks'] = remarks;
    data['isDepandentOnMoon'] = isDepandentOnMoon;
    return data;
  }
}
