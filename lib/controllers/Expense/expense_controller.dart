// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
// import 'package:root_app/enums/page_enum.dart';
// import 'package:root_app/constants/constants.dart';
// import 'package:root_app/models/authentication/components.dart';
// import 'package:root_app/models/expense/advance_model.dart';
// import 'package:root_app/models/expense/conveyance_model.dart';
// import 'package:root_app/models/expense/expense_request_model.dart';
// import 'package:root_app/models/expense/requestfilte.dart';
// import 'package:root_app/models/expense/travel_model.dart';
// import 'package:root_app/services/expense/expense_repository.dart';
// import 'package:root_app/utilities/get_months.dart';
// import 'dart:math' as math;

// class ExpenseController extends GetxController {
//   late Rx<ExpenseScreen> pageScreen;
//   late RxInt month;
//   late RxInt year;
//   late Rx<AutovalidateMode> autoValidate;
//   final selectedDate = DateTime.now().obs;
//   late List<String> errors;
//   late RxBool isLoading;
//   final travelTransport = ''.obs; // Add this to your ExpenseController
//   var expenseList = <ExpenseRequestModel>[].obs;

//   //new
//   final advanceAmountController = TextEditingController();
//   final purposeController = TextEditingController();
//   final expenseService = getIt<ExpenseRepository>();


// //travel
//   // ✅ Add Travel form controllers
//   final locationController = TextEditingController();
  
//   final transportationCostsController = TextEditingController();
//   final accommodationCostsController = TextEditingController();
//   final subsistenceCostsController = TextEditingController();
//   final otherCostsController = TextEditingController();
//   final descriptionController = TextEditingController();
  
//   // Date range
//   var fromDate = Rx<DateTime?>(null);
//   var toDate = Rx<DateTime?>(null);
  
//   // Selected values
//   var selectedTransportation = ''.obs;
//   var refNo = ''.obs;
// //new
//   String get selectedTransactionType => transactionType.value;
//   // String get selectedStatus => status.value;
//   // Reactive variables for transaction form
//   var transactionType = ''.obs;
//   var spendMode = ''.obs;
//   var status = ''.obs; // Adding the missing status variable
//   final transactionDate = Rx<DateTime?>(null);
//   var emailFlag = ''.obs;
//   var requestId = 0.obs;
//   var showingModal = false.obs;
//   final transactionDateRange = Rxn<DateTimeRange>();
//   // Reactive variables for specific forms
//   var conveyanceTransportations = <Map<String, String>>[].obs;
//   var entertainmentItems = <Map<String, String>>[].obs;
//   var expatItems = <Map<String, String>>[].obs;
//   var uploadFileName = 'Choose File (Only Pdf, Jpg, Png File)'.obs;

// // New properties
//   var advanceAmount = ''.obs;
//   var purpose = ''.obs;
//   var referenceNo = ''.obs;
//   var showAdvanceFields = false.obs;
//   var showTransactionType = true.obs;

//   // Form key for validation
//   //final formKey = GlobalKey<FormState>();
//   final expenseFormKey = GlobalKey<FormState>();
 

//     // Form fields
 
//   var employeeId = 0.obs;
 
//   var location = ''.obs;
 
//   var transportation = ''.obs;
//   var transportationCosts = ''.obs;
//   var accommodationCosts = ''.obs;
//   var subsistenceCosts = ''.obs;
//   var otherCosts = ''.obs;
//   var description = ''.obs;

 
 
// final TextEditingController companyNameController = TextEditingController();

//   // Lists for dropdowns
//   final List<String> transactionTypes = [
//     'Advance',
//     'Conveyance',
//     'Travel',
//     'Entertainment',
//     'Purchase',
//     'Expat',
//     'Training'
//   ];
//   final List<String> spendModes = ['Advance', 'Bill Settlement'];
//   final List<String> transportationModes = ['Car', 'Bus', 'Train', 'Flight'];
//   final List<String> travelTransports = ['Flight', 'Train', 'Car', 'Bus'];
// //  final List<String> locations = ['New York', 'London', 'Tokyo', 'Sydney'];
// //   final List<String> companyNames = ['Company A', 'Company B', 'Company C']; 
//   final List<String> billTypes = ['Utility', 'Rent', 'Service'];
//   final List<String> institutions = [
//     'Institute A',
//     'Institute B',
//     'Institute C'
//   ];
//   final List<String> courses = ['Course A', 'Course B', 'Course C'];
//   final List<String> statuses = ['Pending', 'Approved', 'Rejected', 'Returned'];

//   // Mock data list
//   var list = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     pageScreen = ExpenseScreen.Main.obs;
//     month = 0.obs;
//     year = 0.obs;
//     isLoading = false.obs;
//     errors = <String>[].obs;
//     autoValidate = AutovalidateMode.disabled.obs;
//     super.onInit();
//     //loadMockData();
//     fetchExpenseAmount(getCurrentUser().employeeId ?? 0);
//     initializeFormArrays();
//     fetchRequestData();
//     fetchInitialRequestData();
//   }

//   @override
//   void onClose() {
//     locationController.dispose();
//     purposeController.dispose();
//     transportationCostsController.dispose();
//     accommodationCostsController.dispose();
//     subsistenceCostsController.dispose();
//     otherCostsController.dispose();
//     descriptionController.dispose();
//     super.onClose();
//   }

//   void initializeFormArrays() {
//     conveyanceTransportations.add({'place': '', 'type': '', 'cost': ''});
//     entertainmentItems
//         .add({'item': '', 'quantity': '', 'price': '', 'amount': ''});
//     expatItems
//         .add({'companyName': '', 'particular': '', 'billType': '', 'cost': ''});
//   }

//   void loadMockData() {
//     list.assignAll([
//       {
//         'transactionType': 'Conveyance',
//         'transactionDate': DateTime(2025, 4, 1),
//         'referenceNumber': 'REF001',
//         'requestDate': DateTime(2025, 4, 2),
//         'companyName': 'Company A',
//         'purpose': 'Travel',
//         'spendMode': 'Card',
//         'description': 'Travel expense',
//         'stateStatus': 'Pending',
//       },
//       {
//         'transactionType': 'Travels',
//         'transactionDate': DateTime(2025, 4, 3),
//         'referenceNumber': 'REF002',
//         'fromDate': DateTime(2025, 4, 4),
//         'toDate': DateTime(2025, 4, 6),
//         'spendMode': 'Cash',
//         'location': 'New York',
//         'purpose': 'Business Trip',
//         'transportation': 'Flight',
//         'transportationCosts': 500,
//         'accommodationCosts': 300,
//         'subsistenceCosts': 100,
//         'otherCosts': 50,
//         'stateStatus': 'Approved',
//       },
//     ]);
//   }

//   void restoreDefultValues() {
//     // month = 0.obs;
//     // year = 0.obs;
//     isLoading = false.obs;
//     autoValidate.value = AutovalidateMode.disabled;
//     errors.clear();
//     transactionDate.value = null;
//     spendMode.value = '';
//     transactionType.value = '';
//     emailFlag.value = '';
//     requestId.value = 0;
//     conveyanceTransportations.clear();
//     entertainmentItems.clear();
//     expatItems.clear();
//     initializeFormArrays();
//     advanceAmount.value = '';
//     purpose.value = '';
//     referenceNo.value = '';
//     showAdvanceFields.value = false;
//     showTransactionType.value = true;

//     uploadFileName.value = 'Choose File (Only Pdf, Jpg, Png File)';
//   }

//   /// Validation Errors Block
//   void updateAdvanceFieldsVisibility(String? spendMode) {
//     showAdvanceFields.value = spendMode == 'Advance';
//     showTransactionType.value = spendMode != 'Advance';
//     if (spendMode == 'Advance') {
//       transactionType.value = ''; // Clear transaction type
//       conveyanceTransportations.clear();
//       entertainmentItems.clear();
//       expatItems.clear();
//       initializeFormArrays();
//       referenceNo.value = generateRefNo(DateTime.now(), 'Advance');
//     } else {
//       referenceNo.value = ''; // Clear reference number for non-Advance
//     }
//   }

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

//   void onMonthChanged(int value) {
//     month.value = value;
//     if (value != 0) {
//       removeError(error: kMonthNotSelectedError);
//       debugPrint(
//           '=======>>>>>> Selected Month : ${months[value - 1]} <<<<<<======');
//     } else {
//       addError(error: kMonthNotSelectedError);
//       debugPrint(
//           '=======>>>>>> Selected Month : ${value.toString()} <<<<<<======');
//     }
//   }

//   String? validateSelectedMonth(int value) {
//     if (value == 0) {
//       addError(error: kMonthNotSelectedError);
//       return "";
//     }
//     return null;
//   }

//   void setTransactionDateRange(DateTimeRange? range) {
//     transactionDateRange.value = range;
//   }

//   void onYearChanged(int value) {
//     year.value = value;
//     if (value != 0) {
//       removeError(error: kYearNotSelectedError);
//     } else {
//       addError(error: kYearNotSelectedError);
//     }
//     debugPrint(
//         '=======>>>>>> Selected Year : ${value.toString()} <<<<<<======');
//   }

//   void openRequestDeleteModal(Map<String, dynamic> item) {
//     Get.defaultDialog(
//       title: "Delete Request",
//       middleText: "Are you sure you want to delete this request?",
//       textCancel: "Cancel",
//       textConfirm: "Delete",
//       confirmTextColor: Colors.white,
//       onConfirm: () {
//         // Your deletion logic here
//         deleteRequest(item); // If you already have a method like this
//         Get.back();
//       },
//     );
//   }

//   void deleteRequest(Map<String, dynamic> item) {
//     list.remove(item);
//     Get.snackbar(
//       'Deleted',
//       'Request deleted successfully',
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//   }

//   String? validateSelectedYear(int value) {
//     if (value == 0) {
//       addError(error: kYearNotSelectedError);
//       return "";
//     }
//     return null;
//   }

//   String? validateSpendMode(String? value) {
//     if (value == null || value.isEmpty) {
//       addError(error: kSpendModeNotSelectedError);
//       return 'Spend Mode is required';
//     }
//     removeError(error: kSpendModeNotSelectedError);
//     return null;
//   }

//   String? validateTransactionType(String? value) {
//     if (value == null || value.isEmpty) {
//       addError(error: kTransactionTypeNotSelectedError);
//       return 'Transaction Type is required';
//     }
//     removeError(error: kTransactionTypeNotSelectedError);
//     return null;
//   }

//   /// Form Handlers

//   // void onTransactionTypeChanged(String? value) {
//   //   restoreDefultValues(); // Clear previous state first
//   //   transactionType.value = value ?? ''; // THEN assign new value

//   //   // Refresh input arrays as needed
//   //   initializeFormArrays();

//   //   if (value == null || value.isEmpty) {
//   //     addError(error: kTransactionTypeNotSelectedError);
//   //   } else {
//   //     removeError(error: kTransactionTypeNotSelectedError);
//   //   }
//   // }
//   // void onTransactionTypeChanged(String? value, int authorityId) {
//   //   restoreDefultValues();
//   //   transactionType.value = value ?? '';

//   //   initializeFormArrays();

//   //   if (value == null || value.isEmpty) {
//   //     addError(error: kTransactionTypeNotSelectedError);
//   //   } else {
//   //     removeError(error: kTransactionTypeNotSelectedError);

//   //     if (transactionType.value == 'Advance') {
//   //       fetchExpenseAmount(authorityId); // now authorityId is defined
//   //     }
//   //   }
//   // }

//   // void onTransactionTypeChanged(String? value) {
//   //   restoreDefultValues(); // Clear previous state
//   //   transactionType.value = value ?? '';

//   //   initializeFormArrays();

//   //   if (value == null || value.isEmpty) {
//   //     addError(error: kTransactionTypeNotSelectedError);
//   //     return;
//   //   }

//   //   removeError(error: kTransactionTypeNotSelectedError);

//   //   // ✅ Define authorityId from current user or context
//   //   final user = getCurrentUser(); // <- your existing method
//   //   final authorityId = user.employeeId ?? 0;

//   //   // ✅ Fetch data when Advance is selected
//   //   if (transactionType.value == 'Advance') {
//   //     fetchExpenseAmount(authorityId);
//   //   }
//   // }
//   void onTransactionTypeChanged(String? value) async {
//     restoreDefultValues(); // Reset previous selections
//     transactionType.value = value ?? '';

//     initializeFormArrays();

//     if (value == null || value.isEmpty) {
//       addError(error: kTransactionTypeNotSelectedError);
//       return;
//     }

//     removeError(error: kTransactionTypeNotSelectedError);

//     final user = getCurrentUser();
//     // ignore: unused_local_variable
//     final authorityId = user.employeeId ?? 0;

//     try {
//       // 🔹 If Advance → fetch advance amount
//       if (transactionType.value == 'Advance') {
//         //await fetchExpenseAmount(authorityId);
//         await fetchRequestData();
//       }

//       // 🔹 For ALL types (Advance, Conveyance, etc.) → fetch related requests
//       await fetchRequestData();
//     } catch (e) {
//       Get.snackbar('Error', e.toString(),
//           backgroundColor: Colors.red.shade700, colorText: Colors.white);
//     }
//   }

//   void onDateChanged(DateTime? date) {
//     transactionDate.value = date;
//     if (date == null) {
//       addError(error: 'Transaction date is required');
//     } else {
//       removeError(error: 'Transaction date is required');
//     }
//   }

//   void addConveyanceTransportation() {
//     conveyanceTransportations.add({'place': '', 'type': '', 'cost': ''});
//   }

//   void removeConveyanceTransportation(int index) {
//     if (conveyanceTransportations.length > 1) {
//       conveyanceTransportations.removeAt(index);
//     }
//   }

//   void addEntertainmentItem() {
//     entertainmentItems
//         .add({'item': '', 'quantity': '', 'price': '', 'amount': ''});
//   }

//   void removeEntertainmentItem(int index) {
//     if (entertainmentItems.length > 1) {
//       entertainmentItems.removeAt(index);
//     }
//   }

//   void calculateEntertainmentAmount(int index) {
//     var item = entertainmentItems[index];
//     double quantity = double.tryParse(item['quantity'] ?? '0') ?? 0;
//     double price = double.tryParse(item['price'] ?? '0') ?? 0;
//     item['amount'] = (quantity * price).toString();
//     entertainmentItems.refresh();
//   }

//   void addExpatItem() {
//     expatItems
//         .add({'companyName': '', 'particular': '', 'billType': '', 'cost': ''});
//   }

//   void removeExpatItem(int index) {
//     if (expatItems.length > 1) {
//       expatItems.removeAt(index);
//     }
//   }

//   double calculateTotalAmount(List<Map<String, String>> items, String key) {
//     double total = 0;
//     for (var item in items) {
//       total += double.tryParse(item[key] ?? '0') ?? 0;
//     }
//     return total;
//   }

//   void pickFile() {
//     // Placeholder for file picker logic
//     uploadFileName.value = 'SelectedFile.pdf';
//   }

//   // String generateRefNo(DateTime date, String type) {
//   //   return 'REF-${type.substring(0, 3).toUpperCase()}-${date.millisecondsSinceEpoch}';
//   // }

// // String generateRefNo(DateTime date, String type) {
// //   // Extract first 3 letters or use full type if shorter
// //   String prefix = type.length >= 3 
// //       ? type.substring(0, 3).toUpperCase() 
// //       : type.toUpperCase();
  
// //   return 'REF-$prefix-${date.millisecondsSinceEpoch}';
// // }
// // ...existing code...
// String generateRefNo(DateTime date, String type) {
//   // Map known types to prefixes
//   final mapPrefix = {
//     'Conveyance': 'CONV',
//     'Travel': 'TRV',
//     'Advance': 'ADV',
//   };

//   final prefix = (mapPrefix[type] ?? type.toUpperCase().replaceAll(RegExp(r'\s+'), '').substring(0, math.min(4, type.length))).toString();

//   // Try to get employee id from any available user helper; fallback to '00'
//   String empId = '00';
//   try {
//     final user = getCurrentUser(); // if your project provides this helper
//     if (user != null && (user.employeeId != null && user.employeeId != 0)) {
//       empId = user.employeeId.toString();
//     }
//   } catch (_) {
//     // ignore and keep fallback
//   }

//   // Date string y-m-d
//   final dateStr = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

//   // Find highest existing sequence for same prefix, empId and date in expenseList
//   final pattern = RegExp('^$prefix-$empId-$dateStr-(\\d+)\$');
//   int maxSeq = 0;
//   for (var item in expenseList) {
//     String ref = '';
//     try {
//       // dynamic access to possible field names
//       final dyn = item as dynamic;
//       ref = dyn.referenceNumber ?? dyn.referenceNo ?? dyn.refNo ?? '';
//     } catch (_) {
//       ref = item.toString();
//     }
//     final m = pattern.firstMatch(ref);
//     if (m != null) {
//       final seq = int.tryParse(m.group(1) ?? '0') ?? 0;
//       if (seq > maxSeq) maxSeq = seq;
//     }
//   }

//   final nextSeq = (maxSeq + 1).toString().padLeft(2, '0');
//   return '$prefix-$empId-$dateStr-$nextSeq';
// }
// // ...existing code...
//   /// Function Block
// // ──────────────────────────────────────────────────────────────
//   // Reset everything to the default / empty state
//   // ──────────────────────────────────────────────────────────────
//   void restoreDefaultValues() {
//     requestId.value = 0;
//     spendMode.value = '';
//     transactionType.value = '';
//     transactionDate.value = null;
//     advanceAmount.value = '';
//     purpose.value = '';
//     referenceNo.value = '';

//     // Clear TextEditingControllers (if you use them)
//     // advanceAmountCtrl.clear();
//     // purposeCtrl.clear();
//     // referenceNoCtrl.clear();

//     // Reset validation
//     autoValidate.value = AutovalidateMode.disabled;
//     errors.clear();

//     // Optionally reset the form key to remove any lingering validation UI
//     expenseFormKey.currentState?.reset();
//   }

// // ── Reset everything to a *brand‑new* empty form ───────
//   void clearForm() {
//     requestId.value = 0;
//     spendMode.value = '';
//     transactionType.value = '';
//     transactionDate.value = null;
//     advanceAmount.value = '';
//     purpose.value = '';
//     referenceNo.value = '';
//     emailFlag.value = 'Add';

//     // advanceAmountCtrl.clear();
//     // purposeCtrl.clear();
//     // referenceNoCtrl.clear();

//     autoValidate.value = AutovalidateMode.disabled;
//     errors.clear();

//     // Important: reset the Form widget itself
//     expenseFormKey.currentState?.reset();
//   }

//   UserInfo getCurrentUser() {
//     final getStorage = GetStorage();
//     final userJsonString = getStorage.read(USER_SIGN_IN_KEY);
//     var user = UserInfo.fromJson(json.decode(userJsonString));
//     return user;
//   }

//   void showModal(int id, String type, String mode, String action) {
//     requestId.value = id;
//     transactionType.value = type;
//     spendMode.value = mode;
//     emailFlag.value = action;
//     showingModal.value = true;
//   }

//   void closeModal() {
//     showingModal.value = false;

//     restoreDefultValues();
//   }

//   void onStatusChanged(String? value) {
//     status.value = value ?? '';
//     errors.clear();
//   }

//   // Future<bool> submit(String action) async {
//   //   errors.clear();
//   //   if (!expenseFormKey.currentState!.validate()) {
//   //     autoValidate.value = AutovalidateMode.always;
//   //     return false;
//   //   }

//   //   isLoading.value = true;
//   //   await Future.delayed(const Duration(seconds: 2)); // Simulate API call

//   //   try {
//   //     // Prepare data to submit
//   //     Map<String, dynamic> requestData = {
//   //       'requestId': requestId.value,
//   //       'transactionType': transactionType.value,
//   //       'transactionDate': transactionDate.value?.toIso8601String(),
//   //       'spendMode': spendMode.value,
//   //       'action': action,
//   //     };

//   //     if (transactionType.value == 'Conveyance') {
//   //       requestData['conveyance'] = {
//   //         'transportations': conveyanceTransportations,
//   //         'totalAmount':
//   //             calculateTotalAmount(conveyanceTransportations, 'cost'),
//   //       };
//   //     } else if (transactionType.value == 'Entertainment' ||
//   //         transactionType.value == 'Purchase') {
//   //       requestData['entertainment'] = {
//   //         'items': entertainmentItems,
//   //         'totalAmount': calculateTotalAmount(entertainmentItems, 'amount'),
//   //       };
//   //     } else if (transactionType.value == 'Expat') {
//   //       requestData['expat'] = {
//   //         'items': expatItems,
//   //         'totalAmount': calculateTotalAmount(expatItems, 'cost'),
//   //       };
//   //     }

//   //     // Simulate successful submission
//   //     list.add(requestData);
//   //     Get.snackbar('Success',
//   //         'Request ${action == 'Edit' ? 'Updated' : 'Submitted'} Successfully',
//   //         backgroundColor: Colors.green, colorText: Colors.white);
//   //     isLoading.value = false;
//   //     return true;
//   //   } catch (e) {
//   //     isLoading.value = false;
//   //     Get.snackbar('Error', e.toString(),
//   //         backgroundColor: Colors.red.shade700, colorText: Colors.white);
//   //     return false;
//   //   }
//   // }
//   // Future<bool> submitAdvance() async {
//   //   errors.clear();
//   //   if (!expenseFormKey.currentState!.validate()) {
//   //     autoValidate.value = AutovalidateMode.always;
//   //     return false;
//   //   }

//   //   isLoading.value = true;

//   //   try {
//   //     final user = getCurrentUser();
//   //     final model = AdvanceDTO(
//   //       employeeId: user.employeeId ?? 0,
//   //       requestId: requestId.value,
//   //       spendMode: spendMode.value,
//   //       transactionType: transactionType.value,
//   //       transactionDate: transactionDate.value!.toIso8601String(),
//   //       advanceAmount: double.tryParse(advanceAmount.value) ?? 0,
//   //       purpose: purpose.value,
//   //       referenceNumber: referenceNo.value,
//   //       flag: 'Request',
//   //       requestDate: DateTime.now().toIso8601String(),
//   //     );

//   //     final response = await expenseService.saveAdvance(model);

//   //     if (response.error == true) {
//   //       Get.snackbar(
//   //         'Error',
//   //         response.errorMessage ?? 'Something went wrong',
//   //         backgroundColor: Colors.red.shade700,
//   //         colorText: Colors.white,
//   //       );
//   //       isLoading.value = false;
//   //       return false;
//   //     }

//   //     // On success
//   //     list.add({
//   //       'transactionType': transactionType.value,
//   //       'transactionDate': transactionDate.value,
//   //       'referenceNumber': referenceNo.value,
//   //       'spendMode': spendMode.value,
//   //       'advanceAmount': advanceAmount.value,
//   //       'purpose': purpose.value,
//   //       'flag': 'Request',
//   //     });

//   //     Get.snackbar(
//   //       'Success',
//   //       'Advance request submitted successfully',
//   //       backgroundColor: Colors.green,
//   //       colorText: Colors.white,
//   //     );

//   //     restoreDefultValues();
//   //     isLoading.value = false;
//   //     return true;
//   //   } catch (e) {
//   //     isLoading.value = false;
//   //     Get.snackbar(
//   //       'Error',
//   //       e.toString(),
//   //       backgroundColor: Colors.red.shade700,
//   //       colorText: Colors.white,
//   //     );
//   //     return false;
//   //   }
//   // }

//   // Future<void> submitAdvanceamount() async {
//   //   errors.clear();

//   //   // Validate the form
//   //   if (!expenseFormKey.currentState!.validate()) {
//   //     autoValidate.value = AutovalidateMode.always;
//   //     return;
//   //   }

//   //   isLoading.value = true;

//   //   try {
//   //     final user = getCurrentUser();
//   //     final model = AdvanceDTO(
//   //       employeeId: user.employeeId ?? 0,
//   //       requestId: requestId.value,
//   //       spendMode: spendMode.value,
//   //       transactionType: transactionType.value,
//   //       transactionDate: transactionDate.value!.toIso8601String(),
//   //       advanceAmount: double.tryParse(advanceAmount.value) ?? 0.0,
//   //       purpose: purpose.value,
//   //       referenceNumber: referenceNo.value,
//   //       flag: 'Request',
//   //       requestDate: DateTime.now().toIso8601String(),
//   //     );

//   //     // Call the service – now it returns ExpenseResponseModel
//   //     final response = await expenseService.saveAdvance(model);

//   //     if (!response.error) {
//   //       restoreDefaultValues(); // reset form / controller state
//   //       Get.snackbar('Success', 'Advance request submitted successfully');

//   //       // Small delay so the snackbar is visible before popping
//   //       await Future.delayed(const Duration(milliseconds: 200));
//   //       Get.back(result: 'Success');
//   //     } else {
//   //       Get.snackbar(
//   //         'Error',
//   //         response.errorMessage ?? 'Something went wrong',
//   //         backgroundColor: Colors.redAccent,
//   //         colorText: Colors.white,
//   //       );
//   //     }
//   //   } catch (e) {
//   //     Get.snackbar(
//   //       'Error',
//   //       e.toString(),
//   //       backgroundColor: Colors.redAccent,
//   //       colorText: Colors.white,
//   //     );
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
// // ── Submit -------------------------------------------------
//   Future<bool> submitAdvanceamount() async {
//     errors.clear();

//     if (!expenseFormKey.currentState!.validate()) {
//       autoValidate.value = AutovalidateMode.always;
//       return false;
//     }

//     isLoading.value = true;

//     try {
//       final user = getCurrentUser();
//       final model = AdvanceDTO(
//         employeeId: user.employeeId ?? 0,
//         requestId: requestId.value,
//         spendMode: spendMode.value,
//         transactionType: transactionType.value,
//         transactionDate: transactionDate.value!.toIso8601String(),
//         advanceAmount: double.tryParse(advanceAmount.value) ?? 0.0,
//         purpose: purpose.value,
//         referenceNumber: referenceNo.value,
//         flag: 'Request',
//         requestDate: DateTime.now().toIso8601String(),
//       );

//       final response = await expenseService.saveAdvance(model);

//       if (!response.error) {
//         Get.snackbar(
//           'Success',
//           'Advance request submitted successfully',
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//         );
        
//         // Clear all fields including purpose
//         requestId.value = 0;
//         spendMode.value = '';
//         transactionType.value = '';
//         transactionDate.value = null;
//         advanceAmount.value = '';
//         purpose.value = '';
//         purposeController.clear(); // Clear the purpose controller
//         referenceNo.value = '';
//         autoValidate.value = AutovalidateMode.disabled;
//         errors.clear();
        
//         // Reset the form validation state
//         expenseFormKey.currentState?.reset();
        
//         return true;
//       } else {
//         final msg = response.errorMessage ?? '';

//         if (msg.toLowerCase().contains('already exists')) {
//           Get.snackbar(
//             'Validation Error',
//             'An advance request already exists for this date. Please select a different date.',
//             backgroundColor: Colors.orange,
//             colorText: Colors.white,
//             duration: const Duration(seconds: 5),
//           );
//         } else {
//           Get.snackbar(
//             'Error',
//             msg.isNotEmpty ? msg : 'Something went wrong',
//             backgroundColor: Colors.redAccent,
//             colorText: Colors.white,
//           );
//         }
//         return false;
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         e.toString(),
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> fetchExpenseAmount(int authorityId) async {
//     try {
//       isLoading.value = true;
//       final response = await expenseService.getExpenseAmount(authorityId);

//       if (response.error == true) {
//         Get.snackbar('Error', response.errorMessage ?? 'Failed to load data',
//             backgroundColor: Colors.red.shade700, colorText: Colors.white);
//       } else {
//         // Populate controllers
//         advanceAmountController.text = (response.advanceAmount ?? 0).toString();
//         purposeController.text = response.purpose ?? '';

//         // Optionally store to reactive variables
//         advanceAmount.value = (response.advanceAmount ?? 0).toString();
//         purpose.value = response.purpose ?? '';

//         // Get.snackbar('Success', 'Expense data fetched successfully',
//         //     backgroundColor: Colors.green, colorText: Colors.white);
//       }
//     } catch (e) {
//       Get.snackbar('Error', e.toString(),
//           backgroundColor: Colors.red.shade700, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   // Future<void> fetchRequestData() async {
//   //   try {
//   //     isLoading.value = true;
//   //     final user = getCurrentUser();

//   //     final filter = RequestFilter(
//   //       employeeId: user.employeeId ?? 0,
//   //       transactionType: transactionType.value,
//   //       spendMode: spendMode.value,
//   //     );

//   //     final data = await expenseService.getRequestData(filter);

//   //     if (data.isNotEmpty) {
//   //       expenseList.assignAll(data);
//   //       Get.snackbar('Success', 'Request data fetched successfully',
//   //           backgroundColor: Colors.green, colorText: Colors.white);
//   //     } else {
//   //       Get.snackbar('Info', 'No records found',
//   //           backgroundColor: Colors.orange, colorText: Colors.white);
//   //     }
//   //   } catch (e) {
//   //     Get.snackbar('Error', e.toString(),
//   //         backgroundColor: Colors.red.shade700, colorText: Colors.white);
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }

//  Future<void> fetchRequestData() async {
//   try {
//     isLoading.value = true;
//     final user = getCurrentUser();

//     final filter = RequestFilter(
//       employeeId: user.employeeId ?? 0,
//       transactionType: transactionType.value,
//       spendMode: spendMode.value,
//     );

//     final data = await expenseService.getRequestData(filter);

//     if (data.isNotEmpty) {
//       list.assignAll(data.map((expense) => expense.toJson()).toList());
//       expenseList.assignAll(data);
//     } else {
//       list.clear();
//       // No snackbar here
//     }
//   } catch (e) {
//     Get.snackbar(
//       'Error',
//       e.toString(),
//       backgroundColor: Colors.red.shade700,
//       colorText: Colors.white,
//     );
//   } finally {
//     isLoading.value = false;
//   }
// }

//   Future<void> fetchInitialRequestData() async {
//     try {
//       isLoading.value = true;
//       final user = getCurrentUser();

//       final data = await expenseService.getRequestData(
//         RequestFilter(employeeId: user.employeeId ?? 0),
//       );

//       if (data.isNotEmpty) {
//         list.assignAll(data.map((e) => e.toJson()).toList());
//         expenseList.assignAll(data);
//       } else {
//         list.clear();
//       }
//     } finally {
//       isLoading.value = false;
//     }
//   }

// /// Submit Travel Request
// Future<bool> submitTravel() async {
//   errors.clear();

//   // Validate form
//   if (!expenseFormKey.currentState!.validate()) {
//     autoValidate.value = AutovalidateMode.always;
//     return false;
//   }

//   isLoading.value = true;

//   try {
//     final user = getCurrentUser();

//     // Ensure reference exists (in case user didn't tap the field)
//     if (referenceNo.value.isEmpty) {
//       final DateTime txDate = transactionDate.value ?? DateTime.now();
//       final String genRef = generateRefNo(txDate, 'Travel');
//       referenceNo.value = genRef;
//       refNo.value = genRef; // keep UI observable in sync
//     }

//     final model = TravelDTO(
//       requestId: requestId.value,
//       employeeId: user.employeeId ?? 0,
//       transactionType: transactionType.value,
//       transactionDate: transactionDate.value,
//       referenceNumber: referenceNo.value,
//       spendMode: spendMode.value,
//       location: location.value,
//       purpose: purpose.value,
//       transportation: travelTransport.value,
//       transportationCosts: double.tryParse(transportationCosts.value) ?? 0.0,
//       accommodationCosts: double.tryParse(accommodationCosts.value) ?? 0.0,
//       subsistenceCosts: double.tryParse(subsistenceCosts.value) ?? 0.0,
//       otherCosts: double.tryParse(otherCosts.value) ?? 0.0,
//       description: description.value,
//       flag: 'Request',
//       isApproved: false, // always default false
//     );

//   // Debug: log outgoing payload
//   debugPrint('Submitting Travel payload: ${model.toJson()}');
//   final response = await expenseService.saveTravel(model);

//   // Debug: log API response
//   debugPrint('Response Data : ${response.data}');

//     // Handle both JSON response or 204 No Content
//     if (response.error == false) {
//       Get.snackbar(
//         'Success',
//         'Travel request submitted successfully',
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       clearTravelForm(); // Reset UI
//       return true;
//     } else {
//       Get.snackbar(
//       'Error',
//       response.errorMessage ?? 'Something went wrong',
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//     }
//     return false;
  
//   } catch (e) {
//     Get.snackbar(
//       'Error',
//       e.toString(),
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//     return false;
//   } finally {
//     isLoading.value = false; // always re-enable button
//   }
// }


//   /// Clear form fields
// void clearTravelForm() {
//   requestId.value = 0;
//   transactionType.value = '';
//   transactionDate.value = null;
//   referenceNo.value = '';
//   spendMode.value = '';
//   location.value = '';
//   travelTransport.value = '';
//   transportationCosts.value = '';
//   accommodationCosts.value = '';
//   subsistenceCosts.value = '';
//   otherCosts.value = '';
//   description.value = '';
// }
//   /// Save Conveyance
// // Future<bool> saveConveyance() async {
// //   if (expenseFormKey.currentState?.validate() != true) {
// //     autoValidate.value = AutovalidateMode.always;
// //     return false;
// //   }

// //   try {
// //     isLoading.value = true;

// //     List<ConveyanceDTO> conveyances = [
// //       ConveyanceDTO(
// //         requestId: requestId.value,
// //         transactionType: transactionType.value,
// //         transactionDate: transactionDate.value?.toIso8601String(),
// //         employeeId: employeeId.value,
// //         referenceNumber: referenceNo.value,
// //         companyName: companyNameController.text,   // ✅ user input
// //         purpose: purposeController.text,
// //         description: descriptionController.text,
// //         transportation: transportation.value,
// //         spendMode: spendMode.value,
// //         advanceAmount: double.tryParse(advanceAmount.value),
// //         destination: locationController.text,       // ✅ user input
// //         mode: selectedTransportation.value,
// //         cost: double.tryParse(transportationCosts.value),
// //       ),
// //     ];

// //     final response = await expenseService.saveConveyance(conveyances);

// //     if (response.error == true) {
// //       Get.snackbar("Error", response.errorMessage ?? "Failed to save conveyance");
// //       return false;
// //     } else {
// //       Get.snackbar("Success", response.message ?? "Conveyance saved successfully");
// //       clearConveyanceForm();
// //       return true;
// //     }
// //   } catch (e) {
// //     Get.snackbar("Error", e.toString());
// //     return false;
// //   } finally {
// //     isLoading.value = false;
// //   }
// // }
// // Future<bool> saveConveyance() async {
// //   errors.clear();

// //   if (!expenseFormKey.currentState!.validate()) {
// //     autoValidate.value = AutovalidateMode.always;
// //     return false;
// //   }

// //   final user = getCurrentUser();
// //   if (user == null || user.employeeId == null || user.employeeId == 0) {
// //     Get.snackbar(
// //       "Error",
// //       "Employee ID is missing.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     debugPrint('Error: Invalid user data: ${user?.toJson()}');
// //     return false;
// //   }

// //   if (spendMode.value != 'Advance' && conveyanceTransportations.isEmpty) {
// //     Get.snackbar(
// //       "Error",
// //       "At least one transportation entry is required.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   }

// //   // Validate required fields
// //   if (companyNameController.text.isEmpty) {
// //     Get.snackbar(
// //       "Error",
// //       "Company name is required.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   }
// //   if (purposeController.text.isEmpty) {
// //     Get.snackbar(
// //       "Error",
// //       "Purpose is required.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   }
// //   if (transactionDate.value == null) {
// //     Get.snackbar(
// //       "Error",
// //       "Transaction date is required.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   }
// //   if (referenceNo.value.isEmpty) {
// //     Get.snackbar(
// //       "Error",
// //       "Reference number is required.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   }

// //   try {
// //     isLoading.value = true;

// //     List<ConveyanceDTO> list = [];
// //     final String transactionDateStr = transactionDate.value!.toIso8601String().split('T')[0];
// //     final String requestDateStr = DateTime.now().toIso8601String().split('T')[0];

// //     if (spendMode.value == 'Advance') {
// //       list.add(
// //         ConveyanceDTO(
// //           requestId: requestId.value ?? 0,
// //           transactionType: transactionType.value.isNotEmpty ? transactionType.value : "Conveyance",
// //           transactionDate: transactionDateStr,
// //           employeeId: user.employeeId!,
// //           referenceNumber: referenceNo.value,
// //           requestDate: requestDateStr,
// //           companyName: companyNameController.text,
// //           spendMode: spendMode.value.isNotEmpty ? spendMode.value : "Advance",
// //           purpose: purposeController.text,
// //           description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
// //           advanceAmount: double.tryParse(advanceAmount.value) ?? 0.0,
// //           destination: locationController.text.isNotEmpty ? locationController.text : null,
// //           mode: null,
// //           cost: null,
// //           isApproved: false,
// //           flag: "Request",
// //         ),
// //       );
// //     } else {
// //       for (var item in conveyanceTransportations) {
// //         if (item['place']?.isEmpty == true || item['type']?.isEmpty == true || item['cost']?.isEmpty == true) {
// //           Get.snackbar(
// //             "Error",
// //             "All transportation fields (destination, mode, cost) are required.",
// //             backgroundColor: Colors.redAccent,
// //             colorText: Colors.white,
// //           );
// //           return false;
// //         }
// //         list.add(
// //           ConveyanceDTO(
// //             requestId: requestId.value ?? 0,
// //             transactionType: transactionType.value.isNotEmpty ? transactionType.value : "Conveyance",
// //             transactionDate: transactionDateStr,
// //             employeeId: user.employeeId!,
// //             referenceNumber: referenceNo.value,
// //             requestDate: requestDateStr,
// //             companyName: companyNameController.text,
// //             spendMode: spendMode.value.isNotEmpty ? spendMode.value : "Bill Settlement",
// //             purpose: purposeController.text,
// //             description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
// //             destination: item['place']!,
// //             mode: item['type']!,
// //             cost: double.tryParse(item['cost']!) ?? 0.0,
// //             isApproved: false,
// //             flag: "Request",
// //           ),
// //         );
// //       }
// //     }

// //     debugPrint('Conveyance Payload: ${jsonEncode(list.map((c) => c.toJson()).toList())}');
// //     final response = await expenseService.saveConveyance(list);

// //     if (response.error == false) {
// //       Get.snackbar(
// //         "Success",
// //         response.message ?? "Conveyance saved successfully",
// //         backgroundColor: Colors.green,
// //         colorText: Colors.white,
// //       );
// //       clearConveyanceForm();
// //       return true;
// //     } else {
// //       Get.snackbar(
// //         "Error",
// //         response.errorMessage ?? "Failed to save conveyance",
// //         backgroundColor: Colors.redAccent,
// //         colorText: Colors.white,
// //       );
// //       return false;
// //     }
// //   } catch (e) {
// //     debugPrint('Error in saveConveyance: $e');
// //     Get.snackbar(
// //       "Error",
// //       e.toString(),
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   } finally {
// //     isLoading.value = false;
// //   }
// // }

// // Future<bool> saveConveyance() async {
// //   errors.clear();

// //   if (!expenseFormKey.currentState!.validate()) {
// //     autoValidate.value = AutovalidateMode.always;
// //     return false;
// //   }

// //   final user = getCurrentUser();
// //   if (user.employeeId == null || user!.employeeId == 0) {
// //     Get.snackbar(
// //       "Error",
// //       "Employee ID is missing.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     debugPrint('Error: Invalid user data: ${user.toJson()}');
// //     return false;
// //   }

// //   if (spendMode.value != 'Advance' && conveyanceTransportations.isEmpty) {
// //     Get.snackbar(
// //       "Error",
// //       "At least one transportation entry is required.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   }

// //   // Validate required fields
// //   if (companyNameController.text.isEmpty || purposeController.text.isEmpty || transactionDate.value == null || referenceNo.value.isEmpty) {
// //     Get.snackbar(
// //       "Error",
// //       "Please fill all required fields.",
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   }

// //   try {
// //     isLoading.value = true;

// //     List<ConveyanceDTO> list = [];
// //     final String transactionDateStr = transactionDate.value!.toIso8601String().split('T')[0];
// //     final String requestDateStr = DateTime.now().toIso8601String().split('T')[0];

// //     if (spendMode.value == 'Advance') {
// //       list.add(
// //         ConveyanceDTO(
// //           requestId: requestId.value,
// //           transactionType: transactionType.value.isNotEmpty ? transactionType.value : "Conveyance",
// //           transactionDate: transactionDateStr,
// //           employeeId: user.employeeId!,
// //           referenceNumber: referenceNo.value,
// //           requestDate: requestDateStr,
// //           companyName: companyNameController.text,
// //           spendMode: "Advance",
// //           purpose: purposeController.text,
// //           description: descriptionController.text.isNotEmpty ? descriptionController.text : "",
// //           advanceAmount: double.tryParse(advanceAmount.value) ?? 0.0,
// //           destination: locationController.text.isNotEmpty ? locationController.text : "",
// //           mode: "",
// //           cost: 0.0,
// //           isApproved: false,
// //           flag: "Request",
// //           stateStatus: "",
// //           userStatus: "",
// //           fileName: "",
// //           actualFileName: "",
// //           fileFormat: "",
// //         //  fileSize: 0,
// //           filePath: "",
// //           commentsUser: "",
// //           commentsAccount: "",
// //           accountStatus: "",
// //           reimburseStatus: "",
// //         ),
// //       );
// //     } else {
// //       for (var item in conveyanceTransportations) {
// //         if (item['place']?.isEmpty == true || item['type']?.isEmpty == true || item['cost']?.isEmpty == true) {
// //           Get.snackbar(
// //             "Error",
// //             "All transportation fields (destination, mode, cost) are required.",
// //             backgroundColor: Colors.redAccent,
// //             colorText: Colors.white,
// //           );
// //           return false;
// //         }
// //         list.add(
// //           ConveyanceDTO(
// //             requestId: requestId.value,
// //             transactionType: transactionType.value.isNotEmpty ? transactionType.value : "Conveyance",
// //             transactionDate: transactionDateStr,
// //             employeeId: user.employeeId!,
// //             referenceNumber: referenceNo.value,
// //             requestDate: requestDateStr,
// //             companyName: companyNameController.text,
// //             spendMode: "Bill Settlement",
// //             purpose: purposeController.text,
// //             description: descriptionController.text.isNotEmpty ? descriptionController.text : "",
// //             destination: item['place'] ?? "",
// //             mode: item['type'] ?? "",
// //             cost: double.tryParse(item['cost'] ?? "0") ?? 0.0,
// //             isApproved: false,
// //             flag: "Request",
// //             stateStatus: "",
// //             userStatus: "",
// //             fileName: "",
// //             actualFileName: "",
// //             fileFormat: "",
// //             //fileSize: 0,
// //             filePath: "",
// //             commentsUser: "",
// //             commentsAccount: "",
// //             accountStatus: "",
// //             reimburseStatus: "",
// //           ),
// //         );
// //       }
// //     }

// //     debugPrint('Conveyance Payload: ${jsonEncode(list.map((c) => c.toJson()).toList())}');
// //     final response = await expenseService.saveConveyance(list);

// //     if (response.error == false) {
// //       Get.snackbar(
// //         "Success",
// //         response.message ?? "Conveyance saved successfully",
// //         backgroundColor: Colors.green,
// //         colorText: Colors.white,
// //       );
// //       clearConveyanceForm();
// //       return true;
// //     } else {
// //       Get.snackbar(
// //         "Error",
// //         response.errorMessage ?? "Failed to save conveyance",
// //         backgroundColor: Colors.redAccent,
// //         colorText: Colors.white,
// //       );
// //       return false;
// //     }
// //   } catch (e) {
// //     debugPrint('Error in saveConveyance: $e');
// //     Get.snackbar(
// //       "Error",
// //       e.toString(),
// //       backgroundColor: Colors.redAccent,
// //       colorText: Colors.white,
// //     );
// //     return false;
// //   } finally {
// //     isLoading.value = false;
// //   }
// // }

// Future<bool> saveConveyance() async {
//   errors.clear();

//   // Validate form
//   if (!expenseFormKey.currentState!.validate()) {
//     autoValidate.value = AutovalidateMode.always;
//     return false;
//   }

//   // Validate user
//   final user = getCurrentUser();
//   if (user == null || user.employeeId == null || user.employeeId == 0) {
//     Get.snackbar(
//       "Error",
//       "Employee ID is missing.",
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//     debugPrint('Error: Invalid user data: ${user?.toJson()}');
//     return false;
//   }

//   // Validate transportation entries if Bill Settlement
//   if (spendMode.value != 'Advance' && conveyanceTransportations.isEmpty) {
//     Get.snackbar(
//       "Error",
//       "At least one transportation entry is required.",
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//     return false;
//   }

//   // Validate required fields
//   if (companyNameController.text.isEmpty) {
//     Get.snackbar("Error", "Company name is required.",
//         backgroundColor: Colors.redAccent, colorText: Colors.white);
//     return false;
//   }

//   if (purposeController.text.isEmpty) {
//     Get.snackbar("Error", "Purpose is required.",
//         backgroundColor: Colors.redAccent, colorText: Colors.white);
//     return false;
//   }

//   if (transactionDate.value == null) {
//     Get.snackbar("Error", "Transaction date is required.",
//         backgroundColor: Colors.redAccent, colorText: Colors.white);
//     return false;
//   }

//   if (referenceNo.value.isEmpty) {
//     Get.snackbar("Error", "Reference number is required.",
//         backgroundColor: Colors.redAccent, colorText: Colors.white);
//     return false;
//   }

//   try {
//     isLoading.value = true;

//     List<ConveyanceDTO> list = [];

//     final String transactionDateStr =
//         transactionDate.value!.toIso8601String().split('T')[0];
//     final String requestDateStr = DateTime.now().toIso8601String().split('T')[0];

//     if (spendMode.value == 'Advance') {
//       // Advance mode
//       list.add(
//         ConveyanceDTO(
//           requestId: requestId.value ?? 0,
//           transactionType: transactionType.value.isNotEmpty
//               ? transactionType.value
//               : "Conveyance",
//           transactionDate: transactionDateStr,
//           employeeId: user.employeeId!,
//           referenceNumber: referenceNo.value,
//           requestDate: requestDateStr,
//           companyName: companyNameController.text,
//           spendMode: "Advance",
//           purpose: purposeController.text,
//           description: descriptionController.text.isNotEmpty
//               ? descriptionController.text
//               : null,
//           advanceAmount: double.tryParse(advanceAmount.value) ?? 0.0,
//           destination: locationController.text.isNotEmpty ? locationController.text : null,
//           mode: null,
//           cost: 0.0, // Changed from null to 0.0
//           isApproved: false,
//           flag: "Request",
//         ),
//       );
//     } else {
//       // Bill Settlement / Conveyance mode
//       for (var item in conveyanceTransportations) {
//         if (item['place']?.isEmpty == true ||
//             item['type']?.isEmpty == true ||
//             item['cost']?.isEmpty == true) {
//           Get.snackbar(
//             "Error",
//             "All transportation fields (destination, mode, cost) are required.",
//             backgroundColor: Colors.redAccent,
//             colorText: Colors.white,
//           );
//           isLoading.value = false;
//           return false;
//         }

//         list.add(
//           ConveyanceDTO(
//             requestId: 0, // Changed: Always send 0 for new requests
//             transactionType: transactionType.value.isNotEmpty
//                 ? transactionType.value
//                 : "Conveyance",
//             transactionDate: transactionDateStr,
//             employeeId: user.employeeId!,
//             referenceNumber: referenceNo.value,
//             requestDate: requestDateStr,
//             companyName: companyNameController.text,
//             spendMode: "Bill Settlement",
//             purpose: purposeController.text,
//             description: descriptionController.text.isNotEmpty
//                 ? descriptionController.text
//                 : null,
//             destination: item['place']!,
//             mode: item['type']!,
//             cost: double.tryParse(item['cost']!) ?? 0.0,
//             advanceAmount: 0.0, // Add this field
//             isApproved: false,
//             flag: "Request",
//           ),
//         );
//       }
//     }

//     // Debug payload
//     debugPrint(
//         'Conveyance Payload: ${jsonEncode(list.map((c) => c.toJson()).toList())}');

//     // Call API with List<ConveyanceDTO>
//     final response = await expenseService.saveConveyance(list);

//     if (response.error == false) {
//       Get.snackbar(
//         "Success",
//         response.message ?? "Conveyance saved successfully",
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//       );
//       clearConveyanceForm();
//       return true;
//     } else {
//       Get.snackbar(
//         "Error",
//         response.errorMessage ?? "Failed to save conveyance",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return false;
//     }
//   } catch (e) {
//     debugPrint('Error in saveConveyance: $e');
//     Get.snackbar(
//       "Error",
//       e.toString(),
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//     );
//     return false;
//   } finally {
//     isLoading.value = false;
//   }
// }

//   /// Clear conveyance-specific form fields
//   void clearConveyanceForm() {
//      referenceNo.value = '';  // This will force regeneration
//     requestId.value = 0;
//     transactionType.value = '';
//     transactionDate.value = null;
//     referenceNo.value = '';
//     purposeController.clear();
//     descriptionController.clear();
//     transportation.value = '';
//     spendMode.value = '';
//     advanceAmount.value = '';
//     location.value = '';
//     selectedTransportation.value = '';
//     transportationCosts.value = '';
//   }

// }
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
import 'package:root_app/enums/page_enum.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/models/authentication/components.dart';
import 'package:root_app/models/expense/account_head_dto.dart';
import 'package:root_app/models/expense/advance_model.dart';
import 'package:root_app/models/expense/conveyance_model.dart';
import 'package:root_app/models/expense/expense_model.dart';
import 'package:root_app/models/expense/expense_request_model.dart';
import 'package:root_app/models/expense/expense_response_model.dart';
import 'package:root_app/models/expense/requestfilte.dart';
import 'package:root_app/models/expense/travel_model.dart';
import 'package:root_app/services/expense/expense_repository.dart';
import 'package:root_app/utilities/get_months.dart';
import 'dart:math' as math;

class ExpenseController extends GetxController {
  late Rx<ExpenseScreen> pageScreen;
  late RxInt month;
  late RxInt year;
  late Rx<AutovalidateMode> autoValidate;
  final selectedDate = DateTime.now().obs;
  late List<String> errors;
  late RxBool isLoading;
  final travelTransport = ''.obs;
  var expenseList = <ExpenseRequestModel>[].obs;

  // Controllers
  final advanceAmountController = TextEditingController();
  final purposeController = TextEditingController();
  final locationController = TextEditingController();
  final transportationCostsController = TextEditingController();
  final accommodationCostsController = TextEditingController();
  final subsistenceCostsController = TextEditingController();
  final otherCostsController = TextEditingController();
  final descriptionController = TextEditingController();
  final companyNameController = TextEditingController();
  
  final expenseService = getIt<ExpenseRepository>();

  // Date range
  var fromDate = Rx<DateTime?>(null);
  var toDate = Rx<DateTime?>(null);
  
  // Selected values
  var selectedTransportation = ''.obs;
  var refNo = ''.obs;

  String get selectedTransactionType => transactionType.value;
  
  // Reactive variables for transaction form
  var transactionType = ''.obs;
  var spendMode = ''.obs;
  var status = ''.obs;
  final transactionDate = Rx<DateTime?>(null);
  var emailFlag = ''.obs;
  var requestId = 0.obs;
  var showingModal = false.obs;
  final transactionDateRange = Rxn<DateTimeRange>();
  
  // Reactive variables for specific forms
  var conveyanceTransportations = <Map<String, String>>[].obs;
  var entertainmentItems = <Map<String, String>>[].obs;
  var expatItems = <Map<String, String>>[].obs;
  var uploadFileName = 'Choose File (Only Pdf, Jpg, Png File)'.obs;

  // New properties
  var advanceAmount = ''.obs;
  var purpose = ''.obs;
  var referenceNo = ''.obs;
  var showAdvanceFields = false.obs;
  var showTransactionType = true.obs;

  // Form key for validation
  final expenseFormKey = GlobalKey<FormState>();

  // Form fields
  var employeeId = 0.obs;
  var location = ''.obs;
  var transportation = ''.obs;
  var transportationCosts = ''.obs;
  var accommodationCosts = ''.obs;
  var subsistenceCosts = ''.obs;
  var otherCosts = ''.obs;
  var description = ''.obs;

  // Lists for dropdowns
  final List<String> transactionTypes = [
    'Advance',
    'Conveyance',
    'Expenses',
    'Travel',
    'Entertainment',
    'Purchase',
    'Expat',
    'Training'
  ];
  final List<String> spendModes = ['Advance', 'Bill Settlement'];
  final List<String> transportationModes = ['Car', 'Bus', 'Train', 'Flight'];
  final List<String> travelTransports = ['Flight', 'Train', 'Car', 'Bus'];
  final List<String> billTypes = ['Utility', 'Rent', 'Service'];
  final List<String> institutions = ['Institute A', 'Institute B', 'Institute C'];
  final List<String> courses = ['Course A', 'Course B', 'Course C'];
  final List<String> statuses = ['Pending', 'Approved', 'Rejected', 'Returned'];
// Text Editing Controllers
final refNoController = TextEditingController();
final expenseDateController = TextEditingController();


// Expenses specific properties
var expensesItems = <Map<String, String>>[
  {'expenseType': '', 'particulars': '', 'amount': ''}
].obs;

var expensesTotalAmount = 0.0.obs;
var uploadedFileName = ''.obs;
var uploadedFile = Rx<PlatformFile?>(null);

// Dropdown data
List<String> expenseTypes = [
  'Travel',
  'Food',
  'Accommodation',
  'Transportation',
  'Entertainment',
  'Office Supplies',
  'Utilities',
  'Other'
];

  // Mock data list
  var list = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    
    pageScreen = ExpenseScreen.Main.obs;
    month = 0.obs;
    year = 0.obs;
    isLoading = false.obs;
    errors = <String>[].obs;
    autoValidate = AutovalidateMode.disabled.obs;
    
    // Add listeners to sync controllers with reactive variables
    purposeController.addListener(() {
      purpose.value = purposeController.text;
    });
    
    advanceAmountController.addListener(() {
      advanceAmount.value = advanceAmountController.text;
    });
    
    locationController.addListener(() {
      location.value = locationController.text;
    });
    
    transportationCostsController.addListener(() {
      transportationCosts.value = transportationCostsController.text;
    });
    
    accommodationCostsController.addListener(() {
      accommodationCosts.value = accommodationCostsController.text;
    });
    
    subsistenceCostsController.addListener(() {
      subsistenceCosts.value = subsistenceCostsController.text;
    });
    
    otherCostsController.addListener(() {
      otherCosts.value = otherCostsController.text;
    });
    
    descriptionController.addListener(() {
      description.value = descriptionController.text;
    });
// Replace the existing listener with this:
expenseDateController.addListener(() {
  if (expenseDateController.text.isEmpty) {
    transactionDate.value = null;
    try { refNoController.text = ''; } catch (_) {}
    referenceNo.value = '';
    refNo.value = '';
    return;
  }

  try {
    // Manual parse yyyy-MM-dd
    final parts = expenseDateController.text.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    
    final date = DateTime(year, month, day);
    transactionDate.value = date;
    
    final type = transactionType.value.isNotEmpty ? transactionType.value : 'Expenses';
    final ref = generateRefNo(date, type);
    
    try { refNoController.text = ref; } catch (_) {}
    referenceNo.value = ref;
    refNo.value = ref;
  } catch (e) {
    debugPrint('Error: $e');
  }
});
    fetchExpenseAmount(getCurrentUser().employeeId ?? 0);
    initializeFormArrays();
    fetchRequestData();
    fetchInitialRequestData();
    fetchExpenseTypes(); // Fetch dynamic expense types
  }

  @override
  void onClose() {
    // Dispose all controllers safely
    try {
      advanceAmountController.dispose();
      purposeController.dispose();
      locationController.dispose();
      transportationCostsController.dispose();
      accommodationCostsController.dispose();
      subsistenceCostsController.dispose();
      otherCostsController.dispose();
      descriptionController.dispose();
      companyNameController.dispose();
       refNoController.dispose();
       expenseDateController.dispose();
      
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }
    
    super.onClose();
  }

  void initializeFormArrays() {
    conveyanceTransportations.add({'place': '', 'type': '', 'cost': ''});
    entertainmentItems.add({'item': '', 'quantity': '', 'price': '', 'amount': ''});
    expatItems.add({'companyName': '', 'particular': '', 'billType': '', 'cost': ''});
  }

  void restoreDefultValues() {
    isLoading = false.obs;
    autoValidate.value = AutovalidateMode.disabled;
    errors.clear();
    transactionDate.value = null;
    spendMode.value = '';
    transactionType.value = '';
    emailFlag.value = '';
    requestId.value = 0;
   expenseDateController.clear();
    
    // Clear advance fields
    advanceAmount.value = '';
    purpose.value = '';
    referenceNo.value = '';
    refNo.value = '';
    showAdvanceFields.value = false;
    showTransactionType.value = true;
    
    // Clear ALL text controllers
    advanceAmountController.clear();
    purposeController.clear();
    locationController.clear();
    transportationCostsController.clear();
    accommodationCostsController.clear();
    subsistenceCostsController.clear();
    otherCostsController.clear();
    descriptionController.clear();
    companyNameController.clear();
    
    // Clear conveyance fields
    conveyanceTransportations.clear();
    entertainmentItems.clear();
    expatItems.clear();
    initializeFormArrays();
    
    // Clear travel fields
    location.value = '';
    transportation.value = '';
    transportationCosts.value = '';
    accommodationCosts.value = '';
    subsistenceCosts.value = '';
    otherCosts.value = '';
    description.value = '';
    travelTransport.value = '';
    fromDate.value = null;
    toDate.value = null;
    transactionDateRange.value = null;
    
    uploadFileName.value = 'Choose File (Only Pdf, Jpg, Png File)';
    
    // Reset form key
    expenseFormKey.currentState?.reset();
  }

  void updateAdvanceFieldsVisibility(String? spendMode) {
    showAdvanceFields.value = spendMode == 'Advance';
    showTransactionType.value = spendMode != 'Advance';
    
    // Clear ALL fields when switching modes
    transactionType.value = '';
    advanceAmount.value = '';
    purpose.value = '';
    advanceAmountController.clear();
    purposeController.clear();
    
    if (spendMode == 'Advance') {
      // Generate fresh reference number for Advance
      final date = transactionDate.value ?? DateTime.now();
      final ref = generateRefNo(date, 'Advance');
      referenceNo.value = ref;
      refNo.value = ref;
      
      conveyanceTransportations.clear();
      entertainmentItems.clear();
      expatItems.clear();
      initializeFormArrays();
    } else {
      // Clear reference for non-Advance
      referenceNo.value = '';
      refNo.value = '';
    }
  }
// ========== FIX 3: Update initializeExpenseForm ==========
void initializeExpenseForm() {
  final today = DateTime.now();
  
  // Format as yyyy-MM-dd
  final formattedDate = '${today.year.toString().padLeft(4, '0')}-'
      '${today.month.toString().padLeft(2, '0')}-'
      '${today.day.toString().padLeft(2, '0')}';
  
  expenseDateController.text = formattedDate;
  transactionDate.value = today;
  
  final ref = generateRefNo(today, 'Expenses');
  refNoController.text = ref;
  referenceNo.value = ref;
  refNo.value = ref;
  
  debugPrint('Initialized: Date=$formattedDate, Ref=$ref');
  
  if (expensesItems.isEmpty) {
    addExpenseItem();
  }
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

  void onMonthChanged(int value) {
    month.value = value;
    if (value != 0) {
      removeError(error: kMonthNotSelectedError);
      debugPrint('=======>>>>>> Selected Month : ${months[value - 1]} <<<<<<======');
    } else {
      addError(error: kMonthNotSelectedError);
      debugPrint('=======>>>>>> Selected Month : ${value.toString()} <<<<<<======');
    }
  }

  String? validateSelectedMonth(int value) {
    if (value == 0) {
      addError(error: kMonthNotSelectedError);
      return "";
    }
    return null;
  }

  void setTransactionDateRange(DateTimeRange? range) {
    transactionDateRange.value = range;
  }

  void onYearChanged(int value) {
    year.value = value;
    if (value != 0) {
      removeError(error: kYearNotSelectedError);
    } else {
      addError(error: kYearNotSelectedError);
    }
    debugPrint('=======>>>>>> Selected Year : ${value.toString()} <<<<<<======');
  }

  void openRequestDeleteModal(Map<String, dynamic> item) {
    Get.defaultDialog(
      title: "Delete Request",
      middleText: "Are you sure you want to delete this request?",
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      onConfirm: () {
        deleteRequest(item);
        Get.back();
      },
    );
  }

  void deleteRequest(Map<String, dynamic> item) {
    list.remove(item);
    Get.snackbar(
      'Deleted',
      'Request deleted successfully',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  String? validateSelectedYear(int value) {
    if (value == 0) {
      addError(error: kYearNotSelectedError);
      return "";
    }
    return null;
  }

  String? validateSpendMode(String? value) {
    if (value == null || value.isEmpty) {
      addError(error: kSpendModeNotSelectedError);
      return 'Spend Mode is required';
    }
    removeError(error: kSpendModeNotSelectedError);
    return null;
  }

  String? validateTransactionType(String? value) {
    if (value == null || value.isEmpty) {
      addError(error: kTransactionTypeNotSelectedError);
      return 'Transaction Type is required';
    }
    removeError(error: kTransactionTypeNotSelectedError);
    return null;
  }

// Update onTransactionTypeChanged to initialize expense form when Expenses is selected
void onTransactionTypeChanged(String? value) async {
  restoreDefultValues();
  transactionType.value = value ?? '';

  initializeFormArrays();

  if (value == null || value.isEmpty) {
    addError(error: kTransactionTypeNotSelectedError);
    return;
  }

  removeError(error: kTransactionTypeNotSelectedError);

  final user = getCurrentUser();
  final authorityId = user.employeeId ?? 0;

  try {
    if (transactionType.value == 'Advance') {
      await fetchRequestData();
    } else if (transactionType.value == 'Expenses') {
      // Initialize expense form when Expenses is selected
      initializeExpenseForm();
    }
    await fetchRequestData();
  } catch (e) {
    Get.snackbar('Error', e.toString(),
        backgroundColor: Colors.red.shade700, colorText: Colors.white);
  }
}
  void onDateChanged(DateTime? date) {
    transactionDate.value = date;
    if (date == null) {
      addError(error: 'Transaction date is required');
    } else {
      removeError(error: 'Transaction date is required');
    }
  }

  void addConveyanceTransportation() {
    conveyanceTransportations.add({'place': '', 'type': '', 'cost': ''});
  }

  void removeConveyanceTransportation(int index) {
    if (conveyanceTransportations.length > 1) {
      conveyanceTransportations.removeAt(index);
    }
  }

  void addEntertainmentItem() {
    entertainmentItems.add({'item': '', 'quantity': '', 'price': '', 'amount': ''});
  }

  void removeEntertainmentItem(int index) {
    if (entertainmentItems.length > 1) {
      entertainmentItems.removeAt(index);
    }
  }

  void calculateEntertainmentAmount(int index) {
    var item = entertainmentItems[index];
    double quantity = double.tryParse(item['quantity'] ?? '0') ?? 0;
    double price = double.tryParse(item['price'] ?? '0') ?? 0;
    item['amount'] = (quantity * price).toString();
    entertainmentItems.refresh();
  }

  void addExpatItem() {
    expatItems.add({'companyName': '', 'particular': '', 'billType': '', 'cost': ''});
  }

  void removeExpatItem(int index) {
    if (expatItems.length > 1) {
      expatItems.removeAt(index);
    }
  }

  double calculateTotalAmount(List<Map<String, String>> items, String key) {
    double total = 0;
    for (var item in items) {
      total += double.tryParse(item[key] ?? '0') ?? 0;
    }
    return total;
  }

  void pickFile() {
    uploadFileName.value = 'SelectedFile.pdf';
  }

  String generateRefNo(DateTime date, String type) {
    final mapPrefix = {
      'Conveyance': 'CONV',
      'Travel': 'TRV',
      'Advance': 'ADV',
      
    };

    final prefix = (mapPrefix[type] ?? type.toUpperCase().replaceAll(RegExp(r'\s+'), '').substring(0, math.min(4, type.length))).toString();

    String empId = '00';
    try {
      final user = getCurrentUser();
      if ((user.employeeId != null && user.employeeId != 0)) {
        empId = user.employeeId.toString();
      }
    } catch (_) {}

    final dateStr = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final pattern = RegExp('^$prefix-$empId-$dateStr-(\\d+)\$');
    int maxSeq = 0;
    for (var item in expenseList) {
      String ref = '';
      try {
        final dyn = item as dynamic;
        ref = dyn.referenceNumber ?? dyn.referenceNo ?? dyn.refNo ?? '';
      } catch (_) {
        ref = item.toString();
      }
      final m = pattern.firstMatch(ref);
      if (m != null) {
        final seq = int.tryParse(m.group(1) ?? '0') ?? 0;
        if (seq > maxSeq) maxSeq = seq;
      }
    }

    final nextSeq = (maxSeq + 1).toString().padLeft(2, '0');
    return '$prefix-$empId-$dateStr-$nextSeq';
  }

  UserInfo getCurrentUser() {
    final getStorage = GetStorage();
    final userJsonString = getStorage.read(USER_SIGN_IN_KEY);
    var user = UserInfo.fromJson(json.decode(userJsonString));
    return user;
  }

  void showModal(int id, String type, String mode, String action) {
    // First restore defaults to clear everything
    restoreDefultValues();
    
    // Then set the new values
    requestId.value = id;
    transactionType.value = type;
    spendMode.value = mode;
    emailFlag.value = action;
    showingModal.value = true;
    
   // If opening for Advance, generate reference number
  if (mode == 'Advance') {
    final date = transactionDate.value ?? DateTime.now();
    final ref = generateRefNo(date, 'Advance');
    referenceNo.value = ref;
    refNo.value = ref;
    showAdvanceFields.value = true;
    showTransactionType.value = false;
  } else if (type == 'Expenses') {
    // Initialize expense form when opening Expenses modal
    initializeExpenseForm();
  }
  }

  void closeModal() {
    showingModal.value = false;
    restoreDefultValues();
  }

  void onStatusChanged(String? value) {
    status.value = value ?? '';
    errors.clear();
  }

  // Submit Advance with safe navigation
  // Future<bool> submitAdvanceamount() async {
  //   errors.clear();

  //   if (!expenseFormKey.currentState!.validate()) {
  //     autoValidate.value = AutovalidateMode.always;
  //     return false;
  //   }

  //   isLoading.value = true;

  //   try {
  //     final user = getCurrentUser();
  //     final model = AdvanceDTO(
  //       employeeId: user.employeeId ?? 0,
  //       requestId: requestId.value,
  //       spendMode: spendMode.value,
  //       transactionType: 'Advance',
  //       transactionDate: transactionDate.value!.toIso8601String(),
  //       advanceAmount: double.tryParse(advanceAmountController.text) ?? 0.0,
  //       purpose: purposeController.text,
  //       referenceNumber: referenceNo.value,
  //       flag: 'Request',
  //       requestDate: DateTime.now().toIso8601String(),
  //     );

  //     final response = await expenseService.saveAdvance(model);

  //     if (!response.error) {
  //       // Clear form first
  //       clearAdvanceForm();
        
  //       // Refresh the list
  //       await fetchRequestData();
        
  //       // Show success message safely
  //       Future.microtask(() {
  //         if (Get.isRegistered<ExpenseController>()) {
  //           Get.snackbar(
  //             'Success',
  //             'Advance request submitted successfully',
  //             backgroundColor: Colors.green,
  //             colorText: Colors.white,
  //             duration: const Duration(seconds: 3),
  //           );
            
  //           // Close modal safely
  //           if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
  //             Get.back(result: 'Success');
  //           }
  //         }
  //       });
        
  //       return true;
  //     } else {
  //       final msg = response.errorMessage ?? '';

  //       // Show error message safely
  //       Future.microtask(() {
  //         if (Get.isRegistered<ExpenseController>()) {
  //           if (msg.toLowerCase().contains('already exists')) {
  //             Get.snackbar(
  //               'Duplicate Request',
  //               'An advance request already exists for ${transactionDate.value?.toString().split(' ')[0]}. Please select a different date or edit the existing request.',
  //               backgroundColor: Colors.orange.shade700,
  //               colorText: Colors.white,
  //               duration: const Duration(seconds: 5),
  //               snackPosition: SnackPosition.TOP,
  //               margin: const EdgeInsets.all(16),
  //             );
              
  //             addError(error: 'Advance already exists for this date');
  //           } else {
  //             Get.snackbar(
  //               'Error',
  //               msg.isNotEmpty ? msg : 'Failed to submit advance request',
  //               backgroundColor: Colors.redAccent,
  //               colorText: Colors.white,
  //               duration: const Duration(seconds: 4),
  //               snackPosition: SnackPosition.TOP,
  //             );
  //           }
  //         }
  //       });
        
  //       return false;
  //     }
  //   } catch (e) {
  //     Future.microtask(() {
  //       if (Get.isRegistered<ExpenseController>()) {
  //         Get.snackbar(
  //           'Error',
  //           'An unexpected error occurred: ${e.toString()}',
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white,
  //           duration: const Duration(seconds: 4),
  //         );
  //       }
  //     });
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
// Future<bool> submitAdvanceamount() async {
//   errors.clear();

//   if (!expenseFormKey.currentState!.validate()) {
//     autoValidate.value = AutovalidateMode.always;
//     return false;
//   }

//   if (transactionDate.value == null) {
//     Get.snackbar(
//       'Error',
//       'Transaction date is required.',
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 4),
//       snackPosition: SnackPosition.TOP,
//     );
//     return false;
//   }

//   isLoading.value = true;

//   try {
//     final user = getCurrentUser();
//     final model = AdvanceDTO(
//       employeeId: user.employeeId ?? 0,
//       requestId: requestId.value,
//       spendMode: spendMode.value,
//       transactionType: 'Advance',
//       transactionDate: transactionDate.value!.toIso8601String(),
//       advanceAmount: double.tryParse(advanceAmountController.text) ?? 0.0,
//       purpose: purposeController.text,
//       referenceNumber: referenceNo.value,
//       flag: 'Request',
//       requestDate: DateTime.now().toIso8601String(),
//     );

//     debugPrint('Submitting Advance payload: ${model.toJson()}');
//     final response = await expenseService.saveAdvance(model);
//     debugPrint('SaveAdvance Response: error=${response.error}, errorMessage=${response.errorMessage}');

//     if (!response.error) {
//       clearAdvanceForm();
//       await fetchRequestData();
//       Get.snackbar(
//         'Success',
//         'Advance request submitted successfully',
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//         snackPosition: SnackPosition.TOP,
//       );
//       if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
//         Get.back(result: 'Success');
//       }
//       return true;
//     } else {
//       final msg = response.errorMessage ?? '';
//       if (msg.toLowerCase().contains('already exists') ||
//           msg.toLowerCase().contains('duplicate') ||
//           msg.toLowerCase().contains('exists')) {
//         Get.snackbar(
//           'Duplicate Request',
//           'An advance request already exists for ${transactionDate.value?.toString().split(' ')[0]}. Please select a different date or edit the existing request.',
//           backgroundColor: Colors.orange.shade700,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 5),
//           snackPosition: SnackPosition.TOP,
//           margin: const EdgeInsets.all(16),
//         );
//         addError(error: 'Advance already exists for this date');
//       } else {
//         Get.snackbar(
//           'Error',
//           msg.isNotEmpty ? msg : 'Failed to submit advance request',
//           backgroundColor: Colors.redAccent,
//           colorText: Colors.white,
//           duration: const Duration(seconds: 4),
//           snackPosition: SnackPosition.TOP,
//         );
//       }
//       return false;
//     }
//   } catch (e) {
//     Get.snackbar(
//       'Error',
//       'An unexpected error occurred: ${e.toString()}',
//       backgroundColor: Colors.redAccent,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 4),
//       snackPosition: SnackPosition.TOP,
//     );
//     return false;
//   } finally {
//     isLoading.value = false;
//   }
// }
Future<bool> submitAdvanceamount() async {
  errors.clear();

  if (!expenseFormKey.currentState!.validate()) {
    autoValidate.value = AutovalidateMode.always;
    return false;
  }

  if (transactionDate.value == null) {
    Get.snackbar(
      'Error',
      'Transaction date is required.',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  isLoading.value = true;

  try {
    final user = getCurrentUser();
    final model = AdvanceDTO(
      employeeId: user.employeeId ?? 0,
      requestId: requestId.value,
      spendMode: spendMode.value,
      transactionType: 'Advance',
      transactionDate: transactionDate.value!.toIso8601String(),
      advanceAmount: double.tryParse(advanceAmountController.text) ?? 0.0,
      purpose: purposeController.text,
      referenceNumber: referenceNo.value,
      flag: 'Request',
      requestDate: DateTime.now().toIso8601String(),
    );

    debugPrint('Submitting Advance: ${model.toJson()}');
    final response = await expenseService.saveAdvance(model);
    debugPrint('Response error: ${response.error}, errorMessage: ${response.errorMessage}');
    
    if (!response.error) {
      clearAdvanceForm();
      await fetchRequestData();

      Get.snackbar(
        'Success',
        'Advance request submitted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
        Get.back(result: 'Success');
      }

      return true;
    } else {
      // Extract the exact backend error message
      final backendMsg = response.errorMessage?.trim() ?? 'Failed to submit advance request';

      debugPrint('Backend Error Message: $backendMsg');

      // Check if it's a duplicate error
      if (backendMsg.toLowerCase().contains('already exists') ||
          backendMsg.toLowerCase().contains('duplicate')) {
        
        Get.snackbar(
          'Duplicate Request',
          backendMsg, // Show exact backend message
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
       
        addError(error: backendMsg);
      } else {
        Get.snackbar(
          'Error',
          backendMsg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
        );
      }

      return false;
    }
  } catch (e) {
    debugPrint('Exception in submitAdvanceamount: $e');
    Get.snackbar(
      'Error',
      'An unexpected error occurred: $e',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
    return false;
  } finally {
    isLoading.value = false;
  }
}

  void clearAdvanceForm() {
    requestId.value = 0;
    spendMode.value = '';
    transactionType.value = '';
    transactionDate.value = null;
    advanceAmount.value = '';
    purpose.value = '';
    referenceNo.value = '';
    refNo.value = '';
    
    // Clear text controllers
    advanceAmountController.clear();
    purposeController.clear();
    
    // Reset validation state
    autoValidate.value = AutovalidateMode.disabled;
    errors.clear();
    
    // Reset form widget state
    expenseFormKey.currentState?.reset();
    
    // Reset visibility flags
    showAdvanceFields.value = false;
    showTransactionType.value = true;
  }

  Future<void> fetchExpenseAmount(int authorityId) async {
    try {
      isLoading.value = true;
      final response = await expenseService.getExpenseAmount(authorityId);

      if (response.error == true) {
        Get.snackbar('Error', response.errorMessage ?? 'Failed to load data',
            backgroundColor: Colors.red.shade700, colorText: Colors.white);
      } else {
        advanceAmountController.text = (response.advanceAmount ?? 0).toString();
        purposeController.text = response.purpose ?? '';
        advanceAmount.value = (response.advanceAmount ?? 0).toString();
        purpose.value = response.purpose ?? '';
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red.shade700, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRequestData() async {
    try {
      isLoading.value = true;
      final user = getCurrentUser();

      final filter = RequestFilter(
        employeeId: user.employeeId ?? 0,
        transactionType: transactionType.value,
        spendMode: spendMode.value,
      );

      final data = await expenseService.getRequestData(filter);

      if (data.isNotEmpty) {
        list.assignAll(data.map((expense) => expense.toJson()).toList());
        expenseList.assignAll(data);
      } else {
        list.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchInitialRequestData() async {
    try {
      isLoading.value = true;
      final user = getCurrentUser();

      final data = await expenseService.getRequestData(
        RequestFilter(employeeId: user.employeeId ?? 0),
      );

      if (data.isNotEmpty) {
        list.assignAll(data.map((e) => e.toJson()).toList());
        expenseList.assignAll(data);
      } else {
        list.clear();
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Submit Travel with safe navigation
  Future<bool> submitTravel() async {
    errors.clear();

    if (!expenseFormKey.currentState!.validate()) {
      autoValidate.value = AutovalidateMode.always;
      return false;
    }

    isLoading.value = true;

    try {
      final user = getCurrentUser();

      if (referenceNo.value.isEmpty) {
        final DateTime txDate = transactionDate.value ?? DateTime.now();
        final String genRef = generateRefNo(txDate, 'Travel');
        referenceNo.value = genRef;
        refNo.value = genRef;
      }

      final model = TravelDTO(
        requestId: requestId.value,
        employeeId: user.employeeId ?? 0,
        transactionType: transactionType.value,
        transactionDate: transactionDate.value,
        referenceNumber: referenceNo.value,
        spendMode: spendMode.value,
        location: location.value,
        purpose: purpose.value,
        transportation: travelTransport.value,
        transportationCosts: double.tryParse(transportationCosts.value) ?? 0.0,
        accommodationCosts: double.tryParse(accommodationCosts.value) ?? 0.0,
        subsistenceCosts: double.tryParse(subsistenceCosts.value) ?? 0.0,
        otherCosts: double.tryParse(otherCosts.value) ?? 0.0,
        description: description.value,
        flag: 'Request',
        isApproved: false,
      );

      debugPrint('Submitting Travel payload: ${model.toJson()}');
      final response = await expenseService.saveTravel(model);
      debugPrint('Response Data : ${response.data}');

      if (response.error == false) {
        clearTravelForm();
        await fetchRequestData();
        
        Future.microtask(() {
          if (Get.isRegistered<ExpenseController>()) {
            Get.snackbar(
              'Success',
              'Travel request submitted successfully',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            
            if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
              Get.back(result: 'Success');
            }
          }
        });
        
        return true;
      } else {
        Future.microtask(() {
          if (Get.isRegistered<ExpenseController>()) {
            Get.snackbar(
              'Error',
              response.errorMessage ?? 'Something went wrong',
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          }
        });
        return false;
      }
    } catch (e) {
      Future.microtask(() {
        if (Get.isRegistered<ExpenseController>()) {
          Get.snackbar(
            'Error',
            e.toString(),
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      });
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearTravelForm() {
    requestId.value = 0;
    transactionType.value = '';
    transactionDate.value = null;
    referenceNo.value = '';
    refNo.value = '';
    spendMode.value = '';
    location.value = '';
    travelTransport.value = '';
    transportationCosts.value = '';
    accommodationCosts.value = '';
    subsistenceCosts.value = '';
    otherCosts.value = '';
    description.value = '';
    
    // Clear controllers
    locationController.clear();
    purposeController.clear();
    transportationCostsController.clear();
    accommodationCostsController.clear();
    subsistenceCostsController.clear();
    otherCostsController.clear();
    descriptionController.clear();
    
    // Reset validation
    autoValidate.value = AutovalidateMode.disabled;
    errors.clear();
    expenseFormKey.currentState?.reset();
  }

  // Save Conveyance with safe navigation
  // Future<bool> saveConveyance() async {
  //   errors.clear();

  //   if (!expenseFormKey.currentState!.validate()) {
  //     autoValidate.value = AutovalidateMode.always;
  //     return false;
  //   }

  //   final user = getCurrentUser();
  //   if (user == null || user.employeeId == null || user.employeeId == 0) {
  //     Future.microtask(() {
  //       if (Get.isRegistered<ExpenseController>()) {
  //         Get.snackbar(
  //           "Error",
  //           "Employee ID is missing.",
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white,
  //         );
  //       }
  //     });
  //     return false;
  //   }

  //   if (spendMode.value != 'Advance' && conveyanceTransportations.isEmpty) {
  //     Future.microtask(() {
  //       if (Get.isRegistered<ExpenseController>()) {
  //         Get.snackbar(
  //           "Error",
  //           "At least one transportation entry is required.",
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white,
  //         );
  //       }
  //     });
  //     return false;
  //   }

  //   if (companyNameController.text.isEmpty || 
  //       purposeController.text.isEmpty || 
  //       transactionDate.value == null || 
  //       referenceNo.value.isEmpty) {
  //     Future.microtask(() {
  //       if (Get.isRegistered<ExpenseController>()) {
  //         Get.snackbar(
  //           "Error",
  //           "Please fill all required fields.",
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white,
  //         );
  //       }
  //     });
  //     return false;
  //   }

  //   try {
  //     isLoading.value = true;

  //     List<ConveyanceDTO> list = [];
  //     final String transactionDateStr = transactionDate.value!.toIso8601String().split('T')[0];
  //     final String requestDateStr = DateTime.now().toIso8601String().split('T')[0];

  //     if (spendMode.value == 'Advance') {
  //       list.add(
  //         ConveyanceDTO(
  //           requestId: requestId.value ?? 0,
  //           transactionType: "Conveyance",
  //           transactionDate: transactionDateStr,
  //           employeeId: user.employeeId!,
  //           referenceNumber: referenceNo.value,
  //           requestDate: requestDateStr,
  //           companyName: companyNameController.text,
  //           spendMode: "Advance",
  //           purpose: purposeController.text,
  //           description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
  //           advanceAmount: double.tryParse(advanceAmountController.text) ?? 0.0,
  //           destination: locationController.text.isNotEmpty ? locationController.text : null,
  //           mode: null,
  //           cost: 0.0,
  //           isApproved: false,
  //           flag: "Request",
  //         ),
  //       );
  //     } else {
  //       for (var item in conveyanceTransportations) {
  //         if (item['place']?.isEmpty == true ||
  //             item['type']?.isEmpty == true ||
  //             item['cost']?.isEmpty == true) {
  //           isLoading.value = false;
  //           Future.microtask(() {
  //             if (Get.isRegistered<ExpenseController>()) {
  //               Get.snackbar(
  //                 "Error",
  //                 "All transportation fields are required.",
  //                 backgroundColor: Colors.redAccent,
  //                 colorText: Colors.white,
  //               );
  //             }
  //           });
  //           return false;
  //         }

  //         list.add(
  //           ConveyanceDTO(
  //             requestId: 0,
  //             transactionType: "Conveyance",
  //             transactionDate: transactionDateStr,
  //             employeeId: user.employeeId!,
  //             referenceNumber: referenceNo.value,
  //             requestDate: requestDateStr,
  //             companyName: companyNameController.text,
  //             spendMode: "Bill Settlement",
  //             purpose: purposeController.text,
  //             description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
  //             destination: item['place']!,
  //             mode: item['type']!,
  //             cost: double.tryParse(item['cost']!) ?? 0.0,
  //             advanceAmount: 0.0,
  //             isApproved: false,
  //             flag: "Request",
  //           ),
  //         );
  //       }
  //     }

  //     debugPrint('Conveyance Payload: ${jsonEncode(list.map((c) => c.toJson()).toList())}');
  //     final response = await expenseService.saveConveyance(list);

  //     if (response.error == false) {
  //       // Clear form first
  //       clearConveyanceForm();
        
  //       // Refresh list
  //       await fetchRequestData();
        
  //       // Show success and navigate safely
  //       Future.microtask(() {
  //         if (Get.isRegistered<ExpenseController>()) {
  //           Get.snackbar(
  //             "Success",
  //             response.message ?? "Conveyance saved successfully",
  //             backgroundColor: Colors.green,
  //             colorText: Colors.white,
  //           );
            
  //           if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
  //             Get.back(result: 'Success');
  //           }
  //         }
  //       });
        
  //       return true;
  //     } else {
  //       final msg = response.errorMessage ?? '';
        
  //       Future.microtask(() {
  //         if (Get.isRegistered<ExpenseController>()) {
  //           if (msg.toLowerCase().contains('already exists')) {
  //             Get.snackbar(
  //               "Duplicate Request",
  //               "A conveyance request already exists for this date. Please select a different date.",
  //               backgroundColor: Colors.orange.shade700,
  //               colorText: Colors.white,
  //               duration: const Duration(seconds: 5),
  //               snackPosition: SnackPosition.TOP,
  //             );
  //           } else {
  //             Get.snackbar(
  //               "Error",
  //               msg.isNotEmpty ? msg : "Failed to save conveyance",
  //               backgroundColor: Colors.redAccent,
  //               colorText: Colors.white,
  //             );
  //           }
  //         }
  //       });
        
  //       return false;
  //     }
  //   } catch (e) {
  //     Future.microtask(() {
  //       if (Get.isRegistered<ExpenseController>()) {
  //         Get.snackbar(
  //           "Error",
  //           e.toString(),
  //           backgroundColor: Colors.redAccent,
  //           colorText: Colors.white,
  //         );
  //       }
  //     });
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
Future<bool> saveConveyance() async {
  errors.clear();

  if (!expenseFormKey.currentState!.validate()) {
    autoValidate.value = AutovalidateMode.always;
    return false;
  }

  final user = getCurrentUser();
  if (user.employeeId == null || user.employeeId == 0) {
    Get.snackbar(
      "Error",
      "Employee ID is missing.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  if (spendMode.value != 'Advance' && conveyanceTransportations.isEmpty) {
    Get.snackbar(
      "Error",
      "At least one transportation entry is required.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  if (companyNameController.text.isEmpty || 
      purposeController.text.isEmpty || 
      transactionDate.value == null || 
      referenceNo.value.isEmpty) {
    Get.snackbar(
      "Error",
      "Please fill all required fields.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  try {
    isLoading.value = true;

    List<ConveyanceDTO> list = [];
    final String transactionDateStr = transactionDate.value!.toIso8601String().split('T')[0];
    final String requestDateStr = DateTime.now().toIso8601String().split('T')[0];

    if (spendMode.value == 'Advance') {
      list.add(
        ConveyanceDTO(
          requestId: requestId.value ?? 0,
          transactionType: "Conveyance",
          transactionDate: transactionDateStr,
          employeeId: user.employeeId!,
          referenceNumber: referenceNo.value,
          requestDate: requestDateStr,
          companyName: companyNameController.text,
          spendMode: "Advance",
          purpose: purposeController.text,
          description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
          advanceAmount: double.tryParse(advanceAmountController.text) ?? 0.0,
          destination: locationController.text.isNotEmpty ? locationController.text : null,
          mode: null,
          cost: 0.0,
          isApproved: false,
          flag: "Request",
        ),
      );
    } else {
      for (var item in conveyanceTransportations) {
        if (item['place']?.isEmpty == true ||
            item['type']?.isEmpty == true ||
            item['cost']?.isEmpty == true) {
          isLoading.value = false;
          Get.snackbar(
            "Error",
            "All transportation fields are required.",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return false;
        }

        list.add(
          ConveyanceDTO(
            requestId: 0,
            transactionType: "Conveyance",
            transactionDate: transactionDateStr,
            employeeId: user.employeeId!,
            referenceNumber: referenceNo.value,
            requestDate: requestDateStr,
            companyName: companyNameController.text,
            spendMode: "Bill Settlement",
            purpose: purposeController.text,
            description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
            destination: item['place']!,
            mode: item['type']!,
            cost: double.tryParse(item['cost']!) ?? 0.0,
            advanceAmount: 0.0,
            isApproved: false,
            flag: "Request",
          ),
        );
      }
    }

    debugPrint('Conveyance Payload: ${jsonEncode(list.map((c) => c.toJson()).toList())}');
    final response = await expenseService.saveConveyance(list);
    debugPrint('Response error: ${response.error}, errorMessage: ${response.errorMessage}');

    if (!response.error) {
      clearConveyanceForm();
      await fetchRequestData();
      
      Get.snackbar(
        "Success",
        response.message ?? "Conveyance saved successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );
      
      if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
        Get.back(result: 'Success');
      }
      
      return true;
    } else {
      // Extract the exact backend error message
      final backendMsg = response.errorMessage?.trim() ?? 'Failed to save conveyance';

      debugPrint('Backend Error Message: $backendMsg');

      // Check if it's a duplicate error
      if (backendMsg.toLowerCase().contains('already exists') ||
          backendMsg.toLowerCase().contains('duplicate')) {
        
        Get.snackbar(
          "Duplicate Request",
          backendMsg, // Show exact backend message
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
        
        addError(error: backendMsg);
      } else {
        Get.snackbar(
          "Error",
          backendMsg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
        );
      }
      
      return false;
    }
  } catch (e) {
    debugPrint('Exception in saveConveyance: $e');
    Get.snackbar(
      "Error",
      'An unexpected error occurred: $e',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
    return false;
  } finally {
    isLoading.value = false;
  }
}
  void clearConveyanceForm() {
    referenceNo.value = '';
    refNo.value = '';
    requestId.value = 0;
    transactionType.value = '';
    transactionDate.value = null;
    spendMode.value = '';
    advanceAmount.value = '';
    location.value = '';
    selectedTransportation.value = '';
    transportationCosts.value = '';
    
    // Clear controllers
    purposeController.clear();
    descriptionController.clear();
    companyNameController.clear();
    locationController.clear();
    advanceAmountController.clear();
    
    // Clear transportation items
    conveyanceTransportations.clear();
    initializeFormArrays();
    
    // Reset validation
    autoValidate.value = AutovalidateMode.disabled;
    errors.clear();
    expenseFormKey.currentState?.reset();
  }

// Methods for expenses
void addExpenseItem() {
  expensesItems.add({'expenseType': '', 'particulars': '', 'amount': ''});
}

void removeExpenseItem(int index) {
  if (expensesItems.length > 1) {
    expensesItems.removeAt(index);
    calculateExpensesTotalAmount();
  }
}

void calculateExpensesTotalAmount() {
  double total = 0.0;
  for (var item in expensesItems) {
    total += double.tryParse(item['amount'] ?? '0') ?? 0.0;
  }
  expensesTotalAmount.value = total;
}


// Add to ExpenseController (inside class ExpenseController)
// Note: Your existing methods (addExpenseItem, removeExpenseItem, calculateExpensesTotalAmount) are already included.

// Fetch expense types from backend
Future<void> fetchExpenseTypes() async {
  try {
    isLoading.value = true;
    final filter = AccountHeadDTO();
    final response = await expenseService.getExpensesType(filter);

    if (response.isNotEmpty) {
      expenseTypes = response.map((item) => item.headName ?? '').where((type) => type.isNotEmpty).toList();
    } else {
      Get.snackbar(
        "Error",
        "Failed to load expense types",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  } catch (e) {
    debugPrint('Exception in fetchExpenseTypes: $e');
    Get.snackbar(
      "Error",
      "Failed to load expense types: $e",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  } finally {
    isLoading.value = false;
  }
}

// ========== FIX 4: Update validateExpenses date parsing ==========
Future<bool> validateExpenses() async {
  errors.clear();

  if (!expenseFormKey.currentState!.validate()) {
    autoValidate.value = AutovalidateMode.always;
    return false;
  }

  final user = getCurrentUser();
  if (user.employeeId == null || user.employeeId == 0) {
    Get.snackbar(
      "Error",
      "Employee ID is missing.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  if (expensesItems.isEmpty) {
    Get.snackbar(
      "Error",
      "At least one expense item is required.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  try {
    isLoading.value = true;

    // ✅ FIX: Use direct DateTime.parse for yyyy-MM-dd format
    final String transactionDateStr = expenseDateController.text.trim();
    
    // Validate it's a proper date
    DateTime.parse(transactionDateStr); // This will throw if invalid
    
    final String requestDateStr = DateTime.now().toIso8601String().split('T')[0];

    List<ExpensesDTO> model = [
      ExpensesDTO(
        requestId: requestId.value,
        transactionType: "Expenses",
        transactionDate: transactionDateStr,
        employeeId: user.employeeId!,
        referenceNumber: refNoController.text,
        requestDate: requestDateStr,
        spendMode: spendMode.value,
        description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
        expensesData: jsonEncode(expensesItems.map((item) => {
              'ExpenseType': item['expenseType'],
              'Particulars': item['particulars'],
              'Amount': item['amount'],
            }).toList()),
        isApproved: false,
        flag: "Request",
        fileName: uploadedFileName.value.isNotEmpty ? uploadedFileName.value : null,
        actualFileName: uploadedFileName.value.isNotEmpty ? uploadedFileName.value : null,
        fileSize: uploadedFile.value != null ? (uploadedFile.value!.size / 1024).toStringAsFixed(2) : null,
        fileFormat: uploadedFile.value != null ? uploadedFile.value!.extension : null,
      )
    ];

    debugPrint('Validation Payload: ${jsonEncode(model.map((e) => e.toJson()).toList())}');
    final response = await expenseService.validateExpenses(model);
    debugPrint('Validation Response: error=${response.error}, msg=${response.errorMessage}');

    if (!response.error) {
      return true;
    } else {
      final backendMsg = response.errorMessage?.trim() ?? 'Failed to validate expenses';
      Get.snackbar(
        "Validation Error",
        backendMsg,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
      );
      addError(error: backendMsg);
      return false;
    }
  } catch (e) {
    debugPrint('Exception in validateExpenses: $e');
    Get.snackbar(
      "Error",
      "Invalid date format or error: $e",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  } finally {
    isLoading.value = false;
  }
}


// ========== FIX 5: Update saveExpenses date parsing ==========
Future<bool> saveExpenses() async {
  errors.clear();

  if (!expenseFormKey.currentState!.validate()) {
    autoValidate.value = AutovalidateMode.always;
    return false;
  }

  final user = getCurrentUser();
  if (user.employeeId == null || user.employeeId == 0) {
    Get.snackbar(
      "Error",
      "Employee ID is missing.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  if (expensesItems.isEmpty) {
    Get.snackbar(
      "Error",
      "At least one expense item is required.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  if (expenseDateController.text.isEmpty || refNoController.text.isEmpty) {
    Get.snackbar(
      "Error",
      "Please fill all required fields.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    return false;
  }

  for (var item in expensesItems) {
    if (item['expenseType']?.isEmpty == true || item['amount']?.isEmpty == true) {
      Get.snackbar(
        "Error",
        "Expense Type and Amount are required for all items.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return false;
    }
  }

  if (!(await validateExpenses())) {
    return false;
  }

  try {
    isLoading.value = true;

    // ✅ FIX: Use direct string, no parsing needed
    final String transactionDateStr = expenseDateController.text.trim();
    
    // Validate format
    DateTime.parse(transactionDateStr); // Throws if invalid
    
    final String requestDateStr = DateTime.now().toIso8601String().split('T')[0];

    if (refNoController.text.isEmpty) {
      final date = DateTime.parse(transactionDateStr);
      final genRef = generateRefNo(date, 'Expenses');
      refNoController.text = genRef;
      referenceNo.value = genRef;
      refNo.value = genRef;
    }

    List<ExpensesDTO> list = [
      ExpensesDTO(
        requestId: requestId.value,
        transactionType: "Expenses",
        transactionDate: transactionDateStr,
        employeeId: user.employeeId!,
        referenceNumber: refNoController.text,
        requestDate: requestDateStr,
        spendMode: spendMode.value,
        description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
        expensesData: jsonEncode(expensesItems.map((item) => {
              'ExpenseType': item['expenseType'],
              'Particulars': item['particulars'],
              'Amount': item['amount'],
            }).toList()),
        isApproved: false,
        flag: "Request",
        fileName: uploadedFileName.value.isNotEmpty ? uploadedFileName.value : null,
        actualFileName: uploadedFileName.value.isNotEmpty ? uploadedFileName.value : null,
        fileSize: uploadedFile.value != null ? (uploadedFile.value!.size / 1024).toStringAsFixed(2) : null,
        fileFormat: uploadedFile.value != null ? uploadedFile.value!.extension : null,
      )
    ];

    debugPrint('Expenses Payload: ${jsonEncode(list.map((e) => e.toJson()).toList())}');
    final response = await expenseService.saveExpenses(list, file: uploadedFile.value);
    debugPrint('Response: error=${response.error}, msg=${response.errorMessage}');

    if (!response.error) {
      clearExpensesForm();
      await fetchRequestData();

      Get.snackbar(
        "Success",
        response.errorMessage ?? "Expenses saved successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
      );

      if (Get.isDialogOpen == true || Get.isBottomSheetOpen == true) {
        Get.back(result: 'Success');
      }

      return true;
    } else {
      final backendMsg = response.errorMessage?.trim() ?? 'Failed to save expenses';

      if (backendMsg.toLowerCase().contains('already exists') ||
          backendMsg.toLowerCase().contains('duplicate')) {
        Get.snackbar(
          "Duplicate Request",
          backendMsg,
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
        );
        addError(error: backendMsg);
      } else {
        Get.snackbar(
          "Error",
          backendMsg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
        );
      }

      return false;
    }
  } catch (e) {
    debugPrint('Exception in saveExpenses: $e');
    Get.snackbar(
      "Error",
      'Error: $e',
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      snackPosition: SnackPosition.TOP,
    );
    return false;
  } finally {
    isLoading.value = false;
  }
}


// Clear expenses form
void clearExpensesForm() {
  referenceNo.value = '';
  refNo.value = '';
  requestId.value = 0;
  transactionType.value = '';
  spendMode.value = '';
  uploadedFileName.value = 'Choose File (Only Pdf, Jpg, Png File)';
  uploadedFile.value = null;

  // Clear controllers
  refNoController.clear();
  expenseDateController.clear();
  descriptionController.clear();

  // Clear expense items
  expensesItems.clear();
  addExpenseItem();
  calculateExpensesTotalAmount();

  // Reset validation
  autoValidate.value = AutovalidateMode.disabled;
  errors.clear();
  expenseFormKey.currentState?.reset();
}

// Override pickFile to handle actual file selection

}