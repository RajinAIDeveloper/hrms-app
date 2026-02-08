import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root_app/constants/const_validation.dart';
import 'package:root_app/constants/token_const.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/models/authentication/sign_in_response_model.dart';
import 'package:root_app/models/early_departure/early_departure_item_response.dart';
import 'package:root_app/models/early_departure/early_departure_report_model.dart';
import 'package:root_app/services/early_departure/early_departure_repository.dart';

class EarlyDepartureController extends GetxController {
  late Rx<AutovalidateMode> autoValidate;
  final earlydepartureFormKey = GlobalKey<FormState>();

  Rx<EarlyDepartureScreen> pageScreen = EarlyDepartureScreen.Main.obs;
  var selectedDate = Rxn<DateTime>(); // Reactive DateTime (null by default)
  var selectedTime = Rxn<TimeOfDay>(); // Reactive TimeOfDay (null by default)
  var reason = ''.obs; // Reactive String for reason
  var isSubmitting = false.obs; // Reactive boolean for submission state
  RxBool isLoading = false.obs;
  late RxInt month;
  late RxInt year;
  late RxInt statestatus;
  late List<String> errors;

  late EarlyDepartureReportModel earlyDepartureReportModel;
  RxList<EarlyDepartureItem> earlyDepartureList = <EarlyDepartureItem>[].obs;
  final earlydepartureService = getIt<EarlyDepartureRepository>();
  final filter = EarlyDepartureReportModel().obs;

  // Add the TextEditingController
  final dateTextController = TextEditingController();
  final timeTextController = TextEditingController();
  // Data list for table
  RxList<Map<String, dynamic>> earlyDepartureData =
      <Map<String, dynamic>>[].obs;

  // Added for UI
  String? selectedMonth;
  String? selectedYear;
  String? selectedStatus;

  final List<String> months = [
    '---Select Month---',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<String> years = [
    '---Select Year---',
    '2025',
    '2024',
    '2023',
    '2022',
    '2021'
  ];

  final List<String> statuses = [
    '---Select Status---',
    'Pending',
    'Recommended',
    'Approved',
    'Rejected',
    'Canceled'
  ];

  // // Sample data (replace with actual data from service)
  // List<Map<String, dynamic>> earlyDepartureData = [
  //   {
  //     'sl': 1,
  //     'date': '09 March 2025',
  //     'dayName': 'Sunday',
  //     'inTime': '09:00 AM',
  //     'outTime': '03:00 PM',
  //     'attendanceStatus': 'Present',
  //     'departureDate': '09 March 2025',
  //     'departureTime': '02:30 PM',
  //     'purpose': 'Medical Appointment',
  //     'status': 'Pending'
  //   },
  // ];
  @override
  void onInit() {
    pageScreen = EarlyDepartureScreen.Main.obs;
    isLoading = false.obs;
    month = 0.obs; //DateTime.now().month.obs;
    year = 0.obs; //DateTime.now().year.obs;
    statestatus = 0.obs;
    earlyDepartureReportModel = EarlyDepartureReportModel();
    autoValidate = AutovalidateMode.disabled.obs;
    errors = <String>[].obs;
    isLoading = false.obs;
    fetchEarlyDepartureList();
    //loadSampleData();

    super.onInit();
  }

  // void loadSampleData() {
  //   earlyDepartureData.assignAll([
  //     {
  //       'date': '10 Mar 2025',
  //       'dayName': 'Monday',
  //       'inTime': '9:00 AM',
  //       'outTime': '3:00 PM',
  //       'attendanceStatus': 'Present',
  //       'departureDate': '10 Mar 2025',
  //       'departureTime': '2:50 PM',
  //       'purpose': 'Doctor Visit',
  //       'status': 'Pending',
  //     },
  //     {
  //       'date': '08 Mar 2025',
  //       'dayName': 'Saturday',
  //       'inTime': '9:00 AM',
  //       'outTime': null,
  //       'attendanceStatus': 'Present',
  //       'departureDate': '08 Mar 2025',
  //       'departureTime': '1:00 PM',
  //       'purpose': 'Family Emergency',
  //       'status': 'Approved',
  //     },
  //   ]);
  // }

  @override
  void onClose() {
    dateTextController.dispose();
    timeTextController.dispose();
    super.onClose();
  }

  void restoreDefultValues() {
    // month = 0.obs;
    // year = 0.obs;
    isLoading = false.obs;
    autoValidate.value = AutovalidateMode.disabled;
    //errors.clear();
  }

  void resetFilters() {
    month.value = 0;
    year.value = 0;
    statestatus.value = 0;
    filter.value = EarlyDepartureReportModel();
  }

  // Future<void> submitEarlyDeparture(Map<String, dynamic> request) async {
  //   try {
  //     isLoading.value = true;
  //     final result = await earlydepartureService.saveEarlyDeparture(request);
  //     //response.value = result;

  //     if (result.status == true) {
  //       Get.snackbar("Success", result.message ?? "Request submitted");
  //       // optionally close modal or navigate
  //       Get.back();
  //     } else {
  //       Get.snackbar("Failed", result.message ?? "Something went wrong");
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString());
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  UserInfo getCurrentUser() {
    final getStorge = GetStorage();
    final userJsonString = getStorge.read(USER_SIGN_IN_KEY);
    var user = UserInfo.fromJson(json.decode(userJsonString));
    return user;
  }

  // Future<void> submitEarlyDeparture(Map<String, dynamic> request) async {
  //   if (earlydepartureFormKey.currentState!.validate()) {
  //     try {
  //       isSubmitting.value = true;
  //       isLoading.value = true;

  //       UserInfo user = getCurrentUser(); // ✅ Added this line for current user
  //       request['employeeId'] = user.employeeId;
  //       final result = await earlydepartureService.saveEarlyDeparture(request);

  //       if (result.status == true) {
  //         Get.snackbar(
  //           "Success",
  //           result.message ?? "Request submitted successfully.",
  //         );
  //         clearForm();
  //         //Get.back(); // Optionally navigate or close modal
  //       } else {
  //         Get.snackbar(
  //           "Failed",
  //           result.message ?? "Something went wrong. Please try again.",
  //         );
  //       }
  //     } catch (e) {
  //       Get.snackbar("Error", e.toString());
  //     } finally {
  //       isSubmitting.value = false;
  //       isLoading.value = false;
  //     }
  //   } else {
  //     autoValidate.value = AutovalidateMode.always;
  //     Get.snackbar("Validation Error", "Please fill all required fields.");
  //   }
  // }
  Future<void> fetchEarlyDepartureList() async {
    try {
      isLoading.value = true;
      UserInfo user = getCurrentUser();
      filter.value.employeeId =
          user.employeeId; // Adjust based on your user model
      final list =
          await earlydepartureService.getEarlyDepartureList(filter.value);
      earlyDepartureList.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateFilter({
    int? month,
    int? year,
    int? statestatus,
  }) {
    filter.update((val) {
      val?.month = month ?? val.month;
      val?.year = year ?? val.year;
      val?.statestatus = statestatus ?? val.statestatus;
    });
    fetchEarlyDepartureList();
  }

  Future<void> submitEarlyDeparture(Map<String, dynamic> request) async {
    if (earlydepartureFormKey.currentState!.validate()) {
      try {
        isSubmitting.value = true;
        isLoading.value = true;

        UserInfo user = getCurrentUser();
        request['employeeId'] = user.employeeId;
        debugPrint("Request payload: $request"); // Log the request being sent
        final result = await earlydepartureService.saveEarlyDeparture(request);

        debugPrint("Result status: ${result.status}"); // Log the status
        debugPrint("Result message: ${result.message}"); // Log the message

        if (result.status == false) {
          Get.snackbar(
            "Success",
            result.message ?? "Request submitted successfully.",
          );
          clearForm();
          //Get.back();
        } else {
          Get.snackbar(
            "Failed",
            result.message ?? "Something went wrong. Please try again.",
          );
        }
      } catch (e) {
        Get.snackbar("Error", e.toString());
      } finally {
        isSubmitting.value = false;
        isLoading.value = false;
      }
    } else {
      autoValidate.value = AutovalidateMode.always;
      Get.snackbar("Validation Error", "Please fill all required fields.");
    }
  }

  void onMonthChanged(int value) {
    if (value != 0) {
      removeError(error: kMonthNotSelectedError);
      debugPrint(
          '=======>>>>>> Selected Month : ${months[value - 1]} <<<<<<======');
    } else {
      debugPrint(
          '=======>>>>>> Selected Month : ${value.toString()} <<<<<<======');
    }
    return;
  }

  String? validateSelectedMonth(int value) {
    if (value == 0) {
      addError(error: kMonthNotSelectedError);
      return "";
    }
    return null;
  }

  void onYearChanged(int value) {
    if (value != 0) {
      removeError(error: kYearNotSelectedError);
    }
    debugPrint(
        '=======>>>>>> Selected Year : ${value.toString()} <<<<<<======');
    return;
  }

  String? validateSelectedYear(int value) {
    if (value == 0) {
      addError(error: kYearNotSelectedError);
      return "";
    }
    return null;
  }

// Handle status change
  void onStatusChanged(int value) {
    statestatus.value = value;
    if (value != 0) {
      removeError(
          error:
              kStatusNotSelectedError); // Define this in const_validation.dart
      debugPrint(
          '=======>>>>>> Selected Status: ${statuses[value]} <<<<<<======');
    } else {
      debugPrint(
          '=======>>>>>> Selected Status: ${value.toString()} <<<<<<======');
    }
  }

  // Validate status
  String? validateSelectedStatus(int value) {
    if (value == 0) {
      addError(
          error:
              kStatusNotSelectedError); // Define this in const_validation.dart
      return "";
    }
    return null;
  }

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

  void clearForm() {
    selectedDate.value = null;
    selectedTime.value = null;
    reason.value = '';
    earlydepartureFormKey.currentState?.reset();
    autoValidate.value = AutovalidateMode.disabled;
  }

  // Added methods for UI actions
  Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.blue;
      case 'Rejected':
        return Colors.red;
      case 'Canceled':
        return Colors.grey;
      case 'Recommended':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  // void fetchEarlyDepartureList() {
  //   isLoading.value = true;

  //   // For now, just simulate delay
  //   Future.delayed(Duration(seconds: 1), () {
  //     // You can filter based on selectedMonth, selectedYear, selectedStatus if needed

  //     isLoading.value = false;
  //   });
  // }

  void editRequest(Map<String, dynamic> item) {
    // Implement edit logic (e.g., open a form with pre-filled data)
    print('Editing request: ${item['purpose']}');
  }

  void cancelRequest(Map<String, dynamic> item) {
    // Implement cancel logic
    print('Canceling request: ${item['purpose']}');
  }

  void showActivityLog(Map<String, dynamic> item) {
    // Implement activity log logic
    print('Showing activity log for: ${item['purpose']}');
  }

  void cancelApprovedRequest(Map<String, dynamic> item) {
    // Implement cancel approved logic
    print('Canceling approved request: ${item['purpose']}');
  }

  // Sample data (replace this with actual data fetching logic)
  var listOfEarlyDeparture = <EarlyDepartureItem>[
    // EarlyDepartureItem(
    //   id: 1,
    //   transactionDate: DateTime.now(),
    //   dayName: 'Monday',
    //   inTime: '09:00 AM',
    //   outTime: '02:00 PM',
    //   status: 'Approved',
    //   appliedDate: DateTime.now(),
    //   appliedTime: '02:00 PM',
    //   reason: 'Personal',
    //   stateStatus: 'Pending',
    //   isApproved: 0,
    // ),
    // Add more items...
  ].obs;

  // Label for no data message
  var earlyDepartureDTLabel = ''.obs;

  // Functions to handle actions
  void openInsertUpdateModal(int id) {
    // Handle open update modal
  }

  void openRequestDeleteModal(EarlyDepartureItem item) {
    // Handle delete modal
  }

  void openActivityModal(EarlyDepartureItem item) {
    // Handle activity log modal
  }

  void openCancelApprovedModal(EarlyDepartureItem item) {
    // Handle cancel approved modal
  }
}

var attendanceList = [].obs;
void fetchearlydepartureData() async {
  try {
    // Show loading state
    // isLoading.value = true;
    // GeoLocationAttendanceModel mo = GeoLocationAttendanceModel(
    //   actionName: 'Get',
    //   pageNumber: 1,
    //   pageSize: 100,
    // );
    // //final response = await attendanceService.getGeoLocationAttendance(mo);

    // // Check response status

    // // final data = json.decode(response as String);

    // // // Clear existing data before adding new ones
    // // attendanceList.clear();

    // // attendanceList.add(response);
    // // // Convert JSON list into GeoLocationAttendance objects
    // // // for (var item in data['items']) {
    // final List<GeoLocationAttendanceModel> response =
    //     await attendanceService.getGeoLocationAttendance(mo);

    // ✅ Clear existing data before adding new ones
    attendanceList.clear();

    // ✅ Add the fetched list directly
    // attendanceList.addAll(response);
    // }
  } catch (e) {
    print("Error fetching attendance data: $e");
  } finally {
    // Hide loading state
    // isLoading.value = false;
  }
}
