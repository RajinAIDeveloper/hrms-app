import 'package:root_app/models/workshift/employee-work-shift-model.dart';
import 'package:root_app/models/workshift/workshift-model.dart';

abstract class WorkshiftRepository {
  Future<WorkshiftResponsemodel> workshiftlist();

  /// Get weekly shifts for selected employee
  Future<List<EmployeeWorkShift>> getWeeklyShifts({int? employeeId});
}
