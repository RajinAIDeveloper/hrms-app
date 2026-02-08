import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/controllers/home/home_controller.dart';
import 'package:root_app/models/common/key_value_pair_model.dart';
import 'package:root_app/models/leave/employee_leave_request_model.dart';
import 'package:root_app/models/leave/holidays_response_model.dart';
import 'package:root_app/models/leave/leave_applied_records_response_model.dart';
import 'package:root_app/models/leave/leave_balance_response_model.dart';
import 'package:root_app/models/leave/leave_hierarchy_response_model.dart';
import 'package:root_app/models/leave/leave_type_dropdown_response_model.dart';
import 'package:root_app/models/leave/leave_type_setting_response_model.dart';
import 'package:root_app/models/profile/profile_model.dart';
import 'package:root_app/services/leave/leave_repository.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';

class LeaveController extends GetxController {
  late Rx<LeaveScreen> pageScreen;
  late ProfileModel currentUser;
  late RxList<Holiday> holidays;
  late RxList<LeaveBalance> leaveBalance;
  late RxList<LeaveAppliedRecord> leaveAppliedRecords;
  late RxList<LeaveTypeDropdown> leaveTypeDropdown;
  late LeaveTypeSettingResponseModel leaveTypeSetting;
  late LeaveHierarchyResponseModel leaveHierarchy;
  late Rx<AutovalidateMode> autoValidate;
  late List<String> errors;
  late RxBool isLoading;
  //new
  Rx<File?> selectedFile = Rx<File?>(null);

  // Add these for date handling
  Rx<DateTimeRange?> appliedFromDate = Rx<DateTimeRange?>(null);
  RxInt totalLeave = 0.obs;

  late RxInt leaveType;
  late RxString leaveDuration;
  late RxString halfDayDuration;
  late RxBool isHalfDayLeave;

  late RxString attachmentName;
  late RxString attachmentPath;
  late RxString attachmentContent;
  late RxString attachmentExtention;

  List<KeyValuePair> leaveDurationItems = [
    KeyValuePair(id: "Full-Day", name: "Full-Day"),
    KeyValuePair(id: "Half-Day", name: "Half-Day"),
  ];
  List<KeyValuePair> halfDayDurationItems = [
    KeyValuePair(id: "First Portion", name: "First Half"),
    KeyValuePair(id: "Second Portion", name: "Second Half"),
  ];

  final leaveFormKey = GlobalKey<FormState>();
  final leavePurposeController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final addressDuringLeaveController = TextEditingController();
  final recommenderController = TextEditingController();
  final finalApproverController = TextEditingController();

  final leaveService = getIt<LeaveRepository>();

  @override
  void onInit() {
    pageScreen = LeaveScreen.Main.obs;
    holidays = <Holiday>[].obs;
    leaveBalance = <LeaveBalance>[].obs;
    leaveAppliedRecords = <LeaveAppliedRecord>[].obs;
    leaveTypeDropdown = <LeaveTypeDropdown>[].obs;
    leaveTypeSetting = LeaveTypeSettingResponseModel();
    leaveHierarchy = LeaveHierarchyResponseModel();

    isLoading = false.obs;
    errors = <String>[].obs;
    autoValidate = AutovalidateMode.disabled.obs;

    leaveType = 0.obs;
    leaveDuration = ''.obs;
    halfDayDuration = ''.obs;
    isHalfDayLeave = false.obs;

    attachmentName = ''.obs;
    attachmentPath = ''.obs;
    attachmentContent = ''.obs;
    attachmentExtention = ''.obs;

    currentUser = getCurrentUser();

    holidayList();
    leaveBalanceList();
    leaveAppliedRecordList();
    leaveTypeDropdownList();

    super.onInit();
  }

  @override
  void onClose() {
    leavePurposeController.dispose();
    emergencyPhoneController.dispose();
    addressDuringLeaveController.dispose();
    recommenderController.dispose();
    finalApproverController.dispose();
    super.onClose();
  }

  void restoreDefultValues() {
    //pageScreen = LeaveScreen.Main.obs;
    isLoading = false.obs;
    autoValidate.value = AutovalidateMode.disabled;
    errors.clear();

    //new
    leaveType.value = 0;
    leaveDuration.value = '';
    halfDayDuration.value = '';
    isHalfDayLeave.value = false;
    appliedFromDate.value = null;
    totalLeave.value = 0;
    leavePurposeController.clear();
    emergencyPhoneController.clear();
    addressDuringLeaveController.clear();
    selectedFile.value = null;
    attachmentName.value = '';
    attachmentPath.value = '';
    attachmentContent.value = '';
    attachmentExtention.value = '';
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

  // void onLeaveTypeChanged(int value) {
  //   if (value != 0) {
  //     removeError(error: kLeaveTypeNotSelectedError);
  //     var leaveType = leaveTypeDropdown.firstWhere(
  //       (e) => e.id == value.toString(),
  //       orElse: () => LeaveTypeDropdown(id: '0', text: 'No Selection'),
  //     );

  //     debugPrint(
  //         '=======>>>>>> Selected ID : ${value.toString()} || Leave Type : ${leaveType.text} <<<<<<======');
  //   } else {
  //     debugPrint(
  //         '=======>>>>>> Selected Leave Type ID : ${value.toString()} <<<<<<======');
  //   }
  //   return;
  // }

  void onLeaveTypeChanged(int selectedValue) {
    leaveType.value = selectedValue; // <-- THIS is important

    if (selectedValue != 0) {
      removeError(error: kLeaveTypeNotSelectedError);
      var selectedLeaveType = leaveTypeDropdown.firstWhere(
        (e) => e.id == selectedValue.toString(),
        orElse: () => LeaveTypeDropdown(id: '0', text: 'No Selection'),
      );

      debugPrint(
          '=======>>>>>> Selected ID : ${selectedValue.toString()} || Leave Type : ${selectedLeaveType.text} <<<<<<======');
    } else {
      debugPrint(
          '=======>>>>>> Selected Leave Type ID : ${selectedValue.toString()} <<<<<<======');
    }
  }

  String? validateSelectedLeaveType(int value) {
    if (value == 0) {
      addError(error: kLeaveTypeNotSelectedError);
      return "";
    }
    return null;
  }

  void onLeaveDurationChanged(String value) {
    if (value != '') {
      removeError(error: kLeaveDurationNotSelectedError);
      var leaveDuration = leaveDurationItems.firstWhere(
        (e) => e.id == value.toString(),
        orElse: () => KeyValuePair(id: '0', name: 'No Selection'),
      );

      debugPrint(
          '=======>>>>>> Selected ID : ${value.toString()} || Leave Duration : ${leaveDuration.name} <<<<<<======');
    } else {
      debugPrint(
          '=======>>>>>> Selected Leave Duration ID : ${value.toString()} <<<<<<======');
    }
    removeError(error: kLeaveDurationTypeNotSelectedError);
    if (value == 'Half-Day') {
      isHalfDayLeave.value = true;
    } else {
      isHalfDayLeave.value = false;
    }
    return;
  }

  String? validateSelectedLeaveDuration(String value) {
    if (value == '') {
      addError(error: kLeaveDurationNotSelectedError);
      return "";
    }
    return null;
  }

  void onHalfDayDurationChanged(String value) {
    if (value != '') {
      removeError(error: kLeaveDurationTypeNotSelectedError);
      var leaveDuration = halfDayDurationItems.firstWhere(
        (e) => e.id == value.toString(),
        orElse: () => KeyValuePair(id: '0', name: 'No Selection'),
      );

      debugPrint(
          '=======>>>>>> Selected ID : ${value.toString()} || Leave Duration : ${leaveDuration.name} <<<<<<======');
    } else {
      debugPrint(
          '=======>>>>>> Selected Leave Duration ID : ${value.toString()} <<<<<<======');
    }
    return;
  }

  String? validateSelectedHalfDayDuration(String value) {
    if (value == '' && isHalfDayLeave.value == true) {
      addError(error: kLeaveDurationTypeNotSelectedError);
      return "";
    }
    return null;
  }

  void onLeavePurposeChanged(String value) {
    if (value.trim().isNotEmpty) {
      removeError(error: kLeavePurposeNullError);
      debugPrint(
          '=======>>>>>> Leave Purpose : ${value.toString()} <<<<<<======');
    }
    return;
  }

  String? validateLeavePurpose(String value) {
    if (value.trim().isEmpty) {
      addError(error: kLeavePurposeNullError);
      return "";
    }
    return null;
  }

  void onEmergencyPhoneChanged(String value) {
    if (value.trim().isNotEmpty) {
      removeError(error: kEmergencyPhoneNullError);
      debugPrint(
          '=======>>>>>> Emergency Phone : ${value.toString()} <<<<<<======');
    }
    return;
  }

  String? validateEmergencyPhone(String value) {
    // if (value.trim().isEmpty) {
    //   addError(error: kEmergencyPhoneNullError);
    //   return "";
    // }
    return null;
  }

  void onAddressDuringLeaveChanged(String value) {
    if (value.trim().isNotEmpty) {
      removeError(error: kAddressDuringLeaveNullError);
      debugPrint(
          '=======>>>>>> Address During Leave  : ${value.toString()} <<<<<<======');
    }
    return;
  }

  String? validateAddressDuringLeave(String value) {
    // if (value.trim().isEmpty) {
    //   addError(error: kEmergencyPhoneNullError);
    //   return "";
    // }
    return null;
  }

// Format date for display
  String getFormattedDate() {
    if (appliedFromDate.value != null) {
      final start = appliedFromDate.value!.start;
      final end = appliedFromDate.value!.end;
      debugPrint('Formatting date: start=$start, end=$end');
      if (start == end) {
        return start.toString().split(' ')[0]; // Single day, e.g., "2025-04-15"
      }
      return '${start.toString().split(' ')[0]} - ${end.toString().split(' ')[0]}'; // Range, e.g., "2025-04-15 - 2025-04-20"
    }
    debugPrint('No date selected, returning "Select Date"');
    return 'Select Date';
  }

  // Set date range (handles single day or range)
  void setDateRange(DateTimeRange range) {
    debugPrint('Setting date range: ${range.start} to ${range.end}');
    appliedFromDate.value = range;
    totalLeave.value = range.end.difference(range.start).inDays + 1;
    debugPrint(
        'Updated appliedFromDate: ${appliedFromDate.value}, totalLeave: ${totalLeave.value}');
    validateDate();
  }

  // Clear date
  void clearDate() {
    debugPrint('Clearing date range');
    appliedFromDate.value = null;
    totalLeave.value = 0;
    removeError(error: 'appliedFromDateError');
  }

  // Validate date
  void validateDate() {
    if (appliedFromDate.value == null) {
      debugPrint('Validation failed: No date selected');
      addError(error: 'appliedFromDateError');
    } else {
      debugPrint('Validation passed: Date selected');
      removeError(error: 'appliedFromDateError');
    }
  }
//new

  void calculateTotalDays() {
    if (appliedFromDate.value != null) {
      final start = appliedFromDate.value!.start;
      final end = appliedFromDate.value!.end;
      final days = end.difference(start).inDays + 1;
      totalLeave.value = days;
    }
  }

  // File Handling
  void setAttachment(File file, String name, String extension, String content) {
    selectedFile.value = file;
    attachmentName.value = name;
    attachmentExtention.value = extension;
    attachmentContent.value = content;
    attachmentPath.value = file.path;
  }

  // // Submit Leave Request
  // Future<void> submitLeaveRequest() async {
  //   if (!leaveFormKey.currentState!.validate()) {
  //     autoValidate.value = AutovalidateMode.always;
  //     return;
  //   }

  //   isLoading.value = true;

  //   try {
  //     final leaveDays = appliedFromDate.value != null
  //         ? List.generate(
  //             appliedFromDate.value!.end
  //                     .difference(appliedFromDate.value!.start)
  //                     .inDays +
  //                 1,
  //             (index) => EmployeeLeaveDay(
  //               date: appliedFromDate.value!.start.add(Duration(days: index)),
  //               days: leaveDuration.value == 'Half-Day' ? 0.5 : 1.0,
  //             ),
  //           )
  //         : <EmployeeLeaveDay>[];

  //     final request = EmployeeLeaveRequest(
  //       employeeId: currentUser.employeeId!,
  //       leaveTypeId: leaveType.value,
  //       leaveTypeName: leaveTypeDropdown
  //           .firstWhere((e) => e.id == leaveType.value.toString())
  //           .text,
  //       dayLeaveType: leaveDuration.value,
  //       halfDayType: halfDayDuration.value,
  //       appliedFromDate: appliedFromDate.value?.start,
  //       appliedToDate: leaveDuration.value == 'Half-Day'
  //           ? appliedFromDate.value?.start
  //           : appliedFromDate.value?.end,
  //       appliedTotalDays: leaveDuration.value == 'Half-Day'
  //           ? 0.5
  //           : totalLeave.value.toDouble(),
  //       leavePurpose: leavePurposeController.text,
  //       emergencyPhoneNo: emergencyPhoneController.text,
  //       addressDuringLeave: addressDuringLeaveController.text,
  //       remarks: null,
  //       leaveDays: leaveDays,
  //       filePath: attachmentPath.value,
  //       flag: 'Submit',
  //     );

  //     final response = await leaveService.saveEmployeeLeaveRequest(
  //       request,
  //       selectedFile.value,
  //     );

  //     Get.showSnackbar(
  //       GetSnackBar(
  //         title: 'Success',
  //         message: 'Leave request submitted successfully',
  //         icon: const Icon(Icons.add_task_outlined, color: Colors.white),
  //         duration: const Duration(seconds: 3),
  //         backgroundColor: Colors.green,
  //       ),
  //     );

  //     restoreDefultValues();
  //     leaveAppliedRecordList(); // Refresh leave records
  //   } catch (e) {
  //     Get.showSnackbar(
  //       GetSnackBar(
  //         title: 'Error',
  //         message: 'Failed to submit leave request: $e',
  //         icon: const Icon(Icons.do_not_touch_outlined, color: Colors.white),
  //         duration: const Duration(seconds: 3),
  //         backgroundColor: Colors.red.shade700,
  //       ),
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

// Submit Leave Request
  Future<void> submitLeaveRequest() async {
    if (!leaveFormKey.currentState!.validate()) {
      autoValidate.value = AutovalidateMode.always;
      return;
    }

    isLoading.value = true;

    try {
      final leaveDays = appliedFromDate.value != null
          ? List.generate(
              appliedFromDate.value!.end
                      .difference(appliedFromDate.value!.start)
                      .inDays +
                  1,
              (index) => EmployeeLeaveDay(
                date: appliedFromDate.value!.start.add(Duration(days: index)),
                days: leaveDuration.value == 'Half-Day' ? 0.5 : 1.0,
              ),
            )
          : <EmployeeLeaveDay>[];

      final request = EmployeeLeaveRequest(
        employeeId: currentUser.employeeId!,
        // leaveTypeId: leaveType.value,
        // leaveTypeName: leaveTypeDropdown
        //     .firstWhere((e) => e.id == leaveType.value.toString())
        //     .text,
        leaveTypeId: int.parse(leaveType.value.toString()),

        leaveTypeName: leaveTypeDropdown
            .firstWhere((e) => e.id == leaveType.value.toString())
            .text,
        dayLeaveType: leaveDuration.value,
        halfDayType: halfDayDuration.value,
        appliedFromDate: appliedFromDate.value?.start,
        appliedToDate: leaveDuration.value == 'Half-Day'
            ? appliedFromDate.value?.start
            : appliedFromDate.value?.end,
        appliedTotalDays: leaveDuration.value == 'Half-Day'
            ? 0.5
            : totalLeave.value.toDouble(),
        leavePurpose: leavePurposeController.text,
        emergencyPhoneNo: emergencyPhoneController.text,
        addressDuringLeave: addressDuringLeaveController.text,
        remarks: null,
        leaveDays: leaveDays,
        filePath: attachmentPath.value,
        flag: 'Submit',
      );

      await leaveService.saveEmployeeLeaveRequest(
        request,
        selectedFile.value,
      );

      Get.showSnackbar(
        GetSnackBar(
          title: 'Success',
          message: 'Leave request submitted successfully',
          icon: const Icon(Icons.add_task_outlined, color: Colors.white),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
        ),
      );

      restoreDefultValues();
      leaveAppliedRecordList(); // Refresh leave records
    } catch (e) {
      String errorMessage = e is String ? e : 'An unexpected error occurred';

      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to submit leave request: $errorMessage',
          icon: const Icon(Icons.do_not_touch_outlined, color: Colors.white),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Validation Errors Block

  /// Function Block

  ProfileModel getCurrentUser() {
    final homeController = Get.find<HomeController>();
    var user = homeController.profile;
    return user;
  }

  Future<List<Holiday>> holidayList() async {
    //await Future.delayed(const Duration(seconds: 1));
    isLoading.value = true;
    await leaveService.yearlyHolidays().then((result) {
      holidays.value = result.holidays;
      isLoading.value = false;
    });

    return holidays;
  }

  Future<List<LeaveBalance>> leaveBalanceList() async {
    //await Future.delayed(const Duration(seconds: 1));
    isLoading.value = true;
    await leaveService.yearlyLeaveBalance().then((result) {
      leaveBalance.value = result.leaveBalance;
      isLoading.value = false;
    });
    return leaveBalance;
  }

  Future<List<LeaveAppliedRecord>> leaveAppliedRecordList() async {
    //await Future.delayed(const Duration(seconds: 1));
    isLoading.value = true;
    await leaveService.leaveAppliedRecords().then((result) {
      leaveAppliedRecords.value = result.leaveAppliedRecords;
      isLoading.value = false;
    });
    return leaveAppliedRecords;
  }

  Future<List<LeaveTypeDropdown>> leaveTypeDropdownList() async {
    //await Future.delayed(const Duration(seconds: 1));
    isLoading.value = true;

    await leaveService.leaveTypeDropdown(23).then((result) {
      leaveTypeDropdown.value = result.leaveTypes;
      isLoading.value = false;
    });
    return leaveTypeDropdown;
  }

  Future<LeaveHierarchyResponseModel> employeeActiveleaveHierarchy() async {
    //await Future.delayed(const Duration(seconds: 1));
    isLoading.value = true;
    await leaveService.leaveHierarchy(currentUser.employeeId!).then((result) {
      leaveHierarchy = result;
      isLoading.value = false;
    });
    return leaveHierarchy;
  }

  Future<LeaveTypeSettingResponseModel> leaveTypeSettings(int leaveId) async {
    //await Future.delayed(const Duration(seconds: 1));
    isLoading.value = true;
    await leaveService
        .leaveTypeSetting(leaveId, currentUser.employeeId!)
        .then((result) {
      leaveTypeSetting = result;
      isLoading.value = false;
    });
    return leaveTypeSetting;
  }

  /// Function Block
}
