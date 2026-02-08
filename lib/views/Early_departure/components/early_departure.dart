import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:root_app/components/components.dart'; // Assuming AppText is here
import 'package:root_app/configs/configs.dart';
import 'package:root_app/controllers/early_departure/early_departure_controller.dart';
import 'package:root_app/constants/constants.dart';
import 'dart:math' as math;

class EarlyDeparture extends StatelessWidget {
  EarlyDeparture({super.key});

  final _earlyDepartureController = Get.find<EarlyDepartureController>();

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
          // Title
          const AppText(
            text: "Early Departure Purpose",
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
            size: kTextSize + 2,
          ),
          SizedBox(height: getProportionateScreenWidth(20)),

          // Departure Date Field
          Obx(
            () => TextFormField(
              readOnly: true,
              style: const TextStyle(
                  color: Colors.black), // 👈 Ensure text is black
              decoration: InputDecoration(
                labelText: "Departure Date *",
                prefixIcon: const Icon(Icons.calendar_today),
                suffixIcon: _earlyDepartureController.selectedDate.value != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          _earlyDepartureController.selectedDate.value = null;
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: TextEditingController(
                text: _earlyDepartureController.selectedDate.value != null
                    ? DateFormat('yyyy-MM-dd')
                        .format(_earlyDepartureController.selectedDate.value!)
                    : '',
              ),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  _earlyDepartureController.selectedDate.value = picked;
                }
              },
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(20)),

          // Departure Time Field
          Obx(
            () => TextFormField(
              readOnly: true,
              style: const TextStyle(
                  color: Colors.black), // 👈 Ensure text is black
              decoration: InputDecoration(
                labelText: "Departure Time *",
                prefixIcon: const Icon(Icons.access_time),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: TextEditingController(
                text: _earlyDepartureController.selectedTime.value != null
                    ? _earlyDepartureController.selectedTime.value!
                        .format(context)
                    : '',
              ),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  _earlyDepartureController.selectedTime.value = picked;
                }
              },
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(20)),

          // Departure Reason Field
          TextFormField(
            maxLines: 3,
            style:
                const TextStyle(color: Colors.black), // 👈 Ensure text is black
            decoration: InputDecoration(
              labelText: "Departure Reason *",
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              _earlyDepartureController.reason.value = value;
            },
          ),
          SizedBox(height: getProportionateScreenWidth(20)),

          // Submit and Cancel Buttons
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     ElevatedButton.icon(
          //       icon: const Icon(Icons.send, size: 18),
          //       label: Obx(
          //         () => Text(
          //           earlyDepartureController.isSubmitting.value
          //               ? 'Submitting...'
          //               : 'Submit',
          //         ),
          //       ),
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: kPrimaryColor,
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         padding: EdgeInsets.symmetric(
          //           horizontal: getProportionateScreenWidth(15),
          //           vertical: getProportionateScreenWidth(10),
          //         ),
          //       ),
          //       onPressed: earlyDepartureController.isSubmitting.value ||
          //               earlyDepartureController.selectedDate.value == null ||
          //               earlyDepartureController.selectedTime.value == null ||
          //               earlyDepartureController.reason.value.isEmpty
          //           ? null
          //           : () {
          //               final request = {
          //                 //"employeeId": earlyDepartureController.employeeId.value, // or wherever you store it
          //                 "appliedDate": earlyDepartureController
          //                     .selectedDate.value!
          //                     .toIso8601String(),
          //                 "appliedTime": earlyDepartureController
          //                     .selectedTime.value!
          //                     .format(context),
          //                 "reason": earlyDepartureController.reason.value,
          //                 // Add more fields as needed (departmentId, etc.)
          //               };

          //               earlyDepartureController.submitEarlyDeparture(request);
          //             },
          //     ),
          // Submit and Cancel Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.send,
                  size: 18,
                  color: Colors.white,
                ),
                label: Obx(
                  () => Text(
                    _earlyDepartureController.isSubmitting.value
                        ? 'Submitting...'
                        : 'Submit',
                    style: const TextStyle(
                      color: Colors.white, // Darker color (adjust as needed)
                      fontWeight:
                          FontWeight.bold, // Optional: make it stand out
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    vertical: getProportionateScreenWidth(10),
                  ),
                ),
                onPressed: _earlyDepartureController.isSubmitting.value
                    ? null
                    : () {
                        if (_earlyDepartureController
                            .earlydepartureFormKey.currentState!
                            .validate()) {
                          final request = {
                            "appliedDate": _earlyDepartureController
                                .selectedDate.value!
                                .toIso8601String(),
                            "appliedTime": _earlyDepartureController
                                .selectedTime.value!
                                .format(context),
                            "reason": _earlyDepartureController.reason.value,
                            "employeeId": 0,
                          };
                          _earlyDepartureController
                              .submitEarlyDeparture(request);
                        }
                      },
              ),
              SizedBox(width: getProportionateScreenWidth(10)),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.cancel,
                  size: 18,
                  color: kPrimaryColor, // Icon matches border color
                ),
                label: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: kPrimaryColor, // Text matches border color
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // No fill color
                  side: const BorderSide(
                    color: kPrimaryColor, // Blue border
                    width: 2, // Border thickness
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  elevation: 0, // Remove shadow for a flat look
                ),
                onPressed: () {
                  _earlyDepartureController.clearForm();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class EarlyDeparture extends StatelessWidget {
//   EarlyDeparture({super.key});

//   final EarlyDepartureController earlyDepartureController =
//       Get.find<EarlyDepartureController>();

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
//       child: Form(
//         key: earlyDepartureController.earlydepartureFormKey,
//         autovalidateMode: earlyDepartureController.autoValidate.value,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const AppText(
//               text: "Early Departure Purpose",
//               fontWeight: FontWeight.bold,
//               color: kPrimaryColor,
//               size: kTextSize + 2,
//             ),
//             SizedBox(height: getProportionateScreenWidth(20)),

//             // Departure Date Field
//             Obx(
//               () => TextFormField(
//                 readOnly: true,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: "Departure Date *",
//                   prefixIcon: const Icon(Icons.calendar_today),
//                   suffixIcon: earlyDepartureController.selectedDate.value !=
//                           null
//                       ? IconButton(
//                           icon: const Icon(Icons.clear, color: Colors.red),
//                           onPressed: () {
//                             earlyDepartureController.selectedDate.value = null;
//                           },
//                         )
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 controller: earlyDepartureController.dateTextController,
//                 validator: (value) =>
//                     earlyDepartureController.selectedDate.value == null
//                         ? "Departure Date is required"
//                         : null,
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime(2030),
//                   );
//                   if (picked != null) {
//                     earlyDepartureController.selectedDate.value = picked;
//                     earlyDepartureController.dateTextController.text =
//                         DateFormat('yyyy-MM-dd').format(picked);
//                   }
//                 },
//               ),
//             ),
//             SizedBox(height: getProportionateScreenWidth(20)),

//             // Departure Time Field
//             Obx(
//               () => TextFormField(
//                 readOnly: true,
//                 style: const TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: "Departure Time *",
//                   prefixIcon: const Icon(Icons.access_time),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 controller: earlyDepartureController.timeTextController,
//                 validator: (value) =>
//                     earlyDepartureController.selectedTime.value == null
//                         ? "Departure Time is required"
//                         : null,
//                 onTap: () async {
//                   TimeOfDay? picked = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (picked != null) {
//                     earlyDepartureController.selectedTime.value = picked;
//                     earlyDepartureController.timeTextController.text =
//                         picked.format(context);
//                   }
//                 },
//               ),
//             ),
//             SizedBox(height: getProportionateScreenWidth(20)),

//             // Departure Reason Field
//             TextFormField(
//               maxLines: 3,
//               style: const TextStyle(color: Colors.black),
//               decoration: InputDecoration(
//                 labelText: "Departure Reason *",
//                 prefixIcon: const Icon(Icons.description),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               validator: (value) =>
//                   value!.isEmpty ? "Reason is required" : null,
//               onChanged: (value) {
//                 earlyDepartureController.reason.value = value;
//               },
//             ),
//             SizedBox(height: getProportionateScreenWidth(20)),

//             // Submit and Cancel Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.send, size: 18),
//                   label: Obx(
//                     () => Text(
//                       earlyDepartureController.isSubmitting.value
//                           ? 'Submitting...'
//                           : 'Submit',
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: kPrimaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: getProportionateScreenWidth(15),
//                       vertical: getProportionateScreenWidth(10),
//                     ),
//                   ),
//                   onPressed: earlyDepartureController.isSubmitting.value
//                       ? null
//                       : () {
//                           if (earlyDepartureController
//                               .earlydepartureFormKey.currentState!
//                               .validate()) {
//                             final request = {
//                               "appliedDate": earlyDepartureController
//                                   .selectedDate.value!
//                                   .toIso8601String(),
//                               "appliedTime": earlyDepartureController
//                                   .selectedTime.value!
//                                   .format(context),
//                               "reason": earlyDepartureController.reason.value,
//                             };
//                             earlyDepartureController
//                                 .submitEarlyDeparture(request);
//                           }
//                         },
//                 ),
//                 SizedBox(width: getProportionateScreenWidth(10)),
//                 ElevatedButton.icon(
//                   icon: const Icon(Icons.cancel, size: 18),
//                   label: const Text('Cancel'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: getProportionateScreenWidth(15),
//                       vertical: getProportionateScreenWidth(10),
//                     ),
//                   ),
//                   onPressed: () {
//                     earlyDepartureController.clearForm();
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EarlyDeparture extends StatelessWidget {
//   EarlyDeparture({super.key});

//   final EarlyDepartureController earlyDepartureController =
//       Get.find<EarlyDepartureController>();

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
//       child: Form(
//         key: earlyDepartureController.earlydepartureFormKey,
//         autovalidateMode: earlyDepartureController.autoValidate.value,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title
//             const AppText(
//               text: "Early Departure Purpose",
//               fontWeight: FontWeight.bold,
//               color: kPrimaryColor,
//               size: kTextSize + 2,
//             ),
//             SizedBox(height: getProportionateScreenWidth(20)),

//             // Departure Date Field
//             Obx(
//               () => TextFormField(
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   labelText: "Departure Date *",
//                   prefixIcon: const Icon(Icons.calendar_today),
//                   suffixIcon: earlyDepartureController.selectedDate.value !=
//                           null
//                       ? IconButton(
//                           icon: const Icon(Icons.clear, color: Colors.red),
//                           onPressed: () {
//                             earlyDepartureController.selectedDate.value = null;
//                           },
//                         )
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 controller: TextEditingController(
//                   text: earlyDepartureController.selectedDate.value != null
//                       ? DateFormat('yyyy-MM-dd')
//                           .format(earlyDepartureController.selectedDate.value!)
//                       : '',
//                 ),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime(2030),
//                   );
//                   if (picked != null) {
//                     earlyDepartureController.selectedDate.value = picked;
//                   }
//                 },
//                 validator: (value) {
//                   if (earlyDepartureController.selectedDate.value == null) {
//                     return 'Please select a departure date';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             SizedBox(height: getProportionateScreenWidth(20)),

//             // Departure Time Field
//             Obx(
//               () => TextFormField(
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   labelText: "Departure Time *",
//                   prefixIcon: const Icon(Icons.access_time),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 controller: TextEditingController(
//                   text: earlyDepartureController.selectedTime.value != null
//                       ? earlyDepartureController.selectedTime.value!
//                           .format(context)
//                       : '',
//                 ),
//                 onTap: () async {
//                   TimeOfDay? picked = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (picked != null) {
//                     earlyDepartureController.selectedTime.value = picked;
//                   }
//                 },
//                 validator: (value) {
//                   if (earlyDepartureController.selectedTime.value == null) {
//                     return 'Please select a departure time';
//                   }
//                   return null;
//                 },
//               ),
//             ),
//             SizedBox(height: getProportionateScreenWidth(20)),

//             // Departure Reason Field
//             TextFormField(
//               maxLines: 3,
//               decoration: InputDecoration(
//                 labelText: "Departure Reason *",
//                 prefixIcon: const Icon(Icons.description),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onChanged: (value) {
//                 earlyDepartureController.reason.value = value;
//               },
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a reason';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: getProportionateScreenWidth(20)),

//             // Submit and Cancel Buttons
//             Obx(
//               () => Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.send, size: 18),
//                     label: Text(
//                       earlyDepartureController.isSubmitting.value
//                           ? 'Submitting...'
//                           : 'Submit',
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: kPrimaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: getProportionateScreenWidth(15),
//                         vertical: getProportionateScreenWidth(10),
//                       ),
//                     ),
//                     onPressed: earlyDepartureController.isSubmitting.value
//                         ? null
//                         : () => earlyDepartureController.submitRequest(),
//                   ),
//                   SizedBox(width: getProportionateScreenWidth(10)),
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.cancel, size: 18),
//                     label: const Text('Cancel'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: getProportionateScreenWidth(15),
//                         vertical: getProportionateScreenWidth(10),
//                       ),
//                     ),
//                     onPressed: () => earlyDepartureController.clearForm(),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: getProportionateScreenWidth(10)),
//             Obx(
//               () => earlyDepartureController.isLoading.value
//                   ? const Center(child: CircularProgressIndicator())
//                   : const SizedBox.shrink(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
