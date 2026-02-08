// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/routes/routing_constants.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final bool isActive;

  const CustomBottomNavBar({
    super.key,
    required this.activeIndex,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isAndroid
          ? getProportionateScreenWidth(55)
          : getProportionateScreenWidth(85),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black12,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35.0),
          topRight: Radius.circular(35.0),
        ),
        child: BottomNavigationBar(
          //backgroundColor: kDotColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: activeIndex < 0 ? 0 : activeIndex,
          onTap: (idx) {
            if (idx == activeIndex) return;
            switch (idx) {
              case 0:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HOME_SCREEN,
                  (_) => false,
                );
                return;
              case 1:
                Navigator.of(context).pushNamed(COLLEAGUES_SCREEN);
                return;
              case 2:
                Navigator.of(context).pushNamed(NOTIFICATION_SCREEN);
                return;
              case 3:
                Navigator.of(context).pushNamed(PROFILE_SCREEN);
                return;
              default:
                return;
            }
          },
          showUnselectedLabels: true,
          selectedItemColor: isActive
              ? kPrimaryColor
              : const Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
          unselectedItemColor: const Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
          selectedLabelStyle: isActive
              ? const TextStyle(
                  fontSize: kTextSize - 4,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                )
              : const TextStyle(
                  fontSize: kTextSize - 4,
                  color: Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
                ),
          unselectedLabelStyle: const TextStyle(
            fontSize: kTextSize - 4,
            color: Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "$kIconPath/home.svg",
                height: getProportionateScreenWidth(20),
                width: getProportionateScreenWidth(20),
                color: activeIndex == 0 && isActive
                    ? kPrimaryColor
                    : const Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "$kIconPath/colleagues.svg",
                height: getProportionateScreenWidth(20),
                width: getProportionateScreenWidth(20),
                color: activeIndex == 1 && isActive
                    ? kPrimaryColor
                    : const Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
              ),
              label: "Colleagues",
            ),
            BottomNavigationBarItem(
              // icon: Stack(children: <Widget>[
              //   Icon(Icons.notifications_active_outlined),
              //   Positioned(
              //     // draw a red marble
              //     top: 0.0,
              //     right: 0.0,
              //     child: Icon(Icons.brightness_1,
              //         size: 8.0, color: Colors.redAccent),
              //   )
              // ]),
              icon: SvgPicture.asset(
                "$kIconPath/notification.svg",
                height: getProportionateScreenWidth(20),
                width: getProportionateScreenWidth(20),
                color: activeIndex == 2 && isActive
                    ? kPrimaryColor
                    : const Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
              ),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "$kIconPath/my_profile.svg",
                height: getProportionateScreenWidth(20),
                width: getProportionateScreenWidth(20),
                color: activeIndex == 3 && isActive
                    ? kPrimaryColor
                    : const Color.fromARGB(0xff, 0x4e, 0x58, 0x6e),
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
