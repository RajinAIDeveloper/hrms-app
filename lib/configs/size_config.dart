import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData = const MediaQueryData();
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double defaultSize = 0;
  static Orientation? orientation;
  static bool isMobileDevice = false;
  static bool isTabeDevice = false;
  static bool isWebDevice = false;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    isMobileDevice = _mediaQueryData.size.width < 576;
    isWebDevice = _mediaQueryData.size.width > 992;
    isTabeDevice =
        _mediaQueryData.size.width >= 576 && _mediaQueryData.size.width <= 992;

    getDeviceInfo(isMobileDevice, isTabeDevice, isWebDevice);
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  var height = (inputHeight / 812.0) * screenHeight;
  //debugPrint('=======>>> Height : $height  <<<======');
  return height;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use

  var width = (inputWidth / 375.0) * screenWidth;
  //debugPrint('=======>>> Width : $width  <<<======');
  return width;
}

void getDeviceInfo(bool isMobileDevice, bool isTabeDevice, bool isWebDevice) {
  String message = '=======>>>>>> App is Running on :';

  if (isMobileDevice) {
    message += ' Mobile';
  } else if (isTabeDevice) {
    message += ' Tab';
  } else if (isWebDevice) {
    message += ' Web';
  } else {
    message += ' Unknown Device';
  }

  message += ' <<<<<<======';
  debugPrint(message);
}
