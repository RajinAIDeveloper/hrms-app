import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root_app/utilities/get_months.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
import 'package:root_app/models/authentication/components.dart';
import 'package:root_app/models/payroll/payroll_report_model.dart';
import 'package:root_app/models/payroll/payroll_report_response_model.dart';
import 'package:root_app/services/payroll/payroll_repository.dart';

class PayrollController extends GetxController {
  late Rx<PayrollScreen> pageScreen;
  late RxInt month;
  late RxInt year;
  late PayrollReportModel payrollReportModel;
  late Rx<AutovalidateMode> autoValidate;
  late List<String> errors;
  late RxBool isLoading;

  final payrollFormKey = GlobalKey<FormState>();
  final payrollService = getIt<PayrollRepository>();

  @override
  void onInit() {
    pageScreen = PayrollScreen.Main.obs;
    month = 0.obs; //DateTime.now().month.obs;
    year = 0.obs; //DateTime.now().year.obs;
    payrollReportModel = PayrollReportModel();
    isLoading = false.obs;
    errors = <String>[].obs;
    autoValidate = AutovalidateMode.disabled.obs;
    super.onInit();
  }

  @override
  void onClose() {
    //clientIDController.dispose();
    super.onClose();
  }

  void restoreDefultValues() {
    // month = 0.obs;
    // year = 0.obs;
    isLoading = false.obs;
    autoValidate.value = AutovalidateMode.disabled;
    errors.clear();
  }

  /// Validation Errors Block

  void addError({required String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
    }
  }

  void onMonthChanged(int value) {
    if (value != 0) {
      removeError(error: kMonthNotSelectedError);
      debugPrint(
          '=======>>>>>> Selected Month : ${months[value - 1]} <<<<<<======');
    } else {
      debugPrint(
          '=======>>>>>> Selected Month : ${value.toString()} <<<<<<======');
    }
    return;
  }

  String? validateSelectedMonth(int value) {
    if (value == 0) {
      addError(error: kMonthNotSelectedError);
      return "";
    }
    return null;
  }

  void onYearChanged(int value) {
    if (value != 0) {
      removeError(error: kYearNotSelectedError);
    }
    debugPrint(
        '=======>>>>>> Selected Year : ${value.toString()} <<<<<<======');
    return;
  }

  String? validateSelectedYear(int value) {
    if (value == 0) {
      addError(error: kYearNotSelectedError);
      return "";
    }
    return null;
  }

  /// Validation Errors Block

  /// Function Block

  Future<PayrollReportResponseModel> submit() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    UserInfo user = getCurrentUser();
    payrollReportModel.employeeId = user.employeeId;

    final result = pageScreen.value == PayrollScreen.PaySlip
        ? await payrollService.payslip(payrollReportModel)
        : await payrollService.taxCard(payrollReportModel);
    isLoading.value = false;
    return result;
  }

  UserInfo getCurrentUser() {
    final getStorge = GetStorage();
    final userJsonString = getStorge.read(USER_SIGN_IN_KEY);
    var user = UserInfo.fromJson(json.decode(userJsonString));
    return user;
  }

  /// Function Block
}
