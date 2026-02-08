// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/const_colors.dart';

class SomethingWentWrongScreen extends StatelessWidget {
  const SomethingWentWrongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error/3_Something Went Wrong.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            // bottom: SizeConfig.screenHeight * 0.15,
            // left: SizeConfig.screenWidth * 0.3,
            // right: SizeConfig.screenWidth * 0.3,

            bottom: SizeConfig.isTabeDevice
                ? SizeConfig.screenHeight * 0.08
                : SizeConfig.screenHeight * 0.10,
            left: SizeConfig.isTabeDevice
                ? SizeConfig.screenWidth * 0.4
                : SizeConfig.screenWidth * 0.3,
            right: SizeConfig.isTabeDevice
                ? SizeConfig.screenWidth * 0.4
                : SizeConfig.screenWidth * 0.3,

            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Try Again".toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
