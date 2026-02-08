import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeService {
  final _getStorage = GetStorage();
  final storageKey = "isDarkMode";

  ThemeMode getThemeMode() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    bool isSystemInDarkMode = brightness == Brightness.dark;
    // ignore: avoid_print
    // print("-------->  System in Dark Mode : " +
    //     isSystemInDarkMode.toString() +
    //     "  <------------");

    if (isSystemInDarkMode == true) {
      return ThemeMode.light;
    } else {
      return isSavedDarkMode() ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void saveThemeMode(bool isDarkMode) {
    _getStorage.write(storageKey, isDarkMode);
  }

  void changeThemeMode() {
    Get.changeThemeMode(isSavedDarkMode() ? ThemeMode.light : ThemeMode.dark);
    saveThemeMode(!isSavedDarkMode());
  }

  bool isSavedDarkMode() {
    return _getStorage.read(storageKey) ?? false;
  }
}
