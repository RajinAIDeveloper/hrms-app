// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/routes/routing_constants.dart';

class Error404Screen2 extends StatelessWidget {
  const Error404Screen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error/8_404 Error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: SizeConfig.isTabeDevice
                ? SizeConfig.screenHeight * 0.07
                : SizeConfig.screenHeight * 0.06, //11
            left: SizeConfig.isTabeDevice
                ? SizeConfig.screenWidth * 0.4
                : SizeConfig.screenWidth * 0.3,
            right: SizeConfig.isTabeDevice
                ? SizeConfig.screenWidth * 0.4
                : SizeConfig.screenWidth * 0.3,
            // bottom: SizeConfig.screenHeight * 0.14,
            // left: SizeConfig.screenWidth * 0.065,

            child: TextButton(
              style: TextButton.styleFrom(
                //foregroundColor: Colors.white,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HOME_SCREEN,
                  (_) => false,
                );
              },
              child: Text(
                "Home".toUpperCase(),
                style: const TextStyle(color: kTextColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}
