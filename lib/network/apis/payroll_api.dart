import 'package:dio/dio.dart';
import 'package:root_app/models/payroll/payroll_report_model.dart';
import 'package:root_app/network/dio_client.dart';

class PayrollApi {
  final DioClient dioClient;
  PayrollApi({required this.dioClient});

  Future<Response> downloadPayslip(
      PayrollReportModel model, String filePath) async {
    try {
      // String queryParam = "employeeId=${model.employeeId}&month=${model.month}&year=${model.year}"; //?$queryParam
      final response = await dioClient.download(
        "/payroll/Salary/SalarySelfService/DownloadPayslip",
        queryParameters: model.toJson(),
        filePath,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> downloadTaxCard(
      PayrollReportModel model, String filePath) async {
    try {
      // String queryParam = "employeeId=${model.employeeId}&month=${model.month}&year=${model.year}"; //?$queryParam
      final response = await dioClient.download(
        "/payroll/Tax/TaxSelfService/DownloadTaxCard",
        queryParameters: model.toJson(),
        filePath,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
