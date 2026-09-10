import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/core/widget/my_custom_icon_button.dart';
import 'package:job_seeker/prsentation/settings/chat_settings_page.dart';

class TopChatBarWidget extends StatelessWidget {
  final bool asRecruiter;
  const TopChatBarWidget({super.key, this.asRecruiter = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.gradientHeader,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            asRecruiter
                ? "Chat with\njob applicants"
                : "Chat about\njobs",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          MyCustomIconButton(
            icon: Icons.settings,
            callback: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChatSettingsPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
