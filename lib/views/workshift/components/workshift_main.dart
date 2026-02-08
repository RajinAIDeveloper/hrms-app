import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/work-shift/workshift_controller.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';

class WorkshiftMain extends StatelessWidget {
  WorkshiftMain({
    super.key,
  });
  final _workShiftController = Get.find<WorkshiftController>();
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
                    _workShiftController.pageScreen.value =
                        WorkShiftScreen.WorkShiftList;
                    debugPrint(_workShiftController.pageScreen.toString());
                    _workShiftController.restoreDefultValues();
                  },
                  text: "WorkShift List",
                  svgFile: "$kIconPath/shift-list.svg",
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.250,
                child: SmallSelectabelSvgIconButton(
                  onTapFunction: () {
                    _workShiftController.pageScreen.value =
                        WorkShiftScreen.WorkshiftCalender;
                    debugPrint(_workShiftController.pageScreen.toString());
                    _workShiftController.restoreDefultValues();
                  },
                  text: "Shift Calendar",
                  svgFile: "$kIconPath/calender-shift.svg",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
