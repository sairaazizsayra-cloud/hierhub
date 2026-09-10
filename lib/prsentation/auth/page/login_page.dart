import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/prsentation/auth/page/ragister_page.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/auth/widgets/auth_action_button.dart';
import 'package:job_seeker/prsentation/auth/widgets/auth_header_widget.dart';
import 'package:job_seeker/prsentation/auth/widgets/my_custom_input_filed.dart';
import 'package:job_seeker/prsentation/auth/widgets/prompt_login_sigup_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: AppTheme.primary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            const AuthHeaderWidget(text: 'Welcome back', title: 'Login'),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      MyCustomInputFiled(
                        text: 'Email',
                        textEditingController: emailController,
                      ),
                      const SizedBox(height: 12),
                      MyCustomInputFiled(
                        text: 'Password',
                        textEditingController: passwordController,
                        isPassword: true,
                      ),
                      if (auth.error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          auth.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _showForgotPasswordDialog(context),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppTheme.primary),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AuthActionButton(
                        text: auth.isLoading ? 'Please wait...' : 'Log In',
                        onPressed:
                            auth.isLoading ? () {} : () => _login(context),
                      ),
                      const SizedBox(height: 32),
                      PromptLoginSignUpWidget(
                        text: "Don't have an Account?",
                        promptText: 'Register',
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const RagisterPage()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    final ok = await context.read<AuthProvider>().sigIn(
          emailController.text,
          passwordController.text,
        );
    if (!context.mounted) return;
    if (ok) {
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: context.read<AuthProvider>().error ?? 'Login failed',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final resetEmailController = TextEditingController(
      text: emailController.text.trim(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset password'),
          content: TextField(
            controller: resetEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter your email'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final email = resetEmailController.text.trim();
                if (email.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please enter your email');
                  return;
                }
                try {
                  await context.read<AuthProvider>().resetPassword(email);
                  if (!dialogContext.mounted) return;
                  Navigator.pop(dialogContext);
                  Fluttertoast.showToast(
                    msg: 'Password reset link sent to your email',
                  );
                } catch (_) {
                  Fluttertoast.showToast(
                    msg: 'Failed to send reset link',
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
