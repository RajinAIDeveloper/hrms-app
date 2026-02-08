import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/controllers/Expense/expense_controller.dart';
import 'package:root_app/constants/constants.dart';


import 'dart:math' as math;

import 'package:root_app/views/leave/components/leave_request_cell.dart';

class ExpenseForm extends StatelessWidget {
  ExpenseForm({
    super.key,
  });
  final _expenseController = Get.find<ExpenseController>();
 
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Expense Request",
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _expenseController.closeModal();
                  Get.back(result: 'Cancel click');
                },
              ),
            ],
          ),
          SizedBox(height: getProportionateScreenWidth(20)),
          buildTransactionForm(),
          Obx(() => buildSpecificForm()),
          SizedBox(height: getProportionateScreenWidth(20)),
          buildFooter(),
        ],
      ),
    );
  }

  Widget buildTransactionForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: "Transaction Details", fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildTransactionDateField(),
        SizedBox(height: getProportionateScreenWidth(10)),
        //buildSpendModeDropdownField(),
        buildSpendModeDropdownFieldSafe(),
        SizedBox(height: getProportionateScreenWidth(10)),
        // Only show transaction type dropdown if showTransactionType is true
        Obx(() => _expenseController.showTransactionType.value
            ? buildTransactionTypeDropdownField()
            : const SizedBox.shrink()),
      ],
    );
  }


  Widget buildFooter() {
  return Obx(() => Container(
    padding: EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _expenseController.isLoading.value
                ? null
                : () {
                    _expenseController.closeModal();
                    Get.back(result: 'Cancel');
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black87,
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenWidth(15),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _expenseController.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                    ),
                  )
                : const AppText(
                    text: "Cancel",
                    fontWeight: FontWeight.bold,
                  ),
          ),
        ),
        SizedBox(width: getProportionateScreenWidth(15)),
        // Expanded(
        //   child: ElevatedButton(
        //     onPressed: _expenseController.isLoading.value
        //         ? null
        //         : () async {
        //             bool success = false;
        //             if (_expenseController.transactionType.value.isEmpty) {
        //               Get.snackbar(
        //                 'Error',
        //                 'Please select a transaction type',
        //                 backgroundColor: Colors.redAccent,
        //                 colorText: Colors.white,
        //               );
        //               return;
        //             }
        //             switch (_expenseController.transactionType.value) {
        //               case 'Advance':
        //                 success = await _expenseController.submitAdvanceamount();
        //                 break;
        //               case 'Travel':
        //                 success = await _expenseController.submitTravel();
        //                 break;
        //               case 'Conveyance':
                     
        //                success = await _expenseController.saveConveyance();
        //                 break;
        //               default:
        //                 Get.snackbar(
        //                   'Error',
        //                   'Unsupported transaction type',
        //                   backgroundColor: Colors.redAccent,
        //                   colorText: Colors.white,
        //                 );
        //                 return;
        //             }
        //             if (success) {
        //               Get.back(result: 'Success');
        //             }
        //           },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: kPrimaryColor,
        //       foregroundColor: Colors.white,
        //       padding: EdgeInsets.symmetric(
        //         vertical: getProportionateScreenWidth(15),
        //       ),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //     ),
        //     child: _expenseController.isLoading.value
        //         ? const SizedBox(
        //             height: 20,
        //             width: 20,
        //             child: CircularProgressIndicator(
        //               strokeWidth: 2,
        //               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        //             ),
        //           )
        //         : AppText(
        //             text: _expenseController.emailFlag.value == 'Edit'
        //                 ? "Update"
        //                 : "Submit",
        //             fontWeight: FontWeight.bold,
        //             color: Colors.white,
        //           ),
        //   ),
        // ),
        // ...existing code...
        Expanded(
          child: ElevatedButton(
            onPressed: _expenseController.isLoading.value
                ? null
                : () async {
                    bool success = false;

                    // Determine effective transaction type.
                    // If the advance form is shown (showAdvanceFields) treat it as 'Advance'
                    // even if transactionType wasn't explicitly selected.
                    String effectiveType = _expenseController.transactionType.value;
                    if (effectiveType.isEmpty && _expenseController.showAdvanceFields.value) {
                      effectiveType = 'Advance';
                    }

                    if (effectiveType.isEmpty) {
                      Get.snackbar(
                        'Error',
                        'Please select a transaction type',
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                      return;
                    }

                    switch (effectiveType) {
                      case 'Advance':
                        success = await _expenseController.submitAdvanceamount();
                        break;
                      case 'Travel':
                        success = await _expenseController.submitTravel();
                        break;
                      case 'Conveyance':
                        success = await _expenseController.saveConveyance();
                        break;
                       case 'Expenses':
                        success = await _expenseController.saveExpenses();
                        break;  
                      default:
                        Get.snackbar(
                          'Error',
                          'Unsupported transaction type',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                    }

                    // if (success) {
                    //   Get.back(result: 'Success');
                    // }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: getProportionateScreenWidth(15),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _expenseController.isLoading.value
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : AppText(
                    text: _expenseController.emailFlag.value == 'Edit'
                        ? "Update"
                        : "Submit",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
          ),
        ),
// ...existing code...
      ],
    ),
  ));
}


  Container buildTransactionDateField() {
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
            children: [
              const Icon(Icons.calendar_today),
              SizedBox(width: getProportionateScreenWidth(10)),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Transaction Date *',
                    border: InputBorder.none,
                  ),
                  readOnly: true,
                  style: const TextStyle(
                      color: Colors.black87), // Ensure text is visible
                  controller: TextEditingController(
                    text: _expenseController.transactionDate.value != null
                        ? _expenseController.transactionDate.value!
                            .toString()
                            .split(' ')[0]
                        : '',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: Get.context!,
                      initialDate: _expenseController.transactionDate.value ??
                          DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      _expenseController.onDateChanged(pickedDate);
                    }
                  },
                  validator: (value) =>
                      _expenseController.transactionDate.value == null
                          ? 'Transaction date is required'
                          : null,
                ),
              ),
              if (_expenseController.transactionDate.value != null)
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.red),
                  onPressed: () => _expenseController.onDateChanged(null),
                ),
            ],
          )),
    );
  }

 

  Container buildSpendModeDropdownFieldSafe() {
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
      child: Obx(() => DropdownButtonFormField<String>(
            isExpanded: true, // 👈 Add this for extra safety against overflow
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            value: _expenseController.spendMode.value.isEmpty
                ? null
                : _expenseController.spendMode.value,
            items: [
              // Placeholder item
              const DropdownMenuItem<String>(
                value: null,
                child: Padding(
                  padding: EdgeInsets.only(
                      left:
                          20), // Use fixed padding to avoid function calls in widget tree
                  child: AppText(
                    text: "Select Spend Mode",
                    size: kTextSize - 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Actual items
              ..._expenseController.spendModes
                  .map((mode) => DropdownMenuItem<String>(
                        value: mode,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: getProportionateScreenWidth(20)),
                          width: SizeConfig.screenWidth * 0.5,
                          child: AppText(
                            text: mode,
                            size: kTextSize - 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
            ],
            onChanged: (_expenseController.emailFlag.value != 'Edit' &&
                    _expenseController.transactionDate.value != null)
                ? (value) {
                    _expenseController.spendMode.value = value ?? '';
                    _expenseController.updateAdvanceFieldsVisibility(value);
                    if (value != null) {
                      _expenseController.removeError(
                          error: kSpendModeNotSelectedError);
                    } else {
                      _expenseController.addError(
                          error: kSpendModeNotSelectedError);
                    }
                  }
                : null,
            validator: (value) => value == null || value.isEmpty
                ? 'Spend Mode is required'
                : null,
          )),
    );
  }

 

  Container buildTransactionTypeDropdownField() {
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
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              isExpanded: true, // Take full available width
              decoration: const InputDecoration(
                labelText: 'Transaction Type *', // Added label for clarity
                border: InputBorder.none, // Cleaner look
              ),
              value: _expenseController.transactionType.value.isEmpty
                  ? null
                  : _expenseController.transactionType.value,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: AppText(
                    text: '---Select Type---',
                    size: kTextSize - 2,
                    overflow: TextOverflow.ellipsis, // Prevent text overflow
                  ),
                ),
                ..._expenseController.transactionTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: SizeConfig.screenWidth *
                                  0.8, // Limit item width
                            ),
                            child: AppText(
                              text: type,
                              size: kTextSize - 2,
                              overflow: TextOverflow
                                  .ellipsis, // Prevent text overflow
                            ),
                          ),
                        )),
              ],
              onChanged: (_expenseController.emailFlag.value != 'Edit' &&
                      _expenseController.spendMode.value.isNotEmpty)
                  ? (value) {
                      _expenseController.transactionType.value = value ?? '';
                      if (value != null && value.isNotEmpty) {
                        _expenseController.removeError(
                            error: 'Transaction type is required');
                      } else {
                        _expenseController.addError(
                            error: 'Transaction type is required');
                      }
                      _expenseController.transactionType.refresh();
                    }
                  : null,
              validator: (value) =>
                  _expenseController.validateTransactionType(value),
            ),
          )),
    );
  }

  Widget buildSpecificForm() {
    print(
        'DEBUG - showAdvanceFields: ${_expenseController.showAdvanceFields.value}');
    print('DEBUG - spendMode: ${_expenseController.spendMode.value}');
    print(
        'DEBUG - transactionType: ${_expenseController.transactionType.value}');

    // If showAdvanceFields is true, show advance fields
    if (_expenseController.showAdvanceFields.value) {
      print('DEBUG - Showing Advance Form');
      return buildAdvanceForm();
    }

    // If spend mode is Bill Settlement and transaction type is selected, show specific forms
    if (_expenseController.spendMode.value == 'Bill Settlement' &&
        _expenseController.transactionType.value.isNotEmpty) {
      print(
          'DEBUG - Showing specific form for: ${_expenseController.transactionType.value}');
      switch (_expenseController.transactionType.value) {
        case 'Conveyance':
          return buildConveyanceForm();
        case 'Travel':
          return buildTravelsForm();
        case 'Entertainment':
        case 'Purchase':
          return buildEntertainmentForm();
        case 'Expat':
          return buildExpatForm();
        case 'Training':
          return buildTrainingForm();
        case 'Expenses':
          return buildExpensesForm();
        default:
          print(
              'DEBUG - No form found for: ${_expenseController.transactionType.value}');
          return const SizedBox.shrink();
      }
    }

    print('DEBUG - No form to show');
    return const SizedBox.shrink();
  }

  Widget buildAdvanceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: getProportionateScreenWidth(20)),
        const AppText(text: "Advance Details", fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),
        //buildAdvanceReferenceNoField(),
         buildAdvanceReferenceNoField(DateTime.now(), 'Advance'),

        SizedBox(height: getProportionateScreenWidth(10)),
        buildAdvanceDateField(),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildAdvanceAmountField(),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildAdvancePurposeField(),
      ],
    );
  }

  // Widget buildAdvanceReferenceNoField() {
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
  //     child: Obx(() => TextFormField(
  //           decoration: const InputDecoration(
  //             labelText: 'Reference No *',
  //             border: InputBorder.none,
  //           ),
  //           controller: TextEditingController(
  //             text: _expenseController.referenceNo.value,
  //           ),
  //           readOnly: true,
  //           style: const TextStyle(color: Colors.black87),
  //         )),
  //   );
  // }
// Widget buildAdvanceReferenceNoField(DateTime date, String type) {
//   return Obx(() {
//     // Directly generate the reference number as String
//     final ref = _expenseController.generateRefNo(date, type);

//     return LeaveRequestCell(
//       text: ref.isNotEmpty ? ref : 'Reference No *',
//       isDark: false,
//       isLeftRounded: true,
//       isRightRounded: true,
//     );
//   });
// }
// Widget buildAdvanceReferenceNoField(DateTime date, String type) {
//   final ref = _expenseController.generateRefNo(date, type);

//   return LeaveRequestCell(
//     text: ref.isNotEmpty ? ref : 'Reference No *',
//     isDark: false,
//     isLeftRounded: true,
//     isRightRounded: true,
//   );
// }


  Widget buildAdvanceDateField() {
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
      child: Row(
        children: [
          const Icon(Icons.calendar_today),
          SizedBox(width: getProportionateScreenWidth(10)),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date of Advance *',
                border: InputBorder.none,
              ),
              readOnly: true,
              style: const TextStyle(color: Colors.black87),
              controller: TextEditingController(
                text: _expenseController.transactionDate.value != null
                    ? _expenseController.transactionDate.value!
                        .toString()
                        .split(' ')[0]
                    : '',
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: _expenseController.transactionDate.value ??
                      DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _expenseController.onDateChanged(pickedDate);
                }
              },
              validator: (value) =>
                  _expenseController.transactionDate.value == null
                      ? 'Date of advance is required'
                      : null,
            ),
          ),
          if (_expenseController.transactionDate.value != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: () => _expenseController.onDateChanged(null),
            ),
        ],
      ),
    );
  }

  Widget buildAdvanceAmountField() {
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
      child: TextFormField(
        style: const TextStyle(color: Colors.black), // move style here
        decoration: const InputDecoration(
          labelText: 'Advance Amount *',
          border: InputBorder.none,
        ),
        keyboardType: TextInputType.number,
        controller: _expenseController.advanceAmountController,
        onChanged: (value) {
          _expenseController.advanceAmount.value = value;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Advance amount is required';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid amount';
          }
          return null;
        },
      ),
    );
  }

  Widget buildAdvancePurposeField() {
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
      child: TextFormField(
        style: const TextStyle(color: Colors.black), // move style here
        decoration: const InputDecoration(
          labelText: 'Purpose *',
          border: InputBorder.none,
        ),
        maxLines: 3,
        controller: _expenseController.purposeController,
        onChanged: (value) {
          _expenseController.purpose.value = value;
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Purpose is required';
          }
          return null;
        },
      ),
    );
  }

  // Widget buildConveyanceForm() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       AppText(text: 'Conveyance Details', fontWeight: FontWeight.bold),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRefNoField('Conveyance'),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRequestDateField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildCompanyNameField(),
  //       if (_expenseController.spendMode.value == 'Advance')
  //         buildAdvanceAmountField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildPurposeField(),
  //       if (_expenseController.spendMode.value != 'Advance') ...[
  //         SizedBox(height: getProportionateScreenWidth(10)),
  //         AppText(text: 'Transportation *', fontWeight: FontWeight.bold),
  //         Obx(() => Column(
  //               children: _expenseController.conveyanceTransportations
  //                   .asMap()
  //                   .entries
  //                   .map((entry) {
  //                 final index = entry.key;
  //                 final item = entry.value;
  //                 return Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: TextFormField(
  //                             initialValue: item['place'],
  //                             decoration: const InputDecoration(
  //                                 labelText: 'Destination (From-To)'),
  //                             onChanged: (value) => item['place'] = value,
  //                             validator: (value) =>
  //                                 value == null || value.isEmpty
  //                                     ? 'Destination is required'
  //                                     : null,
  //                           ),
  //                         ),
  //                         SizedBox(width: getProportionateScreenWidth(10)),
  //                         Expanded(
  //                           child: DropdownButtonFormField<String>(
  //                             decoration:
  //                                 const InputDecoration(labelText: 'Mode'),
  //                             value: item['type']?.isNotEmpty == true
  //                                 ? item['type']
  //                                 : null,
  //                             items: [
  //                               const DropdownMenuItem<String>(
  //                                 value: '',
  //                                 child: AppText(text: '---Select Type---'),
  //                               ),
  //                               ..._expenseController.transportationModes
  //                                   .map((mode) => DropdownMenuItem<String>(
  //                                         value: mode,
  //                                         child: AppText(text: mode),
  //                                       )),
  //                             ],
  //                             onChanged: (value) => item['type'] = value ?? '',
  //                             validator: (value) =>
  //                                 value == null || value.isEmpty
  //                                     ? 'Mode is required'
  //                                     : null,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     TextFormField(
  //                       initialValue: item['cost'],
  //                       decoration:
  //                           const InputDecoration(labelText: 'Cost (BDT)'),
  //                       keyboardType: TextInputType.number,
  //                       onChanged: (value) {
  //                         item['cost'] = value;
  //                         _expenseController.conveyanceTransportations
  //                             .refresh();
  //                       },
  //                       validator: (value) => value == null || value.isEmpty
  //                           ? 'Cost is required'
  //                           : null,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         IconButton(
  //                           icon: const Icon(Icons.add, color: kPrimaryColor),
  //                           onPressed:
  //                               _expenseController.addConveyanceTransportation,
        
  //                               .removeConveyanceTransportation(index),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 );
  //               }).toList(),
  //             )),
  //         SizedBox(height: getProportionateScreenWidth(10)),
  //         TextFormField(
  //           initialValue: _expenseController
  //               .calculateTotalAmount(
  //                   _expenseController.conveyanceTransportations, 'cost')
  //               .toString(),
  //           decoration: const InputDecoration(labelText: 'Total Amount'),
  //           readOnly: true,
  //         ),
  //       ],
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildDescriptionField(),
  //     ],
  //   );
  // }
  // Widget buildConveyanceForm() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       AppText(text: 'Conveyance Details', fontWeight: FontWeight.bold),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRefNoField('Conveyance'),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRequestDateField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildCompanyNameField(),
  //       if (_expenseController.spendMode.value == 'Advance')
  //         buildAdvanceAmountField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildPurposeField(),
  //       if (_expenseController.spendMode.value != 'Advance') ...[
  //         SizedBox(height: getProportionateScreenWidth(10)),
  //         const AppText(text: 'Transportation *', fontWeight: FontWeight.bold),
  //         SizedBox(height: getProportionateScreenWidth(10)),
  //         Obx(() => Column(
  //               children: _expenseController.conveyanceTransportations
  //                   .asMap()
  //                   .entries
  //                   .map((entry) {
  //                 final index = entry.key;
  //                 final item = entry.value;
  //                 return Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Expanded(
  //                           child: TextFormField(
  //                             initialValue: item['place'],
  //                             decoration: const InputDecoration(
  //                               labelText: 'Destination (From-To)',
  //                             ),
  //                             onChanged: (value) => item['place'] = value,
  //                             validator: (value) =>
  //                                 value == null || value.isEmpty
  //                                     ? 'Destination is required'
  //                                     : null,
  //                           ),
  //                         ),
  //                         SizedBox(width: getProportionateScreenWidth(10)),
  //                         Expanded(
  //                           child: DropdownButtonHideUnderline(
  //                             child: DropdownButtonFormField<String>(
  //                               isExpanded: true, // Take full available width
  //                               decoration: const InputDecoration(
  //                                 labelText: 'Mode',
  //                                 border: InputBorder.none, // Cleaner look
  //                               ),
  //                               value: item['type']?.isNotEmpty == true
  //                                   ? item['type']
  //                                   : null,
  //                               items: [
  //                                 const DropdownMenuItem<String>(
  //                                   value: null,
  //                                   child: AppText(
  //                                     text: '---Select Type---',
  //                                     size: kTextSize - 2,
  //                                     overflow: TextOverflow.ellipsis,
  //                                   ),
  //                                 ),
  //                                 ..._expenseController.transportationModes
  //                                     .map((mode) => DropdownMenuItem<String>(
  //                                           value: mode,
  //                                           child: ConstrainedBox(
  //                                             constraints: BoxConstraints(
  //                                               maxWidth:
  //                                                   SizeConfig.screenWidth *
  //                                                       0.35,
  //                                             ),
  //                                             child: AppText(
  //                                               text: mode,
  //                                               size: kTextSize - 2,
  //                                               overflow: TextOverflow.ellipsis,
  //                                             ),
  //                                           ),
  //                                         )),
  //                               ],
  //                               onChanged:
  //                                   (_expenseController.emailFlag.value !=
  //                                           'Edit')
  //                                       ? (value) {
  //                                           item['type'] = value ?? '';
  //                                           _expenseController
  //                                               .conveyanceTransportations
  //                                               .refresh();
  //                                         }
  //                                       : null,
  //                               validator: (value) =>
  //                                   value == null || value.isEmpty
  //                                       ? 'Mode is required'
  //                                       : null,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: getProportionateScreenWidth(10)),
  //                     TextFormField(
  //                       initialValue: item['cost'],
  //                       decoration: const InputDecoration(
  //                         labelText: 'Cost (BDT)',
  //                       ),
  //                       keyboardType: TextInputType.number,
  //                       onChanged: (value) {
  //                         item['cost'] = value;
  //                         _expenseController.conveyanceTransportations
  //                             .refresh();
  //                       },
  //                       validator: (value) => value == null || value.isEmpty
  //                           ? 'Cost is required'
  //                           : null,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [
  //                         IconButton(
  //                           icon: const Icon(Icons.add, color: kPrimaryColor),
  //                           onPressed:
  //                               _expenseController.addConveyanceTransportation,
  //                         ),
  //                         IconButton(
  //                           icon: const Icon(Icons.delete, color: Colors.red),
  //                           onPressed: () => _expenseController
  //                               .removeConveyanceTransportation(index),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 );
  //               }).toList(),
  //             )),
  //         SizedBox(height: getProportionateScreenWidth(10)),
  //         TextFormField(
  //           initialValue: _expenseController
  //               .calculateTotalAmount(
  //                   _expenseController.conveyanceTransportations, 'cost')
  //               .toString(),
  //           decoration: const InputDecoration(labelText: 'Total Amount'),
  //           readOnly: true,
  //         ),
  //       ],
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildDescriptionField(),
  //     ],
  //   );
  // }
Widget buildConveyanceForm() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const AppText(text: 'Conveyance Details', fontWeight: FontWeight.bold),
      SizedBox(height: getProportionateScreenWidth(10)),

      // Reference No
      buildRefNoFieldConveyance('Conveyance'),
      SizedBox(height: getProportionateScreenWidth(10)),

      // Request Date
      buildRequestDateField(),
      SizedBox(height: getProportionateScreenWidth(10)),

      // Company Name
      buildCompanyNameField(),
      SizedBox(height: getProportionateScreenWidth(10)),

      // Optional Location Field (User types freely)
      TextFormField(
        controller: _expenseController.locationController,
        decoration: const InputDecoration(
          labelText: 'Location / Area',
          border: OutlineInputBorder(),
        ),
        style: const TextStyle(color: Colors.black),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter location';
          }
          return null;
        },
      ),
      SizedBox(height: getProportionateScreenWidth(10)),

      // Advance Amount (only if spendMode == Advance)
      if (_expenseController.spendMode.value == 'Advance')
        buildAdvanceAmountField(),
      SizedBox(height: getProportionateScreenWidth(10)),

      // Purpose
      buildPurposeField(),
      SizedBox(height: getProportionateScreenWidth(10)),

      // Transportation Details (if not Advance)
      if (_expenseController.spendMode.value != 'Advance') ...[
        const AppText(text: 'Transportation *', fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),

        Obx(() => Column(
              children: _expenseController.conveyanceTransportations
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final item = entry.value;

                return Column(
                  children: [
                    Row(
                      children: [
                        // Destination Field (editable text)
                        Expanded(
                          child: TextFormField(
                            initialValue: item['place'],
                            decoration: const InputDecoration(
                              labelText: 'Destination (From-To)',
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(color: Colors.black),
                            onChanged: (value) {
                              item['place'] = value;
                              _expenseController.conveyanceTransportations.refresh();
                            },
                            validator: (value) => value == null || value.isEmpty
                                ? 'Destination is required'
                                : null,
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(10)),

                        // Mode Dropdown
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Mode',
                              border: OutlineInputBorder(),
                            ),
                            value: item['type']?.isNotEmpty == true ? item['type'] : null,
                            style: const TextStyle(color: Colors.black),
                            items: _expenseController.transportationModes
                                .map((mode) => DropdownMenuItem(
                                      value: mode,
                                      child: Text(
                                        mode,
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (_expenseController.emailFlag.value != 'Edit')
                                ? (value) {
                                    item['type'] = value ?? '';
                                    _expenseController.conveyanceTransportations.refresh();
                                  }
                                : null,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Mode is required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenWidth(10)),

                    // Cost Field
                    TextFormField(
                      initialValue: item['cost'],
                      decoration: const InputDecoration(
                        labelText: 'Cost (BDT)',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        item['cost'] = value;
                        _expenseController.conveyanceTransportations.refresh();
                      },
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Cost is required' : null,
                    ),

                    // Add / Remove buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: kPrimaryColor),
                          onPressed: _expenseController.addConveyanceTransportation,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _expenseController.removeConveyanceTransportation(index),
                        ),
                      ],
                    ),
                    SizedBox(height: getProportionateScreenWidth(10)),
                  ],
                );
              }).toList(),
            )),

        // Total Amount (read-only)
        TextFormField(
          controller: TextEditingController(
            text: _expenseController
                .calculateTotalAmount(
                    _expenseController.conveyanceTransportations, 'cost')
                .toString(),
          ),
          decoration: const InputDecoration(labelText: 'Total Amount'),
          readOnly: true,
          style: const TextStyle(color: Colors.black),
        ),
      ],

      SizedBox(height: getProportionateScreenWidth(10)),

      // Description
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
        child: TextFormField(
          controller: _expenseController.descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.black),
          maxLines: null,
          onChanged: (value) => _expenseController.description.value = value,
        ),
      ),
    ],
  );
}

Widget buildRefNoFieldConveyance(String type) {
  // generate once if empty
  if (_expenseController.referenceNo.value.isEmpty) {
    _expenseController.referenceNo.value =
        _expenseController.generateRefNo(DateTime.now(), type);
  }

  final controller = TextEditingController(
    text: _expenseController.referenceNo.value,
  );

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
    child: Obx(() {
      // keep controller in sync with observable
      controller.text = _expenseController.referenceNo.value;
      return TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          labelText: 'Reference No *',
          labelStyle: TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        readOnly: true,
        validator: (value) =>
            value == null || value.isEmpty ? 'Reference Number is required' : null,
      );
    }),
  );
}

Widget buildExpensesForm() {
  return Builder(
    builder: (BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(text: 'Expenses Details', fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),

        // Reference No (Read-only)
        TextFormField(
          controller: _expenseController.refNoController,
          decoration: const InputDecoration(
            labelText: 'Reference No',
            border: OutlineInputBorder(),
          ),
          style: const TextStyle(color: Colors.black),
          readOnly: true,
        ),
        SizedBox(height: getProportionateScreenWidth(10)),

        // Date of Expense
        TextFormField(
          controller: _expenseController.expenseDateController,
          decoration: InputDecoration(
            labelText: 'Date of Expense *',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.calendar_today),
            suffixIcon: _expenseController.expenseDateController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: () {
                      _expenseController.expenseDateController.clear();
                    },
                  )
                : null,
          ),
          style: const TextStyle(color: Colors.black),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              _expenseController.expenseDateController.text =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Field is required';
            }
            return null;
          },
        ),
        SizedBox(height: getProportionateScreenWidth(10)),

        // Expenses List Section
        const AppText(text: 'Expenses *', fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),

        // Expenses Items Container
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Obx(() => Column(
                children: _expenseController.expensesItems
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final item = entry.value;

                  return Column(
                    children: [
                      // Expense Type Row with Index
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Index Number
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: getProportionateScreenWidth(10)),

                          // Expense Type Dropdown
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Expense Type *',
                                border: OutlineInputBorder(),
                              ),
                              value: item['expenseType']?.isNotEmpty == true
                                  ? item['expenseType']
                                  : null,
                              style: const TextStyle(color: Colors.black),
                              items: _expenseController.expenseTypes
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(
                                          type,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                item['expenseType'] = value ?? '';
                                _expenseController.expensesItems.refresh();
                              },
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Expense Type is required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: getProportionateScreenWidth(10)),

                      // Particulars and Amount Row
                      Row(
                        children: [
                          // Particulars Field
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              initialValue: item['particulars'],
                              decoration: const InputDecoration(
                                labelText: 'Particulars',
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(color: Colors.black),
                              onChanged: (value) {
                                item['particulars'] = value;
                                _expenseController.expensesItems.refresh();
                              },
                            ),
                          ),
                          SizedBox(width: getProportionateScreenWidth(10)),

                          // Amount Field
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              initialValue: item['amount'],
                              decoration: const InputDecoration(
                                labelText: 'Amount (BDT) *',
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(color: Colors.black),
                              textAlign: TextAlign.right,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                item['amount'] = value;
                                _expenseController.expensesItems.refresh();
                                _expenseController.calculateExpensesTotalAmount();
                              },
                              validator: (value) => value == null || value.isEmpty
                                  ? 'Amount is required'
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      // Add / Remove buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, color: kPrimaryColor),
                            onPressed: _expenseController.addExpenseItem,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _expenseController.removeExpenseItem(index),
                          ),
                        ],
                      ),

                      if (index < _expenseController.expensesItems.length - 1)
                        Divider(height: getProportionateScreenWidth(20)),
                    ],
                  );
                }).toList(),
              )),
        ),
        SizedBox(height: getProportionateScreenWidth(10)),

        // Total Amount (read-only, aligned to right)
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: getProportionateScreenWidth(200),
              child: Obx(() => TextFormField(
                    controller: TextEditingController(
                      text: _expenseController.expensesTotalAmount.value.toString(),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Total Amount',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
        SizedBox(height: getProportionateScreenWidth(10)),

        // Description
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
          child: TextFormField(
            controller: _expenseController.descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.black),
            maxLines: 3,
            onChanged: (value) => _expenseController.description.value = value,
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(10)),

        // Attachment Field
        const AppText(
          text: 'Attachment (Only Pdf, Jpg, Png File)',
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: getProportionateScreenWidth(10)),

        InkWell(
          onTap: () async {
            // File picker logic here
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
            );

            if (result != null) {
              _expenseController.uploadedFileName.value =
                  result.files.single.name;
              _expenseController.uploadedFile.value = result.files.single;
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                const Icon(Icons.attach_file),
                SizedBox(width: getProportionateScreenWidth(10)),
                Expanded(
                  child: Obx(() => Text(
                        _expenseController.uploadedFileName.value.isEmpty
                            ? 'Choose File'
                            : _expenseController.uploadedFileName.value,
                        style: TextStyle(
                          color: _expenseController.uploadedFileName.value.isEmpty
                              ? Colors.grey
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
 // ...existing code...
Widget buildAdvanceReferenceNoField(DateTime date, String type) {
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
    child: Obx(() {
      final text = _expenseController.refNo.value;
      return TextFormField(
        controller: TextEditingController(text: text),
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          labelText: 'Reference No *',
          labelStyle: TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        readOnly: true,
        validator: (value) => value == null || value.isEmpty ? 'Reference Number is required' : null,
        onTap: () {
          // generate and set
          final d = _expenseController.transactionDate.value ?? DateTime.now();
          final ref = _expenseController.generateRefNo(d, type);
          _expenseController.refNo.value = ref;
        },
      );
    }),
  );
}

Widget buildRefNoFieldTravel(String type) {
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
    child: Obx(() {
      final text = _expenseController.refNo.value;
      return TextFormField(
        controller: TextEditingController(text: text),
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(
          labelText: 'Reference No *',
          labelStyle: TextStyle(color: Colors.black87),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
        readOnly: true,
        validator: (value) => value == null || value.isEmpty ? 'Reference Number is required' : null,
        onTap: () {
          final d = _expenseController.transactionDate.value ?? DateTime.now();
          final ref = _expenseController.generateRefNo(d, type);
          _expenseController.refNo.value = ref;
          // keep DTO backing value in sync so submitTravel() reads it
          _expenseController.referenceNo.value = ref;
        },
      );
    }),
  );
}
// ...existing code...
  // Widget buildTravelsForm() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       AppText(text: 'Travels Details', fontWeight: FontWeight.bold),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRefNoField('Travels'),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRequestDateRangeField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildSpendModeDropdownFieldSafe(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Destination City *'),
  //         validator: (value) => value == null || value.isEmpty
  //             ? 'Destination City is required'
  //             : null,
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildPurposeField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       // Wrap the dropdown with SingleChildScrollView
  //       SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: buildTransportationTravelsDropdownField(),
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       TextFormField(
  //         decoration:
  //             const InputDecoration(labelText: 'Transportation Costs *'),
  //         keyboardType: TextInputType.number,
  //         validator: (value) => value == null || value.isEmpty
  //             ? 'Transportation Costs is required'
  //             : null,
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Accommodation Costs *'),
  //         keyboardType: TextInputType.number,
  //         validator: (value) => value == null || value.isEmpty
  //             ? 'Accommodation Costs is required'
  //             : null,
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Subsistence Costs *'),
  //         keyboardType: TextInputType.number,
  //         validator: (value) => value == null || value.isEmpty
  //             ? 'Subsistence Costs is required'
  //             : null,
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       TextFormField(
  //         decoration: const InputDecoration(labelText: 'Other Costs'),
  //         keyboardType: TextInputType.number,
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildDescriptionField(),
  //     ],
  //   );
  // }

  // Widget buildTravelsForm() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       AppText(text: 'Travels Details', fontWeight: FontWeight.bold),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRefNoField('Travel'),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRequestDateRangeField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       // buildSpendModeDropdownFieldSafe(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       ConstrainedBox(
  //         constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
  //         child: TextFormField(
  //           decoration: const InputDecoration(labelText: 'Destination City *'),
  //           validator: (value) => value == null || value.isEmpty
  //               ? 'Destination City is required'
  //               : null,
  //         ),
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildPurposeField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildTransportationTravelsDropdownField(), // Constrained dropdown
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       ConstrainedBox(
  //         constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
  //         child: TextFormField(
  //           decoration:
  //               const InputDecoration(labelText: 'Transportation Costs *'),
  //           keyboardType: TextInputType.number,
  //           validator: (value) => value == null || value.isEmpty
  //               ? 'Transportation Costs is required'
  //               : null,
  //         ),
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       ConstrainedBox(
  //         constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
  //         child: TextFormField(
  //           decoration:
  //               const InputDecoration(labelText: 'Accommodation Costs *'),
  //           keyboardType: TextInputType.number,
  //           validator: (value) => value == null || value.isEmpty
  //               ? 'Accommodation Costs is required'
  //               : null,
  //         ),
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       ConstrainedBox(
  //         constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
  //         child: TextFormField(
  //           decoration: const InputDecoration(labelText: 'Subsistence Costs *'),
  //           keyboardType: TextInputType.number,
  //           validator: (value) => value == null || value.isEmpty
  //               ? 'Subsistence Costs is required'
  //               : null,
  //         ),
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       ConstrainedBox(
  //         constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
  //         child: TextFormField(
  //           decoration: const InputDecoration(labelText: 'Other Costs'),
  //           keyboardType: TextInputType.number,
  //         ),
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildDescriptionField(),
  //     ],
  //   );
  // }
Widget buildTravelsForm() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText(text: 'Travels Details', fontWeight: FontWeight.bold),
      SizedBox(height: getProportionateScreenWidth(10)),
      //buildRefNoField('Travel'),
      buildRefNoFieldTravel('Travel'),
      SizedBox(height: getProportionateScreenWidth(10)),
      buildRequestDateRangeField(),
      SizedBox(height: getProportionateScreenWidth(10)),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
        child: TextFormField(
          controller: _expenseController.locationController,
            style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(labelText: 'Destination City *'),
          
          onChanged: (value) => _expenseController.location.value = value,
          validator: (value) => value == null || value.isEmpty
              ? 'Destination City is required'
              : null,
        ),
      ),
      SizedBox(height: getProportionateScreenWidth(10)),
      buildPurposeField(),
      SizedBox(height: getProportionateScreenWidth(10)),
      buildTransportationTravelsDropdownField(),
      SizedBox(height: getProportionateScreenWidth(10)),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
        child: TextFormField(
          controller: _expenseController.transportationCostsController,
          style: const TextStyle(color: Colors.black), // 👈 add this
          decoration:  const InputDecoration(labelText: 'Transportation Costs *',
          labelStyle: TextStyle(color: Colors.black87), // 👈 label visible
    filled: true,
    fillColor: Colors.white,    ),
          
          keyboardType: TextInputType.number,
          onChanged: (value) => _expenseController.transportationCosts.value = value,
          validator: (value) => value == null || value.isEmpty
              ? 'Transportation Costs is required'
              : double.tryParse(value) == null || double.parse(value) <= 0
                  ? 'Enter a valid amount'
                  : null,
        ),
      ),
      SizedBox(height: getProportionateScreenWidth(10)),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
        child: TextFormField(
          controller: _expenseController.accommodationCostsController,
          style: const TextStyle(color: Colors.black), // 👈 add this
          decoration: const InputDecoration(labelText: 'Accommodation Costs *'),
          keyboardType: TextInputType.number,
          onChanged: (value) => _expenseController.accommodationCosts.value = value,
          validator: (value) => value == null || value.isEmpty
              ? 'Accommodation Costs is required'
              : double.tryParse(value) == null || double.parse(value) <= 0
                  ? 'Enter a valid amount'
                  : null,
        ),
      ),
      SizedBox(height: getProportionateScreenWidth(10)),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
        child: TextFormField(
          controller: _expenseController.subsistenceCostsController,
          style: const TextStyle(color: Colors.black), // 👈 add this
          decoration: const InputDecoration(labelText: 'Subsistence Costs *'),
          keyboardType: TextInputType.number,
          onChanged: (value) => _expenseController.subsistenceCosts.value = value,
          validator: (value) => value == null || value.isEmpty
              ? 'Subsistence Costs is required'
              : double.tryParse(value) == null || double.parse(value) <= 0
                  ? 'Enter a valid amount'
                  : null,
        ),
      ),
      SizedBox(height: getProportionateScreenWidth(10)),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
        child: TextFormField(
          controller: _expenseController.otherCostsController,
          style: const TextStyle(color: Colors.black), // 👈 add this
          decoration: const InputDecoration(labelText: 'Other Costs'),
          keyboardType: TextInputType.number,
          onChanged: (value) => _expenseController.otherCosts.value = value,
          validator: (value) =>
              value != null && value.isNotEmpty && double.tryParse(value) == null
                  ? 'Enter a valid amount'
                  : null,
        ),
      ),
      SizedBox(height: getProportionateScreenWidth(10)),
      buildDescriptionField(),
    ],
  );
}
  Widget buildEntertainmentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
            text: '${_expenseController.transactionType.value} Details',
            fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildRefNoField(_expenseController.transactionType.value),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildRequestDateField(),
        if (_expenseController.spendMode.value == 'Advance')
          buildAdvanceAmountField(),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildPurposeField(),
        if (_expenseController.spendMode.value != 'Advance') ...[
          SizedBox(height: getProportionateScreenWidth(10)),
          AppText(text: 'Items *', fontWeight: FontWeight.bold),
          SizedBox(height: getProportionateScreenWidth(10)),
          Obx(() => Column(
                children: _expenseController.entertainmentItems
                    .asMap()
                    .entries
                    .map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: item['item'],
                              decoration:
                                  const InputDecoration(labelText: 'Item'),
                              onChanged: (value) => item['item'] = value,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Item is required'
                                      : null,
                            ),
                          ),
                          SizedBox(width: getProportionateScreenWidth(10)),
                          Expanded(
                            child: TextFormField(
                              initialValue: item['quantity'],
                              decoration:
                                  const InputDecoration(labelText: 'Quantity'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                item['quantity'] = value;
                                _expenseController
                                    .calculateEntertainmentAmount(index);
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Quantity is required'
                                      : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height: getProportionateScreenWidth(
                              10)), // Added vertical spacing
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: item['price'],
                              decoration: const InputDecoration(
                                  labelText: 'Price (BDT)'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                item['price'] = value;
                                _expenseController
                                    .calculateEntertainmentAmount(index);
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Price is required'
                                      : null,
                            ),
                          ),
                          SizedBox(width: getProportionateScreenWidth(10)),
                          Expanded(
                            child: TextFormField(
                              initialValue: item['amount'],
                              decoration: const InputDecoration(
                                  labelText: 'Amount (BDT)'),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add, color: kPrimaryColor),
                            onPressed: _expenseController.addEntertainmentItem,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _expenseController
                                .removeEntertainmentItem(index),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              )),
          SizedBox(height: getProportionateScreenWidth(10)),
          TextFormField(
            initialValue: _expenseController
                .calculateTotalAmount(
                    _expenseController.entertainmentItems, 'amount')
                .toString(),
            decoration: const InputDecoration(labelText: 'Total Amount'),
            readOnly: true,
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
          GestureDetector(
            onTap: _expenseController.pickFile,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Obx(
                  () => AppText(text: _expenseController.uploadFileName.value)),
            ),
          ),
        ],
      ],
    );
  }

  // Widget buildExpatForm() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       AppText(text: 'Expat Details', fontWeight: FontWeight.bold),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRefNoField('Expat'),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildRequestDateField(),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       AppText(text: 'Description *', fontWeight: FontWeight.bold),
  //       Obx(() => Column(
  //             children:
  //                 _expenseController.expatItems.asMap().entries.map((entry) {
  //               final index = entry.key;
  //               final item = entry.value;
  //               return Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: TextFormField(
  //                           initialValue: item['companyName'],
  //                           decoration: const InputDecoration(
  //                               labelText: 'Company Name'),
  //                           onChanged: (value) => item['companyName'] = value,
  //                           validator: (value) => value == null || value.isEmpty
  //                               ? 'Company Name is required'
  //                               : null,
  //                         ),
  //                       ),
  //                       SizedBox(width: getProportionateScreenWidth(10)),
  //                       Expanded(
  //                         child: TextFormField(
  //                           initialValue: item['particular'],
  //                           decoration:
  //                               const InputDecoration(labelText: 'Particulars'),
  //                           onChanged: (value) => item['particular'] = value,
  //                           validator: (value) => value == null || value.isEmpty
  //                               ? 'Particulars are required'
  //                               : null,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(width: getProportionateScreenWidth(10)),
  //                   Row(
  //                     children: [
  //                       Expanded(
  //                         child: TextFormField(
  //                           initialValue: item['billType'],
  //                           decoration: const InputDecoration(
  //                               labelText: 'Type of Bill'),
  //                           onChanged: (value) => item['billType'] = value,
  //                           validator: (value) => value == null || value.isEmpty
  //                               ? 'Bill Type is required'
  //                               : null,
  //                         ),
  //                       ),
  //                       SizedBox(width: getProportionateScreenWidth(10)),
  //                       Expanded(
  //                         child: TextFormField(
  //                           initialValue: item['cost'],
  //                           decoration:
  //                               const InputDecoration(labelText: 'Cost (BDT)'),
  //                           keyboardType: TextInputType.number,
  //                           onChanged: (value) {
  //                             item['cost'] = value;
  //                             _expenseController.expatItems.refresh();
  //                           },
  //                           validator: (value) => value == null || value.isEmpty
  //                               ? 'Cost is required'
  //                               : null,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(width: getProportionateScreenWidth(10)),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       IconButton(
  //                         icon: const Icon(Icons.add, color: kPrimaryColor),
  //                         onPressed: _expenseController.addExpatItem,
  //                       ),
  //                       IconButton(
  //                         icon: const Icon(Icons.delete, color: Colors.red),
  //                         onPressed: () =>
  //                             _expenseController.removeExpatItem(index),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               );
  //             }).toList(),
  //           )),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       TextFormField(
  //         initialValue: _expenseController
  //             .calculateTotalAmount(_expenseController.expatItems, 'cost')
  //             .toString(),
  //         decoration: const InputDecoration(labelText: 'Total Amount'),
  //         readOnly: true,
  //       ),
  //       SizedBox(height: getProportionateScreenWidth(10)),
  //       buildDescriptionField(),
  //     ],
  //   );
  // }
  Widget buildExpatForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: 'Expat Details', fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildRefNoField('Expat'),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildRequestDateField(),
        SizedBox(height: getProportionateScreenWidth(10)),
        AppText(text: 'Description *', fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),
        Obx(() => Column(
              children:
                  _expenseController.expatItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: SizeConfig.screenWidth * 0.45),
                            child: TextFormField(
                              initialValue: item['companyName'],
                              decoration: const InputDecoration(
                                  labelText: 'Company Name'),
                              onChanged: (value) => item['companyName'] = value,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Company Name is required'
                                      : null,
                            ),
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(10)),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: SizeConfig.screenWidth * 0.45),
                            child: TextFormField(
                              initialValue: item['particular'],
                              decoration: const InputDecoration(
                                  labelText: 'Particulars'),
                              onChanged: (value) => item['particular'] = value,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Particulars are required'
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: getProportionateScreenWidth(
                            10)), // Added vertical spacing
                    Row(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: SizeConfig.screenWidth * 0.45),
                            child: TextFormField(
                              initialValue: item['billType'],
                              decoration: const InputDecoration(
                                  labelText: 'Type of Bill'),
                              onChanged: (value) => item['billType'] = value,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Bill Type is required'
                                      : null,
                            ),
                          ),
                        ),
                        SizedBox(width: getProportionateScreenWidth(10)),
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: SizeConfig.screenWidth * 0.45),
                            child: TextFormField(
                              initialValue: item['cost'],
                              decoration: const InputDecoration(
                                  labelText: 'Cost (BDT)'),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                item['cost'] = value;
                                _expenseController.expatItems.refresh();
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Cost is required'
                                      : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, color: kPrimaryColor),
                          onPressed: _expenseController.addExpatItem,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _expenseController.removeExpatItem(index),
                        ),
                      ],
                    ),
                  ],
                );
              }).toList(),
            )),
        SizedBox(height: getProportionateScreenWidth(10)),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth),
          child: TextFormField(
            initialValue: _expenseController
                .calculateTotalAmount(_expenseController.expatItems, 'cost')
                .toString(),
            decoration: const InputDecoration(labelText: 'Total Amount'),
            readOnly: true,
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildDescriptionField(),
      ],
    );
  }

  Widget buildTrainingForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: 'Training Details', fontWeight: FontWeight.bold),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildRefNoField('Training'),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildRequestDateField(),
        SizedBox(height: getProportionateScreenWidth(10)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Institution Name *'),
          validator: (value) => value == null || value.isEmpty
              ? 'Institution Name is required'
              : null,
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Course Name *'),
          validator: (value) =>
              value == null || value.isEmpty ? 'Course Name is required' : null,
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildDescriptionField(),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildAdmissionDateField(),
        SizedBox(height: getProportionateScreenWidth(10)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Duration *'),
          validator: (value) =>
              value == null || value.isEmpty ? 'Duration is required' : null,
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Costs *'),
          keyboardType: TextInputType.number,
          validator: (value) =>
              value == null || value.isEmpty ? 'Costs is required' : null,
        ),
        SizedBox(height: getProportionateScreenWidth(10)),
        buildPurposeField(),
      ],
    );
  }

  Container buildRequestDateField() {
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
      child: Row(
        children: [
          const Icon(Icons.calendar_today),
          SizedBox(width: getProportionateScreenWidth(10)),
          Expanded(
            child: TextFormField(
              style: const TextStyle(color: Colors.black),   // ✅ correct place
              controller: TextEditingController(
                text: _expenseController.transactionDate.value != null
                    ? _expenseController.transactionDate.value
                        .toString()
                        .split(' ')[0]
                    : '',
              ),
              decoration: const InputDecoration(
                 
                labelText: 'Date of Expense *',
                labelStyle: TextStyle(color: Colors.black87),
                border: InputBorder.none,
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: _expenseController.transactionDate.value ??
                      DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  _expenseController.onDateChanged(pickedDate);
                }
              },
              validator: (value) =>
                  _expenseController.transactionDate.value == null
                      ? 'Date of expense is required'
                      : null,
            ),
          ),
          if (_expenseController.transactionDate.value != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: () => _expenseController.onDateChanged(null),
            ),
        ],
      ),
    );
  }

  // Container buildRequestDateRangeField() {
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
  //     child: Row(
  //       children: [
  //         const Icon(Icons.calendar_today),
  //         SizedBox(width: getProportionateScreenWidth(10)),
  //         Expanded(
  //           child: TextFormField(
  //             decoration: const InputDecoration(
                
  //               labelText: 'Date of Travels',
  //               border: InputBorder.none,
  //             ),
  //             readOnly: true,
  //             onTap: () async {
  //               // Placeholder for date range picker (to be implemented)
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
Container buildRequestDateRangeField() {
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
    child: Obx(() {
      final DateTimeRange? range = _expenseController.transactionDateRange.value;
      final display = range != null
          ? '${range.start.toString().split(' ')[0]} - ${range.end.toString().split(' ')[0]}'
          : 'Date of Travels';

      return Row(
        children: [
          const Icon(Icons.calendar_today),
          SizedBox(width: getProportionateScreenWidth(10)),
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: display,
                border: InputBorder.none,
              ),
              readOnly: true,
              onTap: () async {
                final initial = _expenseController.transactionDateRange.value;
                final picked = await showDateRangePicker(
                  context: Get.context!,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  initialDateRange: initial,
                );
                if (picked != null) {
                  // store to controller so other code can use it
                  _expenseController.transactionDateRange.value = picked;
                  _expenseController.fromDate.value = picked.start;
                  _expenseController.toDate.value = picked.end;

                  // Optional: set transactionDate to start (if other code expects single date)
                  _expenseController.transactionDate.value = picked.start;
                }
              },
              validator: (value) =>
                  _expenseController.transactionDateRange.value == null
                      ? 'Travel date range is required'
                      : null,
            ),
          ),
        ],
      );
    }),
  );
}
  // Container buildCompanyNameField() {
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
  //     child: TextFormField(
  //       decoration: const InputDecoration(labelText: 'Company Name *'),
  //       validator: (value) =>
  //           value == null || value.isEmpty ? 'Company Name is required' : null,
  //     ),
  //   );
  // }
Widget buildCompanyNameField() {
  return TextFormField(
    controller: _expenseController.companyNameController,
    style: const TextStyle(color: Colors.black), // 👈 add this
    decoration: const InputDecoration(
      labelText: 'Company Name',
      labelStyle: TextStyle(color: Colors.black87), // 👈 label visible
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter company name';
      }
      return null;
    },
  );
}

  // Container buildAdvanceAmountField() {
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
  //     child: TextFormField(
  //       decoration: const InputDecoration(labelText: 'Advance Amount *'),
  //       keyboardType: TextInputType.number,
  //       validator: (value) => value == null || value.isEmpty
  //           ? 'Advance Amount is required'
  //           : null,
  //     ),
  //   );
  // }
// Widget buildRefNoFieldTravel(String type) {
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
//     child: Obx(() => TextFormField(
//           controller: TextEditingController(text: _expenseController.referenceNo.value),
//           style: const TextStyle(color: Colors.black), // 👈 add this
//           decoration: const InputDecoration(
//             labelText: 'Reference No *',
//             labelStyle: TextStyle(color: Colors.black87), // 👈 label visible
//     filled: true,
//     fillColor: Colors.white, // 👈 white background
//             border: InputBorder.none,
//           ),
//           readOnly: true,
//           validator: (value) => value == null || value.isEmpty
//               ? 'Reference Number is required'
//               : null,
//           onTap: () async {
//             // Generate reference number when the field is tapped or form is initialized
//             String refNo = await _expenseController.generateRefNo(
//               _expenseController.transactionDate.value ?? DateTime.now(),
//               type,
//             );
//             _expenseController.referenceNo.value = refNo;
//           },
//         )),
//   );
// }
// Widget buildRefNoFieldTravel(String type) {
//   // generate once if empty
//   if (_expenseController.referenceNo.value.isEmpty) {
//     _expenseController.referenceNo.value = _expenseController.generateRefNo(
//       DateTime.now(),
//       type,
//     );
//   }

//   final controller = TextEditingController(
//     text: _expenseController.referenceNo.value,
//   );

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
//     child: Obx(() {
//       controller.text = _expenseController.referenceNo.value;
//       return TextFormField(
//         controller: controller,
//         style: const TextStyle(color: Colors.black),
//         decoration: const InputDecoration(
//           labelText: 'Reference No *',
//           labelStyle: TextStyle(color: Colors.black87),
//           filled: true,
//           fillColor: Colors.white,
//           border: InputBorder.none,
//         ),
//         readOnly: true,
//         validator: (value) => value == null || value.isEmpty
//             ? 'Reference Number is required'
//             : null,
//       );
//     }),
//   );
// }

  Container buildRefNoField(String type) {
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
      child: TextFormField(
        initialValue: _expenseController.generateRefNo(DateTime.now(), type),
        decoration: const InputDecoration(
          labelText: 'Reference No',
          border: InputBorder.none,
        ),
        readOnly: true,
      ),
    );
  }

  // Container buildPurposeField() {
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
  //     child: TextFormField(
  //       maxLines: 3,
  //       decoration: const InputDecoration(labelText: 'Purpose *'),
  //       validator: (value) =>
  //           value == null || value.isEmpty ? 'Purpose is required' : null,
  //     ),
  //   );
  // }
  Container buildPurposeField() {
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
    child: TextFormField(
      controller: _expenseController.purposeController, // Add this
        style: const TextStyle(color: Colors.black),
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Purpose *',
        labelStyle: TextStyle(color: Colors.black87),
        border: OutlineInputBorder(), // Optional: gives a better look
      ),
      onChanged: (value) => _expenseController.purpose.value = value,
      validator: (value) =>
          value == null || value.isEmpty ? 'Purpose is required' : null,
    ),
  );
}


  // Container buildTransportationTravelsDropdownField() {
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
  //     child: DropdownButtonFormField<String>(
  //       decoration: const InputDecoration(
  //         enabled: false,
  //         border: InputBorder.none,
  //       ),
  //       value: null,
  //       items: [
  //         const DropdownMenuItem<String>(
  //           value: '',
  //           child: AppText(text: '---Select Type---'),
  //         ),
  //         ..._expenseController.travelTransports
  //             .map((mode) => DropdownMenuItem<String>(
  //                   value: mode,
  //                   child: AppText(text: mode),
  //                 )),
  //       ],
  //       onChanged: (value) {},
  //       validator: (value) => value == null || value.isEmpty
  //           ? 'Transportation is required'
  //           : null,
  //     ),
  //   );
  // }
  // Container buildTransportationTravelsDropdownField() {
  //   return Container(
  //     padding:
  //         EdgeInsets.all(getProportionateScreenWidth(8)), // Reduced padding
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
  //     child: Obx(() => DropdownButtonFormField<String>(
  //           isExpanded: true, // Ensures dropdown takes available width
  //           decoration: const InputDecoration(
  //             labelText: 'Transportation *',
  //             border: InputBorder.none,
  //           ),
  //           value: _expenseController.travelTransport.value.isEmpty
  //               ? null
  //               : _expenseController.travelTransport.value,
  //           items: [
  //             const DropdownMenuItem<String>(
  //               value: null,
  //               child: AppText(
  //                 text: '---Select Type---',
  //                 size: kTextSize - 2,
  //                 overflow: TextOverflow.ellipsis, // Truncate long text
  //               ),
  //             ),
  //             ..._expenseController.travelTransports
  //                 .map((mode) => DropdownMenuItem<String>(
  //                       value: mode,
  //                       child: ConstrainedBox(
  //                         constraints: BoxConstraints(
  //                           maxWidth: SizeConfig.screenWidth *
  //                               0.8, // Limit item width
  //                         ),
  //                         child: AppText(
  //                           text: mode,
  //                           size: kTextSize - 2,
  //                           overflow:
  //                               TextOverflow.ellipsis, // Truncate long text
  //                         ),
  //                       ),
  //                     )),
  //           ],
  //           onChanged: (_expenseController.emailFlag.value != 'Edit' &&
  //                   _expenseController.spendMode.value.isNotEmpty)
  //               ? (value) {
  //                   _expenseController.travelTransport.value = value ?? '';
  //                   if (value != null) {
  //                     _expenseController.removeError(
  //                         error: 'Transportation is required');
  //                   } else {
  //                     _expenseController.addError(
  //                         error: 'Transportation is required');
  //                   }
  //                 }
  //               : null,
  //           validator: (value) => value == null || value.isEmpty
  //               ? 'Transportation is required'
  //               : null,
  //         )),
  //   );
  // }
  Container buildTransportationTravelsDropdownField() {
    return Container(
      padding: EdgeInsets.all(
          getProportionateScreenWidth(10)), // Match buildConveyanceForm
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
      child: Obx(() => DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Transportation *',
                border: InputBorder.none,
              ),
              value: _expenseController.travelTransport.value.isEmpty
                  ? null
                  : _expenseController.travelTransport.value,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: AppText(
                    text: '---Select Type---',
                    size: kTextSize - 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ..._expenseController.travelTransports
                    .map((mode) => DropdownMenuItem<String>(
                          value: mode,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: SizeConfig.screenWidth * 0.8,
                            ),
                            child: AppText(
                              text: mode,
                              size: kTextSize - 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )),
              ],
              onChanged: (_expenseController.emailFlag.value != 'Edit' &&
                      _expenseController.spendMode.value.isNotEmpty)
                  ? (value) {
                      _expenseController.travelTransport.value = value ?? '';
                      if (value != null && value.isNotEmpty) {
                        _expenseController.removeError(
                            error: 'Transportation is required');
                      } else {
                        _expenseController.addError(
                            error: 'Transportation is required');
                      }
                      _expenseController.travelTransport
                          .refresh(); // Ensure UI update
                    }
                  : null,
              validator: (value) => value == null || value.isEmpty
                  ? 'Transportation is required'
                  : null,
            ),
          )),
    );
  }

  Container buildAdmissionDateField() {
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
      child: Row(
        children: [
          const Icon(Icons.calendar_today),
          SizedBox(width: getProportionateScreenWidth(10)),
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Date of Admission *',
                border: InputBorder.none,
              ),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  // Implement date setting logic
                }
              },
              validator: (value) => value == null || value.isEmpty
                  ? 'Date of Admission is required'
                  : null,
            ),
          ),
          if (false) // Placeholder condition
            // ignore: dead_code
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  Container buildDescriptionField() {
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
      child: TextFormField(
        maxLines: 3,
        decoration: const InputDecoration(labelText: 'Description'),
      ),
    );
  }
}
