import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';

class EarlyDepartureCell extends StatelessWidget {
  final bool isDark;
  final bool isLeftRounded;
  final bool isRightRounded;
  final String text;

  const EarlyDepartureCell({
    super.key,
    required this.text,
    this.isDark = false,
    this.isLeftRounded = false,
    this.isRightRounded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(130),
      height: getProportionateScreenHeight(30),
      decoration: BoxDecoration(
        color: isDark ? kPrimaryColor : const Color(0xfff3f3f3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isLeftRounded ? 12 : 0),
          bottomLeft: Radius.circular(isLeftRounded ? 12 : 0),
          topRight: Radius.circular(isRightRounded ? 12 : 0),
          bottomRight: Radius.circular(isRightRounded ? 12 : 0),
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(5),
      ),
      margin: EdgeInsets.only(
        bottom: getProportionateScreenWidth(2),
        right: getProportionateScreenWidth(2),
      ),
      child: Center(
        child: AppText(
          text: text,
          size: kTextSize - 4,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : kTextColor,
        ),
      ),
    );
  }
}
