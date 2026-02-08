import 'package:flutter/material.dart';
import 'package:root_app/components/texts/app_text.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';

class AppDefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback? press;
  final double width;
  final double height;
  final Color color;
  final double textSize;
  final FontWeight fontWeight;
  final double radiusCircular;

  const AppDefaultButton(
      {super.key,
      required this.text,
      required this.press,
      this.width = double.infinity,
      this.height = 56,
      this.color = kPrimaryColor,
      this.textSize = kMediumTextSize,
      this.fontWeight = FontWeight.normal,
      this.radiusCircular = 5});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getProportionateScreenWidth(width),
      height: getProportionateScreenHeight(height),
      child: TextButton(
        style: TextButton.styleFrom(
          //shape: const LinearBorder(),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radiusCircular))),
          backgroundColor: color,
        ),
        onPressed: press,
        child: Row(
          children: [
            const Spacer(),
            AppText(
              text: text,
              size: getProportionateScreenWidth(textSize),
              color: Colors.white,
              fontWeight: fontWeight,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
