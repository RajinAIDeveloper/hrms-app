import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/const_colors.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.6,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1), //kSecondaryColor
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) => debugPrint(value),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenWidth(9)),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search product",
            prefixIcon: const Icon(Icons.search)),
      ),
    );
  }
}
