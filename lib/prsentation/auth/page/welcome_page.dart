import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/core/user_role.dart';
import 'package:job_seeker/core/widget/app_logo.dart';
import 'package:job_seeker/prsentation/auth/page/login_page.dart';
import 'package:job_seeker/prsentation/auth/page/ragister_page.dart';
import 'package:job_seeker/prsentation/explore/page/guest_jobs_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _openBrowse(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GuestJobsPage()),
    );
  }

  void _openRegister(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RagisterPage(initialRole: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(height: 140),
                    SizedBox(height: 12),
                    Text(
                      'Find jobs. Post jobs. Get hired.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.primaryDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Job seekers apply to jobs.\nRecruiters hire from job applications.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      _roleHint(
                        icon: Icons.work_outline,
                        label: 'Browse jobs',
                        onTap: () => _openBrowse(context),
                      ),
                      const SizedBox(width: 8),
                      _roleHint(
                        icon: Icons.badge_outlined,
                        label: 'Apply to jobs',
                        onTap: () =>
                            _openRegister(context, UserRole.jobSeeker),
                      ),
                      const SizedBox(width: 8),
                      _roleHint(
                        icon: Icons.campaign_outlined,
                        label: 'Post jobs',
                        onTap: () =>
                            _openRegister(context, UserRole.recruiter),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      ),
                      child: const Text('Log In'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        side: const BorderSide(color: AppTheme.primary),
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => _openRegister(
                        context,
                        UserRole.jobSeeker,
                      ),
                      child: const Text('Create Job Account'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleHint({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: AppTheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Icon(icon, color: AppTheme.primary, size: 20),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
