import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(80)),
                Image.asset(kAppLogo,
                    fit: BoxFit.contain,
                    width: getProportionateScreenWidth(160)),
                AppText(
                  text: "Welcome Back!",
                  size: getProportionateScreenWidth(kLargeTextSize),
                ),
                AppText(
                  text: "Sign in with your email and password",
                  size: getProportionateScreenWidth(kMediumTextSize),
                ),

                SizedBox(height: getProportionateScreenHeight(60)),
                SignForm(),

                SizedBox(height: getProportionateScreenHeight(12)),
                const ForgetPasswordText(),

                SizedBox(height: getProportionateScreenHeight(36)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocalCard(
                      icon: "assets/icons/facebook-2.svg",
                      press: () {
                        debugPrint("Facebook Clicked");
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/instagram.svg",
                      press: () {
                        debugPrint("Instagram Clicked");
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/twitter.svg",
                      press: () {
                        debugPrint("Twitter Clicked");
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/youtube.svg",
                      press: () {
                        debugPrint("Youtube Clicked");
                      },
                    ),
                    SocalCard(
                      icon: "assets/icons/google-icon.svg",
                      press: () {
                        debugPrint("Google Clicked");
                      },
                    ),
                  ],
                ),

                SizedBox(height: getProportionateScreenHeight(48)),
                const CopyrightText(),

                SizedBox(
                    height: SizeConfig.isMobileDevice
                        ? getProportionateScreenHeight(12)
                        : getProportionateScreenHeight(24)),

                //const NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
