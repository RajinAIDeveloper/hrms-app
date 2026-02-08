import 'package:flutter/material.dart';
import 'package:root_app/services/notification/notification_service.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({Key? key}) : super(key: key);

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  List<String> _logs = [];
  bool _isLoading = false;

  void _addLog(String message) {
    setState(() {
      _logs.insert(0, '${DateTime.now().toString().substring(11, 19)} - $message');
    });
  }

  Future<void> _testImmediateNotification() async {
    setState(() => _isLoading = true);
    _addLog('Sending immediate notification...');
    
    try {
      await NotificationService().showImmediateNotification(
        'Test Notification',
        'This is an immediate test notification!',
      );
      _addLog('✅ Immediate notification sent!');
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testScheduledNotification() async {
    setState(() => _isLoading = true);
    _addLog('Scheduling test notification (1 minute)...');
    
    try {
      await NotificationService().scheduleTestNotification();
      _addLog('✅ Test notification scheduled for 1 minute from now');
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _scheduleDailyReminder() async {
    setState(() => _isLoading = true);
    _addLog('Scheduling daily 9 AM reminder...');
    
    try {
      await NotificationService().scheduleDailyLunchReminder();
      _addLog('✅ Daily reminder scheduled for 9:00 AM');
      await _checkPendingNotifications();
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkPendingNotifications() async {
    setState(() => _isLoading = true);
    _addLog('Checking pending notifications...');
    
    try {
      final pending = await NotificationService().getPendingNotifications();
      _addLog('📋 Found ${pending.length} pending notification(s)');
      
      for (var notif in pending) {
        _addLog('   ID: ${notif.id} - ${notif.title}');
      }
      
      if (pending.isEmpty) {
        _addLog('⚠️ No pending notifications found!');
      }
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _cancelAllNotifications() async {
    setState(() => _isLoading = true);
    _addLog('Cancelling all notifications...');
    
    try {
      await NotificationService().cancelAllNotifications();
      _addLog('✅ All notifications cancelled');
      await _checkPendingNotifications();
    } catch (e) {
      _addLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _addLog('Notification test screen initialized');
    _checkPendingNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Testing'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              children: [
                _buildActionButton(
                  'Send Immediate Notification',
                  Icons.notifications_active,
                  Colors.blue,
                  _testImmediateNotification,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  'Schedule Test (1 min)',
                  Icons.schedule,
                  Colors.green,
                  _testScheduledNotification,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  'Schedule Daily 9 AM Reminder',
                  Icons.alarm,
                  Colors.orange,
                  _scheduleDailyReminder,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  'Check Pending Notifications',
                  Icons.search,
                  Colors.purple,
                  _checkPendingNotifications,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  'Cancel All Notifications',
                  Icons.cancel,
                  Colors.red,
                  _cancelAllNotifications,
                ),
              ],
            ),
          ),
          
          // Logs Section
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Logs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          setState(() => _logs.clear());
                        },
                        icon: const Icon(Icons.clear_all, size: 16),
                        label: const Text('Clear'),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: _logs.isEmpty
                        ? const Center(
                            child: Text(
                              'No logs yet. Try testing a notification!',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _logs.length,
                            itemBuilder: (context, index) {
                              final log = _logs[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  color: log.contains('❌')
                                      ? Colors.red[50]
                                      : log.contains('✅')
                                          ? Colors.green[50]
                                          : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  log,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                    color: log.contains('❌')
                                        ? Colors.red[900]
                                        : log.contains('✅')
                                            ? Colors.green[900]
                                            : Colors.black87,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
          
          // Loading Indicator
          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange[100],
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Processing...'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}