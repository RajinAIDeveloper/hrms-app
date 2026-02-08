import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/const_colors.dart';
import 'package:root_app/constants/const_size.dart';
import 'package:root_app/models/profile/profile_model.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key, required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getProportionateScreenHeight(90),
      width: double.infinity,
      margin: EdgeInsets.all(getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(15),
      ),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: "${profile.employeeName}\n",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(kTextSize),
              ),
            ),
            TextSpan(
              text: profile.designationName,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(kLargeTextSize - 4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
