import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/core/theme/app_theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool jobAlerts = true;
  bool applicationUpdates = true;
  bool chatMessages = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('New job alerts'),
            subtitle: const Text('Get notified about matching jobs'),
            value: jobAlerts,
            activeColor: AppTheme.primary,
            onChanged: (v) => setState(() => jobAlerts = v),
          ),
          SwitchListTile(
            title: const Text('Application updates'),
            subtitle: const Text('Status changes on your applications'),
            value: applicationUpdates,
            activeColor: AppTheme.primary,
            onChanged: (v) => setState(() => applicationUpdates = v),
          ),
          SwitchListTile(
            title: const Text('Chat messages'),
            subtitle: const Text('Messages from recruiters'),
            value: chatMessages,
            activeColor: AppTheme.primary,
            onChanged: (v) => setState(() => chatMessages = v),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(msg: 'Notification preferences saved');
                Navigator.pop(context);
              },
              child: const Text('Save Preferences'),
            ),
          ),
        ],
      ),
    );
  }
}
