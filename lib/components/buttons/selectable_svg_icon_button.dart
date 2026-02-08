import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';

class SelectabelSvgIconButton extends StatelessWidget {
  final String text;
  final double textSize;
  final String svgFile;
  final VoidCallback? onTapFunction;
  final double size;
  final bool isSelected;
  final double paddingVertical;
  const SelectabelSvgIconButton({
    super.key,
    required this.text,
    required this.svgFile,
    this.size = 55,
    this.textSize = kTextSize,
    this.isSelected = false,
    this.onTapFunction,
    this.paddingVertical = 18,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Container(
        width: SizeConfig.screenWidth * 0.38,
        padding: EdgeInsets.symmetric(
          vertical: getProportionateScreenWidth(paddingVertical),
        ),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black26,
              offset: Offset.fromDirection(math.pi * 0.5, 10),
            )
          ],
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              svgFile,
              height: getProportionateScreenWidth(size),
              width: getProportionateScreenWidth(size),
              // ignore: deprecated_member_use
              color: isSelected ? Colors.white : kSecondarColor,
            ),
            SizedBox(height: getProportionateScreenWidth(5)),
            SizedBox(
              width: SizeConfig.screenWidth * 0.3,
              child: AppText(
                text: text,
                color: isSelected ? Colors.white : Colors.black45,
                fontWeight: FontWeight.bold,
                size: getProportionateScreenWidth(textSize),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
