import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/domain/entity/job_listing_entity.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:job_seeker/prsentation/recruiter/page/job_applicants_page.dart';
import 'package:job_seeker/prsentation/recruiter/page/post_job_page.dart';
import 'package:job_seeker/prsentation/recruiter/provider/recruiter_jobs_provider.dart';
import 'package:provider/provider.dart';

class RecruiterJobsPage extends StatefulWidget {
  const RecruiterJobsPage({super.key});

  @override
  State<RecruiterJobsPage> createState() => _RecruiterJobsPageState();
}

class _RecruiterJobsPageState extends State<RecruiterJobsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RecruiterJobsProvider>().fetchMyJobs());
  }

  @override
  Widget build(BuildContext context) {
    final recruiter = context.watch<RecruiterJobsProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Job Openings',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            '${recruiter.myJobs.length} jobs posted • ${recruiter.openJobsCount} currently open',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (recruiter.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (recruiter.myJobs.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'You have not posted a job yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PostJobPage()),
                      ),
                      child: const Text('Post your first job'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: recruiter.fetchMyJobs,
                child: ListView.separated(
                  itemCount: recruiter.myJobs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return _jobTile(recruiter.myJobs[index]);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _jobTile(JobListingEntity job) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          job.jobTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${job.companyName} • ${job.location}\n'
            '${job.type} • ${job.workingModel} • ${job.salary}',
          ),
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'toggle') {
              await context
                  .read<RecruiterJobsProvider>()
                  .setJobActive(job, !job.isActive);
              if (!mounted) return;
              await context.read<JobListingProvider>().fetchJobs();
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 'toggle',
              child: Text(job.isActive ? 'Close this job' : 'Reopen job'),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: job.isActive
                  ? AppTheme.primary.withValues(alpha: 0.12)
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              job.isActive ? 'Job open' : 'Closed',
              style: TextStyle(
                color: job.isActive ? AppTheme.primary : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobApplicantsPage(jobId: job.id, jobTitle: job.jobTitle),
            ),
          );
        },
      ),
    );
  }
}
