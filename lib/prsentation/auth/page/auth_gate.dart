import 'package:flutter/material.dart';
import 'package:job_seeker/prsentation/auth/page/user_fill_up_form_page.dart';
import 'package:job_seeker/prsentation/auth/page/welcome_page.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/home/page/home_page.dart';
import 'package:job_seeker/prsentation/recruiter/page/recruiter_home_page.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (auth.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (auth.user != null) {
          if (auth.needsProfileSetup) {
            return const UserFillUpFormPage();
          }
          if (auth.isRecruiter) {
            return const RecruiterHomePage();
          }
          return const MyHomePage();
        }

        return const WelcomePage();
      },
    );
  }
}
