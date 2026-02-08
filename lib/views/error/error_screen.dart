import 'package:flutter/material.dart';
import '10_connection_lost.dart';
import '11_broken_link.dart';
import '12_artical_not_found.dart';
import '13_no_space.dart';
import '14_no_result_found.dart';
import '15_payment_faild.dart';
import '16_time_error.dart';
import '17_location_error.dart';
import '18_router_offline.dart';
import '19_connection_faild.dart';
import '1_no_connection.dart';
import '20_no_file.dart';
import '21_camera_access.dart';
import '2_404_error.dart';
import '3_something_went_wrong.dart';
import '4_file_not_found.dart';
import '5_something_wrong.dart';
import '6_error.dart';
import '7_error_2.dart';
import '8_404_error_2.dart';
import '9_location_access.dart';

class ErrorScreen extends StatefulWidget {
  final String? errorPageName;

  const ErrorScreen({super.key, this.errorPageName});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  late Widget _body;
  List<Widget> screenList = [
    const NoConnectionScreen(),
    const Error404Screen(),
    const Error404Screen2(),
    const SomethingWentWrongScreen(),
    const FileNotFoundScreen(),
    const SomethingWrongScreen(),
    const Error1Screen(),
    const Error2Screen(),
    const LocationAccessScreen(),
    const ConnectionLostScreen(),
    const BrokenLinkScreen(),
    const ArticleNotFoundScreen(),
    const NoSpaceScreen(),
    const NoResultFoundScreen(),
    const PaymentFaildScreen(),
    const TimeErrorScreen(),
    const LocationErrorScreen(),
    const RouterOfflineScreen(),
    const ConnectionFaildScreen(),
    const NoFileScreen(),
    const CameraAccessScreen(),
  ];
  @override
  void initState() {
    super.initState();

    if (widget.errorPageName != null) {
      _body = screenList.firstWhere(
          (e) => e.toString() == widget.errorPageName.toString(),
          orElse: () => const SomethingWentWrongScreen());
    } else {
      _body = const SomethingWentWrongScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body);
  }
}

/*

import 'package:flutter/material.dart';

import '10_connection_lost.dart';
import '11_broken_link.dart';
import '12_artical_not_found.dart';
import '13_no_space.dart';
import '14_no_result_found.dart';
import '15_payment_faild.dart';
import '16_time_error.dart';
import '17_location_error.dart';
import '18_router_offline.dart';
import '19_connection_faild.dart';
import '1_no_connection.dart';
import '20_no_file.dart';
import '21_camera_access.dart';
import '2_404_error.dart';
import '3_something_went_wrong.dart';
import '4_file_not_found.dart';
import '5_something_wrong.dart';
import '6_error.dart';
import '7_error_2.dart';
import '8_404_error_2.dart';
import '9_location_access.dart';

class ErrorScreen extends StatelessWidget {
  final String? errorPageName;

  const ErrorScreen({Key? key, this.errorPageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> screenList = [
      const NoConnectionScreen(),
      const Error404Screen(),
      const Error404Screen2(),
      const SomethingWentWrongScreen(),
      const FileNotFoundScreen(),
      const SomethingWrongScreen(),
      const Error1Screen(),
      const Error2Screen(),
      const LocationAccessScreen(),
      const ConnectionLostScreen(),
      const BrokenLinkScreen(),
      const ArticleNotFoundScreen(),
      const NoSpaceScreen(),
      const NoResultFoundScreen(),
      const PaymentFaildScreen(),
      const TimeErrorScreen(),
      const LocationErrorScreen(),
      const RouterOfflineScreen(),
      const ConnectionFaildScreen(),
      const NoFileScreen(),
      const CameraAccessScreen(),
    ];

    return MaterialApp(
      title: 'Error',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Swipe to check the next Screen
      home: PageView.builder(
          itemCount: screenList.length,
          itemBuilder: (context, index) {
            return screenList[index];
          }),
    );
  }
}

*/
