import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/Expense/expense_controller.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/views/Expense/components/expense_form.dart';
import 'package:root_app/views/Expense/components/expense_main.dart';
import 'package:root_app/views/Expense/components/expense_resquest.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final _expenseController = Get.put(ExpenseController());
  @override
  Widget build(BuildContext context) {
    _expenseController.restoreDefultValues();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // Add this to prevent unbounded height
          children: [
            const CustomAppBar(),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Add this to prevent unbounded height
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
                                text: "Expense Management",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                size: kMediumTextSize,
                              ),
                              SizedBox(height: getProportionateScreenWidth(10)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SelectabelSvgIconButton(
                                    text: "Expense",
                                    svgFile: "$kIconPath/cost-icon.svg",
                                    onTapFunction: (() {
                                      _expenseController.pageScreen.value =
                                          ExpenseScreen.Main;
                                      debugPrint(_expenseController.pageScreen
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
                      key: _expenseController.expenseFormKey,
                      autovalidateMode: _expenseController.autoValidate.value,
                      child: _buildForm()))),
                  //SizedBox(height: getProportionateScreenWidth(50)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildForm() {
  final expenseController = Get.find<ExpenseController>();
  if (expenseController.pageScreen.value == ExpenseScreen.Main) {
    return ExpenseMain();
  } else if (expenseController.pageScreen.value ==
      ExpenseScreen.ExpenseRequestScreen) {
    return ExpenseRequestScreen();
  } else if (expenseController.pageScreen.value == ExpenseScreen.ExpenseForm) {
    return ExpenseForm();
  } else {
    return const SizedBox.shrink();
  }
}
