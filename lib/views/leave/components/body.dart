import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/leave/leave_controller.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/views/leave/components/components.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final _leaveController = Get.put(LeaveController());
  @override
  Widget build(BuildContext context) {
    _leaveController.restoreDefultValues();
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
                              text: "Leave",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              size: kMediumTextSize,
                            ),
                            SizedBox(height: getProportionateScreenWidth(10)),
                            Obx((() => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SelectabelSvgIconButton(
                                        text: "Holiday List",
                                        svgFile: "$kIconPath/holiday_list.svg",
                                        onTapFunction: (() {
                                          _leaveController.pageScreen.value =
                                              LeaveScreen.Holidays;
                                          debugPrint(_leaveController.pageScreen
                                              .toString());
                                        }),
                                        isSelected:
                                            _leaveController.pageScreen.value ==
                                                LeaveScreen.Holidays),
                                    SelectabelSvgIconButton(
                                        text: "Leave",
                                        svgFile: "$kIconPath/self_leave.svg",
                                        onTapFunction: (() {
                                          _leaveController.pageScreen.value =
                                              LeaveScreen.SelfLeave;
                                          debugPrint(_leaveController.pageScreen
                                              .toString());
                                        }),
                                        isSelected:
                                            _leaveController.pageScreen.value ==
                                                LeaveScreen.SelfLeave),
                                  ],
                                ))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(35)),
                Obx((() => _buildScreenContent())),
                SizedBox(height: getProportionateScreenWidth(50)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildScreenContent() {
  final leaveController = Get.find<LeaveController>();
  if (leaveController.pageScreen.value == LeaveScreen.Main) {
    return const LeaveMain();
  } else if (leaveController.pageScreen.value == LeaveScreen.Holidays) {
    return Holidays();
  } else if (leaveController.pageScreen.value == LeaveScreen.SelfLeave) {
    return LeaveSelf();
  } else {
    return const SizedBox.shrink();
  }
}
