import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
// Add DateFormat import
import 'package:root_app/components/components.dart'; // Assuming AppText is here
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/const_colors.dart';
import 'package:root_app/constants/const_size.dart';
import 'package:root_app/controllers/Expense/expense_controller.dart';
import 'package:root_app/enums/page_enum.dart';

class ExpenseRequestScreen extends StatelessWidget {
  ExpenseRequestScreen({super.key});

  //final ExpenseController _controller = Get.find<ExpenseController>();
  final ExpenseController _expenseController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);

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
            offset: Offset.fromDirection(math.pi * 0.5, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText(
                text: "Expense Request",
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
              // ElevatedButton.icon(
              //   onPressed: () => _expenseController.showModal(0, '', '', ''),
              //   icon: const Icon(Icons.add),
              //   label: const Text('Request'),
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              // ),
              ElevatedButton.icon(
                onPressed: () {
                  _expenseController.pageScreen.value =
                      ExpenseScreen.ExpenseForm;
                  debugPrint(_expenseController.pageScreen.toString());
                  _expenseController.restoreDefultValues();
                },
                icon: const Icon(Icons.add),
                label: const Text('Request'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(20)),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTransactionTypeDropdown(),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  buildTransactionDateFieldRange(),
                  //_buildDateRangeField(),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  _buildStatusDropdown(),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  Obx(() =>
                      FormError(errors: _expenseController.errors.toList())),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  // Obx(() => _buildSubmitButton()),
                ],
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(20)),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: SizeConfig.screenHeight * 0.5,
              ),
              child: Obx(() => _buildTableView(context)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const AppText(
          text: "Search By Type",
          fontWeight: FontWeight.bold,
          size: kTextSize - 2,
        ),
        SizedBox(height: getProportionateScreenWidth(5)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(7),
            vertical: getProportionateScreenWidth(10),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black26,
                offset: Offset.fromDirection(math.pi * 0.5, 10),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration:
                const InputDecoration(enabled: false, border: InputBorder.none),
            value: _expenseController.transactionType.value.isEmpty
                ? null
                : _expenseController.transactionType.value,
            items: _expenseController.transactionTypes
                .map((type) => DropdownMenuItem<String>(
                      value: type,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: getProportionateScreenWidth(20)),
                        width: SizeConfig.screenWidth * 0.5,
                        child: AppText(
                          text: type,
                          size: kTextSize - 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                .toList()
              ..insert(
                0,
                DropdownMenuItem<String>(
                  value: '',
                  child: Container(
                    padding:
                        EdgeInsets.only(left: getProportionateScreenWidth(20)),
                    width: SizeConfig.screenWidth * 0.5,
                    child: const AppText(
                      text: "---Select Type---",
                      size: kTextSize - 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            onChanged: _expenseController.onTransactionTypeChanged,
          ),
        ),
      ],
    );
  }

  // Widget buildDatePicker() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: [
  //       const Text(
  //         "Search By Date",
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: kTextSize - 2,
  //         ),
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(5)),
  //       Container(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: getProportionateScreenWidth(7),
  //           vertical: getProportionateScreenWidth(10),
  //         ),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(10),
  //           boxShadow: [
  //             BoxShadow(
  //               blurRadius: 15,
  //               color: Colors.black12,
  //               offset: Offset.fromDirection(math.pi * 0.5, 10),
  //             ),
  //           ],
  //         ),
  //         child: InkWell(
  //           onTap: () async {
  //             final DateTime? picked = await showDatePicker(
  //               context: Get.context!,
  //               initialDate: _expenseController.selectedDate.value,
  //               firstDate: DateTime(2000),
  //               lastDate: DateTime(2101),
  //             );
  //             if (picked != null) {
  //               _expenseController.selectedDate.value = picked;
  //             }
  //           },
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(
  //               horizontal: getProportionateScreenWidth(20),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Obx(() => Text(
  //                       DateFormat('yyyy-MM-dd')
  //                           .format(_expenseController.selectedDate.value),
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.w300,
  //                       ),
  //                     )),
  //                 const Icon(Icons.calendar_today),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  // Widget buildDatePicker() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //     children: [
  //       const AppText(
  //         text: "Search By Date",
  //         fontWeight: FontWeight.bold,
  //         size: kTextSize - 2,
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(5)),
  //       Container(
  //         padding: EdgeInsets.symmetric(
  //           horizontal: getProportionateScreenWidth(7),
  //           vertical: getProportionateScreenWidth(10),
  //         ),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(10),
  //           boxShadow: [
  //             BoxShadow(
  //               blurRadius: 15,
  //               color: Colors.black26,
  //               offset: Offset.fromDirection(math.pi * 0.5, 10),
  //             ),
  //           ],
  //         ),
  //         child: InkWell(
  //           onTap: () async {
  //             final DateTime? picked = await showDatePicker(
  //               context: Get.context!,
  //               initialDate: _expenseController.selectedDate.value,
  //               firstDate: DateTime(2000),
  //               lastDate: DateTime(2101),
  //             );
  //             if (picked != null) {
  //               _expenseController.selectedDate.value = picked;
  //             }
  //           },
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(
  //               horizontal: getProportionateScreenWidth(20),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Obx(() => AppText(
  //                       text: DateFormat('yyyy-MM-dd')
  //                           .format(_expenseController.selectedDate.value),
  //                       size: kTextSize - 2,
  //                       fontWeight: FontWeight.bold,
  //                     )),
  //                 const Icon(Icons.calendar_today),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  // Container buildTransactionDateFieldRange() {
  //   return Container(
  //     padding: EdgeInsets.all(getProportionateScreenWidth(10)),
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
  //     child: Obx(() => Row(
  //           children: [
  //             const Icon(Icons.calendar_today),
  //             SizedBox(width: getProportionateScreenWidth(10)),
  //             Expanded(
  //               child: GestureDetector(
  //                 onTap: () async {
  //                   DateTimeRange? pickedRange = await showDateRangePicker(
  //                     context: Get.context!,
  //                     firstDate: DateTime(2000),
  //                     lastDate: DateTime(2100),
  //                     initialDateRange:
  //                         _expenseController.transactionDateRange.value,
  //                   );

  //                   if (pickedRange != null) {
  //                     _expenseController.setTransactionDateRange(pickedRange);
  //                   }
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.symmetric(
  //                     vertical: getProportionateScreenWidth(10),
  //                   ),
  //                   child: Text(
  //                     _expenseController.transactionDateRange.value == null
  //                         ? 'Select Transaction Date Range *'
  //                         : '${_expenseController.transactionDateRange.value!.start.toLocal().toString().split(' ')[0]} - '
  //                             '${_expenseController.transactionDateRange.value!.end.toLocal().toString().split(' ')[0]}',
  //                     style: const TextStyle(
  //                       color: Colors.black87,
  //                       fontSize: 14,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             if (_expenseController.transactionDateRange.value != null)
  //               IconButton(
  //                 icon: const Icon(Icons.clear, color: Colors.red),
  //                 onPressed: () =>
  //                     _expenseController.setTransactionDateRange(null),
  //               ),
  //           ],
  //         )),
  //   );
  // }
  Container buildTransactionDateFieldRange() {
    return Container(
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
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
      child: Obx(() => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
                child: const Icon(Icons.calendar_today, color: Colors.black54),
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    DateTimeRange? pickedRange = await showDateRangePicker(
                      context: Get.context!,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDateRange:
                          _expenseController.transactionDateRange.value,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: Colors.black,
                            ),
                            dialogBackgroundColor: Colors.white,
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedRange != null) {
                      _expenseController.setTransactionDateRange(pickedRange);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenWidth(10),
                    ),
                    child: Text(
                      _expenseController.transactionDateRange.value == null
                          ? 'Select Transaction Date Range *'
                          : '${_expenseController.transactionDateRange.value!.start.toLocal().toString().split(' ')[0]} - '
                              '${_expenseController.transactionDateRange.value!.end.toLocal().toString().split(' ')[0]}',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              if (_expenseController.transactionDateRange.value != null)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: () =>
                      _expenseController.setTransactionDateRange(null),
                ),
            ],
          )),
    );
  }

  Widget _buildStatusDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const AppText(
          text: "Search By Status",
          fontWeight: FontWeight.bold,
          size: kTextSize - 2,
        ),
        SizedBox(height: getProportionateScreenWidth(5)),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(7),
            vertical: getProportionateScreenWidth(10),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black26,
                offset: Offset.fromDirection(math.pi * 0.5, 10),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            decoration:
                const InputDecoration(enabled: false, border: InputBorder.none),
            value: _expenseController.status.value.isEmpty
                ? null
                : _expenseController.status.value,
            items: _expenseController.statuses
                .map((status) => DropdownMenuItem<String>(
                      value: status,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: getProportionateScreenWidth(20)),
                        width: SizeConfig.screenWidth * 0.5,
                        child: AppText(
                          text: status,
                          size: kTextSize - 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                .toList()
              ..insert(
                0,
                DropdownMenuItem<String>(
                  value: '',
                  child: Container(
                    padding:
                        EdgeInsets.only(left: getProportionateScreenWidth(20)),
                    width: SizeConfig.screenWidth * 0.5,
                    child: AppText(
                      text: "---Select Status---",
                      size: kTextSize - 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            onChanged: _expenseController.transactionType.value.isEmpty
                ? null
                : _expenseController.onStatusChanged,
          ),
        ),
      ],
    );
  }

  // Widget _buildSubmitButton() {
  //   return Stack(
  //     children: [
  //       AppDefaultButton(
  //         text: !_expenseController.isLoading.value ? "Search" : "",
  //         press: () => _expenseController.submit('Submit'),
  //       ),
  //       if (_expenseController.isLoading.value)
  //         Container(
  //           padding: EdgeInsets.symmetric(
  //               vertical: getProportionateScreenHeight(14)),
  //           child: const SpinKitThreeBounce(color: kDotColor, size: 30),
  //         ),
  //     ],
  //   );
  // }

  // Widget _buildTableView(BuildContext context) {
  //   if (_expenseController.selectedTransactionType.isEmpty) {
  //     return const Center(
  //       child: AppText(
  //           text: "Please select type",
  //           size: kTextSize,
  //           fontWeight: FontWeight.bold),
  //     );
  //   }

  //   return SingleChildScrollView(
  //     scrollDirection: Axis.vertical,
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: DataTable(
  //         columns: _getColumns(_expenseController.selectedTransactionType),
  //         rows: _expenseController.list
  //             .where((item) =>
  //                 item['transactionType'] ==
  //                 _expenseController.selectedTransactionType)
  //             .map((item) => _getRow(item))
  //             .toList(),
  //       ),
  //     ),
  //   );
  // }
// Widget _buildTableView(BuildContext context) {
//   if (_expenseController.list.isEmpty) {
//     return const Center(
//       child: AppText(
//           text: "No data found",
//           size: kTextSize,
//           fontWeight: FontWeight.bold),
//     );
//   }

//   return SingleChildScrollView(
//     scrollDirection: Axis.vertical,
//     child: SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: DataTable(
//         columns: _getColumns(_expenseController.selectedTransactionType),
//         rows: _expenseController.list
//             .map((item) => _getRow(item))
//             .toList(),
//       ),
//     ),
//   );
// }
  Widget _buildTableView(BuildContext context) {
    if (_expenseController.list.isEmpty) {
      return const Center(
        child: AppText(
          text: "No data found",
          size: kTextSize,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final selectedType = _expenseController.selectedTransactionType;
    final columns = _getColumns(selectedType);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: columns,
          rows: _expenseController.list
              .where((item) =>
                  selectedType.isEmpty ||
                  item['transactionType'] == selectedType)
              .map((item) => _getRow(item))
              .toList(),
        ),
      ),
    );
  }

  Text _headerText(String text) => Text(
        text,
        textAlign: TextAlign.center,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      );

  List<DataColumn> _getColumns(String type) {
    switch (type) {
      case 'Advance':
        return [
          DataColumn(label: _headerText('#SL')),
          DataColumn(label: _headerText('Request Type')),
          DataColumn(label: _headerText('Reference Number')),
          DataColumn(label: _headerText('Request Date')),
          DataColumn(label: _headerText('Expenses Count')),
          DataColumn(label: _headerText('Expense Date')),
          DataColumn(label: _headerText('Amount')),
          DataColumn(label: _headerText('Authorization Status')),
          DataColumn(label: _headerText('Account Status')),
          DataColumn(label: _headerText('Action')),
        ];
      case 'Conveyance':
        return [
          DataColumn(label: _headerText('#SL')),
          DataColumn(label: _headerText('Request Type')),
          DataColumn(label: _headerText('Reference Number')),
          DataColumn(label: _headerText('Request Date')),
          DataColumn(label: _headerText('Expenses Count')),
          DataColumn(label: _headerText('Expense Date')),
          DataColumn(label: _headerText('Amount')),
          DataColumn(label: _headerText('Authorization Status')),
          DataColumn(label: _headerText('Account Status')),
          DataColumn(label: _headerText('Action')),
        ];
      case 'Travels':
        return [
          DataColumn(label: _headerText('#SL')),
          DataColumn(label: _headerText('Request Type')),
          DataColumn(label: _headerText('Reference Number')),
          DataColumn(label: _headerText('Request Date')),
          DataColumn(label: _headerText('Expenses Count')),
          DataColumn(label: _headerText('Expense Date')),
          DataColumn(label: _headerText('Amount')),
          DataColumn(label: _headerText('Authorization Status')),
          DataColumn(label: _headerText('Account Status')),
          DataColumn(label: _headerText('Action')),
        ];
      default:
        return [
          DataColumn(label: _headerText('#SL')),
          DataColumn(label: _headerText('Request Type')),
          DataColumn(label: _headerText('Reference Number')),
          DataColumn(label: _headerText('Request Date')),
          DataColumn(label: _headerText('Expenses Count')),
          DataColumn(label: _headerText('Expense Date')),
          DataColumn(label: _headerText('Amount')),
          DataColumn(label: _headerText('Authorization Status')),
          DataColumn(label: _headerText('Account Status')),
          DataColumn(label: _headerText('Action')),
        ];
    }
  }

  DataRow _getRow(Map<String, dynamic> item) {
    if (item['transactionType'] == 'Advance') {
      return DataRow(cells: [
        const DataCell(Text('1',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black))),
        DataCell(Text(item['transactionType'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['referenceNumber'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text((item['requestDate']?.toString().substring(0, 10) ?? ''),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        const DataCell(
            Text('0', textAlign: TextAlign.center)), // expenseCount placeholder
        DataCell(Text(
            (item['transactionDate']?.toString().substring(0, 10) ?? ''),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text((item['advanceAmount']?.toString() ?? '0'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['stateStatus'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['accountStatus'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _expenseController.showModal(
                  item['requestId'] ?? 0,
                  item['transactionType'] ?? '',
                  item['spendMode'] ?? '',
                  'Edit'),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _expenseController.openRequestDeleteModal(item),
            ),
          ],
        )),
      ]);
    } else if (item['transactionType'] == 'Conveyance') {
      return DataRow(cells: [
        const DataCell(Text('1',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black))),
        DataCell(Text(item['transactionType'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['referenceNumber'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text((item['requestDate']?.toString().substring(0, 10) ?? ''),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        const DataCell(
            Text('0', textAlign: TextAlign.center)), // expenseCount placeholder
        DataCell(Text(
            (item['transactionDate']?.toString().substring(0, 10) ?? ''),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text((item['advanceAmount']?.toString() ?? '0'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['stateStatus'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['accountStatus'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _expenseController.showModal(
                  item['requestId'] ?? 0,
                  item['transactionType'] ?? '',
                  item['spendMode'] ?? '',
                  'Edit'),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _expenseController.openRequestDeleteModal(item),
            ),
          ],
        )),
      ]);
    } else if (item['transactionType'] == 'Travels') {
      return DataRow(cells: [
        const DataCell(Text('1',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black))),
        DataCell(Text(item['transactionType'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['referenceNumber'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text((item['requestDate']?.toString().substring(0, 10) ?? ''),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        const DataCell(
            Text('0', textAlign: TextAlign.center)), // expenseCount placeholder
        DataCell(Text(
            (item['transactionDate']?.toString().substring(0, 10) ?? ''),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text((item['advanceAmount']?.toString() ?? '0'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['stateStatus'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Text(item['accountStatus'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black))),
        DataCell(Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _expenseController.showModal(
                  item['requestId'] ?? 0,
                  item['transactionType'] ?? '',
                  item['spendMode'] ?? '',
                  'Edit'),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _expenseController.openRequestDeleteModal(item),
            ),
          ],
        )),
      ]);
    }
    return DataRow(cells: [
      const DataCell(Text('1',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.black))),
      DataCell(Text(item['transactionType'] ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black))),
      DataCell(Text(item['referenceNumber'] ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black))),
      DataCell(Text((item['requestDate']?.toString().substring(0, 10) ?? ''),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black))),
      const DataCell(
          Text('0', textAlign: TextAlign.center)), // expenseCount placeholder
      DataCell(Text(
          (item['transactionDate']?.toString().substring(0, 10) ?? ''),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black))),
      DataCell(Text((item['advanceAmount']?.toString() ?? '0'),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black))),
      DataCell(Text(item['stateStatus'] ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black))),
      DataCell(Text(item['accountStatus'] ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.black))),
      DataCell(Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _expenseController.showModal(
                item['requestId'] ?? 0,
                item['transactionType'] ?? '',
                item['spendMode'] ?? '',
                'Edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _expenseController.openRequestDeleteModal(item),
          ),
        ],
      )),
    ]);
  }
}
