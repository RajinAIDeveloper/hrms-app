import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/routes/routing_constants.dart';
import 'package:root_app/views/onboard/components/components.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final getStorge = GetStorage();
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {"text": "Welcome to HRMS, Let’s explore!", "image": kSplashImageOne},
    {
      "text": "We help people to conect with everything \naround at one place",
      "image": kSplashImageTwo
    },
    {
      "text": "We show the easy way to mannage. \nJust stay in touch with us",
      "image": kSplashImageThree
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => OnboardContent(
                  image: splashData[index]["image"] ?? '',
                  text: splashData[index]['text'] ?? '',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    const Spacer(flex: 2),
                    AppDefaultButton(
                      text: "Continue".toUpperCase(),
                      press: () {
                        //getStorge.erase();
                        if (getStorge.read(USER_SIGN_IN_KEY) != null) {
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
                      },
                      key: const Key('onboard_continue_button'),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: kAnimationDuration,
      margin: const EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : kDotColor,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
