// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/const_colors.dart';

class TimeErrorScreen extends StatelessWidget {
  const TimeErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error/16_Time Error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: SizeConfig.screenHeight * 0.06,
            left: SizeConfig.isTabeDevice
                ? SizeConfig.screenWidth * 0.4
                : SizeConfig.screenWidth * 0.3,
            right: SizeConfig.isTabeDevice
                ? SizeConfig.screenWidth * 0.4
                : SizeConfig.screenWidth * 0.3,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kGreenColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                " Retry ".toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
