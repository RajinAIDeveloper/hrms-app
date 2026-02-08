import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/colleagues/colleagues_controller.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/views/colleagues/components/components.dart';

class Body extends StatelessWidget {
  Body({super.key});

  final _colleaguesController = Get.put(ColleaguesController());
  @override
  Widget build(BuildContext context) {
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
                              text: "Colleagues",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              size: kMediumTextSize,
                            ),
                            SizedBox(height: getProportionateScreenWidth(10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SelectabelSvgIconButton(
                                  text: "Colleagues",
                                  svgFile: "$kIconPath/colleagues_big.svg",
                                  onTapFunction: (() {
                                    _colleaguesController.pageScreen.value =
                                        ColleaguesScreen.Colleagues;
                                    debugPrint(_colleaguesController.pageScreen
                                        .toString());
                                  }),
                                ),
                                // SelectabelSvgIconButton(
                                //     text: "Leave",
                                //     svgFile: "$kIconPath/self_leave.svg",
                                //     onTapFunction: (() {
                                //       _colleaguesController.pageScreen.value =
                                //           ColleaguesScreen.Colleagues;
                                //       debugPrint(_colleaguesController.pageScreen
                                //           .toString());
                                //     }),
                                //     isSelected:
                                //         _colleaguesController.pageScreen.value ==
                                //             ColleaguesScreen.Colleagues),
                              ],
                            ),
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
  final colleaguesController = Get.find<ColleaguesController>();
  if (colleaguesController.pageScreen.value == ColleaguesScreen.Main) {
    return const ColleaguesMain();
  } else if (colleaguesController.pageScreen.value ==
      ColleaguesScreen.Colleagues) {
    return Colleagues();
  } else {
    return const SizedBox.shrink();
  }
}
