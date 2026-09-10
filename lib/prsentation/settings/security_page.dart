import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/auth/widgets/my_custom_input_filed.dart';
import 'package:provider/provider.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController(
      text: context.read<AuthProvider>().user?.email ?? '',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Login & Security')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Reset your password via email',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            MyCustomInputFiled(
              text: 'Email',
              textEditingController: emailController,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  Fluttertoast.showToast(msg: 'Enter your email');
                  return;
                }
                try {
                  await context.read<AuthProvider>().resetPassword(email);
                  Fluttertoast.showToast(
                    msg: 'Password reset link sent to your email',
                  );
                } catch (_) {
                  Fluttertoast.showToast(
                    msg: 'Failed to send reset email',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: const Text('Send Reset Link'),
            ),
          ],
        ),
      ),
    );
  }
}
