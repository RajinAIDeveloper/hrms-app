import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:get/get_core/src/get_main.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/enums/page_enum.dart';

import '../../../controllers/Attendance/attendance_controller.dart';

class AttendanceMain extends StatelessWidget {
  AttendanceMain({
    super.key,
  });

  final _attendanceController = Get.find<AttendanceController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(40)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SizeConfig.screenWidth * 0.25,
                child: SmallSelectabelSvgIconButton(
                  onTapFunction: () {
                    _attendanceController.pageScreen.value =
                        AttendanceScreen.GeoLocation;
                    debugPrint(_attendanceController.pageScreen.toString());
                    _attendanceController.restoreDefultValues();
                  },
                  text: "Geo Location Attendance",
                  svgFile: "$kIconPath/geo_location.svg",
                ),
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
              SizedBox(
                width: SizeConfig.screenWidth * 0.25,
                child: SmallSelectabelSvgIconButton(
                  onTapFunction: () {
                    _attendanceController.pageScreen.value =
                        AttendanceScreen.ManualAttendance;
                    debugPrint(_attendanceController.pageScreen.toString());
                    _attendanceController.restoreDefultValues();
                  },
                  text: "Manual Attendance",
                  svgFile: "$kIconPath/attendance.svg",
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenHeight(20)),
        Center(
          child: SizedBox(
            width: SizeConfig.screenWidth * 0.25,
            child: SmallSelectabelSvgIconButton(
              onTapFunction: () {
                _attendanceController.pageScreen.value =
                    AttendanceScreen.AttendanceReport;
                debugPrint(_attendanceController.pageScreen.toString());
                _attendanceController.restoreDefultValues();

                _attendanceController.fetchManualAttendances();
              },
              text: "Daily Report",
              svgFile: "$kIconPath/report_attendance.svg",
            ),
          ),
        ),
      ],
    );
  }
}
