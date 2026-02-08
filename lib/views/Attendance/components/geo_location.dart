import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/Attendance/attendance_controller.dart';
import 'dart:math' as math;

//import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
class Employee {
  final int id;
  final String text;

  Employee({required this.id, required this.text});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] as int,
      text: json['text'] as String,
    );
  }
}

class GeoLocation extends StatelessWidget {
  GeoLocation({
    super.key,
  });
  final _attendanceController = Get.find<AttendanceController>();
// Add markAttendance here
  void markAttendance() async {
    String actionName =
        _attendanceController.isCheckedIn.value ? 'Punch Out' : 'Punch In';
    _attendanceController
        .updateRemarks(_attendanceController.remarksController.text);
    var actionValue = _attendanceController.punchInTime.value == '00:00:00';
    if (actionValue == true) {
      actionName = 'Punch In';
    } else {
      actionName = 'Punch Out';
    }

    bool success = await _attendanceController.handleAttendance(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      time: DateFormat('HH:mm:ss').format(DateTime.now()),
      employeeIds: _attendanceController.selectedEmployees
          .map((e) => e.id.toString())
          .toList(),
      actionName: actionName,
      attendanceType: _attendanceController.selectedAttendanceType.value,
      location: _attendanceController.location.value,
      remarks: _attendanceController.remarks.value,
    );

    if (success) {
      Get.snackbar('Success', '$actionName successful');
      _attendanceController.isCheckedIn.value = (actionName == 'Punch In');
    } else {
      Get.snackbar('Error', 'Failed to perform $actionName');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(20),
        horizontal: getProportionateScreenWidth(20),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset.fromDirection(math.pi * .5, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Attendance Log",
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(20)),

          // 🗓 Day & Date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppText(
                text: "Today: ${DateTime.now().toLocal()}",
                fontWeight: FontWeight.bold,
                size: kTextSize - 2,
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(10)),

          // 🕒 Timeline (Progress Indicator)
          // LinearProgressIndicator(
          //   value: _attendanceController.isCheckedIn.value ? 1.0 : 0.5,
          //   backgroundColor: Colors.grey[300],
          //   color: Colors.blue,
          //   minHeight: 6,
          // ),
          SizedBox(height: getProportionateScreenWidth(20)),

          buildFingerprintIcon(),
          SizedBox(height: getProportionateScreenWidth(20)),
          buildCheckInOutTimes(),

          SizedBox(height: getProportionateScreenWidth(20)),

          buildAttendanceTypeSelection(),

          SizedBox(height: getProportionateScreenWidth(20)),
          Obx(() {
            if (_attendanceController.selectedAttendanceType.value ==
                "Outdoor Meeting") {
              return Column(
                children: [
                  buildAddEmployeeCheckbox(),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  if (_attendanceController.isEmployeeAdded.value)
                    buildAttendanceDropdownField(),
                ],
              );
            } else if (_attendanceController.selectedAttendanceType.value ==
                "Other") {
              return buildRemarksTextField();
            } else {
              return const SizedBox.shrink();
            }
          }),
          buildMarkAttendanceButton(),
        ],
      ),
    );
  }

  Container buildCheckInOutTimes() {
    // final attendanceController =
    //     getIt<AttendanceController>(); // Dependency Injection

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(7),
        vertical: getProportionateScreenWidth(10),
      ),
      width: double.infinity,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              // const Text(
              //   "Check-in",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: kTextColor,
              //   ),
              // ),
              // // Obx for dynamic Check-in time
              // Obx(() => Text(
              //       _attendanceController.checkInTime.value.isNotEmpty
              //           ? _attendanceController.checkInTime.value
              //           : "--:--",
              //       style: const TextStyle(fontSize: 16, color: Colors.green),
              //     )),
            ],
          ),
          Column(
            children: [
              // const Text(
              //   "Check-out",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.bold,
              //     color: kTextColor,
              //   ),
              // ),
              // // Obx for dynamic Check-out time
              // Obx(() => Text(
              //       _attendanceController.checkOutTime.value.isNotEmpty
              //           ? _attendanceController.checkOutTime.value
              //           : "--:--",
              //       style: const TextStyle(fontSize: 16, color: Colors.red),
              //     )),
            ],
          ),
        ],
      ),
    );
  }

  Container buildFingerprintIcon() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(15),
        vertical: getProportionateScreenWidth(20),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Fingerprint Button
          GestureDetector(
            onTap: () {
              _attendanceController.markCheckInOut();
            },
            child: Obx(() => Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _attendanceController.isCheckedIn.value
                        ? Colors.green.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.fingerprint,
                        size: 70,
                        color: _attendanceController.isCheckedIn.value
                            ? Colors.green
                            : Colors.blue,
                      ),
                      if (_attendanceController.isLoading.value)
                        const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                    ],
                  ),
                )),
          ),
          const SizedBox(height: 25),

          // Time Information Card
          Obx(() => Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    // Shift Times Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeItem(
                          title: "Shift In Time",
                          time: _attendanceController.shiftInTime.value,
                          color: Colors.blue,
                        ),
                        _buildTimeItem(
                          title: "Shift End Time",
                          time: _attendanceController.shiftEndTime.value,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    // Check In/Out Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTimeItem(
                          title: "Check In",
                          time: _attendanceController.punchInTime.value,
                          color: Colors.green,
                        ),
                        _buildTimeItem(
                          title: "Check Out",
                          time: _attendanceController.punchOutTime.value,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

// Helper method to build time display items
  Widget _buildTimeItem({
    required String title,
    required String time,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          time.isNotEmpty ? time : '--:--',
          style: TextStyle(
            fontSize: 18,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Function to build Attendance Type Selection (Radio Buttons)
  Container buildAttendanceTypeSelection() {
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(7),
        right: getProportionateScreenWidth(3),
        top: getProportionateScreenWidth(10),
        bottom: getProportionateScreenWidth(10),
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Attendance Type:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            Column(
              children: _attendanceController.attendanceTypes
                  .map(
                    (type) => RadioListTile<String>(
                      title: Text(type),
                      value: type,
                      groupValue:
                          _attendanceController.selectedAttendanceType.value,
                      onChanged: (value) {
                        if (value != null) {
                          _attendanceController.selectedAttendanceType.value =
                              value;
                          // Trigger remarks visibility update when "Other" is selected
                          _attendanceController.toggleRemarksVisibility(value);
                        }
                      },
                    ),
                  )
                  .toList(), // Convert Iterable to List<Widget>
            ),
          ],
        ),
      ),
    );
  }

  // Function to build the Remarks TextField
  Container buildRemarksTextField() {
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(7),
        right: getProportionateScreenWidth(3),
        top: getProportionateScreenWidth(10),
        bottom: getProportionateScreenWidth(10),
      ),
      width: double.infinity,
      child: TextField(
        controller: _attendanceController.remarksController,
        decoration: InputDecoration(
          labelText: "Remarks",
          hintText: "Enter remarks (optional)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // Change label and hint text color to something dark
          labelStyle: const TextStyle(color: Colors.black),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        maxLines: 3,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

// Update buildMarkAttendanceButton to use markAttendance
  Stack buildMarkAttendanceButton() {
    return Stack(
      children: [
        AppDefaultButton(
          text: !_attendanceController.isLoading.value ? "Mark Attendance" : "",
          press: () async {
            _attendanceController.isLoading.value = true;
            markAttendance(); // Call the method here
            _attendanceController.isLoading.value = false;
          },
        ),
        if (_attendanceController.isLoading.value)
          Positioned.fill(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: getProportionateScreenHeight(14)),
                child: const SpinKitThreeBounce(color: kDotColor, size: 30),
              ),
            ),
          ),
      ],
    );
  }

  Container buildAttendanceDropdownField() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Obx(() {
        final filteredEmployees = _attendanceController.employees
            .where((employee) => employee.text.toLowerCase().contains(
                _attendanceController.searchQuery.value.toLowerCase()))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                onChanged: (text) {
                  _attendanceController.searchQuery.value = text;
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search employee names',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: filteredEmployees.isEmpty
                  ? const Center(child: Text("No employees found"))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
                        final isSelected = _attendanceController
                            .selectedEmployees
                            .contains(employee);
                        return CheckboxListTile(
                          title: Text(employee.text),
                          value: isSelected,
                          onChanged: (bool? checked) {
                            if (checked == true) {
                              _attendanceController.selectedEmployees
                                  .add(employee);
                            } else {
                              _attendanceController.selectedEmployees
                                  .remove(employee);
                            }
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Selected Employees:",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Obx(() => _attendanceController.selectedEmployees.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text("No employees selected",
                        style: TextStyle(color: Colors.grey)),
                  )
                : Wrap(
                    spacing: 8.0,
                    children: _attendanceController.selectedEmployees
                        .map((employee) => Chip(
                              label: Text(employee.text),
                              deleteIcon: const Icon(Icons.cancel),
                              onDeleted: () {
                                _attendanceController.selectedEmployees
                                    .remove(employee);
                              },
                            ))
                        .toList(),
                  )),
          ],
        );
      }),
    );
  }

  Container buildAddEmployeeCheckbox() {
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(4), // Reduced value
        right: getProportionateScreenWidth(2), // Reduced value
        top: getProportionateScreenWidth(6), // Reduced value
        bottom: getProportionateScreenWidth(6), // Reduced value
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset.fromDirection(math.pi * .5, 10),
          ),
        ],
      ),
      child: Obx(() {
        return CheckboxListTile(
          title: const Text(
            "Add Employee",
            style: TextStyle(
              fontSize: kTextSize - 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          value: _attendanceController
              .isEmployeeAdded.value, // Bind checkbox to controller
          onChanged: (bool? value) {
            _attendanceController.isEmployeeAdded.value =
                value ?? false; // Toggle value
          },
          controlAffinity:
              ListTileControlAffinity.leading, // Position checkbox on the left
          activeColor: Colors.blue, // Highlight color when checked
          checkColor: Colors.white, // Color of the checkmark
        );
      }),
    );
  }
}
