import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight fontWeight;
  final Color color;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextDecoration? decoration;
  final TextOverflow? overflow;

  const AppText(
      {super.key,
      required this.text,
      this.size,
      this.fontWeight = FontWeight.normal,
      this.color = kTextColor,
      this.fontFamily,
      this.textAlign,
      this.decoration = TextDecoration.none,
      this.overflow = TextOverflow.visible});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      textDirection: TextDirection.ltr,
      style: TextStyle(
          fontSize: size ?? getProportionateScreenWidth(kTextSize),
          fontWeight: fontWeight,
          color: color,
          fontFamily: 'OpenSans',
          decoration: decoration),
    );
  }
}
