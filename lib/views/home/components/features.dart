import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/const_image.dart';
import 'package:root_app/routes/routing_constants.dart';
import 'package:root_app/views/home/components/components.dart';

class Features extends StatelessWidget {
  const Features({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> featuresRow1 = [
      {
        "icon": "$kIconPath/payroll.svg",
        "text": "Payroll",
        "route": PAYROLL_SCREEN
      },
      {
        "icon": "$kIconPath/leave_report.svg",
        "text": "Leave",
        "route": LEAVE_SCREEN
      },
      {
        "icon": "$kIconPath/shift-emp.svg",
        "text": "Shift Management",
        "route": SHIFT_SCREEN
      },
      {
        "icon": "$kIconPath/daily_attendance.svg",
        "text": "Attendance",
        "route": ATTENDANCE_SCREEN
      },
    ];
    List<Map<String, dynamic>> featuresRow2 = [
      {
        "icon": "$kIconPath/cost-icon.svg",
        "text": "Expense Management",
        "route": EXPENSE_SCREEN
      },
      {
        "icon": "$kIconPath/food_1.svg",
        "text": "Meal Subscription",
        "route": MEAL_SCREEN
      },
      {
        "icon": "$kIconPath/confirmation.svg",
        "text": "Recruiting",
        "route": PAYROLL_SCREEN
      },
      {
        "icon": "$kIconPath/early_departure.svg",
        "text": "Early Departure",
        "route": EARLY_DEPARTURE_SCREEN
      },
    ];
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              featuresRow1.length,
              (index) => FeatureCard(
                icon: featuresRow1[index]["icon"],
                text: featuresRow1[index]["text"],
                press: () {
                  debugPrint(featuresRow1[index]["text"] + ' Clicked!');
                  Navigator.pushNamed(
                    context,
                    featuresRow1[index]["route"],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenWidth(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              featuresRow2.length,
              (index) => FeatureCard(
                icon: featuresRow2[index]["icon"],
                text: featuresRow2[index]["text"],
                press: () {
                  debugPrint(featuresRow2[index]["text"] + ' Clicked!');
                  Navigator.pushNamed(
                    context,
                    featuresRow2[index]["route"],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
