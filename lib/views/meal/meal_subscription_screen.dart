import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/const_colors.dart';
import 'package:root_app/constants/const_image.dart';
import 'package:root_app/constants/const_size.dart';
import 'package:root_app/constants/token_const.dart';
import 'package:root_app/models/authentication/sign_in_response_model.dart';
import 'package:root_app/network/dio_client.dart';
import 'package:root_app/services/notification/notification_service.dart';

class MealSubscriptionScreen extends StatelessWidget {
  const MealSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      body: const Body(),
      bottomNavigationBar: const CustomBottomNavBar(
        activeIndex: -1,
        isActive: false,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomAppBar(),
            _buildHeader(),
            SizedBox(height: getProportionateScreenWidth(35)),
            const LunchRequestWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: getProportionateScreenWidth(90),
          color: kPrimaryColor,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: SizeConfig.screenWidth * 0.05,
          ),
          width: SizeConfig.screenWidth * 0.90,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: "Meal Subscription",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  size: kMediumTextSize,
                ),
                SizedBox(height: getProportionateScreenWidth(10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectabelSvgIconButton(
                      text: "Meal Subscription",
                      svgFile: "$kIconPath/meal_subscription.svg",
                      onTapFunction: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Guest Lunch Request Card Widget
class GuestLunchRequestCard extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final VoidCallback onClose;

  const GuestLunchRequestCard({
    Key? key,
    required this.onSubmit,
    required this.onClose,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GuestLunchRequestCardState createState() => _GuestLunchRequestCardState();
}

class _GuestLunchRequestCardState extends State<GuestLunchRequestCard> {
  final TextEditingController _guestNameController = TextEditingController();
  // final TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String? _selectedCostBearer;
  final List<String> _costBearers = ['Company', 'Personal'];
  final TextEditingController _guestDateController = TextEditingController();
  final TextEditingController _guestIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  @override
  void dispose() {
    _guestNameController.dispose();
    //_dateController.dispose();
    _guestIdController.dispose();
    _guestDateController.dispose();
    //_guestDateController.text = '';
    super.dispose();
  }

  Future<void> _selectGuestDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _guestDateController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(_guestDateController.text),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _guestDateController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(getProportionateScreenWidth(16)),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Guest Lunch Request',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _guestNameController,
              decoration: InputDecoration(
                labelText: 'Guest Name',
                labelStyle: const TextStyle(
                  color: Colors.black, // Set label text color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              style: const TextStyle(
                color: Colors.black, // Set text color inside the TextField
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _guestDateController,
              readOnly: true,
              onTap: _selectGuestDate,
              decoration: InputDecoration(
                labelText: 'Date',
                labelStyle: const TextStyle(
                  color: Colors.black, // Set label text color
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
              style: const TextStyle(
                color: Colors.black, // Set text color inside the TextField
              ),
            ),
            const SizedBox(height: 16),
            // TextField(
            //   controller: _emailController,
            //   decoration: InputDecoration(
            //     labelText: 'Email',
            //     labelStyle: const TextStyle(
            //       color: Colors.black,
            //       // Set label text color
            //     ),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     prefixIcon: const Icon(Icons.email_outlined),
            //   ),
            //   style: const TextStyle(
            //     color: Colors.black, // Set text color inside the TextField
            //   ),
            // ),
            //const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCostBearer,
              decoration: InputDecoration(
                labelText: 'Cost Bearer',
                labelStyle: const TextStyle(
                    color: Colors.black), // Set label text color

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
              ),
              items: _costBearers.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ), // Set item text color to black
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCostBearer = newValue;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // _emailController.text.isEmpty
                  if (_guestNameController.text.isEmpty ||
                      _guestDateController.text.isEmpty ||
                      _selectedCostBearer == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  widget.onSubmit({
                    'guestName': _guestNameController.text,
                    //'guestId': int.tryParse(_guestIdController.text) ?? 0,
                    'guestId': _guestIdController.text, // Keep as String
                    'date': _guestDateController.text,
                    'costBearer': _selectedCostBearer,
                    'email': _emailController.text,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Guest Request',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LunchRequest {
  final int id;
  final String date;
  final String employeeId;
  final String employeeName; // Add employeeName field
  final String? guestName; // Added guestName field
  final String? guestId;
  final String? email; // Added guestId field
  final List<LunchRequestListDetailsWithoutOwn> detailsWithoutOwn;

  LunchRequest({
    required this.id,
    required this.date,
    required this.employeeId,
    required this.employeeName,
    this.guestName,
    this.guestId,
    this.email,
    List<LunchRequestListDetailsWithoutOwn>? detailsWithoutOwn,
  }) : detailsWithoutOwn =
            detailsWithoutOwn ?? []; // Default to an empty list if null

  factory LunchRequest.fromJson(Map<String, dynamic> json) {
    // Use `lunchRequestListDetailsWithoutOwn` if present, otherwise fall back to `requestListDetails`.
    var detailsList =
        (json['lunchRequestListDetailsWithoutOwn'] as List<dynamic>? ??
            json['requestListDetails'] as List<dynamic>? ??
            []);

    return LunchRequest(
      id: json['lunchRequestId'] ?? 0,
      date: json['requestDate'] ?? '',
      employeeId: json['code'] ?? 'N/A',
      employeeName: json['fullName'] ?? 'Unknown',
      guestName: json['guestName'], // If guestName exists
      guestId: json['guestId'],
      email: json['email'],
      detailsWithoutOwn: detailsList
          .map((detail) => LunchRequestListDetailsWithoutOwn.fromJson(
              detail as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LunchRequestListDetailsWithoutOwn {
  final int id;
  final int personId;
  final String fullName;
  final String? createdBy;
  final DateTime createdDate;
  final String createdByFullName;
  final DateTime requestDate;
  final String flag;
  final String costBearer;

  LunchRequestListDetailsWithoutOwn({
    required this.id,
    required this.personId,
    required this.fullName,
    this.createdBy,
    required this.createdDate,
    required this.createdByFullName,
    required this.requestDate,
    required this.flag,
    required this.costBearer,
  });

  factory LunchRequestListDetailsWithoutOwn.fromJson(
      Map<dynamic, dynamic> json) {
    return LunchRequestListDetailsWithoutOwn(
      //id: json['id'],
      id: int.tryParse(json['id'].toString()) ?? 0,

      personId: json['personId'],
      fullName: json['fullName'],
      createdBy: json['createdBy'],
      createdDate: DateTime.parse(json['createdDate']),
      createdByFullName: json['createdByFullName'],
      requestDate: DateTime.parse(json['requestDate']),
      flag: json['flag'],
      costBearer: json['costBearer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'fullName': fullName,
      'createdBy': createdBy,
      'createdDate': createdDate.toIso8601String(),
      'createdByFullName': createdByFullName,
      'requestDate': requestDate.toIso8601String(),
      'flag': flag,
      'costBearer': costBearer,
    };
  }
}

class LunchGuestDeleteDTO {
  final int? lunchRequestId; // Nullable field
  final int? employeeID; // Nullable field
  final String? date; // Nullable field (String)
  final bool? isLunch; // Nullable field
  final DateTime? requestedOn; // Nullable field
  final int? guestID; // Nullable field

  LunchGuestDeleteDTO({
    this.lunchRequestId, // Nullable
    this.employeeID, // Nullable
    this.date, // Nullable (String)
    this.isLunch, // Nullable
    this.requestedOn, // Nullable
    this.guestID, // Nullable
  });

  // Factory constructor to create a LunchGuestDeleteDTO from JSON
  factory LunchGuestDeleteDTO.fromJson(Map<String, dynamic> json) {
    return LunchGuestDeleteDTO(
      lunchRequestId: json['LunchRequestId'], // Nullable in JSON
      employeeID: json['EmployeeID'], // Nullable in JSON
      date: json['LunchDate'], // Nullable in JSON
      isLunch: json['IsLunch'], // Nullable in JSON
      requestedOn: json['RequestedOn'] != null
          ? DateTime.parse(json['RequestedOn'])
          : null, // Nullable
      guestID: json['GuestID'], // Nullable in JSON
    );
  }

  // Method to convert LunchGuestDeleteDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'LunchRequestId': lunchRequestId, // Nullable, can be null
      'EmployeeID': employeeID, // Nullable, can be null
      'LunchDate': date, // Nullable (String), can be null
      'IsLunch': isLunch, // Nullable, can be null
      'RequestedOn': requestedOn
          ?.toIso8601String(), // Nullable DateTime to String, if exists
      'GuestID': guestID, // Nullable, can be null
    };
  }
}

// First, update your DeleteLunchItem class to match backend casing
class DeleteLunchItem {
  final String requestDate; // Matching backend casing
  final int PersonId; // Matching backend casing
  final String Flag; // Matching backend casing

  DeleteLunchItem({
    required this.requestDate,
    required this.PersonId,
    required this.Flag,
  });

  Map<String, dynamic> toJson() {
    return {
      'LunchDate': requestDate,
      'PersonId': PersonId,
      'Flag': Flag,
    };
  }
}

// Define the DeleteLunchDTO
class DeleteLunchDTO {
  final int costBeareId;
  final String lunchDate;
  final List<DeleteLunchItem> items;

  DeleteLunchDTO({
    required this.costBeareId,
    required this.lunchDate,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'CostBeareId': costBeareId,
      'LunchDate': lunchDate,
      'Items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class GuestLunchRequestDTO {
  final int guestId;
  final int costBeareId;
  final bool isCostBearerOffice;
  final String requestDate; // Formatted as 'yyyy-MM-dd'
  final String? guestName; // Added guestName field
  final String? email;

  GuestLunchRequestDTO({
    required this.guestId,
    required this.costBeareId,
    required this.isCostBearerOffice,
    required this.requestDate,
    this.guestName,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'guestId': guestId,
      'costBeareId': costBeareId,
      'isCostBearerOffice': isCostBearerOffice,
      'requestDate': requestDate,
      'guestName': guestName,
      'email': email,
    };
  }
}

class LunchRequestWidget extends StatefulWidget {
  const LunchRequestWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LunchRequestWidgetState createState() => _LunchRequestWidgetState();
}

class _LunchRequestWidgetState extends State<LunchRequestWidget> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _guestDateController = TextEditingController();
  late final DioClient _dioClient;
  late final UserInfo _user;
  bool _isLoading = false;
  bool _isLoadingHistory = false;
  final List<LunchRequest> _lunchRequests = [];

  @override
  void initState() {
    super.initState();

    _dioClient = DioClient(Dio());
    _user = getCurrentUser();

    // Check lunch reminder AFTER dio is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLunchReminder();
    });
  }

  Future<void> _checkLunchReminder() async {
    debugPrint('🔔 Starting lunch reminder check...');
    final now = DateTime.now();
    debugPrint(
        '🔔 Current time: ${now.hour}:${now.minute}, Weekday: ${now.weekday}');

    // Only check on weekdays between 9 AM and 2 PM
    if (now.weekday >= 1 && now.weekday <= 5) {
      if (now.hour >= 9 && now.hour < 14) {
        try {
          final hasRequest = await hasLunchRequestForToday();
          debugPrint('🔔 Has lunch request: $hasRequest');

          if (!hasRequest && mounted) {
            debugPrint('🔔 Showing reminder dialog');
            _showLunchReminderDialog();
          }
        } catch (e) {
          debugPrint('🔔 Error checking lunch reminder: $e');
        }
      } else {
        debugPrint('🔔 Outside time window (9 AM - 2 PM)');
      }
    } else {
      debugPrint('🔔 Not a weekday');
    }
  }

  // ADD THIS NEW METHOD
  Future<bool> hasLunchRequestForToday() async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      debugPrint('🔔 Checking lunch request for date: $today');

      final response = await _dioClient.get(
        "/hrms/LunchRequest/GetLunchDetails",
        queryParameters: {"date": today},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          final hasRequest = (response.data as List).isNotEmpty;
          debugPrint('🔔 Lunch request found: $hasRequest');
          return hasRequest;
        }
      }

      debugPrint('🔔 No lunch request data');
      return false;
    } catch (e) {
      debugPrint('🔔 Error checking lunch request: $e');
      // Return true on error to avoid false notifications
      return true;
    }
  }

  void _showLunchReminderDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.restaurant_menu,
          size: 48,
          color: Colors.orange,
        ),
        title: const Text('Lunch Request Reminder'),
        content: const Text(
            'You haven\'t submitted your lunch request for today. Would you like to submit now?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // The user is already on the meal subscription screen
              // So just close the dialog, no navigation needed
            },
            child: const Text('Submit Now'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _guestDateController.dispose();
    super.dispose();
  }

  // void _showMessage(String message, {bool isError = false}) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         message,
  //         style: TextStyle(color: isError ? Colors.red : Colors.green),
  //       ),
  //       backgroundColor: isError ? Colors.white : Colors.black,
  //     ),
  //   );
  // }

  Future<void> _fetchLunchDetails(String date) async {
    if (date.isEmpty) {
      _showMessage("Please select a date first!", isError: true);
      return;
    }

    setState(() => _isLoadingHistory = true);

    try {
      final formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(date));

      final response = await _dioClient.get(
        "/hrms/LunchRequest/GetLunchDetails",
        //"http://localhost:5000/api/hrms/LunchRequest/GetLunchDetails",
        queryParameters: {"date": formattedDate},
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _lunchRequests.clear();
          if (response.data is List) {
            _lunchRequests.addAll(
              (response.data as List).map((item) {
                var lunchRequest = LunchRequest.fromJson(item);
                return lunchRequest;
              }).toList(),
            );
          }

          if (_lunchRequests.isEmpty) {
            _showMessage("No lunch details available for the selected date.");
          }
        });
      } else {
        _showMessage("Failed to fetch lunch details.", isError: true);
      }
    } catch (e) {
      debugPrint("Error fetching lunch details: $e");
      _showMessage("An error occurred while fetching lunch details.",
          isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoadingHistory = false);
      }
    }
  }

  Future<void> _submitLunchRequest() async {
    if (_dateController.text.isEmpty) {
      _showMessage("Please select a date first!", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final _formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(_dateController.text));

      final response = await _dioClient.post(
        "/hrms/LunchRequest/CreateApp",
        data: {
          "LunchDate": _formattedDate,
          "EmployeeID": _user.employeeId.toString(),
        },
        options: Options(
          validateStatus: (status) {
            return status! < 500; // Accept all status codes less than 500
          },
        ),
      );

      // Handle success case
      if (response.statusCode == 200) {
        _showMessage("Lunch request submitted successfully!");
        if (!_isLoadingHistory) {
          await _fetchLunchDetails(_formattedDate);
        }
        _showHistoryDialog();
        return;
      }

      // Handle error responses (400, 401, etc.)
      if (response.data is Map) {
        final errorMessage = response.data['message'] ??
            "Failed to submit request. Please try again.";

        if (errorMessage.contains("Cannot request after 10.00 AM")) {
          _showMessage("Lunch request is only allowed before 10.00 AM.",
              isError: true);
        } else if (errorMessage.contains("Already requested for lunch")) {
          _showMessage("You have already requested lunch for this date.",
              isError: true);
        } else {
          _showMessage(errorMessage, isError: true);
        }
      } else {
        _showMessage("Failed to submit request. Please try again.",
            isError: true);
      }
    } catch (e) {
      // Handle network errors and other exceptions
      if (e is DioException && e.response != null && e.response!.data is Map) {
        final errorMessage = e.response!.data['message'] ??
            "Failed to submit request. Please try again.";
        _showMessage(errorMessage, isError: true);
      } else {
        _showMessage("An error occurred. Please try again later.",
            isError: true);
        debugPrint("Error submitting lunch request: $e");
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteLunchRequest(String date) async {
    if (date.isEmpty) {
      _showMessage("Please select a date first!", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(_dateController.text));
      final response = await _dioClient.post(
        "/hrms/LunchRequest/DeleteLunchApp",
        data: {
          "LunchDate": formattedDate,
        },
      );

      if (response.statusCode == 200) {
        // Close the history dialog
        Navigator.of(context).pop();

        // // Refresh lunch details
        // await _fetchLunchDetails(date);

        _showMessage("Lunch request deleted successfully!");
        // Refresh lunch details
        await _fetchLunchDetails(date);
      } else {
        final message =
            response.data?['message'] ?? "Failed to delete request.";
        _showMessage(message, isError: true);
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again later.", isError: true);
      debugPrint("Error deleting lunch request: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitGuestLunchRequest(Map<String, dynamic> guestData) async {
    // Prevent multiple submissions
    if (_isLoading) {
      debugPrint("Request already in progress, skipping");
      return;
    }

    final guestId = guestData['guestId'] ?? 0;
    final costBeareId = guestData['costBeareId'] ?? 0;
    final guestName = guestData['guestName'] ?? '';
    final requestDate = guestData['date'] ?? _dateController.text;
    final email = guestData['email'] ?? '';

    // Get the cost bearer type (Company or Personal)
    final String costBearer = guestData['costBearer'] ?? '';

    // Determine if cost bearer is office
    bool isCostBearerOffice = false;
    if (costBearer == 'Company') {
      isCostBearerOffice = true;
    } else if (costBearer == 'Personal') {
      isCostBearerOffice = false;
    }

    debugPrint("isCostBearerOffice value: $isCostBearerOffice");
    debugPrint("Validation passed: Proceeding to submit request");

    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(requestDate));

      final requestBody = {
        "FullName": guestName,
        "GuestId": guestId,
        "CostBeareId": costBeareId,
        "IsCostBearerOffice": isCostBearerOffice,
        "RequestDate": formattedDate,
        "Email": email,
      };

      debugPrint("Sending request to backend: ${jsonEncode(requestBody)}");

      final response = await _dioClient.post(
        "/hrms/LunchRequest/SaveGuestRequestForApp",
        data: requestBody,
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response data: ${response.data}");

      // Force throw an exception for non-200 status codes to go to catch block
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      // Only handle successful case here
      final responseData = response.data;
      if (responseData['status'] == true) {
        if (!_isLoadingHistory) {
          _showMessage("Guest lunch request submitted successfully!");

          await _fetchLunchDetails(formattedDate);
        }
        Navigator.pop(context);
        _showHistoryDialog();
        return;
      }

      // If we get here without a true status, throw an exception
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } catch (e) {
      debugPrint("Error submitting guest lunch request: $e");

      if (e is DioException) {
        final response = e.response;
        if (response != null) {
          final errorData = response.data;
          final errorMessage =
              (errorData is Map && errorData.containsKey('message'))
                  ? errorData['message']
                  : "Failed to submit request. Please try again.";

          debugPrint("Error message received: $errorMessage");

          if (errorMessage.contains("Cannot request after 10.00 AM")) {
            _showMessage("Lunch request is only allowed before 10.00 AM.",
                isError: true);
          } else if (errorMessage.contains("already requested")) {
            _showMessage(
                "A lunch request already exists for this guest on this date.",
                isError: true);
          } else {
            _showMessage(errorMessage, isError: true);
          }
        } else {
          _showMessage("Failed to submit request. Please try again.",
              isError: true);
        }
      } else {
        _showMessage("An error occurred. Please try again later.",
            isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Future<void> _deleteguestLunchRequest(int id, String requestDate) async {
  //   if (requestDate.isEmpty) {
  //     _showMessage("Please select a date first!", isError: true);
  //     return;
  //   }

  //   setState(() => _isLoading = true);

  //   try {
  //     final formattedDate =
  //         DateFormat('yyyy-MM-dd').format(DateTime.parse(requestDate));

  //     final response = await _dioClient.post(
  //       "http://10.0.2.2:5000/api/hrms/LunchRequest/DeleteLunchGuestApp",
  //       data: {
  //         "RequestDate": formattedDate,
  //         "ID": id, // Pass the guest's or lunch request's ID
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       _showMessage("Lunch request deleted successfully!");
  //       // Optionally, update your UI or fetch new data
  //       await _fetchLunchDetails(
  //           requestDate); // Replace with actual fetch logic
  //     } else {
  //       final message =
  //           response.data?['message'] ?? "Failed to delete request.";
  //       _showMessage(message, isError: true);
  //     }
  //   } catch (e) {
  //     _showMessage("An error occurred. Please try again later.", isError: true);
  //     debugPrint("Error deleting lunch request: $e");
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  Future<void> _deleteguestLunchRequest(
      int lunchRequestId, int guestId, String lunchDate, bool isLunch) async {
    if (lunchDate.isEmpty) {
      _showMessage("Please select a date first!", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(lunchDate));

      final requestData = {
        "LunchRequestId": lunchRequestId,
        "GuestID": guestId,
        "LunchDate": formattedDate,
        "IsLunch": isLunch,
        "RequestedOn": DateTime.now().toIso8601String(),
      };

      final response = await _dioClient.post(
        "/hrms/LunchRequest/DeleteLunchGuestApp",
        data: requestData,
      );

      if (response.statusCode == 200) {
        // Close the history dialog
        Navigator.of(context).pop();

        // Refresh lunch details
        await _fetchLunchDetails(lunchDate);

        _showMessage("Guest lunch request deleted successfully!");
      } else {
        final message = response.data?['message'] ??
            "Failed to delete guest lunch request.";
        _showMessage(message, isError: true);
      }
    } catch (e) {
      _showMessage("An error occurred. Please try again later.", isError: true);
      debugPrint("Error deleting guest lunch request: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Lunch Request List",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                // Content
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: _isLoadingHistory
                      ? const Center(child: CircularProgressIndicator())
                      : _lunchRequests.isEmpty
                          ? const Center(
                              child: Text(
                                "No lunch requests found",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Builder(
                              builder: (context) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _lunchRequests.length,
                                  itemBuilder: (context, index) {
                                    final request = _lunchRequests[index];
                                    String formattedDate = "N/A";

                                    // Format Date
                                    if (request.date.isNotEmpty) {
                                      try {
                                        DateTime dateTime =
                                            DateTime.parse(request.date);
                                        formattedDate =
                                            DateFormat('MMM dd, yyyy')
                                                .format(dateTime);
                                      } catch (e) {
                                        debugPrint(
                                            "Error formatting date: ${request.date} - $e");
                                        formattedDate = request.date;
                                      }
                                    }

                                    // return Column(
                                    //   children: [
                                    //     // Employee Card
                                    //     Card(
                                    //       elevation: 2,
                                    //       margin: const EdgeInsets.symmetric(
                                    //           vertical: 4),
                                    //       child: ListTile(
                                    //         leading: const CircleAvatar(
                                    //           backgroundColor: kPrimaryColor,
                                    //           child: Icon(
                                    //             Icons.person,
                                    //             color: Colors.white,
                                    //             size: 20,
                                    //           ),
                                    //         ),
                                    //         title: Text(
                                    //           "Date: $formattedDate",
                                    //           style: const TextStyle(
                                    //             fontWeight: FontWeight.w500,
                                    //           ),
                                    //         ),
                                    //         subtitle: Column(
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             Text(
                                    //               "Employee Name: ${request.employeeName}",
                                    //               style: const TextStyle(
                                    //                 fontSize: 14,
                                    //                 color: Colors.black54,
                                    //               ),
                                    //             ),
                                    //             Text(
                                    //               "Employee ID: ${request.employeeId}",
                                    //               style: const TextStyle(
                                    //                 fontSize: 14,
                                    //                 color: Colors.black54,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         trailing: IconButton(
                                    //           icon: const Icon(Icons.delete,
                                    //               color: Colors.red),
                                    //           onPressed: () =>
                                    //               _showDeleteConfirmation(
                                    //                   context, request),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     // Guest Cards
                                    //     if (request
                                    //         .detailsWithoutOwn.isNotEmpty)
                                    //       ...request.detailsWithoutOwn.map(
                                    //         (guest) {
                                    //           return Card(
                                    //             elevation: 2,
                                    //             margin:
                                    //                 const EdgeInsets.symmetric(
                                    //               vertical: 4,
                                    //               horizontal: 16,
                                    //             ),
                                    //             child: ListTile(
                                    //               leading: const CircleAvatar(
                                    //                 backgroundColor:
                                    //                     Colors.orange,
                                    //                 child: Icon(
                                    //                   Icons.person_outline,
                                    //                   color: Colors.white,
                                    //                   size: 20,
                                    //                 ),
                                    //               ),
                                    //               // title: Text(
                                    //               //   "Guest Name: ${guest.fullName ?? 'N/A'}",
                                    //               //   style: const TextStyle(
                                    //               //     fontSize: 14,
                                    //               //     color: Colors.black87,
                                    //               //   ),
                                    //               // ),
                                    //               // subtitle: Text(
                                    //               //   "Guest ID: ${guest.id ?? 'N/A'}",
                                    //               //   style: const TextStyle(
                                    //               //     fontSize: 14,
                                    //               //     color: Colors.black54,
                                    //               //   ),
                                    //               // ),

                                    //               title: Text(
                                    //                 "Guest Name: ${guest.fullName ?? 'N/A'}",
                                    //                 style: const TextStyle(
                                    //                   fontSize: 14,
                                    //                   color: Colors.black87,
                                    //                 ),
                                    //               ),
                                    //               subtitle: Column(
                                    //                 crossAxisAlignment:
                                    //                     CrossAxisAlignment
                                    //                         .start,
                                    //                 children: [
                                    //                   Text(
                                    //                     "Guest ID: ${guest.id ?? 'N/A'}",
                                    //                     style: const TextStyle(
                                    //                       fontSize: 14,
                                    //                       color: Colors.black54,
                                    //                     ),
                                    //                   ),
                                    //                   Text(
                                    //                     "Cost Bearer: ${guest.costBearer ?? 'N/A'}",
                                    //                     style: const TextStyle(
                                    //                       fontSize: 14,
                                    //                       color: Colors.black54,
                                    //                     ),
                                    //                   ),
                                    //                 ],
                                    //               ),

                                    //               trailing: IconButton(
                                    //                 icon: const Icon(
                                    //                     Icons.delete,
                                    //                     color: Colors.red),
                                    //                 onPressed: () =>
                                    //                     _showDeleteConfirmation(
                                    //                   context,
                                    //                   guest,
                                    //                   isGuest: true,
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //           );
                                    //         },
                                    //       ).toList(),
                                    //   ],
                                    // );

                                    return Column(
                                      children: [
                                        // Employee Card (Only Show If Employee ID is Valid)
                                        if (request.employeeId != null &&
                                            int.tryParse(request.employeeId) !=
                                                null &&
                                            int.parse(request.employeeId) > 0)
                                          Card(
                                            elevation: 2,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: ListTile(
                                              leading: const CircleAvatar(
                                                backgroundColor: kPrimaryColor,
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              title: Text(
                                                "Date: $formattedDate",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Employee Name: ${request.employeeName}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Employee ID: ${request.employeeId}",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // trailing: IconButton(
                                              //   icon: const Icon(Icons.delete,
                                              //       color: Colors.red),
                                              //   onPressed: () =>
                                              //       _showDeleteConfirmation(
                                              //           context, request),
                                              // ),
                                              // trailing: () {
                                              //   UserInfo user =
                                              //       getCurrentUser();
                                              //   String? loggedInEmployeeId =
                                              //       user.employeeCode
                                              //           ?.toString();
                                              //   // Convert request.employeeId to a string consistently
                                              //   String? requestEmployeeId =
                                              //       request.employeeId
                                              //           ?.toString();

                                              //   return (requestEmployeeId ==
                                              //           loggedInEmployeeId)
                                              //       ? IconButton(
                                              //           icon: const Icon(
                                              //               Icons.delete,
                                              //               color: Colors.red),
                                              //           onPressed: () =>
                                              //               _showDeleteConfirmation(
                                              //                   context,
                                              //                   request),
                                              //         )
                                              //       : null;
                                              // }(),

                                              trailing: () {
                                                UserInfo user =
                                                    getCurrentUser();
                                                String? loggedInEmployeeId =
                                                    user.employeeCode
                                                        ?.toString();
                                                String? requestEmployeeId =
                                                    request.employeeId
                                                        ?.toString();

                                                // Ensure both are non-null and of the same type (string comparison)
                                                if (loggedInEmployeeId !=
                                                        null &&
                                                    requestEmployeeId != null) {
                                                  return (requestEmployeeId ==
                                                          loggedInEmployeeId)
                                                      ? IconButton(
                                                          icon: const Icon(
                                                              Icons.delete,
                                                              color:
                                                                  Colors.red),
                                                          onPressed: () =>
                                                              _showDeleteConfirmation(
                                                                  context,
                                                                  request),
                                                        )
                                                      : null;
                                                }
                                                return null; // If either employeeId is null, don't show the button
                                              }(),
                                            ),
                                          ),

                                        // Guest Cards (Show All Guests, Regardless of Cost Bearer)
                                        if (request
                                            .detailsWithoutOwn.isNotEmpty)
                                          ...request.detailsWithoutOwn
                                              .map(
                                                (guest) => Card(
                                                  elevation: 2,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 4,
                                                      horizontal: 16),
                                                  child: ListTile(
                                                    leading: const CircleAvatar(
                                                      backgroundColor:
                                                          Colors.orange,
                                                      child: Icon(
                                                        Icons.person_outline,
                                                        color: Colors.white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                    // title: Text(
                                                    //   "Guest Name: ${guest.fullName ?? 'N/A'}",
                                                    //   style: const TextStyle(
                                                    //     fontSize: 14,
                                                    //     color: Colors.black87,
                                                    //   ),
                                                    // ),
                                                    // subtitle: Column(
                                                    //   crossAxisAlignment:
                                                    //       CrossAxisAlignment
                                                    //           .start,
                                                    //   children: [
                                                    //     Text(
                                                    //       "Guest ID: ${guest.id ?? 'N/A'}",
                                                    //       style:
                                                    //           const TextStyle(
                                                    //         fontSize: 14,
                                                    //         color:
                                                    //             Colors.black54,
                                                    //       ),
                                                    //     ),
                                                    //     Text(
                                                    //       "Cost Bearer: ${guest.costBearer ?? 'N/A'}",
                                                    //       style:
                                                    //           const TextStyle(
                                                    //         fontSize: 14,
                                                    //         color:
                                                    //             Colors.black54,
                                                    //       ),
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    title: Text(
                                                      "Guest Name: ${guest.fullName ?? 'N/A'}",
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.04, // Adjust based on screen width

                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Guest ID: ${guest.id ?? 'N/A'}",
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.035,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Cost Bearer: ${guest.costBearer ?? 'N/A'}",
                                                          style: TextStyle(
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.035,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    // trailing: IconButton(
                                                    //   icon: const Icon(
                                                    //       Icons.delete,
                                                    //       color: Colors.red),
                                                    //   onPressed: () =>
                                                    //       _showDeleteConfirmation(
                                                    //           context, guest,
                                                    //           isGuest: true),
                                                    // ),
                                                    // trailing: () {
                                                    //   UserInfo user =
                                                    //       getCurrentUser();
                                                    //   String?
                                                    //       loggedInEmployeeId =
                                                    //       user.employeeName
                                                    //           ?.toString();
                                                    //   int? requestEmployeeId =
                                                    //       user.employeeId;

                                                    //   String? costBearerId =
                                                    //       guest.costBearer
                                                    //           .toString();

                                                    //   // Check if it's either:
                                                    //   // 1. A matching employee ID for employee requests
                                                    //   // 2. A matching cost bearer ID for guest requests
                                                    //   bool canDelete =
                                                    //       (loggedInEmployeeId ==
                                                    //               costBearerId) ||
                                                    //           (requestEmployeeId ==
                                                    //               15) ||
                                                    //           (requestEmployeeId ==
                                                    //               9);

                                                    //   return canDelete
                                                    //       ? IconButton(
                                                    //           icon: const Icon(
                                                    //               Icons.delete,
                                                    //               color: Colors
                                                    //                   .red),
                                                    //           onPressed: () =>
                                                    //               _showDeleteConfirmation(
                                                    //             context,
                                                    //             request,
                                                    //             isGuest:
                                                    //                 costBearerId ==
                                                    //                     loggedInEmployeeId, // Pass isGuest flag based on match type
                                                    //           ),
                                                    //         )
                                                    //       : null;
                                                    // }(),

                                                    trailing: () {
                                                      UserInfo user =
                                                          getCurrentUser();

                                                      String?
                                                          loggedInEmployeeName =
                                                          user.employeeName
                                                              ?.toString(); // Assuming employeeName is a string.
                                                      int? loggedInEmployeeId =
                                                          user.employeeId; // Assuming employeeId is an integer
                                                      String? costBearerId = guest
                                                          .costBearer
                                                          ?.toString(); // Assuming costBearer is a dynamic value, converting to string

                                                      // Check if it's either:
                                                      // 1. A matching employee ID for employee requests
                                                      // 2. A matching cost bearer ID for guest requests
                                                      // 3. Special cases for requestEmployeeId 15 or 9

                                                      bool canDelete = (loggedInEmployeeName ==
                                                              costBearerId) ||
                                                          (loggedInEmployeeId ==
                                                              15) ||
                                                          (loggedInEmployeeId ==
                                                              9) ||
                                                          (loggedInEmployeeId ==
                                                              23);

                                                      return canDelete
                                                          ? IconButton(
                                                              icon: const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .red),
                                                              onPressed: () =>
                                                                  _showDeleteConfirmation(
                                                                      context,
                                                                      guest,
                                                                      isGuest:
                                                                          true),
                                                            )
                                                          : null; // Return null if delete is not allowed
                                                    }(),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
// lastDate: DateTime(2100),

      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        debugPrint("Selected Date: ${_dateController.text}");
      });
    }
  }
  // Get logged-in user's employee ID

  void _showDeleteConfirmation(BuildContext context, dynamic request,
      {bool isGuest = false}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final String message = isGuest
            ? "Are you sure you want to delete this guest lunch request?"
            : "Are you sure you want to delete this lunch request?";

        return AlertDialog(
          title: const Text(
            "Confirm Delete",
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                if (isGuest) {
                  await _deleteguestLunchRequest(
                    0,
                    request.id,
                    request.requestDate.toString(),
                    false,
                  );
                } else {
                  await _deleteLunchRequest(request.date);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Future<void> _handleDeleteLunch(BuildContext context, String date,
  //     {int? id,
  //     int guestId = 0,
  //     bool isLunch = false,
  //     bool isGuest = false}) async {
  //   if (date.isEmpty) {
  //     _showMessage("Invalid date. Please try again.", isError: true);
  //     return;
  //   }

  //   try {
  //     setState(() => _isLoadingHistory = true);

  //     // Call the appropriate delete function based on the `isGuest` flag
  //     if (isGuest && id != null) {
  //       await _deleteguestLunchRequest(id, guestId, date, isLunch);
  //     } else {
  //       await _deleteLunchRequest(date);
  //     }

  //     // Refresh the list after successful deletion
  //     await _fetchLunchDetails(date);
  //     _showMessage("Lunch request deleted successfully!");
  //     // Navigator.of(context).pop(); // Close the history dialog if open
  //   } catch (e) {
  //     debugPrint("Error during deletion: $e");
  //     _showMessage("Failed to delete lunch request.", isError: true);
  //   } finally {
  //     setState(() => _isLoadingHistory = false);
  //   }
  // }
  Future<void> _handleDeleteLunch(BuildContext context, String date,
      {int? id,
      int guestId = 0,
      bool isLunch = false,
      bool isGuest = false}) async {
    if (date.isEmpty) {
      _showMessage("Invalid date. Please try again.", isError: true);
      return;
    }

    try {
      setState(() => _isLoadingHistory = true);

      // Call the appropriate delete function based on the `isGuest` flag
      if (isGuest && id != null) {
        await _deleteguestLunchRequest(id, guestId, date, isLunch);
      } else {
        await _deleteLunchRequest(date);
      }

      // Refresh the list after successful deletion
      await _fetchLunchDetails(date);
      _showMessage("Lunch request deleted successfully!");

      // Close the history dialog and navigate to lunch page
      Navigator.of(context).pop(); // Close the history dialog
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                MealSubscriptionScreen()), // Replace with your actual lunch page
      );
    } catch (e) {
      debugPrint("Error during deletion: $e");
      _showMessage("Failed to delete lunch request.", isError: true);
    } finally {
      setState(() => _isLoadingHistory = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.screenWidth * 0.03,
      ),
      width: SizeConfig.screenWidth * 0.90,
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: getProportionateScreenWidth(20)),
          _buildDateField(),
          SizedBox(height: getProportionateScreenWidth(20)),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        SvgPicture.asset(
          '$kIconPath/meal_subscription.svg',
          width: getProportionateScreenWidth(24),
          height: getProportionateScreenWidth(24),
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        SizedBox(width: getProportionateScreenWidth(10)),
        const AppText(
          text: "Lunch Request",
          color: Colors.white,
          fontWeight: FontWeight.w400,
          size: 22,
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: _dateController,
      decoration: InputDecoration(
        hintText: 'Select Date',
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.calendar_today),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      readOnly: true,
      style: const TextStyle(color: Colors.black),
      onTap: _selectDate,
    );
  }

  Widget _buildSubmitButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitLunchRequest,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              disabledBackgroundColor: Colors.white.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoadingHistory
                ? null
                : () async {
                    if (_dateController.text.isEmpty) {
                      _showMessage("Please select a date first!",
                          isError: true);
                      return;
                    }
                    await _fetchLunchDetails(_dateController.text);
                    _showHistoryDialog();
                  },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              disabledBackgroundColor: Colors.white.withOpacity(0.7),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoadingHistory
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    "View Lunch Request",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 10),
        // Add the guest request button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GuestLunchRequestCard(
                      onSubmit: (guestData) async {
                        await _submitGuestLunchRequest(guestData);
                        // After submission, close the screen and show a success message
                        Navigator.pop(context);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(
                        //     content: Text(
                        //         'Guest lunch request submitted successfully!'),
                        //     backgroundColor: Colors.green,
                        //   ),
                        // );
                      },
                      onClose: () => Navigator.pop(context),
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add, color: Colors.black),
                SizedBox(width: 8),
                Text(
                  "Guest Lunch Request",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

UserInfo getCurrentUser() {
  final storage = GetStorage();
  final userJsonString = storage.read(USER_SIGN_IN_KEY);
  if (userJsonString == null) {
    throw Exception('User data not found in storage');
  }
  try {
    return UserInfo.fromJson(json.decode(userJsonString));
  } catch (e) {
    throw Exception('Failed to parse user data: $e');
  }
}
