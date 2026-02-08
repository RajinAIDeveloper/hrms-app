import 'package:root_app/models/payroll/payroll_report_model.dart';
import 'package:root_app/models/payroll/payroll_report_response_model.dart';

abstract class PayrollRepository {
  Future<PayrollReportResponseModel> payslip(PayrollReportModel model);
  Future<PayrollReportResponseModel> taxCard(PayrollReportModel model);
}
