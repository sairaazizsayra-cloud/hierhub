import "package:flutter/material.dart";
import "package:job_seeker/core/theme/app_theme.dart";
import "package:job_seeker/prsentation/home/provider/job_list_provider.dart";
import "package:job_seeker/prsentation/job_details/provider/job_details_provider.dart";
import "package:job_seeker/prsentation/job_details/widgets/header.dart";
import "package:job_seeker/prsentation/job_details/widgets/job_details_widgets.dart";
import "package:provider/provider.dart";

class JobDetailsPage extends StatefulWidget {
  final int id;
  const JobDetailsPage({super.key, required this.id});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<JobDetailsProvider>().fetchJob(widget.id);
      final jobs = context.read<JobListingProvider>();
      if (jobs.allJobs.isEmpty) {
        jobs.fetchJobs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SafeArea(
        child: Consumer<JobDetailsProvider>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (value.job == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value.error ?? 'Job not found',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Go Back',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final job = value.job!;
            return Column(
              children: [
                Header(
                  jobId: job.id,
                  jobTitle: job.jobTitle,
                  companyName: job.companyName,
                ),
                Expanded(child: JobDetailsContent(job: job)),
              ],
            );
          },
        ),
      ),
    );
  }
}
