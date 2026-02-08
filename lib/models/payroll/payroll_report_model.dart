class PayrollReportModel {
  int? employeeId;
  int? month;
  int? year;
  PayrollReportModel({
    this.employeeId,
    this.month,
    this.year,
  });

  PayrollReportModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'] ?? 0;
    month = json['month'] ?? 0;
    year = json['year'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employeeId'] = employeeId;
    data['month'] = month;
    data['year'] = year;

    return data;
  }
}
