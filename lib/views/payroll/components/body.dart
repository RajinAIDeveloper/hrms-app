import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/payroll/payroll_controller.dart';
import 'package:root_app/views/payroll/components/components.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final _payrollController = Get.put(PayrollController());
  @override
  Widget build(BuildContext context) {
    _payrollController.restoreDefultValues();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomAppBar(),
            Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: getProportionateScreenWidth(90),
                      color: kPrimaryColor,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth * 0.05,
                      ),
                      width: SizeConfig.screenWidth * 0.90,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppText(
                              text: "Payroll",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              size: kMediumTextSize,
                            ),
                            SizedBox(height: getProportionateScreenWidth(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectabelSvgIconButton(
                                  text: "Payroll",
                                  svgFile: "$kIconPath/payroll_big.svg",
                                  onTapFunction: (() {
                                    _payrollController.pageScreen.value =
                                        PayrollScreen.Main;
                                    debugPrint(_payrollController.pageScreen
                                        .toString());
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(35)),

                Obx((() => Form(
                    key: _payrollController.payrollFormKey,
                    autovalidateMode: _payrollController.autoValidate.value,
                    child: _buildForm()))),
                //SizedBox(height: getProportionateScreenWidth(50)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildForm() {
  final payrollController = Get.find<PayrollController>();
  if (payrollController.pageScreen.value == PayrollScreen.Main) {
    return PayrollMain();
  } else if (payrollController.pageScreen.value == PayrollScreen.PaySlip) {
    return Payslip();
  } else if (payrollController.pageScreen.value == PayrollScreen.TaxCard) {
    return TaxCard();
  } else {
    return const SizedBox.shrink();
  }
}
