import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_app/configs/configs.dart';

class CustomSurffixIcon extends StatelessWidget {
  const CustomSurffixIcon({
    super.key,
    required this.svgIcon,
    this.onTap,
  });

  final String svgIcon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          0,
          getProportionateScreenWidth(20),
          getProportionateScreenWidth(20),
          getProportionateScreenWidth(20),
        ),
        child: SvgPicture.asset(
          svgIcon,
          height: getProportionateScreenWidth(18),
        ),
      ),
    );
  }
}
