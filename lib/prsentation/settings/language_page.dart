import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/core/theme/app_theme.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selected = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text('English'),
            value: 'English',
            groupValue: _selected,
            activeColor: AppTheme.primary,
            onChanged: (v) => setState(() => _selected = v!),
          ),
          RadioListTile<String>(
            title: const Text('Urdu'),
            value: 'Urdu',
            groupValue: _selected,
            activeColor: AppTheme.primary,
            onChanged: (v) => setState(() => _selected = v!),
          ),
          RadioListTile<String>(
            title: const Text('Hindi'),
            value: 'Hindi',
            groupValue: _selected,
            activeColor: AppTheme.primary,
            onChanged: (v) => setState(() => _selected = v!),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Fluttertoast.showToast(
                  msg: 'Language set to $_selected',
                );
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
