import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/services/meal/lunch_service.dart';
import 'components/body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    SizeConfig().init(context);
    // TEST: Check if service is registered
    try {
      final service = GetIt.instance<LunchRequestService>();
      debugPrint('✅ LunchRequestService is registered: $service');
    } catch (e) {
      debugPrint('❌ LunchRequestService is NOT registered: $e');
    }
    return Scaffold(
      key: scaffoldKey,
      body: Body(),
      bottomNavigationBar: const CustomBottomNavBar(
        activeIndex: 0,
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:root_app/components/components.dart';
// import 'package:root_app/configs/size_config.dart';
// import 'package:root_app/services/meal/lunch_service.dart';
// import 'package:root_app/views/meal/lunch_reminder_wrapper.dart';
// import 'package:root_app/views/notification/components/notification_test.dart';
// import 'components/body.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
  
//   @override
//   Widget build(BuildContext context) {
//     var scaffoldKey = GlobalKey<ScaffoldState>();
//     SizeConfig().init(context);
//     // TEST: Check if service is registered
//     try {
//       final service = GetIt.instance<LunchRequestService>();
//       debugPrint('✅ LunchRequestService is registered: $service');
//     } catch (e) {
//       debugPrint('❌ LunchRequestService is NOT registered: $e');
//     }
    
//     return Scaffold(
//       key: scaffoldKey,
//       body: Body(),
//       bottomNavigationBar: const CustomBottomNavBar(
//         activeIndex: 0,
//       ),
//       // ADD FLOATING ACTION BUTTON HERE
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => NotificationTestScreen()),
//           );
//         },
//         child: Icon(Icons.notifications),
//         tooltip: 'Test Notifications',
//         backgroundColor: Colors.orange, // Optional: make it stand out
//       ),
//     );
//   }
// }