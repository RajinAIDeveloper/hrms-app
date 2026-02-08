import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/Attendance/attendance_controller.dart';
import 'dart:math' as math;

class ManualAttendance extends StatelessWidget {
  ManualAttendance({super.key});

  final _attendanceController = Get.find<AttendanceController>();

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
      child: Form(
        key: _attendanceController.manualAttendanceFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Manual Attendance",
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenWidth(20)),
            buildDatePicker(),
            SizedBox(height: getProportionateScreenWidth(20)),
            buildRequestTypeDropdown(),
            SizedBox(height: getProportionateScreenWidth(20)),
            Obx(() {
              final requestType =
                  _attendanceController.selectedRequestType.value;
              return Column(
                children: [
                  if (requestType == 'Both' || requestType == 'In-Time')
                    buildTimePicker("In-Time"),
                  if (requestType == 'Both')
                    SizedBox(height: getProportionateScreenWidth(20)),
                  if (requestType == 'Both' || requestType == 'Out-Time')
                    buildTimePicker("Out-Time"),
                ],
              );
            }),
            SizedBox(height: getProportionateScreenWidth(20)),
            buildReasonField(),
            SizedBox(height: getProportionateScreenWidth(30)),
            buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attendance Date *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: Get.context!,
                initialDate: _attendanceController.selectedDate.value,
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                _attendanceController.selectedDate.value = picked;
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        DateFormat('yyyy-MM-dd')
                            .format(_attendanceController.selectedDate.value),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      )),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildRequestTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Request For *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() => DropdownButtonFormField<String>(
                value: _attendanceController.selectedRequestType.value.isEmpty
                    ? null
                    : _attendanceController.selectedRequestType.value,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  border: InputBorder.none,
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a request type'
                    : null,
                items: ['Both', 'In-Time', 'Out-Time'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value,
                        style: const TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _attendanceController.selectedRequestType.value = newValue;
                  }
                },
              )),
        ),
      ],
    );
  }

  Widget buildTimePicker(String label) {
    bool isInTime = label == "In-Time";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label *",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: Get.context!,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                if (isInTime) {
                  _attendanceController.selectedInTime.value = picked;
                } else {
                  _attendanceController.selectedOutTime.value = picked;
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    final time = isInTime
                        ? _attendanceController.selectedInTime.value
                        : _attendanceController.selectedOutTime.value;
                    return Text(
                      time?.format(Get.context!) ?? "Select Time",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    );
                  }),
                  const Icon(Icons.access_time),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReasonField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Reason *",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: _attendanceController.reasonController,
            style: const TextStyle(color: Colors.black),
            maxLines: 3,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Please provide a reason'
                : null,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(12),
              border: InputBorder.none,
              hintText: "Enter reason for manual attendance",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Stack(
      children: [
        AppDefaultButton(
          text: !_attendanceController.isLoading.value ? "Submit" : "",
          press: () async {
            if (_attendanceController.manualAttendanceFormKey.currentState!
                .validate()) {
              await _attendanceController.submitManualAttendance(context);
            }
          },
        ),
        if (_attendanceController.isLoading.value)
          const Positioned.fill(
            child: Center(
              child: SpinKitThreeBounce(
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
      ],
    );
  }
}
