import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_app/configs/configs.dart';

class SocalCard extends StatelessWidget {
  final String icon;
  final VoidCallback press;

  const SocalCard({super.key, required this.icon, required this.press});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        padding: EdgeInsets.all(getProportionateScreenWidth(12)),
        height: !SizeConfig.isTabeDevice
            ? getProportionateScreenHeight(40)
            : getProportionateScreenHeight(60),
        width: getProportionateScreenWidth(40),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 238, 239, 239), // Color(0xFFF5F6F9),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          icon,
        ),
      ),
    );
  }
}
