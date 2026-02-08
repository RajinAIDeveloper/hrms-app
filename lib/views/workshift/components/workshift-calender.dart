// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:root_app/components/components.dart';
// import 'package:root_app/configs/configs.dart';
// import 'package:root_app/controllers/work-shift/workshift_controller.dart';

// import 'package:root_app/constants/constants.dart';

// import 'dart:math' as math;

// class WorkshiftCalender extends StatelessWidget {
//   WorkshiftCalender({
//     super.key,
//   });
//   final _workShiftController = Get.find<WorkshiftController>();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: getProportionateScreenWidth(20),
//         horizontal: getProportionateScreenWidth(20),
//       ),
//       margin: EdgeInsets.symmetric(
//         horizontal: getProportionateScreenWidth(20),
//       ),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 15,
//             color: Colors.black26,
//             offset: Offset.fromDirection(math.pi * .5, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               AppText(
//                 text: "WorkShift Calender",
//                 fontWeight: FontWeight.bold,
//                 color: kPrimaryColor,
//               ),
//             ],
//           ),
//           SizedBox(height: getProportionateScreenWidth(20)),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               AppText(
//                 text: "Employee Selection",
//                 fontWeight: FontWeight.bold,
//                 size: kTextSize - 2,
//               ),
//             ],
//           ),
//           SizedBox(height: getProportionateScreenWidth(10)),

//           SizedBox(height: getProportionateScreenWidth(20)),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               AppText(
//                 text: "Salary Year  ",
//                 fontWeight: FontWeight.bold,
//                 size: kTextSize - 2,
//               ),
//             ],
//           ),
//           SizedBox(height: getProportionateScreenWidth(10)),
//           // buildSalaryYearDropdownField(),
//           SizedBox(height: getProportionateScreenWidth(15)),

//           SizedBox(height: getProportionateScreenWidth(15)),

//           SizedBox(height: getProportionateScreenWidth(20)),
//         ],
//       ),
//     );
//   }

// }

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:root_app/components/components.dart';
// import 'package:root_app/configs/configs.dart';
// import 'package:root_app/constants/constants.dart';
// import 'package:root_app/controllers/work-shift/workshift_controller.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'dart:math' as math;

// class WorkshiftCalender extends StatelessWidget {
//   WorkshiftCalender({super.key});

//   final _workShiftController = Get.find<WorkshiftController>();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         vertical: getProportionateScreenWidth(20),
//         horizontal: getProportionateScreenWidth(20),
//       ),
//       margin: EdgeInsets.symmetric(
//         horizontal: getProportionateScreenWidth(20),
//       ),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(20)),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 15,
//             color: Colors.black26,
//             offset: Offset.fromDirection(math.pi * .5, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const AppText(
//             text: "Workshift Calendar",
//             fontWeight: FontWeight.bold,
//             color: kPrimaryColor,
//           ),
//           SizedBox(height: getProportionateScreenWidth(20)),

//           // Employee dropdown
//           const Align(
//             alignment: Alignment.centerRight,
//             child: AppText(
//               text: "Employee Selection",
//               fontWeight: FontWeight.bold,
//               size: kTextSize - 2,
//             ),
//           ),
//           SizedBox(height: getProportionateScreenWidth(10)),
//           _buildEmployeeDropdown(),
//           SizedBox(height: getProportionateScreenWidth(20)),

//           // Calendar view
//           Obx(() {
//             if (_workShiftController.isLoadingShifts.value) {
//               return SizedBox(
//                 height: 400,
//                 child: const Center(
//                   child: SpinKitThreeBounce(color: kPrimaryColor, size: 30),
//                 ),
//               );
//             }

//             final shifts = _workShiftController.employeeShiftList;
//             if (shifts.isEmpty) {
//               return SizedBox(
//                 height: 400,
//                 child: const Center(child: AppText(text: "No shifts found")),
//               );
//             }

//             // Convert your shift list to a map<DateTime, String>
//             final shiftMap = _workShiftController.generateCalendarMap();

//             return Column(
//               children: [
//                 // Calendar
//                 SizedBox(
//                   height: 350,
//                   child: TableCalendar(
//                     firstDay: DateTime.utc(2024, 1, 1),
//                     lastDay: DateTime.utc(2030, 12, 31),
//                     focusedDay: _workShiftController.focusedDay.value,
//                     calendarFormat: CalendarFormat.month,
//                     availableCalendarFormats: const {
//                       CalendarFormat.month: 'Month'
//                     },
//                     headerStyle: HeaderStyle(
//                       formatButtonVisible: false,
//                       titleCentered: true,
//                       leftChevronIcon:
//                           const Icon(Icons.chevron_left, color: kPrimaryColor),
//                       rightChevronIcon:
//                           const Icon(Icons.chevron_right, color: kPrimaryColor),
//                       titleTextStyle: const TextStyle(
//                           fontWeight: FontWeight.bold, color: kPrimaryColor),
//                     ),
//                     daysOfWeekStyle: const DaysOfWeekStyle(
//                       weekdayStyle:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
//                       weekendStyle: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.redAccent,
//                           fontSize: 12),
//                     ),
//                     calendarStyle: const CalendarStyle(
//                       weekendTextStyle: TextStyle(color: Colors.redAccent),
//                       outsideDaysVisible: false,
//                       cellMargin: EdgeInsets.all(2),
//                       cellPadding: EdgeInsets.all(4),

//                     ),
//                     selectedDayPredicate: (day) =>
//                         isSameDay(day, _workShiftController.selectedDay.value),
//                     onDaySelected: (selectedDay, focusedDay) {
//                       _workShiftController.selectedDay.value = selectedDay;
//                       _workShiftController.focusedDay.value = focusedDay;
//                     },
//                     calendarBuilders: CalendarBuilders(
//                       defaultBuilder: (context, day, focusedDay) {
//                         final shiftText = shiftMap[DateTime(
//                           day.year,
//                           day.month,
//                           day.day,
//                         )];
//                         if (shiftText == null) return null;

//                         return Container(
//                           margin: const EdgeInsets.all(2.0),
//                           decoration: BoxDecoration(
//                             color: shiftText.contains("Weekend")
//                                 ? Colors.red.shade50
//                                 : Colors.green.shade50,
//                             borderRadius:
//                                 const BorderRadius.all(Radius.circular(8)),
//                           ),
//                           alignment: Alignment.center,
//                           child: Stack(
//                             children: [
//                               Center(
//                                 child: Text(
//                                   "${day.day}",
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 bottom: 4,
//                                 left: 0,
//                                 right: 0,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       width: 5,
//                                       height: 5,
//                                       decoration: BoxDecoration(
//                                         color: shiftText.contains("Weekend")
//                                             ? Colors.redAccent
//                                             : Colors.green,
//                                         shape: BoxShape.circle,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: getProportionateScreenWidth(15)),
//                 // Shift details
//                 _buildShiftDetails(shiftMap),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }

//   /// Employee Dropdown
//   Widget _buildEmployeeDropdown() {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: getProportionateScreenWidth(7),
//         vertical: getProportionateScreenWidth(10),
//       ),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         boxShadow: [
//           BoxShadow(
//             blurRadius: 15,
//             color: Colors.black26,
//             offset: Offset.fromDirection(math.pi * .5, 10),
//           ),
//         ],
//       ),
//       child: Obx(() {
//         final employees = _workShiftController.employeeList;
//         final isLoading = _workShiftController.isLoading.value;

//         if (isLoading) {
//           return const Center(
//             child: SpinKitThreeBounce(
//               color: kPrimaryColor,
//               size: 20,
//             ),
//           );
//         }

//         return DropdownButtonFormField<int>(
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             isDense: true,
//             contentPadding: EdgeInsets.zero,
//           ),
//           dropdownColor: Colors.white,
//           icon: const Icon(Icons.keyboard_arrow_down, color: kPrimaryColor),
//           value: _workShiftController.selectedEmployeeId.value == 0
//               ? null
//               : _workShiftController.selectedEmployeeId.value,
//           hint: Padding(
//             padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
//             child: const AppText(
//               text: "Select Employee",
//               size: kTextSize - 2,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           items: employees.map((emp) {
//             return DropdownMenuItem<int>(
//               value: int.tryParse(emp.id ?? '0') ?? 0,
//               child: Padding(
//                 padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
//                 child: AppText(
//                   text: emp.text ?? '-',
//                   size: kTextSize - 2,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             );
//           }).toList(),
//           onChanged: (value) =>
//               _workShiftController.onEmployeeChanged(value ?? 0),
//         );
//       }),
//     );
//   }

//   /// Build shift details for selected day
//   Widget _buildShiftDetails(Map<DateTime, String> shiftMap) {
//     return Obx(() {
//       final selectedDay = _workShiftController.selectedDay.value;
//       if (selectedDay == null) {
//         return const SizedBox.shrink();
//       }

//       final shiftText = shiftMap[DateTime(
//         selectedDay.year,
//         selectedDay.month,
//         selectedDay.day,
//       )];

//       if (shiftText == null) {
//         return const SizedBox.shrink();
//       }

//       return Container(
//         padding: EdgeInsets.all(getProportionateScreenWidth(12)),
//         decoration: BoxDecoration(
//           color: shiftText.contains("Weekend")
//               ? Colors.red.shade50
//               : Colors.green.shade50,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color:
//                 shiftText.contains("Weekend") ? Colors.redAccent : Colors.green,
//             width: 2,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.calendar_today,
//                   size: 16,
//                   color: shiftText.contains("Weekend")
//                       ? Colors.redAccent
//                       : Colors.green,
//                 ),
//                 SizedBox(width: getProportionateScreenWidth(8)),
//                 AppText(
//                   text:
//                       "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
//                   fontWeight: FontWeight.bold,
//                   color: shiftText.contains("Weekend")
//                       ? Colors.redAccent
//                       : Colors.green,
//                 ),
//               ],
//             ),
//             SizedBox(height: getProportionateScreenWidth(8)),
//             AppText(
//               text: shiftText,
//               size: kTextSize - 2,
//               color: shiftText.contains("Weekend")
//                   ? Colors.redAccent
//                   : Colors.green.shade700,
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/work-shift/workshift_controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math;

class WorkshiftCalender extends StatelessWidget {
  WorkshiftCalender({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: "Workshift Calendar",
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
          SizedBox(height: getProportionateScreenWidth(20)),

          // Employee dropdown
          const Align(
            alignment: Alignment.centerRight,
            child: AppText(
              text: "Employee Selection",
              fontWeight: FontWeight.bold,
              size: kTextSize - 2,
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
          _buildEmployeeDropdown(),
          SizedBox(height: getProportionateScreenWidth(20)),

          // Calendar view
          Obx(() {
            if (_workShiftController.isLoadingShifts.value) {
              return const SizedBox(
                height: 400,
                child: Center(
                  child: SpinKitThreeBounce(color: kPrimaryColor, size: 30),
                ),
              );
            }

            final shifts = _workShiftController.employeeShiftList;
            if (shifts.isEmpty) {
              return const SizedBox(
                height: 400,
                child: Center(child: AppText(text: "No shifts found")),
              );
            }

            // Convert your shift list to a map<DateTime, String>
            final shiftMap = _workShiftController.generateCalendarMap();

            return Column(
              children: [
                // Calendar
                SizedBox(
                  height: 400,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _workShiftController.focusedDay.value,
                    calendarFormat: CalendarFormat.month,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month'
                    },
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: kPrimaryColor),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: kPrimaryColor),
                      titleTextStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                      weekendStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                        fontSize: 12,
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      weekendTextStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      defaultTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      todayTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      selectedTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      outsideDaysVisible: false,
                      cellMargin: EdgeInsets.all(2),
                      cellPadding: EdgeInsets.all(4),
                      todayDecoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: kPrimaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    selectedDayPredicate: (day) =>
                        isSameDay(day, _workShiftController.selectedDay.value),
                    onDaySelected: (selectedDay, focusedDay) {
                      _workShiftController.selectedDay.value = selectedDay;
                      _workShiftController.focusedDay.value = focusedDay;
                    },
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final shiftText = shiftMap[DateTime(
                          day.year,
                          day.month,
                          day.day,
                        )];
                        if (shiftText == null) return null;

                        final isWeekend = shiftText.contains("Weekend");

                        return Container(
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: isWeekend
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: isWeekend
                                  ? Colors.redAccent.shade100
                                  : Colors.green.shade200,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  "${day.day}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isWeekend
                                        ? Colors.red.shade700
                                        : Colors.green.shade900,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 5,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: isWeekend
                                            ? Colors.redAccent
                                            : Colors.green.shade700,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: getProportionateScreenWidth(15)),
                // Shift details
                _buildShiftDetails(shiftMap),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Employee Dropdown
  Widget _buildEmployeeDropdown() {
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
            child: const AppText(
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
        );
      }),
    );
  }

  /// Build shift details for selected day
  Widget _buildShiftDetails(Map<DateTime, String> shiftMap) {
    return Obx(() {
      final selectedDay = _workShiftController.selectedDay.value;
      if (selectedDay == null) {
        return const SizedBox.shrink();
      }

      final shiftText = shiftMap[DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      )];

      if (shiftText == null) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(12)),
        decoration: BoxDecoration(
          color: shiftText.contains("Weekend")
              ? Colors.red.shade50
              : Colors.green.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                shiftText.contains("Weekend") ? Colors.redAccent : Colors.green,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: shiftText.contains("Weekend")
                      ? Colors.redAccent
                      : Colors.green,
                ),
                SizedBox(width: getProportionateScreenWidth(8)),
                AppText(
                  text:
                      "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
                  fontWeight: FontWeight.bold,
                  color: shiftText.contains("Weekend")
                      ? Colors.redAccent
                      : Colors.green,
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenWidth(8)),
            AppText(
              text: shiftText,
              size: kTextSize - 2,
              color: shiftText.contains("Weekend")
                  ? Colors.redAccent
                  : Colors.green.shade700,
            ),
          ],
        ),
      );
    });
  }
}
