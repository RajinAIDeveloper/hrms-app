import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/payroll/payroll_controller.dart';

class PayrollMain extends StatelessWidget {
  PayrollMain({
    super.key,
  });
  final _payrollController = Get.find<PayrollController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(80)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth * 0.25,
                child: SmallSelectabelSvgIconButton(
                  onTapFunction: () {
                    _payrollController.pageScreen.value = PayrollScreen.PaySlip;
                    debugPrint(_payrollController.pageScreen.toString());
                    _payrollController.restoreDefultValues();
                  },
                  text: "Pay Slip",
                  svgFile: "$kIconPath/salary_pay_slip.svg",
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.250,
                child: SmallSelectabelSvgIconButton(
                  onTapFunction: () {
                    _payrollController.pageScreen.value = PayrollScreen.TaxCard;
                    debugPrint(_payrollController.pageScreen.toString());
                    _payrollController.restoreDefultValues();
                  },
                  text: "Tax Card",
                  svgFile: "$kIconPath/tax_card.svg",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
