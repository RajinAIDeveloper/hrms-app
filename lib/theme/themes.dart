import 'package:flutter/material.dart';
import 'package:root_app/constants/constants.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  final darkTheme = ThemeData.dark().copyWith(
      // primaryColor: Colors.blueGrey[800],
      // appBarTheme: const AppBarTheme(color: Colors.deepOrangeAccent)
      );

  static InputDecorationTheme inputDecorationTheme() {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: kPrimaryColor),
      gapPadding: 10,
    );
    return InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
      floatingLabelStyle: const TextStyle(color: kPrimaryColor),
    );
  }

  static TextTheme textTheme() {
    return const TextTheme(
        // headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
        // bodyText1: TextStyle(color: kTextColor),
        // bodyText2: TextStyle(color: kTextColor),

        );
  }

  static AppBarTheme appBarTheme() {
    return const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    );
  }
}
