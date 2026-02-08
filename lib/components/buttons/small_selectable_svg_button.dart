import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';

class SmallSelectabelSvgIconButton extends StatelessWidget {
  final String text;
  final String svgFile;
  final VoidCallback? onTapFunction;
  final bool isSelected;

  const SmallSelectabelSvgIconButton({
    super.key,
    required this.text,
    required this.svgFile,
    this.isSelected = false,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(getProportionateScreenWidth(10)),
            decoration: BoxDecoration(
              color: isSelected
                  ? kSecondarColor
                  : const Color.fromRGBO(0x43, 0x7D, 0xDD, 0.15),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset(
              svgFile,
              // ignore: deprecated_member_use
              color: isSelected ? Colors.white : kPrimaryColor,
              width: getProportionateScreenWidth(50),
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(5)),
          AppText(
            text: text,
            color: isSelected ? kSecondarColor : Colors.black45,
            fontWeight: FontWeight.bold,
            size: getProportionateScreenWidth((kMediumTextSize / 2 + 2)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
