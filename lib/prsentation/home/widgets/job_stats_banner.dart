import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/prsentation/applications/provider/application_provider.dart';
import 'package:job_seeker/prsentation/bookmark/provider/bookmark_jobs_provider.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:provider/provider.dart';

class JobStatsBanner extends StatelessWidget {
  const JobStatsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final jobs = context.watch<JobListingProvider>().openJobsCount;
    final saved = context.watch<BookMarkJobProvider>().jobs.length;
    final applied = context.watch<ApplicationProvider>().applications.length;

    return Row(
      children: [
        _tile('$jobs', 'Open jobs'),
        const SizedBox(width: 8),
        _tile('$saved', 'Saved jobs'),
        const SizedBox(width: 8),
        _tile('$applied', 'Job applications'),
      ],
    );
  }

  Widget _tile(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
