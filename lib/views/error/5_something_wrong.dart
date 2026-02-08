// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/const_colors.dart';

class SomethingWrongScreen extends StatelessWidget {
  const SomethingWrongScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error/5_Something Wrong.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: SizeConfig.isTabeDevice
                ? SizeConfig.screenHeight * 0.07
                : SizeConfig.screenHeight * 0.11,
            left: SizeConfig.isTabeDevice
                ? SizeConfig.screenWidth * 0.4
                : SizeConfig.screenWidth * 0.3,
            right: SizeConfig.isTabeDevice
                ? SizeConfig.screenWidth * 0.4
                : SizeConfig.screenWidth * 0.3,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor, //const Color(0xFF7070DA),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "go back".toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
