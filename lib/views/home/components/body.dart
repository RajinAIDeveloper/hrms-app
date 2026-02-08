import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/home/home_controller.dart';
import 'package:root_app/views/home/components/components.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  Body({super.key});

  // ignore: unused_field
  final _homeController = Get.put(HomeController());

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
              Profile(
                data: _homeController.profile,
              ),
            ]),
            const Features(),
            const SpecialOffers(),
            SizedBox(height: getProportionateScreenWidth(100)),
          ],
        ),
      ),
    );
  }
}
