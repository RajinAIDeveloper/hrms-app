import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/controllers/early_departure/early_departure_controller.dart';
import 'package:root_app/utilities/get_months.dart';
import 'package:root_app/utilities/get_years.dart';
import 'package:root_app/constants/constants.dart';
import 'dart:math' as math;

class EarlyDepartureReport extends StatelessWidget {
  EarlyDepartureReport({
    super.key,
  });
  final _earlyDepartureController = Get.find<EarlyDepartureController>();

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(
  //       vertical: getProportionateScreenWidth(20),
  //       horizontal: getProportionateScreenWidth(20),
  //     ),
  //     margin: EdgeInsets.symmetric(
  //       horizontal: getProportionateScreenWidth(20),
  //     ),
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: const BorderRadius.all(Radius.circular(20)),
  //       boxShadow: [
  //         BoxShadow(
  //           blurRadius: 15,
  //           color: Colors.black26,
  //           offset: Offset.fromDirection(math.pi * .5, 10),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         const Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             AppText(
  //               text: "Early Departure Request",
  //               fontWeight: FontWeight.bold,
  //               color: kPrimaryColor,
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: getProportionateScreenWidth(20)),
  //         const Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             AppText(
  //               text: "Select Month",
  //               fontWeight: FontWeight.bold,
  //               size: kTextSize - 2,
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: getProportionateScreenWidth(10)),
  //         buildSalaryMonthDropdownField(),
  //         SizedBox(height: getProportionateScreenWidth(15)),
  //         const Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             AppText(
  //               text: "Select Year",
  //               fontWeight: FontWeight.bold,
  //               size: kTextSize - 2,
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: getProportionateScreenWidth(10)),
  //         buildSalaryYearDropdownField(),
  //         SizedBox(height: getProportionateScreenWidth(15)),
  //         const Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             AppText(
  //               text: "Select Status",
  //               fontWeight: FontWeight.bold,
  //               size: kTextSize - 2,
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: getProportionateScreenWidth(15)),
  //         buildStatusDropdownField(),
  //         Obx((() => buildErrorMessages())),
  //         SizedBox(height: getProportionateScreenWidth(15)),
  //         _getearlydepartureRecords(),
  //         SizedBox(height: getProportionateScreenWidth(15)),
  //       ],
  //     ),

  //   );

  // }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The card with dropdowns
        Container(
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
                    text: "Early Departure Request",
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
                    text: "Select Month",
                    fontWeight: FontWeight.bold,
                    size: kTextSize - 2,
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenWidth(10)),
              buildSalaryMonthDropdownField(),
              SizedBox(height: getProportionateScreenWidth(15)),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(
                    text: "Select Year",
                    fontWeight: FontWeight.bold,
                    size: kTextSize - 2,
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenWidth(10)),
              buildSalaryYearDropdownField(),
              SizedBox(height: getProportionateScreenWidth(15)),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppText(
                    text: "Select Status",
                    fontWeight: FontWeight.bold,
                    size: kTextSize - 2,
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenWidth(15)),
              buildStatusDropdownField(),
              Obx((() => buildErrorMessages())),
              SizedBox(height: getProportionateScreenWidth(15)),
            ],
          ),
        ),
        // Spacing between the card and the records
        SizedBox(height: getProportionateScreenWidth(20)),
        // The departure records outside the card
        _getearlydepartureRecords(),
      ],
    );
  }

  Container buildSalaryMonthDropdownField() {
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
      child: DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          enabled: false,
          border: InputBorder.none,
        ),
        value: _earlyDepartureController.month.value,
        items: List<DropdownMenuItem<int>>.generate(
          months.length + 1,
          (idx) => DropdownMenuItem<int>(
            value: idx == 0 ? 0 : idx,
            child: Container(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              width: SizeConfig.screenWidth * 0.5,
              child: AppText(
                text: idx == 0 ? "Select Month" : months[idx - 1],
                size: kTextSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onChanged: (value) => _earlyDepartureController.onMonthChanged(value!),
        validator: (value) =>
            _earlyDepartureController.validateSelectedMonth(value!),
        onSaved: (newValue) => _earlyDepartureController
            .earlyDepartureReportModel.month = newValue,
      ),
    );
  }

  Container buildSalaryYearDropdownField() {
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
      child: DropdownButtonFormField<int>(
        decoration:
            const InputDecoration(enabled: false, border: InputBorder.none),
        value: _earlyDepartureController.year.value,
        items: List<DropdownMenuItem<int>>.generate(
          years.length + 1,
          (idx) => DropdownMenuItem<int>(
            value: idx == 0 ? 0 : years[idx - 1],
            child: Container(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              width: SizeConfig.screenWidth * 0.5,
              child: AppText(
                text: idx == 0 ? "Select Year" : years[idx - 1].toString(),
                size: kTextSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onChanged: (value) => _earlyDepartureController.onYearChanged(value!),
        validator: (value) =>
            _earlyDepartureController.validateSelectedYear(value!),
        onSaved: (newValue) =>
            _earlyDepartureController.earlyDepartureReportModel.year = newValue,
      ),
    );
  }

  Container buildStatusDropdownField() {
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
      child: DropdownButtonFormField<int>(
        decoration:
            const InputDecoration(enabled: false, border: InputBorder.none),
        value: _earlyDepartureController.statestatus.value,
        items: List<DropdownMenuItem<int>>.generate(
          _earlyDepartureController.statuses.length,
          (idx) => DropdownMenuItem<int>(
            value:
                idx, // Use index as value (0 for "---Select Status---", 1 for "Pending", etc.)
            child: Container(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
              width: SizeConfig.screenWidth * 0.5,
              child: AppText(
                text: _earlyDepartureController.statuses[idx],
                size: kTextSize - 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        onChanged: (value) => _earlyDepartureController.onStatusChanged(value!),
        validator: (value) =>
            _earlyDepartureController.validateSelectedStatus(value!),
        onSaved: (newValue) => _earlyDepartureController
            .earlyDepartureReportModel
            .statestatus = newValue, // Save status string or null if default
      ),
    );
  }

  // Container _getearlydepartureRecords() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(
  //       horizontal: getProportionateScreenWidth(20),
  //     ),
  //     padding: EdgeInsets.symmetric(
  //       vertical: getProportionateScreenWidth(20),
  //       horizontal: getProportionateScreenWidth(20),
  //     ),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: const BorderRadius.all(Radius.circular(20)),
  //       boxShadow: [
  //         BoxShadow(
  //           blurRadius: 15,
  //           color: Colors.black26,
  //           offset: Offset.fromDirection(math.pi * .5, 10),
  //         ),
  //       ],
  //     ),
  //     child: Obx(() {
  //       if (_earlyDepartureController.isLoading.value) {
  //         return const Center(child: CircularProgressIndicator());
  //       }
  //       return Column(
  //         children: [
  //           const CustomTableHeader(
  //             headerTitles: [
  //               "#SL",
  //               "Date",
  //               "In-Time",
  //               "Attendance Status",
  //               "Out Time",
  //               "Day-Name",
  //               "Departure Time",
  //               "Departure Date",
  //               "Purpose",
  //               "Update",
  //               "Status",
  //             ],
  //             colSizes: [
  //               8,
  //               12,
  //               12,
  //               8,
  //               12,
  //               12,
  //               8,
  //               12,
  //               8,
  //               12,
  //               8,
  //             ], // Adjust column widths as needed
  //           ),
  //           SizedBox(height: getProportionateScreenHeight(5)),
  //           CustomTableBody(
  //             colSizes: const [
  //               8,
  //               12,
  //               12,
  //               8,
  //               12,
  //               12,
  //               8,
  //               12,
  //               8,
  //               12,
  //               8,
  //             ],
  //             bodyData: _getTableBody(),
  //           ),
  //         ],
  //       );
  //     }),
  //   );
  // }

  Container _getearlydepartureRecords() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(10),
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
        if (_earlyDepartureController.isLoading.value) {
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
                      const CustomTableHeader(
                        headerTitles: [
                          "#SL",
                          "Date",
                          //"In-Time",
                          "Attendance Status",
                          "Applied Time",
                          "Applied Date",
                          // "Out Time",
                          "Day-Name",
                          "Departure Time",
                          "Departure Date",
                          "Purpose",
                          // "Update",
                          "Status",
                        ],
                        colSizes: [
                          8,
                          12,
                          12,
                          8,
                          12,
                          12,
                          8,
                          12,
                          8,
                          12,
                        ],
                      ),
                      SizedBox(height: getProportionateScreenHeight(5)),
                      SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                          child: CustomTableBody(
                            colSizes: const [
                              8,
                              12,
                              12,
                              8,
                              12,
                              12,
                              8,
                              12,
                              8,
                              12,
                            ],
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
    );
  }

  List<List<String>> _getTableBody() {
    List<List<String>> result = [];
    int serialNumber = 1; // Start serial number from 1
    for (var record in _earlyDepartureController.earlyDepartureList) {
      List<String> row = [];
      row.add(serialNumber.toString()); // Serial number
      row.add(record.transactionDate.toString());
      row.add(record.status.toString());
      row.add(record.appliedTime.toString());
      row.add(record.appliedDate.toString());
      row.add(record.dayName.toString());
      row.add(record.departureTime);
      row.add(record.departureDate.toString());
      row.add(record.stateStatus.toString());
      row.add(record.appliedTime.toString());
      result.add(row);
    }
    return result;
  }

  FormError buildErrorMessages() =>
      FormError(errors: _earlyDepartureController.errors.toList());
}
