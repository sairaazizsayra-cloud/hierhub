import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  static const _supportEmail = 'support@hirehub.app';

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: 'subject=HireHub Support',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(msg: 'Email: $_supportEmail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Support')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.email, color: AppTheme.primary),
                title: const Text('Email us'),
                subtitle: Text(_supportEmail),
                onTap: _launchEmail,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.help_outline, color: AppTheme.primary),
                title: const Text('FAQ'),
                subtitle: const Text('How to apply, bookmark jobs, and chat with recruiters'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Quick Help'),
                      content: const Text(
                        '• Browse jobs on Home or Explore\n'
                        '• Tap a job to view details and apply\n'
                        '• Bookmark jobs to save them\n'
                        '• Track applications in the Applications tab\n'
                        '• Chat with recruiters in the Chat tab',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
