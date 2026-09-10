import 'package:flutter/material.dart';
import 'package:job_seeker/core/job_match.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:job_seeker/prsentation/home/widgets/job_card.dart';
import 'package:provider/provider.dart';

class MatchedJobsSection extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const MatchedJobsSection({super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final jobs = context.watch<JobListingProvider>().matchedJobs(user);
    if (jobs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Jobs matched to your skills',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(onPressed: onSeeAll, child: const Text('See all jobs')),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: jobs.take(8).map((job) {
              return JobCard(
                id: job.id,
                company: job.companyName,
                jobTitle: job.jobTitle,
                location: job.location,
                salary: job.salary,
                tags: [job.level, job.workingModel, job.type],
                image: job.image,
                matchPercent: JobMatch.score(job, user),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
