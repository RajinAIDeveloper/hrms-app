import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:root_app/models/payroll/payroll_report_model.dart';
import 'package:root_app/models/payroll/payroll_report_response_model.dart';
import 'package:root_app/network/apis/payroll_api.dart';
import 'package:root_app/network/dio_exceptions.dart';
import 'package:root_app/services/payroll/payroll_repository.dart';
// import 'package:open_filex/open_filex.dart';

class PayrollService implements PayrollRepository {
  final PayrollApi api;

  PayrollService({required this.api});

  @override
  Future<PayrollReportResponseModel> payslip(PayrollReportModel model) async {
    try {
      String fileName =
          "Payslip_${model.employeeId}_${model.month}_${model.year}.pdf";
      String filePath = await _getFilePath(fileName);
      var result = PayrollReportResponseModel();

      final pdfFile = File(filePath);

      if (!pdfFile.existsSync()) {
        final response = await api.downloadPayslip(model, filePath);

        if (response.statusCode == 200 && _havingContent(response)) {
          // No Action;
        } else {
          result.error = true;
          result.errorMessage =
              "Sorry, No Payslip found for the respective salary Month and Year!";
          debugPrint(
              "====================>>>>>>${result.errorMessage} <<<<<<==================");
          pdfFile.delete();
          return result;
        }
      }
      if (pdfFile.existsSync()) {
        //await OpenFilex.open(pdfFile.path);
        debugPrint(
            "====================>>>>>> Payslip Download & Opened! <<<<<<==================");
      } else {
        result.errorMessage =
            "Sorry, failed to open payslip. Please check your premissions network and connectivity!";

        debugPrint(
            "====================>>>>>>${result.errorMessage} <<<<<<==================");
      }
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  @override
  Future<PayrollReportResponseModel> taxCard(PayrollReportModel model) async {
    try {
      String fileName =
          "Taxcard_${model.employeeId}_${model.month}_${model.year}.pdf";
      String filePath = await _getFilePath(fileName);
      var result = PayrollReportResponseModel();

      final pdfFile = File(filePath);

      if (!pdfFile.existsSync()) {
        final response = await api.downloadTaxCard(model, filePath);

        if (response.statusCode == 200 && _havingContent(response)) {
          // No Action;
        } else {
          result.error = true;
          result.errorMessage =
              "Sorry, No Tax Card found for the respective salary Month and Year!";
          debugPrint(
              "====================>>>>>>${result.errorMessage} <<<<<<==================");
          pdfFile.delete();
          return result;
        }
      }
      if (pdfFile.existsSync()) {
        //await OpenFilex.open(pdfFile.path);
        debugPrint(
            "====================>>>>>> Tax Card Download & Opened! <<<<<<==================");
      } else {
        result.errorMessage =
            "Sorry, failed to open Tax Card. Please check your premissions network and connectivity!";

        debugPrint(
            "====================>>>>>>${result.errorMessage} <<<<<<==================");
      }
      return result;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint(
          '====================>>>>>> Dio Exceptions errorMessage: $errorMessage  <<<<<<==================');
      throw errorMessage;
    }
  }

  Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/'); // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      debugPrint("Cannot get download folder path $err");
    }
    return "${dir?.path}$filename";
  }

  bool _havingContent(Response<dynamic> response) {
    var contentLength = response.headers["content-length"];
    if (contentLength != null && contentLength.isNotEmpty) {
      return true;
    }
    return false;
  }
}
