// ignore_for_file: unused_import

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/token_const.dart';
import 'package:root_app/dependency-injection/dependency_injection_locator.dart';
import 'package:root_app/models/authentication/sign_in_response_model.dart';
import 'package:root_app/provider/user_provider.dart';
import 'package:root_app/services/notification/notification_service.dart';
import 'package:root_app/theme/theme.dart';
import 'package:root_app/routes/router.dart' as router;
import 'package:root_app/views/home/home_screen.dart';
import 'package:root_app/views/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/authentication/sign in/sign_in_screen.dart';
import 'views/authentication/splash/splash_screen.dart';
import 'views/onboard/onboard_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Get-Local Storage
  await GetStorage.init();

// // Initialize notification service
//   await NotificationService().initialize();
//    await NotificationService().scheduleDailyLunchReminder();
// Initialize GetIt-Dependency Injections (DI)
  await dependencyInjections();
  
  // Initialize notification service with lunch checking
  await NotificationService().initialize();
  await NotificationService().scheduleDailyLunchReminder();
  
  debugPrint('✅ Lunch notification service initialized and scheduled');
  UserInfo? user;
  final getStorge = GetStorage();
  final userJsonString = getStorge.read(USER_SIGN_IN_KEY);

  if (userJsonString != null) {
    user = UserInfo.fromJson(json.decode(userJsonString));

    //for password expire
    var now = DateTime.now();

    // Check for password expiration (assuming 'passwordExpiry' is stored)
    DateTime passwordExpiry;
    try {
      passwordExpiry = DateTime.parse(
          json.decode(userJsonString)['passwordExpiry'] ?? now.toString());
    } catch (e) {
      passwordExpiry = now; // Default to now if parsing fails
    }

    // Password expires after 30 days
    if (!passwordExpiry.isBefore(now)) {
      //user = null; // Use the deserialized user if password hasn't expired
    } else {
      // If password has expired, clear the stored data to force re-login
      await getStorge.remove(USER_SIGN_IN_KEY);
      user = null; // Set user to null to force re-login
    }
  }

  // Locking App Orientation in Portrait Mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize GetIt-Dependency Injections (DI)
  //dependencyInjections();

  runApp(MyApp(loggedInUser: user));
}

class MyApp extends StatelessWidget {
  final UserInfo? loggedInUser;

  const MyApp({super.key, this.loggedInUser});

  @override
  Widget build(BuildContext context) {
    // You have to call it on your starting screen
    //SizeConfig().init(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(user: loggedInUser)),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Themes().lightTheme,
        darkTheme: Themes().darkTheme,
        //themeMode: ThemeMode.system,
        themeMode: ThemeService().getThemeMode(),
        home: loggedInUser == null ? const OnboardScreen() : const HomeScreen(),

        /*
        const SignInScreen(),
        const HomeScreen(),
        const SplashScreen(),
        const ErrorScreen(errorPageName: NO_CONNECTION_SCREEN,),
        */
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}
