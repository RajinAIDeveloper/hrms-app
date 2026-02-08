import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/routes/routing_constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    this.height,
  });
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height != null ? getProportionateScreenWidth(height!) : null,
      color: kPrimaryColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                logoutConfirmation(context);
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  Future<dynamic> logoutConfirmation(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: const AppText(
              text: "Logout Confirmation",
              textAlign: TextAlign.center,
              size: kMediumTextSize,
              fontWeight: FontWeight.bold,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(
                  text: "Do you want to logout?",
                ),
                SizedBox(height: getProportionateScreenWidth(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppDefaultButton(
                      width: 80,
                      height: 40,
                      text: "Yes",
                      //fontWeight: FontWeight.bold,
                      press: () async {
                        final getStorge = GetStorage();
                        getStorge.remove(TOKEN);
                        getStorge.remove(USER_SIGN_IN_KEY);
                        getStorge.remove(USER_PROFILE_KEY);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          ONBOARD_SCREEN,
                          (_) => false,
                        );
                      },
                    ),
                    SizedBox(width: getProportionateScreenWidth(15)),
                    AppDefaultButton(
                      text: "No",
                      width: 80,
                      height: 40,
                      color: kSecondarColor,
                      //fontWeight: FontWeight.bold,
                      press: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(10)),
              ],
            ),
          );
        });
  }
}
