import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/core/theme/app_theme.dart';

class ChatSettingsPage extends StatefulWidget {
  const ChatSettingsPage({super.key});

  @override
  State<ChatSettingsPage> createState() => _ChatSettingsPageState();
}

class _ChatSettingsPageState extends State<ChatSettingsPage> {
  bool readReceipts = true;
  bool soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Read receipts'),
            value: readReceipts,
            activeColor: AppTheme.primary,
            onChanged: (v) => setState(() => readReceipts = v),
          ),
          SwitchListTile(
            title: const Text('Message sounds'),
            value: soundEnabled,
            activeColor: AppTheme.primary,
            onChanged: (v) => setState(() => soundEnabled = v),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(msg: 'Chat settings saved');
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
