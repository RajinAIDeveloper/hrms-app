import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/views/Attendance/components/components.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      body: Body(),
      bottomNavigationBar: const CustomBottomNavBar(
        activeIndex: -1,
        isActive: false,
      ),
    );
  }
}
