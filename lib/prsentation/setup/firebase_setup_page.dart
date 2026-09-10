import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';

class FirebaseSetupPage extends StatelessWidget {
  final String? error;
  const FirebaseSetupPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: AppTheme.gradientHeader,
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.white, size: 40),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Finish Firebase setup',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'HireHub is connected to Firebase project hirehub-app-de9ad. '
                'If this screen appears, restart the app after checking your internet connection.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  error!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],
              const SizedBox(height: 20),
              _step(
                '1',
                'Open: console.cloud.google.com/apis/library/firestore.googleapis.com?project=hirehub-app-de9ad and Enable the API',
              ),
              _step(
                '2',
                'Open Firebase Console → Build → Firestore Database → Create database (test mode or production with rules)',
              ),
              _step('3', 'Run: firebase deploy --only firestore:rules'),
              _step('4', 'Restart: flutter run'),
              const Spacer(),
              const Text(
                'Project: hirehub-app-de9ad',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _step(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.primary,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
