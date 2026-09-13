import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';

class AuthActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const AuthActionButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 50,
      // margin: EdgeInsets.symmetric(horizontal: 50),
      color: AppTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      // decoration: BoxDecoration(
      // ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
