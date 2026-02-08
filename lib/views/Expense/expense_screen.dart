import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/views/Expense/components/components.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});
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
