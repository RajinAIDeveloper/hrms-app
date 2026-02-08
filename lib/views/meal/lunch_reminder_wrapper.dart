import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:root_app/services/meal/lunch_service.dart';

class LunchReminderWrapper extends StatefulWidget {
  final Widget child;
  
  const LunchReminderWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<LunchReminderWrapper> createState() => _LunchReminderWrapperState();
}

class _LunchReminderWrapperState extends State<LunchReminderWrapper> {
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    debugPrint('🔔 LunchReminderWrapper: initState called');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('🔔 LunchReminderWrapper: postFrameCallback triggered');
      if (!_hasChecked) {
        _checkLunchReminder();
        _hasChecked = true;
      }
    });
  }

  Future<void> _checkLunchReminder() async {
    debugPrint('🔔 Starting lunch reminder check...');
    final now = DateTime.now();
    debugPrint('🔔 Current time: ${now.hour}:${now.minute}, Weekday: ${now.weekday}');

    // Only check on Sunday(7) to Thursday(4) - Bangladesh work week
    if (now.weekday >= DateTime.sunday || now.weekday <= DateTime.thursday) {
      debugPrint('🔔 Weekday check passed (Sunday-Thursday)');
      
      if (now.hour >= 9 && now.hour < 14) {
        debugPrint('🔔 Time check passed (9 AM - 2 PM)');
        
        try {
          debugPrint('🔔 Getting LunchRequestService from GetIt...');
          final lunchService = GetIt.instance<LunchRequestService>();
          
          debugPrint('🔔 Calling hasLunchRequestForToday...');
          final hasRequest = await lunchService.hasLunchRequestForToday();
          
          debugPrint('🔔 Has lunch request result: $hasRequest');

          if (!hasRequest && mounted) {
            debugPrint('🔔 No lunch request found, showing dialog...');
            await Future.delayed(const Duration(milliseconds: 500));
            
            if (mounted) {
              _showLunchReminderDialog();
            }
          } else {
            debugPrint('🔔 Lunch request exists or widget unmounted');
          }
        } catch (e) {
          debugPrint('🔔 ❌ Error checking lunch reminder: $e');
          debugPrint('🔔 ❌ Stack trace: ${StackTrace.current}');
        }
      } else {
        debugPrint('🔔 Time check failed: Current hour is ${now.hour}');
      }
    } else {
      debugPrint('🔔 Weekday check failed: Today is ${_getDayName(now.weekday)} (weekday: ${now.weekday})');
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday: return 'Sunday';
      case DateTime.monday: return 'Monday';
      case DateTime.tuesday: return 'Tuesday';
      case DateTime.wednesday: return 'Wednesday';
      case DateTime.thursday: return 'Thursday';
      case DateTime.friday: return 'Friday';
      case DateTime.saturday: return 'Saturday';
      default: return 'Unknown';
    }
  }

  void _showLunchReminderDialog() {
    debugPrint('🔔 Showing lunch reminder dialog...');
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.restaurant_menu,
          size: 48,
          color: Colors.orange,
        ),
        title: const Text('Lunch Request Reminder'),
        content: const Text(
          'You haven\'t submitted your lunch request for today. Would you like to submit now?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              debugPrint('🔔 User clicked: Remind Me Later');
              Navigator.pop(context);
            },
            child: const Text('Remind Me Later'),
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint('🔔 User clicked: Submit Now');
              Navigator.pop(context);
              Navigator.pushNamed(context, '/meal-subscription');
            },
            child: const Text('Submit Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🔔 LunchReminderWrapper: build called');
    return widget.child;
  }
}