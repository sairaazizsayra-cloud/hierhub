import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/core/user_role.dart';
import 'package:job_seeker/prsentation/auth/page/login_page.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/auth/widgets/auth_action_button.dart';
import 'package:job_seeker/prsentation/auth/widgets/auth_header_widget.dart';
import 'package:job_seeker/prsentation/auth/widgets/my_custom_input_filed.dart';
import 'package:job_seeker/prsentation/auth/widgets/prompt_login_sigup_widget.dart';
import 'package:provider/provider.dart';

class RagisterPage extends StatefulWidget {
  final String initialRole;

  const RagisterPage({
    super.key,
    this.initialRole = UserRole.jobSeeker,
  });

  @override
  State<RagisterPage> createState() => _RagisterPageState();
}

class _RagisterPageState extends State<RagisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late String _role = widget.initialRole;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.deepPurple,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80),
            AuthHeaderWidget(
              text: _role == UserRole.recruiter
                  ? "Post jobs and hire candidates"
                  : "Join as seeker or recruiter",
              title: "Register",
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _roleCard(
                              UserRole.jobSeeker,
                              'Job Seeker',
                              'Find and apply to jobs',
                              Icons.work_outline,
                            ),
                            const SizedBox(width: 10),
                            _roleCard(
                              UserRole.recruiter,
                              'Recruiter',
                              'Post jobs and hire',
                              Icons.business_center_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.shade100,
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              MyCustomInputFiled(
                                text: "Email",
                                textEditingController: emailController,
                              ),
                              const SizedBox(height: 10),
                              MyCustomInputFiled(
                                text: "Password",
                                isPassword: true,
                                textEditingController: passwordController,
                              ),
                              const SizedBox(height: 10),
                              MyCustomInputFiled(
                                text: "Confirm Password",
                                textEditingController: confirmPasswordController,
                                isPassword: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        AuthActionButton(
                          text: _role == UserRole.recruiter
                              ? "Create Recruiter Account"
                              : "Create Job Seeker Account",
                          onPressed: () async {
                            if (passwordController.text.length < 6) {
                              Fluttertoast.showToast(
                                msg: 'Password must be at least 6 characters',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }
                            if (passwordController.text !=
                                confirmPasswordController.text) {
                              Fluttertoast.showToast(
                                msg: 'Passwords do not match',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                              return;
                            }
                            final ok = await context.read<AuthProvider>().sigUp(
                                  emailController.text.trim(),
                                  passwordController.text,
                                  role: _role,
                                );
                            if (!context.mounted) return;
                            if (ok) {
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            } else {
                              Fluttertoast.showToast(
                                msg: context.read<AuthProvider>().error ??
                                    'Registration failed',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 50),
                        PromptLoginSignUpWidget(
                          text: "Already have an Account?",
                          promptText: "Login",
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(String role, String title, String subtitle, IconData icon) {
    final selected = _role == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _role = role),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected
                ? AppTheme.primary.withValues(alpha: 0.12)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppTheme.primary : Colors.grey.shade300,
              width: 1.6,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primary),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
