import 'package:get/get.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/models/colleagues/colleagues_response_model.dart';
import 'package:root_app/services/colleagues/colleagues_repository.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';

class ColleaguesController extends GetxController {
  late Rx<ColleaguesScreen> pageScreen;
  late List<Colleague> colleagues;
  late RxBool isLoading;
  late RxString searchText;

  final colleaguesService = getIt<ColleaguesRepository>();

  @override
  void onInit() {
    pageScreen = ColleaguesScreen.Colleagues.obs;
    colleagues = <Colleague>[];
    isLoading = false.obs;
    searchText = ''.obs;

    colleagueList();
    super.onInit();
  }

  @override
  void onClose() {
    //clientIDController.dispose();
    super.onClose();
  }

  void restoreDefultValues() {
    isLoading = false.obs;
    searchText = ''.obs;
  }

  /// Function Block

  Future<List<Colleague>> colleagueList() async {
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = true;
    await colleaguesService.colleagues().then((result) {
      colleagues = result.colleagues;
      isLoading.value = false;
    });

    return colleagues;
  }

  /// Function Block
}
