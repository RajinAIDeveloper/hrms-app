import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/appbar/custom_appbar.dart';
import 'package:root_app/components/buttons/selectable_svg_icon_button.dart';
import 'package:root_app/components/texts/app_text.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/const_colors.dart';
import 'package:root_app/constants/const_image.dart';
import 'package:root_app/constants/const_size.dart';
import 'package:root_app/controllers/early_departure/early_departure_controller.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/views/Early_departure/components/Early_departure_main.dart';
import 'package:root_app/views/Early_departure/components/early_departure.dart';
import 'package:root_app/views/Early_departure/components/early_departure_report.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final _earlydepartureController = Get.put(EarlyDepartureController());

  @override
  Widget build(BuildContext context) {
    _earlydepartureController.restoreDefultValues();
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
                              text: "Early Departure",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              size: kMediumTextSize,
                            ),
                            SizedBox(height: getProportionateScreenWidth(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SelectabelSvgIconButton(
                                  text: "Early Departure",
                                  svgFile: "$kIconPath/early_departure.svg",
                                  onTapFunction: (() {
                                    _earlydepartureController.pageScreen.value =
                                        EarlyDepartureScreen.Main;
                                    debugPrint(_earlydepartureController
                                        .pageScreen
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
                    key: _earlydepartureController.earlydepartureFormKey,
                    autovalidateMode:
                        _earlydepartureController.autoValidate.value,
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

// Widget _buildForm() {
//   final earlydepartureController = Get.find<EarlyDepartureController>();
//   if (earlydepartureController.pageScreen.value == EarlyDepartureScreen.Main) {
//     return EarlyDepartureMain();
//   } else if (earlydepartureController.pageScreen.value ==
//       EarlyDepartureScreen.EarlyDeparture) {
//     return EarlyDeparture();
//     // } else if (attendanceController.pageScreen.value ==
//     //     AttendanceScreen.AttendanceReport) {
//     //   return AttendanceReport();
//   } else {
//     return const SizedBox.shrink();
//   }
// }
Widget _buildForm() {
  final earlydepartureController = Get.find<EarlyDepartureController>();
  switch (earlydepartureController.pageScreen.value) {
    case EarlyDepartureScreen.Main:
      return EarlyDepartureMain();
    case EarlyDepartureScreen.EarlyDeparture:
      return EarlyDeparture();
    case EarlyDepartureScreen.EarlyDepartureReport:
      return EarlyDepartureReport();
    default:
      return const SizedBox.shrink();
  }
}
