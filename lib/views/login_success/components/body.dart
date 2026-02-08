import 'dart:async';
import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/routes/routing_constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.pushNamedAndRemoveUntil(
        context,
        HOME_SCREEN,
        (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Image.asset(
            "assets/images/success.png",
            height: SizeConfig.screenHeight * 0.4, //40%
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.08),
          AppText(
            text: "Login Success!",
            size: getProportionateScreenWidth(30),
            //fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: AppDefaultButton(
                text: "Back to home",
                press: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    HOME_SCREEN,
                    (_) => false,
                  );
                },
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
