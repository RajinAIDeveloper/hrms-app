import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'components/body.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      body: const Body(),
      bottomNavigationBar: const CustomBottomNavBar(
        activeIndex: 2,
      ),
    );
  }
}
