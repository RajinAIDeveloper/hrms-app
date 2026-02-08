import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
import 'package:root_app/models/authentication/components.dart';
import 'package:root_app/models/profile/profile_model.dart';
import 'package:root_app/services/authentication/authentication_repository.dart';
import 'package:root_app/services/profile/profile_repository.dart';

class SignInController extends GetxController {
  final signInFormKey = GlobalKey<FormState>();
  final clientIDController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = getIt<AuthenticationRepository>();
  final profileService = getIt<ProfileRepository>();

  late SignInModel signInModel;
  late ProfileModel profile;
  late Rx<AutovalidateMode> autoValidate = AutovalidateMode.disabled.obs;
  List<String> errors = <String>[].obs;
  RxBool hidePassword = true.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    if (kDebugMode) {
      clientIDController.text = 'recom@admin.com';
      emailController.text = 'admin@root.com';
      usernameController.text = 'demo_user';
      passwordController.text = 'Demo@2024';

      /*
        link: https://hris.myrecombd.com/
        Username: demo_admin
        Password: Demo@2024
        Role: Admin

        Username: demo_user
        Password: Demo@2024
        Role: User
        
        Username: demo_yeasin
        Password: Demo@2024
        Role: Supervisor
      */
    }

    signInModel = SignInModel();
    profile = ProfileModel();
    super.onInit();
  }

  @override
  void onClose() {
    clientIDController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Validation Errors Block

  void addError({required String error}) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      errors.remove(error);
    }
  }

  void onClientIDChanged(String value) {
    if (value.trim().isNotEmpty) {
      removeError(error: kClientIDNullError);
    }
    if (value.trim() == '') {
      removeError(error: kInvalidClientIDError);
    }
    return;
  }

  void onEmailChanged(String value) {
    if (value.trim().isNotEmpty) {
      removeError(error: kEmailNullError);
    }
    if (emailValidatorRegExp.hasMatch(value)) {
      removeError(error: kInvalidEmailError);
    }
    if (value.trim() == '') {
      removeError(error: kInvalidEmailError);
    }
    return;
  }

  void onUsernameChanged(String value) {
    if (value.trim().isNotEmpty) {
      removeError(error: kUsernameNullError);
    }
    if (value.trim() == '') {
      removeError(error: kInvalidUsernameError);
    }
    return;
  }

  void onPasswordChanged(String value) {
    if (value.trim().isNotEmpty) {
      removeError(error: kPassNullError);
    }
    if (value.trim().length >= 8) {
      removeError(error: kShortPassError);
    }
    if (value.trim() == '') {
      removeError(error: kInvalidEmailError);
    }
    return;
  }

  String? validateClientID(String value) {
    if (value.trim().isEmpty) {
      addError(error: kClientIDNullError);
      return "";
    }
    return null;
  }

  String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      addError(error: kEmailNullError);
      return "";
    } else if (!emailValidatorRegExp.hasMatch(value)) {
      addError(error: kInvalidEmailError);
      return "";
    }
    return null;
  }

  String? validateUsername(String value) {
    if (value.trim().isEmpty) {
      addError(error: kUsernameNullError);
      return "";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      addError(error: kPassNullError);
      return "";
    } else if (value.length < 6) {
      addError(error: kShortPassError);
      return "";
    }
    return null;
  }

  /// Validation Errors Block

  /// Function Block

  Future<SignInResponseModel> login() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    final result = await authService.signIn(signInModel);
    isLoading.value = false;
    setAuthTokensToLoacalStorage(result);
    getCurrentUserProfile(result.userInfo!);

    return result;
  }

  void setAuthTokensToLoacalStorage(SignInResponseModel result) {
    final getStorge = GetStorage();
    getStorge.write(TOKEN, result.token!);
    getStorge.write(USER_SIGN_IN_KEY, json.encode(result.toJson()));

    // Add password expiry (30 days from now)
    final passwordExpiry = DateTime.now().add(const Duration(minutes: 30));
    final userData = result.toJson()
      ..['passwordExpiry'] = passwordExpiry.toIso8601String();
    getStorge.write(USER_SIGN_IN_KEY, json.encode(userData));
  }

  Future<ProfileModel> getCurrentUserProfile(UserInfo userInfo) async {
    await profileService.userProfile(userInfo.employeeId!).then((result) {
      profile = result;
      final getStorge = GetStorage();
      getStorge.write(USER_PROFILE_KEY, json.encode(profile.toJson()));
    });

    return profile;
  }

  /// Function Block
}
