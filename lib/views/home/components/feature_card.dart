import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.text,
    required this.press,
  });

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: getProportionateScreenWidth(70),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(15)),
              height: getProportionateScreenWidth(70),
              width: getProportionateScreenWidth(70),
              decoration: BoxDecoration(
                color: const Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                icon,
                // ignore: deprecated_member_use
                color: const Color.fromRGBO(255, 118, 67, 1),
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(5)),
            AppText(
              text: text,
              textAlign: TextAlign.center,
              size: 10,
            ),
          ],
        ),
      ),
    );
  }
}
