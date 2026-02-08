import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  final getStorge = GetStorage();

  @override
  void onReady() {
    super.onReady();
    if (getStorge.read("id") != null) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        // Get.offAllNamed(Routes.HOME);
      });
    } else {
      // Get.offAllNamed(Routes.LOGIN);
    }
  }
}
