// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';

class BrokenLinkScreen extends StatelessWidget {
  const BrokenLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error/11_Broken Link.png",
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
                    offset: const Offset(0, 5),
                    blurRadius: 25,
                    color: Colors.black.withOpacity(0.17),
                  ),
                ],
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: AppText(
                  text: "retry".toUpperCase(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
