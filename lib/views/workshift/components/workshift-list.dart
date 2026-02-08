import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/controllers/work-shift/workshift_controller.dart';

import 'package:root_app/constants/constants.dart';

import 'dart:math' as math;

class WorkshiftList extends StatelessWidget {
  // Payslip({
  //   super.key,
  // });
  WorkshiftList({
    super.key,
  });
  final _workShiftController = Get.find<WorkshiftController>();

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: "Work Shift List",
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenWidth(20)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(
                  text: "Employee Selection  ",
                  fontWeight: FontWeight.bold,
                  size: kTextSize - 2,
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            buildEmployeeNameDropdownField(),
            SizedBox(height: getProportionateScreenWidth(20)),
            Obx(() {
              if (_workShiftController.isLoadingShifts.value) {
                return const Center(
                  child: SpinKitThreeBounce(
                    color: kPrimaryColor,
                    size: 30,
                  ),
                );
              }

              final shifts = _workShiftController.employeeShiftList;

              if (shifts.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(40)),
                    child: AppText(text: "No shifts found"),
                  ),
                );
              }

              final headerTitles = [
                "Employee",
                "Sun",
                "Mon",
                "Tue",
                "Wed",
                "Thu",
                "Fri",
                "Sat"
              ];

              // Give more space to the Employee column and day columns
              final colSizes = [3, 2, 2, 2, 2, 2, 2, 2];

              // Helper function to format shift text
              String formatShiftText(String? shiftText) {
                if (shiftText == null || shiftText.isEmpty) {
                  return "-";
                }

                // Remove quotes and trim
                String cleaned =
                    shiftText.replaceAll("'", "").replaceAll('"', '').trim();

                if (cleaned.isEmpty || cleaned == "-") {
                  return "-";
                }

                // If it contains "Weekend", return "Weekend"
                if (cleaned.toLowerCase().contains("weekend")) {
                  return "Weekend";
                }

                // Extract time from "Work Shift -1 (09:00 - 18:00)"
                final timeMatch = RegExp(r'\(([^)]+)\)').firstMatch(cleaned);
                if (timeMatch != null) {
                  return timeMatch.group(1) ?? cleaned;
                }

                return cleaned;
              }

              final bodyData = shifts
                  .map((shift) => [
                        shift.fullName,
                        formatShiftText(shift.sunday),
                        formatShiftText(shift.monday),
                        formatShiftText(shift.tuesday),
                        formatShiftText(shift.wednesday),
                        formatShiftText(shift.thursday),
                        formatShiftText(shift.friday),
                        formatShiftText(shift.saturday),
                      ])
                  .toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.8,
                  constraints: BoxConstraints(
                    minHeight: 100,
                  ),
                  child: CustomTable(
                    headerTitles: headerTitles,
                    colSizes: colSizes,
                    bodyData: bodyData,
                  ),
                ),
              );
            }),
            SizedBox(height: getProportionateScreenWidth(20)),
          ],
        ),
      ),
    );
  }
  // Container buildEmployeeNameDropdownField() {
  //   return Container(
  //     padding: EdgeInsets.only(
  //       left: getProportionateScreenWidth(7),
  //       right: getProportionateScreenWidth(3),
  //       top: getProportionateScreenWidth(10),
  //       bottom: getProportionateScreenWidth(10),
  //     ),
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: const BorderRadius.all(Radius.circular(10)),
  //       boxShadow: [
  //         BoxShadow(
  //           blurRadius: 15,
  //           color: Colors.black26,
  //           offset: Offset.fromDirection(math.pi * .5, 10),
  //         ),
  //       ],
  //     ),
  //     child: Obx(() {
  //       final employees = _workShiftController.employeeList;
  //       final isLoading = _workShiftController.isLoading.value;

  //       if (isLoading) {
  //         return const Center(
  //           child: SpinKitThreeBounce(
  //             color: kPrimaryColor,
  //             size: 20,
  //           ),
  //         );
  //       }

  //       return DropdownButtonFormField<int>(
  //         decoration: const InputDecoration(
  //           border: InputBorder.none,
  //           enabledBorder: InputBorder.none,
  //           focusedBorder: InputBorder.none,
  //           isDense: true,
  //           contentPadding: EdgeInsets.zero,
  //         ),
  //         dropdownColor: Colors.white,
  //         icon: const Icon(Icons.keyboard_arrow_down, color: kPrimaryColor),
  //         value: _workShiftController.selectedEmployeeId.value == 0
  //             ? null
  //             : _workShiftController.selectedEmployeeId.value,
  //         hint: Padding(
  //           padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
  //           child: AppText(
  //             text: "Select Employee",
  //             size: kTextSize - 2,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         items: employees.map((emp) {
  //           return DropdownMenuItem<int>(
  //             value: int.tryParse(emp.id ?? '0') ?? 0,
  //             child: Container(
  //               padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
  //               width: SizeConfig.screenWidth * 0.55,
  //               child: AppText(
  //                 text: emp.text ?? '-',
  //                 size: kTextSize - 2,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (value) =>
  //             _workShiftController.onEmployeeChanged(value ?? 0),
  //         validator: (value) =>
  //             _workShiftController.validateSelectedEmployee(value ?? 0),
  //       );
  //     }),
  //   );
  // }
  // Employee Dropdown
  Container buildEmployeeNameDropdownField() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(7),
        vertical: getProportionateScreenWidth(10),
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
        final employees = _workShiftController.employeeList;
        final isLoading = _workShiftController.isLoading.value;

        if (isLoading) {
          return const Center(
            child: SpinKitThreeBounce(
              color: kPrimaryColor,
              size: 20,
            ),
          );
        }

        return DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down, color: kPrimaryColor),
          value: _workShiftController.selectedEmployeeId.value == 0
              ? null
              : _workShiftController.selectedEmployeeId.value,
          hint: Padding(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
            child: AppText(
              text: "Select Employee",
              size: kTextSize - 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          items: employees.map((emp) {
            return DropdownMenuItem<int>(
              value: int.tryParse(emp.id ?? '0') ?? 0,
              child: Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                child: AppText(
                  text: emp.text ?? '-',
                  size: kTextSize - 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) =>
              _workShiftController.onEmployeeChanged(value ?? 0),
          validator: (value) =>
              _workShiftController.validateSelectedEmployee(value ?? 0),
        );
      }),
    );
  }
}
