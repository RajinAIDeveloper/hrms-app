// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// import 'package:root_app/enums/page_enum.dart';
// import 'package:root_app/constants/constants.dart';
// import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
// import 'package:root_app/models/authentication/components.dart';
// import 'package:root_app/models/payroll/payroll_report_model.dart';

// import 'package:root_app/services/payroll/payroll_repository.dart';

// class WorkshiftController extends GetxController {
//   late Rx<WorkShiftScreen> pageScreen;
//   late RxInt month;
//   late RxInt year;
//   late PayrollReportModel payrollReportModel;
//   late Rx<AutovalidateMode> autoValidate;
//   late List<String> errors;
//   late RxBool isLoading;

//   final payrollFormKey = GlobalKey<FormState>();
//   final payrollService = getIt<PayrollRepository>();

//   @override
//   void onInit() {
//     pageScreen = WorkShiftScreen.Main.obs;
//     month = 0.obs; //DateTime.now().month.obs;
//     year = 0.obs; //DateTime.now().year.obs;
//     payrollReportModel = PayrollReportModel();
//     isLoading = false.obs;
//     errors = <String>[].obs;
//     autoValidate = AutovalidateMode.disabled.obs;
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     //clientIDController.dispose();
//     super.onClose();
//   }

//   void restoreDefultValues() {
//     // month = 0.obs;
//     // year = 0.obs;
//     isLoading = false.obs;
//     autoValidate.value = AutovalidateMode.disabled;
//     errors.clear();
//   }

//   /// Validation Errors Block

//   void addError({required String error}) {
//     if (!errors.contains(error)) {
//       errors.add(error);
//     }
//   }

//   void removeError({required String error}) {
//     if (errors.contains(error)) {
//       errors.remove(error);
//     }
//   }

//   /// Validation Errors Block

//   /// Function Block

//   UserInfo getCurrentUser() {
//     final getStorge = GetStorage();
//     final userJsonString = getStorge.read(USER_SIGN_IN_KEY);
//     var user = UserInfo.fromJson(json.decode(userJsonString));
//     return user;
//   }

//   /// Function Block
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
import 'package:root_app/models/authentication/components.dart';

import 'package:root_app/models/workshift/employee-work-shift-model.dart';
import 'package:root_app/models/workshift/workshift-model.dart';
import 'package:root_app/services/workshift/workshift_repository.dart';

class WorkshiftController extends GetxController {
  late Rx<WorkShiftScreen> pageScreen;
  late List<Workshiftlist> workshifts;
  var weeklyShifts = <EmployeeWorkShift>[].obs;
  var employeeShiftList = <EmployeeWorkShift>[].obs; // ← add this
  late Rx<AutovalidateMode> autoValidate;
  late RxBool isLoading;
  late List<String> errors;
  var isLoadingShifts = false.obs;
  final payrollFormKey = GlobalKey<FormState>();
  final workshiftService = getIt<WorkshiftRepository>(); // ✅ using DI service

// ✅ Calendar fields
  // DateTime focusedDay = DateTime.now();
  // DateTime? selectedDay;

  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;

  // -------------------------------
  // Employee Dropdown Variables
  // -------------------------------
  var employeeList = <Workshiftlist>[].obs;
  var selectedEmployeeId = 0.obs;

  @override
  void onInit() {
    pageScreen = WorkShiftScreen.Main.obs;
    workshifts = <Workshiftlist>[];
    autoValidate = AutovalidateMode.disabled.obs;
    isLoading = false.obs;
    errors = <String>[].obs;

    loadEmployees(); // ✅ Fetch employee list
    fetchWeeklyShifts(); // ✅ Fetch weekly shifts
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void restoreDefultValues() {
    isLoading.value = false;
    autoValidate.value = AutovalidateMode.disabled;
    errors.clear();
  }

  // -------------------------------
  // Validation helpers
  // -------------------------------
  void addError({required String error}) {
    if (!errors.contains(error)) errors.add(error);
  }

  void removeError({required String error}) {
    if (errors.contains(error)) errors.remove(error);
  }

  // -------------------------------
  // ✅ Load employees using your service
  // -------------------------------
  Future<void> loadEmployees() async {
    try {
      isLoading.value = true;
      final result = await workshiftService.workshiftlist();

      if (result.workshiftlist.isNotEmpty) {
        employeeList.assignAll(result.workshiftlist);
      } else {
        debugPrint("⚠️ No employees found.");
      }
    } catch (e) {
      debugPrint("❌ Error loading employees: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // -------------------------------
  // Fetch weekly shifts
  // -------------------------------
  // Future<void> fetchWeeklyShifts() async {
  //   try {
  //     isLoadingShifts.value = true;
  //     final shifts = await workshiftService.getWeeklyShifts(
  //       employeeId:
  //           selectedEmployeeId.value != 0 ? selectedEmployeeId.value : null,
  //     );
  //     weeklyShifts.assignAll(shifts);
  //   } catch (e) {
  //     debugPrint("❌ Error fetching weekly shifts: $e");
  //   } finally {
  //     isLoadingShifts.value = false;
  //   }
  // }

  // // -------------------------------
  // // Employee dropdown logic
  // // -------------------------------
  // void onEmployeeChanged(int value) {
  //   selectedEmployeeId.value = value;
  // }

  void onEmployeeChanged(int value) {
    selectedEmployeeId.value = value;
    fetchWeeklyShifts();
  }

  // Future<void> fetchWeeklyShifts() async {
  //   try {
  //     isLoadingShifts.value = true;
  //     final shifts = await workshiftService.getWeeklyShifts(
  //       employeeId:
  //           selectedEmployeeId.value != 0 ? selectedEmployeeId.value : null,
  //     );
  //     employeeShiftList.assignAll(shifts); // ✅ assign the data
  //     debugPrint('Shifts fetched: ${employeeShiftList.length}');
  //   } catch (e) {
  //     employeeShiftList.clear();
  //     debugPrint('❌ Failed to fetch shifts: $e');
  //   } finally {
  //     isLoadingShifts.value = false;
  //   }
  // }
  Future<void> fetchWeeklyShifts() async {
    try {
      isLoadingShifts.value = true;

      final shifts = await workshiftService.getWeeklyShifts(
        employeeId:
            selectedEmployeeId.value != 0 ? selectedEmployeeId.value : null,
      );

      // Only assign if data exists
      if (shifts.isNotEmpty) {
        employeeShiftList.assignAll(shifts);
      } else {
        employeeShiftList.clear();
        debugPrint('⚠️ No shifts found for this employee.');
      }
    } catch (e) {
      employeeShiftList.clear();
      debugPrint('❌ Failed to fetch shifts: $e');
    } finally {
      isLoadingShifts.value = false;
    }
  }

  String? validateSelectedEmployee(int value) {
    if (value == 0) return "Please select an employee";
    return null;
  }

  Map<DateTime, String> generateCalendarMap() {
    final map = <DateTime, String>{};
    if (employeeShiftList.isEmpty) return map;

    final now = DateTime.now();
    // Start of current week (Sunday)
    final weekStart = now.subtract(Duration(days: now.weekday % 7));

    for (var shift in employeeShiftList) {
      final weekDays = {
        0: shift.sunday,
        1: shift.monday,
        2: shift.tuesday,
        3: shift.wednesday,
        4: shift.thursday,
        5: shift.friday,
        6: shift.saturday,
      };

      for (int i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        final shiftText = weekDays[i];
        if (shiftText != null && shiftText.isNotEmpty) {
          // Store date & shift name
          map[DateTime(date.year, date.month, date.day)] = shiftText;
        }
      }
    }

    return map;
  }

  // -------------------------------
  // User Info helper
  // -------------------------------
  UserInfo getCurrentUser() {
    final getStorage = GetStorage();
    final userJsonString = getStorage.read(USER_SIGN_IN_KEY);
    return UserInfo.fromJson(json.decode(userJsonString));
  }
}
