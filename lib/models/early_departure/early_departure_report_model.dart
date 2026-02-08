class EarlyDepartureReportModel {
  int? employeeId;
  int? month;
  int? year;
  int? statestatus;

  EarlyDepartureReportModel({
    this.employeeId,
    this.month,
    this.year,
    this.statestatus,
  });

  EarlyDepartureReportModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'] ?? 0;
    month = json['month'] ?? 0;
    year = json['year'] ?? 0;
    statestatus = json['statestatus'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeId'] = employeeId;
    data['month'] = month;
    data['year'] = year;
    data['statestatus'] = statestatus;
    return data;
  }

  // Add this to convert to query parameters
  Map<String, String> toQueryParams() {
    return {
      if (employeeId != null) 'employeeId': employeeId.toString(),
      if (month != null) 'month': month.toString(),
      if (year != null) 'year': year.toString(),
      if (statestatus != null) 'statestatus': statestatus.toString(),
    };
  }
}
