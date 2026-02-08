import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/utilities/get_months.dart';
import 'package:root_app/utilities/get_years.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/payroll/payroll_controller.dart';
import 'dart:math' as math;

class TaxCard extends StatelessWidget {
  TaxCard({
    super.key,
  });
  final _payrollController = Get.find<PayrollController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(20),
        horizontal: getProportionateScreenWidth(20),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset.fromDirection(math.pi * .5, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Tax Card",
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(20)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppText(
                text: "Salary Month  ",
                fontWeight: FontWeight.bold,
                size: kTextSize - 2,
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
          buildSalaryMonthDropdownField(),
          SizedBox(height: getProportionateScreenWidth(20)),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppText(
                text: "Salary Year  ",
                fontWeight: FontWeight.bold,
                size: kTextSize - 2,
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
          buildSalaryYearDropdownField(),
          SizedBox(height: getProportionateScreenWidth(15)),
          Obx((() => buildErrorMessages())),
          SizedBox(height: getProportionateScreenWidth(15)),
          Obx((() => buildDownloadButton())),
          SizedBox(height: getProportionateScreenWidth(20)),
        ],
      ),
    );
  }

  Container buildSalaryMonthDropdownField() {
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(7),
        right: getProportionateScreenWidth(3),
        top: getProportionateScreenWidth(10),
        bottom: getProportionateScreenWidth(10),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset.fromDirection(math.pi * .5, 10),
          ),
        ],
      ),
      child: DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          enabled: false,
          border: InputBorder.none,
        ),
        value: _payrollController.month.value,
        items: List<DropdownMenuItem<int>>.generate(
          months.length + 1,
          (idx) => DropdownMenuItem<int>(
            value: idx == 0 ? 0 : idx,
            child: Container(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              width: SizeConfig.screenWidth * 0.5,
              child: AppText(
                text: idx == 0 ? "Select Month" : months[idx - 1],
                size: kTextSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onChanged: (value) => _payrollController.onMonthChanged(value!),
        validator: (value) => _payrollController.validateSelectedMonth(value!),
        onSaved: (newValue) =>
            _payrollController.payrollReportModel.month = newValue,
      ),
    );
  }

  Container buildSalaryYearDropdownField() {
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(7),
        right: getProportionateScreenWidth(3),
        top: getProportionateScreenWidth(10),
        bottom: getProportionateScreenWidth(10),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset.fromDirection(math.pi * .5, 10),
          ),
        ],
      ),
      child: DropdownButtonFormField<int>(
        decoration:
            const InputDecoration(enabled: false, border: InputBorder.none),
        value: _payrollController.year.value,
        items: List<DropdownMenuItem<int>>.generate(
          years.length + 1,
          (idx) => DropdownMenuItem<int>(
            value: idx == 0 ? 0 : years[idx - 1],
            child: Container(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              width: SizeConfig.screenWidth * 0.5,
              child: AppText(
                text: idx == 0 ? "Select Year" : years[idx - 1].toString(),
                size: kTextSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onChanged: (value) => _payrollController.onYearChanged(value!),
        validator: (value) => _payrollController.validateSelectedYear(value!),
        onSaved: (newValue) =>
            _payrollController.payrollReportModel.year = newValue,
      ),
    );
  }

  Stack buildDownloadButton() {
    return Stack(children: [
      AppDefaultButton(
        text: !_payrollController.isLoading.value ? "Download" : "",
        press: () async {
          if (_payrollController.payrollFormKey.currentState!.validate()) {
            _payrollController.payrollFormKey.currentState!.save();
            try {
              debugPrint(
                  '====================>>>>>> Submitted <<<<<<==================');
              await _payrollController.submit().then((value) {
                if (!value.error!) {
                  Get.showSnackbar(
                    GetSnackBar(
                      title: 'Success',
                      message: 'Message : ${'Download Successful'.toString()}',
                      icon: const Icon(
                        Icons.add_task_outlined,
                        color: Colors.white,
                      ),
                      duration: const Duration(seconds: 3),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  Get.showSnackbar(GetSnackBar(
                    title: 'Error',
                    message: 'Message : ${value.errorMessage}',
                    icon: const Icon(
                      Icons.do_not_touch_outlined,
                      color: Colors.white,
                    ),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red.shade700,
                  ));
                }
              });
            } catch (e) {
              _payrollController.isLoading.value = false;
              Get.showSnackbar(
                GetSnackBar(
                  title: 'Error',
                  message: 'Message : ${e.toString()}',
                  icon: const Icon(
                    Icons.do_not_touch_outlined,
                    color: Colors.white,
                  ),
                  duration: const Duration(seconds: 3),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          } else {
            debugPrint(
                '====================>>>>>> Validation Failed <<<<<<==================');
            _payrollController.autoValidate.value = AutovalidateMode.always;
          }
        },
      ),
      _payrollController.isLoading.value
          ? Container(
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenHeight(14),
              ),
              child: const SpinKitThreeBounce(
                color: kDotColor,
                size: 30,
              ),
            )
          : const SizedBox.shrink(),
    ]);
  }

  FormError buildErrorMessages() =>
      FormError(errors: _payrollController.errors.toList());
}
