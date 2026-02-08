import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/models/profile/profile_model.dart';

class HomeController extends GetxController {
  late ProfileModel profile;

  @override
  void onInit() {
    profile = ProfileModel();
    getCurrentUserProfile();
    super.onInit();
  }

  @override
  void onClose() {
    //clientIDController.dispose();
    super.onClose();
  }

  ProfileModel getCurrentUserProfile() {
    final getStorge = GetStorage();
    final jsonString = getStorge.read(USER_PROFILE_KEY);

    if (jsonString != null) {
      profile = ProfileModel.fromJson(json.decode(jsonString));
    }
    return profile;
  }

  /// Function Block
}
