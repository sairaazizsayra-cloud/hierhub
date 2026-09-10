import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/domain/entity/applications_entity.dart';
import 'package:job_seeker/prsentation/recruiter/provider/recruiter_jobs_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class JobApplicantsPage extends StatefulWidget {
  final int? jobId;
  final String? jobTitle;

  const JobApplicantsPage({super.key, this.jobId, this.jobTitle});

  @override
  State<JobApplicantsPage> createState() => _JobApplicantsPageState();
}

class _JobApplicantsPageState extends State<JobApplicantsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecruiterJobsProvider>().fetchApplicants(jobId: widget.jobId);
    });
  }

  Color _statusColor(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.rejected:
        return Colors.red;
      case ApplicationStatus.hired:
        return AppTheme.primary;
      case ApplicationStatus.interviewed:
        return Colors.orange.shade700;
      case ApplicationStatus.applied:
      case ApplicationStatus.shortlisted:
        return Colors.green;
    }
  }

  Future<void> _openResume(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final recruiter = context.watch<RecruiterJobsProvider>();
    final list = widget.jobId == null
        ? recruiter.applicants
        : recruiter.jobApplicants;
    final embedded = widget.jobId == null;

    final body = recruiter.isLoading
        ? const Center(child: CircularProgressIndicator())
        : list.isEmpty
            ? Center(
                child: Text(
                  widget.jobTitle == null
                      ? 'No job applications yet.'
                      : 'No applications for this job yet.',
                  style: const TextStyle(color: Colors.grey),
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _applicantCard(list[index]);
                },
              );

    if (embedded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Job Applicants',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Review every job application and update hiring status.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobTitle ?? 'Job applicants'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }

  Widget _applicantCard(ApplicationEntity application) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              application.applicantName.isEmpty
                  ? 'Job applicant'
                  : application.applicantName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${application.job.jobTitle} job at ${application.job.companyName}',
              style: const TextStyle(color: Colors.grey),
            ),
            if (application.applicantEmail.isNotEmpty)
              Text(application.applicantEmail),
            if (application.applicantSkills.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text('Skills: ${application.applicantSkills}'),
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                DropdownButton<ApplicationStatus>(
                  value: application.status,
                  items: ApplicationStatus.values
                      .map(
                        (status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status.name,
                            style: TextStyle(color: _statusColor(status)),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (status) {
                    if (status == null) return;
                    context
                        .read<RecruiterJobsProvider>()
                        .updateStatus(application, status);
                  },
                ),
                if (application.resumeUrl.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _openResume(application.resumeUrl),
                    icon: const Icon(Icons.description_outlined),
                    label: const Text('Job resume'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
