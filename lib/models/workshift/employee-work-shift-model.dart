class EmployeeWorkShift {
  final int employeeId;
  final String fullName;
  final String sunday;
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;

  EmployeeWorkShift({
    required this.employeeId,
    required this.fullName,
    required this.sunday,
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
  });

  factory EmployeeWorkShift.fromJson(Map<String, dynamic> json) {
    return EmployeeWorkShift(
      employeeId: json['employeeId'] ?? 0, // Changed from 'EmployeeId'
      fullName: json['fullName'] ?? '-', // Changed from 'FullName'
      sunday: json['sunday'] ?? '-', // Changed from 'Sunday'
      monday: json['monday'] ?? '-', // Changed from 'Monday'
      tuesday: json['tuesday'] ?? '-', // Changed from 'Tuesday'
      wednesday: json['wednesday'] ?? '-', // Changed from 'Wednesday'
      thursday: json['thursday'] ?? '-', // Changed from 'Thursday'
      friday: json['friday'] ?? '-', // Changed from 'Friday'
      saturday: json['saturday'] ?? '-', // Changed from 'Saturday'
    );
  }
}
