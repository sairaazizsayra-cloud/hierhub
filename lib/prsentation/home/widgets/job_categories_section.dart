import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/prsentation/home/provider/filter_jobs_provider.dart';
import 'package:job_seeker/prsentation/home/provider/job_data.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:provider/provider.dart';

class JobCategoriesSection extends StatelessWidget {
  final ValueChanged<String>? onCategoryTap;

  const JobCategoriesSection({super.key, this.onCategoryTap});

  IconData _iconFor(String category) {
    switch (category) {
      case 'Designer':
        return Icons.brush_outlined;
      case 'Management':
        return Icons.apartment_outlined;
      case 'Marketing':
        return Icons.campaign_outlined;
      case 'Data':
        return Icons.analytics_outlined;
      case 'QA':
        return Icons.verified_outlined;
      case 'HR':
        return Icons.groups_outlined;
      default:
        return Icons.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = context
        .watch<JobData>()
        .recentJobFilters
        .where((item) => item != 'All')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Job categories',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            return ActionChip(
              avatar: Icon(_iconFor(category), size: 16, color: AppTheme.primary),
              label: Text('$category jobs'),
              onPressed: () {
                context.read<JobData>().setSelectedRecentJobFilter(category);
                context.read<JobFilterProvider>().setSelectedFilter(category);
                context.read<JobListingProvider>().setCategoryFilter(category);
                onCategoryTap?.call(category);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
