import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';

class OnboardContent extends StatelessWidget {
  final String text, image;
  const OnboardContent({
    super.key,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(
          flex: 3,
        ),
        // Image.asset(
        //   ImageManagemetService.AppLogo,
        //   height: getProportionateScreenHeight(120),
        //   width: getProportionateScreenWidth(120),
        // ),
        AppText(
          text: "HRMS",
          size: getProportionateScreenWidth(36),
        ),
        AppText(
          text: text,
          textAlign: TextAlign.center,
        ),
        const Spacer(flex: 2),
        SvgPicture.asset(
          image,
          fit: BoxFit.contain,
          height: getProportionateScreenHeight(265), //265
          width: getProportionateScreenWidth(235), //235
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
