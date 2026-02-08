import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const CustomAppBar(),
            Stack(children: [
              Container(
                  height: SizeConfig.screenHeight * 0.10, color: kPrimaryColor),
            ]),
            const AppText(text: 'Notification Screen'),
            SizedBox(height: getProportionateScreenWidth(100)),
          ],
        ),
      ),
    );
  }
}
