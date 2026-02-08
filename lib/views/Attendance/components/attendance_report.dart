import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'dart:math' as math;
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/Attendance/attendance_controller.dart';
import 'package:root_app/constants/constants.dart'; // Added import for kPrimaryColor

class AttendanceReport extends StatelessWidget {
  AttendanceReport({super.key});

  final AttendanceController _attendanceController =
      Get.find<AttendanceController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Regular Attendance Table
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(20),
          ),
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
          child: Obx(() {
            if (_attendanceController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            text: "Regular Attendance",
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          const CustomTableHeader(
                            headerTitles: [
                              "#SL",
                              "Date",
                              "In Time",
                              "In Time Remarks",
                              "Out Time",
                              "Out Time Remarks",
                            ],
                            colSizes: [8, 12, 12, 12, 12, 12, 12],
                          ),
                          SizedBox(height: getProportionateScreenHeight(5)),
                          IntrinsicHeight(
                            child: SingleChildScrollView(
                              child: CustomTableBody(
                                colSizes: const [8, 12, 12, 12, 12, 12, 12],
                                bodyData: _getTableBody(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),

        SizedBox(height: getProportionateScreenHeight(20)),

        // Manual Attendance Table
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
          ),
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenWidth(20),
            horizontal: getProportionateScreenWidth(20),
          ),
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
          child: Obx(() {
            if (_attendanceController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            text: "Manual Attendance",
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor,
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          const CustomTableHeader(
                            headerTitles: [
                              "#SL",
                              "Employee",
                              "Department",
                              "Designation",
                              "Attendance Date",
                              "Reason",
                              "Time Request For",
                              "Time",
                              "Status",
                              "Entry Date",
                              "Action",
                            ],
                            colSizes: [
                              8,
                              12,
                              12,
                              12,
                              12,
                              12,
                              12,
                              12,
                              12,
                              12,
                              12
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(5)),
                          IntrinsicHeight(
                            child: SingleChildScrollView(
                              child: CustomTableBody(
                                colSizes: const [
                                  8,
                                  12,
                                  12,
                                  12,
                                  12,
                                  12,
                                  12,
                                  12,
                                  12,
                                  12,
                                  12
                                ],
                                bodyData: _getManualTableBody().isEmpty
                                    ? [List.filled(11, "No Data")]
                                    : _getManualTableBody(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  List<List<String>> _getTableBody() {
    List<List<String>> result = [];
    int serialNumber = 1; // Start serial number from 1
    for (var record in _attendanceController.attendanceList) {
      List<String> row = [];
      row.add(serialNumber.toString()); // Serial number
      row.add(record.date.toString());
      row.add(record.punchIn ?? "N/A");
      row.add(record.attendanceInRemarks ?? "N/A");
      row.add(record.punchOut ?? "N/A");
      row.add(record.attendanceOutRemarks ?? "N/A");

      result.add(row);
      serialNumber++;
    }
    return result;
  }

  List<List<String>> _getManualTableBody() {
    List<List<String>> result = [];
    int serialNumber = 1;
    for (var record in _attendanceController.manualAttendanceList) {
      List<String> row = [];
      row.add(serialNumber.toString());
      row.add(record.employeeName ?? "N/A");
      row.add(record.departmentName ?? "N/A");
      row.add(record.designationName ?? "N/A");
      row.add(record.attendanceDate.toString());
      row.add(record.reason);
      row.add(record.timeRequestFor);
      row.add("${record.inTime ?? 'N/A'} - ${record.outTime ?? 'N/A'}");
      row.add(record.stateStatus ?? "N/A");
      row.add(record.attendanceDate.toString());
      row.add("View");
      result.add(row);
      serialNumber++;
    }
    return result;
  }
}
