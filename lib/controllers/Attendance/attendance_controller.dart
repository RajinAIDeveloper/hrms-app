import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:root_app/constants/token_const.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
import 'package:root_app/models/attendance/attendance_response_model.dart';
import 'package:root_app/models/attendance/employee_manual_attendance_dto.dart';
import 'package:root_app/models/attendance/geolocation_attendance_model.dart';
import 'package:root_app/models/attendance/manual_attendance_model.dart';
import 'package:root_app/models/attendance/submit_attendance.dart';
import 'package:root_app/models/authentication/sign_in_response_model.dart';
import 'package:root_app/models/profile/profile_model.dart';

import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/services/attendance/attendance_repository.dart';
import 'package:root_app/views/Attendance/components/geo_location.dart';

class AttendanceController extends GetxController {
  final RxInt rowsPerPage = 5.obs;
  final RxInt currentPage = 1.obs;
  Rx<AttendanceScreen> pageScreen = AttendanceScreen.Main.obs;
  var attendanceList = <GeoLocationAttendanceModel>[].obs;
  final attendanceService = getIt<AttendanceRepository>(); // Now using DI
  var selectedEmployeeIds = <String>[].obs; // Add this for IDs
  ProfileModel? currentUser; // Using nullable type with '?'
  late Rx<AutovalidateMode> autoValidate;
  late List<String> errors;
  RxString remarks = ''.obs;
  RxBool isCheckedIn = false.obs;
  RxString punchInTime = "".obs;
  RxString punchOutTime = "".obs;
  RxBool isEmployeeAdded = false.obs; // Add this to the controller
  RxString checkInTime = ''.obs;
  RxString checkOutTime = ''.obs;
  RxBool isLoading = false.obs;
  RxString location = 'Office'.obs; // Default value, can be changed by UI
  var searchQuery = ''.obs; // This is the reactive search query variable
  var employees = <Employee>[].obs; // Store Employee objects
  var selectedEmployees = <Employee>[].obs; // Store selected Employees
  RxString selectedAttendanceType = "Home Office".obs;
  // var selectedEmployees = <String>[].obs; // Assuming this stores employee IDs
// New variables to match the API response
  var shiftInTime = '09:00:00'.obs;
  var maxInTime = '09:30:00'.obs;
  var actualInTime = ''.obs;
  var earlyInTime = '00:00:00'.obs;
  var lateInTime = '00:00:00'.obs;
  var shiftEndTime = '18:00:00'.obs;
  var actualOutTime = ''.obs;
  var earlyGoing = '00:00:00'.obs;
  var overTime = '00:00:00'.obs;
  var inTimeLocation = ''.obs;
  var outTimeLocation = ''.obs;
  final checkInController = TextEditingController();
  final checkOutController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  RxBool isRemarksVisible = false.obs;
  final List<String> attendanceTypes = [
    "Home Office",
    "Outdoor Meeting",
    "Other"
  ];

// Manual Attendance Variables
  final selectedDate = DateTime.now().obs;
  final selectedRequestType = ' '.obs;
  final selectedInTime = Rx<TimeOfDay?>(null);
  final selectedOutTime = Rx<TimeOfDay?>(null);
  TextEditingController reasonController = TextEditingController();
  var manualAttendanceList = <ManualAttendanceModel>[].obs;

// Form validation keys and controllers
  final GlobalKey<FormState> manualAttendanceFormKey = GlobalKey<FormState>();
  final manualAttendanceId = 0.obs;
  final manualAttendanceCode = ''.obs;
  final lineManagerId = 0.obs;
  final supervisorId = 0.obs;
  final headOfDepartmentId = 0.obs;
  final hrAuthorityId = 0.obs;

// Time constraints
  final minTime = TimeOfDay(hour: 1, minute: 0);
  final maxTime = TimeOfDay(hour: 23, minute: 59);

  void initializeManualAttendanceForm() {
    manualAttendanceId.value = 0;
    manualAttendanceCode.value = '';
    selectedRequestType.value = 'Both';
    selectedDate.value = DateTime.now();
    selectedInTime.value = null;
    selectedOutTime.value = null;
    reasonController.text = '';
    lineManagerId.value = 0;
    supervisorId.value = 0;
    headOfDepartmentId.value = 0;
    hrAuthorityId.value = 0;

    // Remove these if they cause context issues inside controller:
    // ever(selectedRequestType, (_) => validateAndUpdateForm(context));
    // ever(selectedDate, (_) => validateAndUpdateForm(context));
  }

// Pass context from the UI when needed
  void validateAndUpdateForm(BuildContext context) {
    final formValues = {
      'manualAttendanceId': manualAttendanceId.value,
      'manualAttendanceCode': manualAttendanceCode.value,
      'employeeId': currentUser?.employeeId ?? 0,
      'attendanceDate': selectedDate.value,
      'timeRequestFor': selectedRequestType.value,
      'inTime': selectedInTime.value?.format(context),
      'outTime': selectedOutTime.value?.format(context),
      'reason': reasonController.text,
      'stateStatus': 'Pending',
      'lineManagerId': lineManagerId.value,
      'supervisorId': supervisorId.value,
      'headOfDeparmentId': headOfDepartmentId.value,
      'hrAuthorityId': hrAuthorityId.value,
    };
    print("Manual Attendance Form Values: $formValues");
  }

  bool validateManualAttendanceForm(BuildContext context) {
    return _validateForm(context);
  }

  bool _validateForm(BuildContext context) {
    if (manualAttendanceFormKey.currentState == null ||
        !manualAttendanceFormKey.currentState!.validate()) {
      Get.snackbar('Error', 'Please fill all required fields correctly.');
      return false;
      //return false;
    }

    // Validate request type selection (redundant with validator, but kept for clarity)
    if (selectedRequestType.value.trim().isEmpty) {
      Get.snackbar('Error', 'Please select request type');
      return false;
    }

    // Check in-time if required
    if (selectedRequestType.value == 'Both' ||
        selectedRequestType.value == 'In-Time') {
      if (selectedInTime.value == null) {
        Get.snackbar('Error', 'Please select in-time');
        return false;
      }
    }

    // Check out-time if required
    if (selectedRequestType.value == 'Both' ||
        selectedRequestType.value == 'Out-Time') {
      if (selectedOutTime.value == null) {
        Get.snackbar('Error', 'Please select out-time');
        return false;
      }
    }

    // Validate in-time bounds
    if (selectedInTime.value != null) {
      if (selectedInTime.value!.hour < minTime.hour ||
          (selectedInTime.value!.hour == minTime.hour &&
              selectedInTime.value!.minute < minTime.minute)) {
        Get.snackbar(
            'Error', 'In-time cannot be before ${minTime.format(context)}');
        return false;
      }
    }

    // Validate out-time bounds
    if (selectedOutTime.value != null) {
      if (selectedOutTime.value!.hour > maxTime.hour ||
          (selectedOutTime.value!.hour == maxTime.hour &&
              selectedOutTime.value!.minute > maxTime.minute)) {
        Get.snackbar(
            'Error', 'Out-time cannot be after ${maxTime.format(context)}');
        return false;
      }
    }

    return true;
  }

  Future<void> submitManualAttendance(BuildContext context) async {
    try {
      if (!validateManualAttendanceForm(context)) {
        return;
      }

      isLoading.value = true;

      String formatTimeOfDay(TimeOfDay? time) {
        if (time == null) return '';
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
      }

      var manualAttendanceDTO = EmployeeManualAttendanceDTO(
        manualAttendanceId: manualAttendanceId.value,
        manualAttendanceCode: manualAttendanceCode.value,
        employeeId: currentUser?.employeeId ?? 0,
        attendanceDate: selectedDate.value,
        timeRequestFor: selectedRequestType.value,
        inTime: selectedRequestType.value != 'Out-Time'
            ? formatTimeOfDay(selectedInTime.value)
            : null,
        outTime: selectedRequestType.value != 'In-Time'
            ? formatTimeOfDay(selectedOutTime.value)
            : null,
        reason: reasonController.text,
        stateStatus: 'Pending',
      );

      bool success =
          await attendanceService.saveManualAttendance(manualAttendanceDTO);

      if (success) {
        Get.snackbar(
          'Success',
          'Manual attendance submitted successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2), // set display duration
        );
        await Future.delayed(
            const Duration(seconds: 2)); // ✅ allow snackbar to show
        resetManualAttendance();
        Get.back();
        await fetchManualAttendances();
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit manual attendance',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadEmployees() async {
    try {
      isLoading.value = true;
      final employeeList = await attendanceService.fetchEmployees();
      employees.assignAll(employeeList);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch employees: $e');
    } finally {
      isLoading.value = false;
    }
  }

  final attendanceFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    pageScreen = AttendanceScreen.Main.obs;
    isLoading = false.obs;
    errors = <String>[].obs;
    autoValidate = AutovalidateMode.disabled.obs;
    isCheckedIn = false.obs;
    checkInTime = ''.obs;
    checkOutTime = ''.obs;
    isLoading = false.obs;

    _initializeCurrentUser(); // New method to set currentUser
    markCheckInOut();
    fetchAttendanceData();
    loadEmployees();
    fetchManualAttendances(); // Added manual attendance fetch
    initializeManualAttendanceForm();
  }

  @override
  void onClose() {
    checkInController.dispose();
    checkOutController.dispose();
    remarksController.dispose();
    reasonController.dispose();
    super.onClose();
  }

  void restoreDefultValues() {
    // month = 0.obs;
    // year = 0.obs;
    isLoading = false.obs;
    autoValidate.value = AutovalidateMode.disabled;
    errors.clear();
  }

// Update remarks from controller
  void updateRemarks(String value) {
    remarks.value = value;
  }

  // Update location from UI or geolocation
  void updateLocation(String newLocation) {
    location.value = newLocation;
  }

  bool isRemarksRequired() {
    return selectedAttendanceType.value == "Other";
  }

  // Reset all attendance fields and form state
  void resetAttendanceForm() {
    selectedAttendanceType.value = "Home Office";
    remarks.value = '';
    checkInTime.value = '';
    checkOutTime.value = '';
    isCheckedIn.value = false;
    isRemarksVisible.value = false; // Hide remarks by default when resetting
    errors.clear();
  }

  void toggleRemarksVisibility(String? selectedType) {
    // Show remarks only when "Other" is selected
    if (selectedType == "Other") {
      isRemarksVisible.value = true;
    } else {
      isRemarksVisible.value = false;
    }
  }

  void fetchAttendanceData() async {
    try {
      // Show loading state
      isLoading.value = true;
      GeoLocationAttendanceModel mo = GeoLocationAttendanceModel(
        actionName: 'Get',
        pageNumber: 1,
        pageSize: 100,
      );
      //final response = await attendanceService.getGeoLocationAttendance(mo);

      // Check response status

      // final data = json.decode(response as String);

      // // Clear existing data before adding new ones
      // attendanceList.clear();

      // attendanceList.add(response);
      // // Convert JSON list into GeoLocationAttendance objects
      // // for (var item in data['items']) {
      final List<GeoLocationAttendanceModel> response =
          await attendanceService.getGeoLocationAttendance(mo);

      // ✅ Clear existing data before adding new ones
      attendanceList.clear();

      // ✅ Add the fetched list directly
      attendanceList.addAll(response);
      // }
    } catch (e) {
      print("Error fetching attendance data: $e");
    } finally {
      // Hide loading state
      isLoading.value = false;
    }
  }

  void onEmployeesChanged(List<Employee> values) {
    selectedEmployees.assignAll(values);
    selectedEmployeeIds.assignAll(values.map((e) => e.id.toString()).toList());
  }

  /// Validates employee selection
  String? validateSelectedEmployee(String? value) {
    return value == null || value.isEmpty ? "Please select an employee" : null;
  }

// Add these helper methods to your controller
  Future<void> processHomeOfficeAttendance() async {
    // Add your Home Office attendance logic here
    await Future.delayed(
        const Duration(seconds: 1)); // Replace with actual API call
  }

  Future<void> processOutdoorMeetingAttendance(List<Employee> employees) async {
    // Add your Outdoor Meeting attendance logic here
    if (employees.isNotEmpty) {
      debugPrint(
          'Processing Outdoor Meeting for: ${employees.map((e) => e.text).join(", ")}');
    }
    await Future.delayed(
        const Duration(seconds: 1)); // Replace with actual API call
  }

  Future<void> processOtherAttendance() async {
    // Add your Other attendance type logic here
    await Future.delayed(
        const Duration(seconds: 1)); // Replace with actual API call
  }

  Future<void> markCheckInOut() async {
    isLoading.value = true;
    try {
      // AttendanceModel model = AttendanceModel(
      //   actionName: isCheckedIn.value ? 'Punch Out' : 'Punch In',
      // );

      AttendanceResponseModel response =
          await attendanceService.markCheckInOutAttendance();

      if (!response.error) {
        String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());

        if (1 == 1) {
          punchInTime.value = response.actualInTime ?? currentTime;
          isCheckedIn.value = response.punchIn ?? true;
          // You might want to store additional info
          shiftInTime.value = response.shiftInTime ?? '09:00:00';
          maxInTime.value = response.maxInTime ?? '09:30:00';
          lateInTime.value = response.lateInTime ?? '00:00:00';
          inTimeLocation.value = response.inTimeLocation ?? 'Office';

          punchOutTime.value = response.actualOutTime ?? currentTime;
          isCheckedIn.value = !(response.punchOut ?? true);
          // Additional info for punch out
          shiftEndTime.value = response.shiftEndTime ?? '18:00:00';
          earlyGoing.value = response.earlyGoing ?? '00:00:00';
          overTime.value = response.overTime ?? '00:00:00';
          outTimeLocation.value = response.outTimeLocation ?? '';
          selectedEmployees.clear();
        }
      } else {
        Get.snackbar(
          'Error',
          response.errorMessage ?? 'Failed to mark attendance',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint("Error marking check-in/out: ${e.toString()}");
      Get.snackbar(
        'Error',
        'Something went wrong: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch last punch-in/out status
  Future<void> fetchLastPunchStatus() async {
    isLoading.value = true;
    try {
      // Assuming getGeoLocationAttendance returns a list where first item has the latest status
      var filter = GeoLocationAttendanceModel(
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        pageNumber: 1,
        pageSize: 1,
      );

      var data = await attendanceService.getGeoLocationAttendance(filter);
      if (data.isNotEmpty) {
        punchInTime.value = data.first.punchIn ?? '';
        punchOutTime.value = data.first.punchOut ?? '';
        isCheckedIn.value =
            punchInTime.value.isNotEmpty && punchOutTime.value.isEmpty;
      }
    } catch (e) {
      print("Error fetching punch status: $e");
    } finally {
      isLoading.value = false;
    }
  }

  //     // Clear selected employees after submission
  //     selectedEmployees.clear();
  //     debugPrint('Attendance submitted successfully!');
  //   } catch (e) {
  //     debugPrint('Error: $e');
  //     Get.snackbar('Error', 'Failed to process attendance: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<bool> handleAttendance({
    required String date,
    required String time,
    required List<String> employeeIds,
    required String actionName,
    required String attendanceType,
    String? location,
    String? remarks,
  }) async {
    print("Function called: handleAttendance");
    print("Initial isLoading value: ${isLoading.value}");

    isLoading.value = true;
    print("isLoading set to true");

    bool success = true;

    try {
      switch (attendanceType) {
        case "Home Office":
          success = await _handleHomeOfficeAttendance(
            date: date,
            time: time,
            employeeIds: employeeIds,
            location: location,
            remarks: remarks,
            actionName: actionName,
          );
          break;

        case "Outdoor Meeting":
          success = await _handleOutdoorMeetingAttendance(
            date: date,
            time: time,
            employeeIds: employeeIds,
            location: location,
            remarks: remarks,
            actionName: actionName,
          );
          break;

        case "Other":
          success = await _handleOthersAttendance(
            date: date,
            time: time,
            employeeIds: employeeIds,
            location: location,
            remarks: remarks,
            actionName: actionName,
          );
          break;

        default:
          print("Invalid attendance type.");
          return false;
      }
    } catch (e) {
      print("Error in handleAttendance: $e");
      success = false;
    } finally {
      print("isLoading set to false");
      isLoading.value = false;
    }

    return success;
  }

// ✅ Home Office Attendance (No Employee ID Needed)
  Future<bool> _handleHomeOfficeAttendance({
    required String date,
    required String time,
    required String actionName,
    required List<String> employeeIds,
    String? location,
    String? remarks,
  }) async {
    print("Processing Home Office attendance...");

    SubmitAttendanceModel submissionData = SubmitAttendanceModel(
      attendanceDate: date,
      attendanceTime: time,
      attendanceLocation: location ?? '',
      attendanceRemarks: remarks ?? '',
      actionName: actionName,
      attendanceType: "Home Office",
    );

    try {
      bool result =
          await attendanceService.submitGeoLocationAttendance(submissionData);
      if (result) {
        markCheckInOut();
        print("Successfully submitted Home Office attendance.");
        return true;
      } else {
        print("Failed to submit Home Office attendance.");
        return false;
      }
    } catch (e) {
      print("Error while submitting Home Office attendance: $e");
      return false;
    }
  }

// ✅ Outdoor Meeting Attendance (Requires Employee ID)
  Future<bool> _handleOutdoorMeetingAttendance({
    required String date,
    required String time,
    required List<String> employeeIds,
    required String actionName,
    String? location,
    String? remarks,
  }) async {
    print("Processing Outdoor Meeting attendance...");

    // if (employeeIds.isEmpty) {
    //   print("Please select an employee for Outdoor Meeting.");
    //   return false;
    // }

    bool success = true;
    String ids = employeeIds.join(',');

    print("Submitting Outdoor Meeting attendance for Employee ID: $ids");

    SubmitAttendanceModel submissionData = SubmitAttendanceModel(
      attendanceDate: date,
      attendanceTime: time,
      attendanceLocation: location ?? '',
      attendanceRemarks: remarks ?? '',
      actionName: actionName,
      attendanceType: "Outdoor Meeting",
      selectedEmployeeId: ids,
    );

    try {
      bool result =
          await attendanceService.submitGeoLocationAttendance(submissionData);
      if (!result) {
        print("Failed to submit attendance for Employee ID: $ids");
        success = false;
      }
    } catch (e) {
      print(
          "Error while submitting attendance for Employee ID: $ids - Error: $e");
      success = false;
    }
    selectedEmployees.clear();
    markCheckInOut();

    return success;
  }

// ✅ Others Attendance (Requires Employee ID & Remarks)
  Future<bool> _handleOthersAttendance({
    required String date,
    required String time,
    required List<String> employeeIds,
    required String actionName,
    String? location,
    required String? remarks,
  }) async {
    print("Processing Others attendance...");

    if (remarks == null || remarks.isEmpty) {
      print("Remarks are required for 'Others' attendance type.");
      return false;
    }

    bool success = true;

    // for (String employeeId in employeeIds) {
    //   print("Submitting 'Others' attendance for Employee ID: $employeeId");

    SubmitAttendanceModel submissionData = SubmitAttendanceModel(
      attendanceDate: date,
      attendanceTime: time,
      attendanceLocation: location ?? '',
      attendanceRemarks: remarks,
      actionName: actionName,
      attendanceType: "Others",
    );

    try {
      bool result =
          await attendanceService.submitGeoLocationAttendance(submissionData);
      if (!result) {
        // print("Failed to submit attendance for Employee ID: $employeeId");
        success = false;
      }
    } catch (e) {
      // print(
      //     "Error while submitting attendance for Employee ID: $employeeId - Error: $e");
      success = false;
    }

    markCheckInOut();
    return success;
  }
  // Update your AttendanceController with these additions:

  // Add these observables
  var totalEmployees = 0.obs;
  var presentCount = 0.obs;
  var absentCount = 0.obs;

  // Method to fetch daily report
  // void fetchDailyReport() {
  //   // Implement your API call or data fetching logic here
  //   // This is a sample implementation
  //   // Replace with your actual data source
  //   totalEmployees.value = 50; // Sample value
  //   presentCount.value = 45; // Sample value
  //   absentCount.value = 5; // Sample value

  //   // attendanceList.value = [
  //   //   {
  //   //     'employeeName': 'John Doe',
  //   //     'checkInTime': '09:00 AM',
  //   //     'status': 'Present'
  //   //   },
  //   //   {
  //   //     'employeeName': 'Jane Smith',
  //   //     'checkInTime': '09:15 AM',
  //   //     'status': 'Present'
  //   //   },
  //   //   // Add more sample data or real data from your backend
  //   // ];
  // }

  // Reset manual attendance form
  void resetManualAttendance() {
    manualAttendanceId.value = 0;
    manualAttendanceCode.value = '';
    selectedRequestType.value = '';
    selectedDate.value = DateTime.now();
    selectedInTime.value = null;
    selectedOutTime.value = null;
    reasonController.clear();
    lineManagerId.value = 0;
    supervisorId.value = 0;
    headOfDepartmentId.value = 0;
    hrAuthorityId.value = 0;
  }

// New method to initialize currentUser from storage
  void _initializeCurrentUser() {
    final getStorage = GetStorage();
    final userJsonString = getStorage.read(USER_SIGN_IN_KEY);
    if (userJsonString != null) {
      final user = UserInfo.fromJson(json.decode(userJsonString));
      currentUser = ProfileModel(
        employeeId: user.employeeId, // Assuming UserInfo has employeeId
        // Add other required fields from UserInfo to ProfileModel as needed
      );
    } else {
      print("No user data found in storage");
      Get.snackbar(
        'Error',
        'User data not found. Please sign in again.',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  Future<void> fetchManualAttendances() async {
    try {
      isLoading.value = true;

      if (currentUser == null) {
        _initializeCurrentUser();
        if (currentUser == null) {
          throw Exception("User not logged in or employee ID is missing");
        }
      }

      final employeeId = currentUser!.employeeId;
      if (employeeId == null || employeeId <= 0) {
        throw Exception("Invalid Employee ID: $employeeId");
      }

      final params = {
        'employeeId': employeeId,
        'pageNumber': 1,
        'pageSize': 50,
        // 'searchText': '',
        // 'fromDate': DateFormat('yyyy-MM-dd')
        //     .format(DateTime.now().subtract(const Duration(days: 30))),
        // 'toDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      };
      print("Request Parameters: $params");

      final attendances = await attendanceService.getEmployeeManualAttendances(
        employeeId: employeeId, // Pass directly, ensure it’s an int
        pageNumber: params['pageNumber'] as int,
        pageSize: params['pageSize'] as int,
        // searchText: params['searchText'] as String,
        // fromDate: params['fromDate'] as String,
        // toDate: params['toDate'] as String,
      );

      if (attendances.isEmpty) {
        print("No manual attendances found");
      }

      manualAttendanceList.assignAll(attendances);
    } catch (e) {
      print('Error fetching manual attendances: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch manual attendances: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Updated getCurrentUser() method (if you still need it separately)
  UserInfo getCurrentUser() {
    final getStorage = GetStorage();
    final userJsonString = getStorage.read(USER_SIGN_IN_KEY);
    if (userJsonString == null) {
      throw Exception("No user data found in storage");
    }
    return UserInfo.fromJson(json.decode(userJsonString));
  }
}
