import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/early_departure/early_departure_controller.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/enums/page_enum.dart';

class EarlyDepartureMain extends StatelessWidget {
  EarlyDepartureMain({
    super.key,
  });

  final _earlydepartureController = Get.find<EarlyDepartureController>();
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
                    _earlydepartureController.pageScreen.value =
                        EarlyDepartureScreen.EarlyDeparture;
                    debugPrint(_earlydepartureController.pageScreen.toString());
                    _earlydepartureController.restoreDefultValues();
                  },
                  text: "Early Departure Request",
                  svgFile: "$kIconPath/leave-early.svg",
                ),
              ),
              SizedBox(
                width: SizeConfig.screenWidth * 0.250,
                child: SmallSelectabelSvgIconButton(
                  onTapFunction: () {
                    _earlydepartureController.pageScreen.value =
                        EarlyDepartureScreen.EarlyDepartureReport;
                    debugPrint(_earlydepartureController.pageScreen.toString());
                    _earlydepartureController.restoreDefultValues();
                  },
                  text: "Report",
                  svgFile: "$kIconPath/report_early_departure.svg",
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
