import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/work-shift/workshift_controller.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/views/workshift/components/workshift-calender.dart';

import 'package:root_app/views/workshift/components/workshift_main.dart';
import 'package:root_app/views/workshift/components/workshift-list.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final _workShiftController = Get.put(WorkshiftController());
  @override
  Widget build(BuildContext context) {
    _workShiftController.restoreDefultValues();
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
                              text: "Work Shift",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              size: kMediumTextSize,
                            ),
                            SizedBox(height: getProportionateScreenWidth(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectabelSvgIconButton(
                                  text: "Work Shift",
                                  svgFile: "$kIconPath/shift-emp.svg",
                                  onTapFunction: (() {
                                    _workShiftController.pageScreen.value =
                                        WorkShiftScreen.Main;
                                    debugPrint(_workShiftController.pageScreen
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
                    // key: _payrollController.payrollFormKey,
                    // autovalidateMode: _payrollController.autoValidate.value,
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
  final workshiftController = Get.find<WorkshiftController>();
  if (workshiftController.pageScreen.value == WorkShiftScreen.Main) {
    return WorkshiftMain();
  } else if (workshiftController.pageScreen.value ==
      WorkShiftScreen.WorkShiftList) {
    return WorkshiftList();
  } else if (workshiftController.pageScreen.value ==
      WorkShiftScreen.WorkshiftCalender) {
    return WorkshiftCalender();
  } else {
    return const SizedBox.shrink();
  }
}
