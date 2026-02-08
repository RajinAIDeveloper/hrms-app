import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'components/components.dart';

class OnboardScreen extends StatelessWidget {
  //static String routeName = "/splash";

  const OnboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}
