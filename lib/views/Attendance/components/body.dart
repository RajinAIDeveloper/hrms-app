import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/Attendance/attendance_controller.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/views/Attendance/components/attendance_main.dart';
import 'package:root_app/views/Attendance/components/attendance_report.dart';
import 'package:root_app/views/Attendance/components/geo_location.dart';
import 'package:root_app/views/Attendance/components/manual_attendance.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final _attendanceController = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    //_payrollController.restoreDefultValues();
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
                              text: "Attendance",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              size: kMediumTextSize,
                            ),
                            SizedBox(height: getProportionateScreenWidth(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectabelSvgIconButton(
                                  text: "Attendance",
                                  svgFile: "$kIconPath/daily_attendance.svg",
                                  onTapFunction: (() {
                                    _attendanceController.pageScreen.value =
                                        AttendanceScreen.Main;
                                    debugPrint(_attendanceController.pageScreen
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
                //AttendanceMain(),
                // Obx(() {
                //   switch (_attendanceController.pageScreen.value) {
                //     case AttendanceScreen.Main:
                //       return AttendanceMain();
                //     case AttendanceScreen.GeoLocation:
                //       return GeoLocation();
                //     default:
                //       return AttendanceMain();
                //   }
                // })

                Obx((() => Form(
                    key: _attendanceController.attendanceFormKey,
                    autovalidateMode: _attendanceController.autoValidate.value,
                    child: _buildForm()))),
                SizedBox(height: getProportionateScreenWidth(50)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildForm() {
  final attendanceController = Get.find<AttendanceController>();
  if (attendanceController.pageScreen.value == AttendanceScreen.Main) {
    return AttendanceMain();
  } else if (attendanceController.pageScreen.value ==
      AttendanceScreen.GeoLocation) {
    return GeoLocation();
  } else if (attendanceController.pageScreen.value ==
      AttendanceScreen.AttendanceReport) {
    return AttendanceReport();
  } else if (attendanceController.pageScreen.value ==
      AttendanceScreen.ManualAttendance) {
    return ManualAttendance();
  } else {
    return const SizedBox.shrink();
  }
}
