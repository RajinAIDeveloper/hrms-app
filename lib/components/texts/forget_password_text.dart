import 'package:flutter/material.dart';
import 'package:root_app/components/texts/app_text.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/routes/routing_constants.dart';

class ForgetPasswordText extends StatelessWidget {
  const ForgetPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppText(
          text: "Can't remember password? ",
        ),
        // GestureDetector(
        //   onTap: () => debugPrint(
        //       '======>>>> password Reset Link Clicked! <======='), //Navigator.pushNamed(context, ''),
        //   child: const AppText(
        //       text: "Reset",
        //       decoration: TextDecoration.underline,
        //       color: kPrimaryColor),
        // ),
        GestureDetector(
          onTap: () {
            debugPrint('======>>>> Password Reset Link Clicked! <=======');
            Navigator.pushNamed(
                context, FORGOT_PASSWORD_SCREEN); // ✅ Navigation Added
          },
          child: const AppText(
            text: "Forgot Password",
            decoration: TextDecoration.underline,
            color: kPrimaryColor,
          ),
        ),
      ],
    );
  }
}
