// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';

class LocationAccessScreen extends StatelessWidget {
  const LocationAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error/9_Location Error.png",
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
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 13),
                    blurRadius: 25,
                    color: const Color(0xFFD27E4A).withOpacity(0.17),
                  ),
                ],
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: kOrangeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Enable".toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
