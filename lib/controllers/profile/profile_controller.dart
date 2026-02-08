import 'package:get/get.dart';
import 'package:root_app/controllers/home/home_controller.dart';
import 'package:root_app/models/profile/profile_model.dart';
import 'package:root_app/services/profile/profile_repository.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';

class ProfileController extends GetxController {
  late ProfileModel profile;
  late RxBool isLoading;

  final profileService = getIt<ProfileRepository>();

  @override
  void onInit() {
    profile = ProfileModel();
    isLoading = false.obs;
    getCurrentUserProfile();
    super.onInit();
  }

  @override
  void onClose() {
    //clientIDController.dispose();
    super.onClose();
  }

  void restoreDefultValues() {
    isLoading = false.obs;
  }

  /// Function Block

  Future<ProfileModel> getCurrentUserProfile() async {
    final homeController = Get.find<HomeController>();
    var user = homeController.profile;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 3));
    await profileService.userProfile(user.employeeId!).then((result) {
      profile = result;
      isLoading.value = false;
    });
    return profile;
  }

  /// Function Block
}
