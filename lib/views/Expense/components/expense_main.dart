import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/Expense/expense_controller.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/enums/page_enum.dart';

class ExpenseMain extends StatelessWidget {
  ExpenseMain({
    super.key,
  });
  final _expenseController = Get.find<ExpenseController>();
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
                    _expenseController.pageScreen.value =
                        ExpenseScreen.ExpenseRequestScreen;
                    debugPrint(_expenseController.pageScreen.toString());
                    _expenseController.restoreDefultValues();
                  },
                  text: "Expense Request",
                  svgFile: "$kIconPath/salary_pay_slip.svg",
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.250,
                child: SmallSelectabelSvgIconButton(
                  onTapFunction: () {
                    _expenseController.pageScreen.value =
                        ExpenseScreen.ExpenseForm;
                    debugPrint(_expenseController.pageScreen.toString());
                    _expenseController.restoreDefultValues();
                  },
                  text: "Expense Request Form",
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
