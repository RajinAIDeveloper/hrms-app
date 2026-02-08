import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/leave/leave_controller.dart';
import 'dart:math' as math;

import 'package:root_app/views/leave/components/components.dart';

class LeaveSelf extends StatelessWidget {
  LeaveSelf({
    super.key,
  });
  final _leaveController = Get.find<LeaveController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _getLeaveBalance(),
        SizedBox(height: getProportionateScreenHeight(20)),
        _getLeaveApplyForm(),
        SizedBox(height: getProportionateScreenHeight(20)),
        _getLeaveRecords()
      ],
    );
  }

  Container _getLeaveBalance() {
    return Container(
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
      child: Obx((() => _leaveController.leaveBalance.isEmpty
          ? const CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: "Leave Balance",
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                const CustomTableHeader(
                  headerTitles: [
                    "Leave Type",
                    "Allocated",
                    "Availed",
                    "Balance"
                  ],
                  colSizes: [6, 5, 4, 5, 5],
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                CustomTableBody(
                  colSizes: const [6, 5, 4, 5, 5],
                  bodyData: _getLeaveBalanceTableBody(),
                ),
              ],
            ))),
    );
  }

  List<List<String>> _getLeaveBalanceTableBody() {
    List<List<String>> result = [];
    for (var balance in _leaveController.leaveBalance) {
      List<String> row = [];
      row.add(balance.leaveTypeName.toString());
      row.add(balance.allottedLeave.toString());
      row.add(balance.yearlyLeaveTypeAvailed.toString());
      row.add(balance.yearlyLeaveTypeBalance.toString());

      result.add(row);
    }
    return result;
  }

  Container _getLeaveRecords() {
    return Container(
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
      child: Obx((() => _leaveController.leaveAppliedRecords.isEmpty
          ? const CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  text: "Leave Requests",
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                SizedBox(
                  width: SizeConfig.screenWidth - 40,
                  height: getProportionateScreenHeight(12) * 15,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        (_leaveController.leaveAppliedRecords.length) + 1,
                    itemBuilder: (context, idx) {
                      if (idx == 0) {
                        return const Column(
                          children: [
                            LeaveRequestCell(
                              isLeftRounded: true,
                              isDark: true,
                              text: "Leave Type",
                            ),
                            LeaveRequestCell(
                              isLeftRounded: true,
                              isDark: true,
                              text: "Date",
                            ),
                            LeaveRequestCell(
                              isLeftRounded: true,
                              isDark: true,
                              text: "Total Days",
                            ),
                            LeaveRequestCell(
                              isLeftRounded: true,
                              isDark: true,
                              text: "Status",
                            ),
                            LeaveRequestCell(
                              isLeftRounded: true,
                              isDark: true,
                              text: "Remarks",
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            LeaveRequestCell(
                              isRightRounded: idx ==
                                  (_leaveController.leaveAppliedRecords.length),
                              text: _leaveController
                                  .leaveAppliedRecords[idx - 1].leaveTypeName
                                  .toString(),
                            ),
                            LeaveRequestCell(
                              isRightRounded: idx ==
                                  (_leaveController.leaveAppliedRecords.length),
                              text: _leaveController
                                  .leaveAppliedRecords[idx - 1].date
                                  .toString(),
                            ),
                            LeaveRequestCell(
                              isRightRounded: idx ==
                                  (_leaveController.leaveAppliedRecords.length),
                              text: _leaveController
                                  .leaveAppliedRecords[idx - 1].appliedTotalDays
                                  .toString(),
                            ),
                            LeaveRequestCell(
                              isRightRounded: idx ==
                                  (_leaveController.leaveAppliedRecords.length),
                              text: _leaveController
                                  .leaveAppliedRecords[idx - 1].stateStatus
                                  .toString(),
                            ),
                            LeaveRequestCell(
                              isRightRounded: idx ==
                                  (_leaveController.leaveAppliedRecords.length),
                              text: _leaveController
                                  .leaveAppliedRecords[idx - 1].approvalRemarks
                                  .toString(),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                )
              ],
            ))),
    );
  }

  Container _getLeaveApplyForm() {
    return Container(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: "Leave Apply",
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            Obx((() => Form(
                key: _leaveController.leaveFormKey,
                autovalidateMode: _leaveController.autoValidate.value,
                child: Column(
                  children: [
                    //buildUsernameFormField(),
                    buildLeaveTypeDropdownField(),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    buildLeaveDurationsDropdownField(),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    _leaveController.isHalfDayLeave.value
                        ? buildHalfDayDurationsDropdownField()
                        : const SizedBox.shrink(),
                    _leaveController.isHalfDayLeave.value
                        ? SizedBox(height: getProportionateScreenHeight(16))
                        : const SizedBox.shrink(),

                    buildAppliedDateField(),
                    SizedBox(height: getProportionateScreenHeight(16)),
                    buildLeavePurposeFormField(),
                    SizedBox(height: getProportionateScreenHeight(16)),

                    buildEmergencyPhoneFormField(),
                    SizedBox(height: getProportionateScreenWidth(16)),

                    buildAddressDuringLeaveFormField(),
                    SizedBox(height: getProportionateScreenWidth(16)),
                    // buildRecommenderFormField(),
                    // SizedBox(height: getProportionateScreenWidth(16)),
                    // buildFinalApproverFormField(),
                    // SizedBox(height: getProportionateScreenWidth(16)),

                    Obx((() => buildErrorMessages())),
                    SizedBox(height: getProportionateScreenWidth(8)),

                    Stack(children: [
                      AppDefaultButton(
                        text: !_leaveController.isLoading.value ? "Submit" : "",
                        //   press: () async {
                        //     if (_leaveController.leaveFormKey.currentState!
                        //         .validate()) {
                        //       _leaveController.leaveFormKey.currentState!.save();
                        //       try {
                        //         // await _leaveController.login().then((value) {
                        //         //   Provider.of<UserProvider>(
                        //         //     context,
                        //         //     listen: false,
                        //         //   ).user = value.userInfo;
                        //         //   Navigator.pushNamedAndRemoveUntil(
                        //         //     context,
                        //         //     LOGIN_SUCCESS_SCREEN,
                        //         //     (_) => false,
                        //         //   );
                        //         debugPrint(
                        //             '====================>>>>>>  Successful <<<<<<==================');
                        //         Get.showSnackbar(
                        //           GetSnackBar(
                        //             title: 'Success',
                        //             message:
                        //                 'Message : ${'Submit Successful'.toString()}',
                        //             icon: const Icon(
                        //               Icons.add_task_outlined,
                        //               color: Colors.white,
                        //             ),
                        //             duration: const Duration(seconds: 3),
                        //             backgroundColor: Colors.green,
                        //           ),
                        //         );
                        //       } catch (e) {
                        //         _leaveController.isLoading.value = false;
                        //         Get.showSnackbar(
                        //           GetSnackBar(
                        //             title: 'Error',
                        //             message: 'Message : ${e.toString()}',
                        //             icon: const Icon(
                        //               Icons.do_not_touch_outlined,
                        //               color: Colors.white,
                        //             ),
                        //             duration: const Duration(seconds: 3),
                        //             backgroundColor: Colors.red.shade700,
                        //           ),
                        //         );
                        //       }
                        //     } else {
                        //       debugPrint(
                        //           '====================>>>>>> Validation Failed <<<<<<==================');

                        //       _leaveController.autoValidate.value =
                        //           AutovalidateMode.always;
                        //     }
                        //   },

                        press: () async {
                          await _leaveController.submitLeaveRequest();
                        },
                      ),
                      _leaveController.isLoading.value
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenHeight(14),
                              ),
                              child: const SpinKitThreeBounce(
                                color: kDotColor,
                                size: 30,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ]),
                  ],
                ))))
          ],
        ));
  }

  // Container buildLeaveTypeDropdownField() {
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
  //     child: DropdownButtonFormField<int>(
  //       decoration: const InputDecoration(
  //         enabled: false,
  //         border: InputBorder.none,
  //       ),
  //       value: _leaveController.leaveType.value,
  //       items: List<DropdownMenuItem<int>>.generate(
  //         _leaveController.leaveTypeDropdown.length + 1,
  //         (idx) => DropdownMenuItem<int>(
  //           value: idx == 0
  //               ? 0
  //               : int.tryParse(
  //                       _leaveController.leaveTypeDropdown[idx - 1].id!) ??
  //                   0,
  //           child: Container(
  //             padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
  //             width: SizeConfig.screenWidth * 0.5,
  //             child: AppText(
  //               text: idx == 0
  //                   ? "Select Leave type"
  //                   : '${_leaveController.leaveTypeDropdown[idx - 1].text!} ',
  //               size: kTextSize - 2,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //       onChanged: (value) => _leaveController.onLeaveTypeChanged(value!),
  //       validator: (value) =>
  //           _leaveController.validateSelectedLeaveType(value!),
  //       //onSaved: (newValue) => _leaveController.payrollReportModel.month = newValue,
  //     ),
  //   );
  // }

  // Container buildLeaveTypeDropdownField() {
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
  //     child: DropdownButtonFormField<int>(
  //       decoration: const InputDecoration(
  //         enabled: false,
  //         border: InputBorder.none,
  //       ),
  //       value: _leaveController.leaveType.value,
  //       items: List<DropdownMenuItem<int>>.generate(
  //         _leaveController.leaveTypeDropdown.length + 1,
  //         (idx) => DropdownMenuItem<int>(
  //           value: idx == 0
  //               ? 0
  //               : int.tryParse(
  //                       _leaveController.leaveTypeDropdown[idx - 1].id!) ??
  //                   0,
  //           child: Container(
  //             padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
  //             width: SizeConfig.screenWidth * 0.5,
  //             child: AppText(
  //               text: idx == 0
  //                   ? "Select Leave type"
  //                   : '${_leaveController.leaveTypeDropdown[idx - 1].text!} ',
  //               size: kTextSize - 2,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //       onChanged: (value) {
  //         // Handle null safely by providing a default value (0)
  //         final selectedValue = value ?? 0;

  //         // Check if the value is not 0 (the default "Select Leave type" option)
  //         if (selectedValue != 0) {
  //           // Find the corresponding leave type ID from the dropdown data
  //           final selectedItem = _leaveController.leaveTypeDropdown.firstWhere(
  //               (item) => int.tryParse(item.id!) == selectedValue,
  //               orElse: () => _leaveController.leaveTypeDropdown[0]);

  //           // Pass the actual ID to the controller (now non-nullable)
  //           _leaveController.onLeaveTypeChanged(selectedValue);

  //           // For debugging
  //           print(
  //               '=======>>>>>> Selected ID : $selectedValue || Leave Type : ${selectedItem.text} <<<<<<======');
  //         } else {
  //           _leaveController.onLeaveTypeChanged(0);
  //         }
  //       },
  //       validator: (value) =>
  //           _leaveController.validateSelectedLeaveType(value ?? 0),
  //     ),
  //   );
  // }

  Widget buildLeaveTypeDropdownField() {
    return Obx(() => Container(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(7),
            right: getProportionateScreenWidth(3),
            top: getProportionateScreenWidth(10),
            bottom: getProportionateScreenWidth(10),
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
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              enabled: false,
              border: InputBorder.none,
            ),
            value: _leaveController.leaveType.value,
            items: List<DropdownMenuItem<int>>.generate(
              _leaveController.leaveTypeDropdown.length + 1,
              (idx) => DropdownMenuItem<int>(
                value: idx == 0
                    ? 0
                    : int.tryParse(
                            _leaveController.leaveTypeDropdown[idx - 1].id!) ??
                        0,
                child: Container(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(20)),
                  width: SizeConfig.screenWidth * 0.5,
                  child: AppText(
                    text: idx == 0
                        ? "Select Leave type"
                        : '${_leaveController.leaveTypeDropdown[idx - 1].text!} ',
                    size: kTextSize - 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            onChanged: (value) {
              final selectedValue = value ?? 0;
              if (selectedValue != 0) {
                final selectedItem = _leaveController.leaveTypeDropdown
                    .firstWhere(
                        (item) => int.tryParse(item.id!) == selectedValue,
                        orElse: () => _leaveController.leaveTypeDropdown[0]);
                _leaveController.onLeaveTypeChanged(selectedValue);
                print(
                    '=======>>>>>> Selected ID : $selectedValue || Leave Type : ${selectedItem.text} <<<<<<======');
              } else {
                _leaveController.onLeaveTypeChanged(0);
              }
            },
            validator: (value) =>
                _leaveController.validateSelectedLeaveType(value ?? 0),
          ),
        ));
  }

// Applied Date Field (Date Picker for Single Day or Range)
  Container buildAppliedDateField() {
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(7),
        right: getProportionateScreenWidth(3),
        top: getProportionateScreenWidth(10),
        bottom: getProportionateScreenWidth(10),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset.fromDirection(math.pi * 0.5, 10),
          ),
        ],
      ),
      child: Obx(() {
        debugPrint(
            'Rebuilding date field: appliedFromDate=${_leaveController.appliedFromDate.value}');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label and Total Leave Days
            Padding(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              child: Row(
                children: [
                  AppText(
                    text:
                        'Applied Date${_leaveController.leaveDuration.value == 'Full-Day' ? ' Range' : ''}',
                    size: kTextSize - 2,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(width: getProportionateScreenWidth(5)),
                  AppText(
                    text: '*',
                    size: kTextSize - 2,
                    color: Colors.red,
                  ),
                  if (_leaveController.totalLeave.value > 0)
                    Container(
                      margin: EdgeInsets.only(
                          left: getProportionateScreenWidth(10)),
                      padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(8),
                        vertical: getProportionateScreenWidth(4),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellow[700],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: AppText(
                        text:
                            'Total Leave Days: ${_leaveController.totalLeave.value}',
                        size: kTextSize - 4,
                        color: Colors.black,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenWidth(8)),
            // Input Field with Icon and Clear Button
            Row(
              children: [
                // Calendar Icon
                Padding(
                  padding:
                      EdgeInsets.only(left: getProportionateScreenWidth(20)),
                  child: Icon(
                    Icons.calendar_today,
                    size: kTextSize,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(10)),
                // Date Input
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      debugPrint('Opening date range picker');
                      final DateTimeRange? range = await showDateRangePicker(
                        context: Get.context!,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDateRange:
                            _leaveController.appliedFromDate.value,
                        helpText: _leaveController.leaveDuration.value ==
                                'Half-Day'
                            ? 'Select a single date or range (tap same date for one day)'
                            : 'Select a date range or single date (tap same date for one day)',
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (range != null) {
                        debugPrint(
                            'Selected range: ${range.start} to ${range.end}');
                        _leaveController.setDateRange(range);
                      } else {
                        debugPrint('No range selected');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenWidth(10),
                      ),
                      child: AppText(
                        text: _leaveController.getFormattedDate(),
                        size: kTextSize - 2,
                        color:
                            _leaveController.getFormattedDate() == 'Select Date'
                                ? Colors.grey
                                : Colors.black,
                      ),
                    ),
                  ),
                ),
                // Clear Button
                if (_leaveController.appliedFromDate.value != null)
                  GestureDetector(
                    onTap: () {
                      debugPrint('Clearing date');
                      _leaveController.clearDate();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: getProportionateScreenWidth(10)),
                      child: Icon(
                        Icons.close,
                        size: kTextSize,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
            // Validation Error
            if (_leaveController.errors.contains('appliedFromDateError'))
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
                child: AppText(
                  text:
                      'Please select a date${_leaveController.leaveDuration.value == 'Full-Day' ? ' or range' : ''}',
                  size: kTextSize - 4,
                  color: Colors.red,
                ),
              ),
          ],
        );
      }),
    );
  }

  Container buildLeaveDurationsDropdownField() {
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(7),
        right: getProportionateScreenWidth(3),
        top: getProportionateScreenWidth(10),
        bottom: getProportionateScreenWidth(10),
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
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          enabled: false,
          border: InputBorder.none,
        ),
        value: _leaveController.leaveDuration.value,
        items: List<DropdownMenuItem<String>>.generate(
          _leaveController.leaveDurationItems.length + 1,
          (idx) => DropdownMenuItem<String>(
            value: idx == 0
                ? ''
                : _leaveController.leaveDurationItems[idx - 1].id!,
            child: Container(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              width: SizeConfig.screenWidth * 0.5,
              child: AppText(
                text: idx == 0
                    ? "Select Leave Duration"
                    : '${_leaveController.leaveDurationItems[idx - 1].name} ',
                size: kTextSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onChanged: (value) => _leaveController.onLeaveDurationChanged(value!),
        validator: (value) =>
            _leaveController.validateSelectedLeaveDuration(value!),
        //onSaved: (newValue) => _leaveController.payrollReportModel.month = newValue,
      ),
    );
  }

  Container buildHalfDayDurationsDropdownField() {
    return Container(
      padding: EdgeInsets.only(
        left: getProportionateScreenWidth(7),
        right: getProportionateScreenWidth(3),
        top: getProportionateScreenWidth(10),
        bottom: getProportionateScreenWidth(10),
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
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          enabled: false,
          border: InputBorder.none,
        ),
        value: _leaveController.halfDayDuration.value,
        items: List<DropdownMenuItem<String>>.generate(
          _leaveController.halfDayDurationItems.length + 1,
          (idx) => DropdownMenuItem<String>(
            value: idx == 0
                ? ''
                : _leaveController.halfDayDurationItems[idx - 1].id!,
            child: Container(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              width: SizeConfig.screenWidth * 0.5,
              child: AppText(
                text: idx == 0
                    ? "Select Half-Day Duration"
                    : '${_leaveController.halfDayDurationItems[idx - 1].name} ',
                size: kTextSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onChanged: (value) => _leaveController.onHalfDayDurationChanged(value!),
        validator: (value) =>
            _leaveController.validateSelectedHalfDayDuration(value!),
        //onSaved: (newValue) => _leaveController.payrollReportModel.month = newValue,
      ),
    );
  }

  AppTextField buildLeavePurposeFormField() {
    return AppTextField(
      controller: _leaveController.leavePurposeController,
      keyboardType: TextInputType.text,
      labelText: 'Leave Purpose ',
      hintText: '',
      floatingLabelBehavior: FloatingLabelBehavior.always,
      onChanged: (value) => _leaveController.onLeavePurposeChanged(value),
      validator: (value) => _leaveController.validateLeavePurpose(value!),
      // onSaved: (newValue) => _leaveController.signInModel.username = newValue!,
    );
  }

  AppTextField buildEmergencyPhoneFormField() {
    return AppTextField(
      controller: _leaveController.emergencyPhoneController,
      keyboardType: TextInputType.text,
      labelText: 'Emergency Phone ',
      hintText: '',
      floatingLabelBehavior: FloatingLabelBehavior.always,
      onChanged: (value) => _leaveController.onEmergencyPhoneChanged(value),
      validator: (value) => _leaveController.validateEmergencyPhone(value!),
      // onSaved: (newValue) => _leaveController.signInModel.username = newValue!,
    );
  }

  AppTextField buildAddressDuringLeaveFormField() {
    return AppTextField(
      controller: _leaveController.addressDuringLeaveController,
      keyboardType: TextInputType.text,
      labelText: 'Address During Leave',
      hintText: '',
      floatingLabelBehavior: FloatingLabelBehavior.always,
      onChanged: (value) => _leaveController.onAddressDuringLeaveChanged(value),
      validator: (value) => _leaveController.validateAddressDuringLeave(value!),
      // onSaved: (newValue) => _leaveController.signInModel.username = newValue!,
    );
  }

  // AppTextField buildRecommenderFormField() {
  //   return AppTextField(
  //     controller: _leaveController.recommenderController,
  //     keyboardType: TextInputType.text,
  //     labelText: 'Recommender',
  //     hintText: '',
  //     floatingLabelBehavior: FloatingLabelBehavior.always,
  //     // onChanged: (value) => _leaveController.onAddressDuringLeaveChanged(value),
  //     // validator: (value) => _leaveController.validateAddressDuringLeave(value!),
  //     // onSaved: (newValue) => _leaveController.signInModel.username = newValue!,
  //     readOnly: true,
  //   );
  // }

  // AppTextField buildFinalApproverFormField() {
  //   return AppTextField(
  //     controller: _leaveController.finalApproverController,
  //     keyboardType: TextInputType.text,
  //     labelText: 'Final Approver',
  //     hintText: '',
  //     floatingLabelBehavior: FloatingLabelBehavior.always,
  //     // onChanged: (value) => _leaveController.onAddressDuringLeaveChanged(value),
  //     // validator: (value) => _leaveController.validateAddressDuringLeave(value!),
  //     // onSaved: (newValue) => _leaveController.signInModel.username = newValue!,
  //     readOnly: true,
  //   );
  // }

  Row buildUploadFileField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: (SizeConfig.screenWidth - 80) * 0.7,
          padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(15),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: Colors.black26,
                offset: Offset.fromDirection(math.pi * .5, 4),
              ),
            ],
          ),
          child: Text(
            _leaveController.attachmentName.value == ''
                ? _leaveController.attachmentName.value
                : "Attachment",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _leaveController.attachmentName.value == ''
                  ? Colors.black45
                  : Colors.black,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            var status = await Permission.storage.status;
            if (!status.isGranted) {
              status = await Permission.storage.request();
              if (!status.isGranted) {
                Get.showSnackbar(
                  GetSnackBar(
                    title: 'Error',
                    message: 'Message : Please allow storage permission!}',
                    icon: const Icon(
                      Icons.do_not_touch_outlined,
                      color: Colors.white,
                    ),
                    duration: const Duration(seconds: 3),
                    backgroundColor: Colors.red.shade700,
                  ),
                );

                return;
              }
            }
            // final pickedFile = await FilePicker.getFile(
            //   type: FileType.custom,
            //   allowedExtensions: ["pdf", "jpeg", "jpg", "docx", "png"],
            // );
            // if (pickedFile == null) return;
            // final fileCotent = base64Encode(pickedFile.readAsBytesSync());

            FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
              allowMultiple: false,
              type: FileType.custom,
              allowedExtensions: ["pdf", "jpeg", "jpg", "docx", "png"],
            );

            if (pickedFile == null) return;
            File file = File(pickedFile.files.single.path!);

            final fileCotent = base64Encode(file.readAsBytesSync());

            // setState(() {
            //   attachmentName = pickedFile.path.split("/").last;
            //   attachmentExtention =
            //       pickedFile.path.split("/").last.split(".").last;
            //   attachmentContent = fileCotent;
            //   attachmentPath = pickedFile.path;
            // });
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: (SizeConfig.screenWidth - 80) * 0.28,
            decoration: const BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                )),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.camera_enhance_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  FormError buildErrorMessages() =>
      FormError(errors: _leaveController.errors.toList());
}
