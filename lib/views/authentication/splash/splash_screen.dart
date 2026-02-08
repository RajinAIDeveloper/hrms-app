import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/routes/routing_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final getStorge = GetStorage();
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      //getStorge.erase();
      // This will be executed after 3 seconds
      if (getStorge.read(USER_SIGN_IN_KEY) != null) {
        // var a = getStorge.read(USER_SIGN_IN_KEY);
        // var b = SignInResponseModel.fromJson(jsonDecode(a));
        Navigator.pushNamedAndRemoveUntil(
          context,
          HOME_SCREEN,
          (_) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          SIGN_IN_SCREEN,
          (_) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        // child: AppText(text: 'Splash Screen'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              kAppLogo,
              height: getProportionateScreenHeight(105.0),
            ),
            const SpinKitThreeBounce(
              color: kDotColor,
              size: 30.0,
            )
          ],
        ),
      ),
    );
  }
}
