import 'package:flutter/material.dart';
import 'package:job_seeker/core/constants.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/domain/entity/applications_entity.dart';
import 'package:job_seeker/prsentation/applications/provider/application_provider.dart';
import 'package:provider/provider.dart';

class ApplicationsPage extends StatefulWidget {
  const ApplicationsPage({super.key});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final applicationProvider = context.read<ApplicationProvider>();
      applicationProvider.fetchApplication();
      applicationProvider.subscribeToApplication();
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

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final applicationProvider = context.watch<ApplicationProvider>();

    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Track Your\nJob Applications',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 1.15,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            if (applicationProvider.isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (applicationProvider.applications.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No job applications yet.\nApply to jobs to track them here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: applicationProvider.applications.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final application =
                        applicationProvider.applications[index];
                    final createdAt = DateTime.parse(application.createdAt);
                    final imageUrl = application.job.image?.toString() ?? '';
                    final avatarUrl = imageUrl.isEmpty
                        ? AppConstants.defaultCompanyLogo
                        : imageUrl;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              avatarUrl,
                              width: 42,
                              height: 42,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppTheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.business,
                                  color: AppTheme.primary,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  application.job.jobTitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  application.status.name,
                                  style: TextStyle(
                                    color: _statusColor(application.status),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatDate(createdAt),
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _formatTime(createdAt),
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
