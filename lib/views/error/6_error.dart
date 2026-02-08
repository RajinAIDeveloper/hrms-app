// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/routes/routing_constants.dart';

class Error1Screen extends StatelessWidget {
  const Error1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error/6_Error.png",
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
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                //backgroundColor: Colors.white,
                side: const BorderSide(width: 1.0, color: Colors.white),
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
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
