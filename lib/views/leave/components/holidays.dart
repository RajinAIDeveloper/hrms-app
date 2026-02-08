import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'dart:math' as math;
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/controllers/leave/leave_controller.dart';

class Holidays extends StatelessWidget {
  Holidays({
    super.key,
  });
  final _leaveController = Get.find<LeaveController>();

  @override
  Widget build(BuildContext context) {
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
      child: Obx((() => _leaveController.holidays.isEmpty
          ? const CircularProgressIndicator()
          : Column(
              children: [
                const CustomTableHeader(
                  headerTitles: ["Date", "Reason"],
                  colSizes: [6, 10],
                ),
                SizedBox(height: getProportionateScreenHeight(5)),
                CustomTableBody(
                  colSizes: const [6, 10],
                  bodyData: _getTableBody(),
                ),
              ],
            ))),
    );
  }

  List<List<String>> _getTableBody() {
    List<List<String>> result = [];
    for (var holiday in _leaveController.holidays) {
      List<String> row = [];
      row.add(holiday.date!);
      row.add(holiday.title!);
      result.add(row);
    }
    return result;
  }
}
