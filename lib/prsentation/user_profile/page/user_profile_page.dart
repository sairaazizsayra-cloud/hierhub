import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_seeker/core/constants.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/core/widget/my_custom_icon_button.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/settings/language_page.dart';
import 'package:job_seeker/prsentation/settings/notifications_page.dart';
import 'package:job_seeker/prsentation/settings/security_page.dart';
import 'package:job_seeker/prsentation/settings/support_page.dart';
import 'package:job_seeker/prsentation/user_profile/page/update_profile_page.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class UserProfilePage extends StatefulWidget {
  final bool showBackButton;
  const UserProfilePage({super.key, this.showBackButton = true});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;

    try {
      await context.read<AuthProvider>().uploadAvatar(image);
      Fluttertoast.showToast(msg: 'Profile photo updated');
      setState(() {});
    } catch (_) {
      Fluttertoast.showToast(
        msg: 'Failed to upload photo',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(context),
              _profileHeader(context),
              const SizedBox(height: 8),
              _buildListTile(
                Icons.person_outline,
                'Personal information',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UpdateProfilePage(),
                  ),
                ),
              ),
              _buildListTile(
                Icons.lock_outline,
                'Login and security',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SecurityPage()),
                ),
              ),
              _buildListTile(
                Icons.headset_mic,
                'Customer Support',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SupportPage()),
                ),
              ),
              _buildListTile(
                Icons.language,
                'Language',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguagePage()),
                ),
              ),
              _buildListTile(
                Icons.share,
                'Share the app',
                () => Share.share(
                  'Find your dream job with HireHub - the smart job seeking app!',
                ),
              ),
              _buildListTile(
                Icons.power_settings_new,
                'Log Out',
                () async {
                  await context.read<AuthProvider>().signOut();
                  if (mounted) Navigator.pop(context);
                },
                isDestructive: true,
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  'HireHub v1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: AppTheme.gradientHeader,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.showBackButton
                ? MyCustomIconButton(
                    icon: Icons.arrow_back,
                    callback: () => Navigator.pop(context),
                  )
                : const SizedBox(width: 42),
            Text(
              context.watch<AuthProvider>().isRecruiter
                  ? 'Recruiter Profile'
                  : 'Job Seeker Profile',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            MyCustomIconButton(
              icon: Icons.notifications_outlined,
              callback: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsPage(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(BuildContext context) {
    final user = context.watch<AuthProvider>().user!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(_avatarUrl(user.avatar)),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickAvatar,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.name} ${user.lastName}'.trim(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UpdateProfilePage()),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  String _avatarUrl(String avatar) {
    return avatar.isEmpty ? AppConstants.defaultAvatar : avatar;
  }

  Widget _buildListTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.red : AppTheme.primary),
        title: Text(
          title,
          style: TextStyle(color: isDestructive ? Colors.red : null),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
