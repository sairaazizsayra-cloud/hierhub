import 'package:flutter/material.dart';
import 'package:job_seeker/prsentation/auth/page/login_page.dart';
import 'package:job_seeker/prsentation/explore/page/explorer_page.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:provider/provider.dart';

class GuestJobsPage extends StatefulWidget {
  const GuestJobsPage({super.key});

  @override
  State<GuestJobsPage> createState() => _GuestJobsPageState();
}

class _GuestJobsPageState extends State<GuestJobsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<JobListingProvider>().fetchJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Browse jobs'),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            ),
            child: const Text(
              'Log In',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: const ExplorerPage(),
    );
  }
}
