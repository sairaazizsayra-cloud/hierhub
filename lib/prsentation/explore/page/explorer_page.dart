import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/prsentation/home/provider/job_data.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:job_seeker/prsentation/home/widgets/job_card.dart';
import 'package:job_seeker/prsentation/home/widgets/search_bar_widgets.dart';
import 'package:provider/provider.dart';

class ExplorerPage extends StatelessWidget {
  const ExplorerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobListingProvider>();
    final jobData = context.watch<JobData>();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${jobProvider.jobs.length} jobs found',
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'Search jobs by title, company, location or skill',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          const SearchBarWidget(),
          const SizedBox(height: 12),
          _chips(
            'Job type',
            jobData.jobTypes,
            jobProvider.typeFilter,
            jobProvider.setTypeFilter,
          ),
          _chips(
            'Job model',
            jobData.workingModels,
            jobProvider.workingModelFilter,
            jobProvider.setWorkingModelFilter,
          ),
          _chips(
            'Job category',
            jobData.recentJobFilters,
            jobProvider.categoryFilter,
            jobProvider.setCategoryFilter,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: jobProvider.clearJobFilters,
              child: const Text('Clear job filters'),
            ),
          ),
          Expanded(
            child: Consumer<JobListingProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return Center(
                    child: Text('Failed to load jobs: ${provider.error}'),
                  );
                }
                if (provider.jobs.isEmpty) {
                  return Center(
                    child: Text(
                      provider.searchQuery.isEmpty
                          ? 'No jobs available.'
                          : 'No jobs match your search.',
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(left: 10),
                  itemCount: provider.jobs.length,
                  itemBuilder: (context, index) {
                    final job = provider.jobs[index];
                    return JobCard(
                      id: job.id,
                      company: job.companyName,
                      jobTitle: job.jobTitle,
                      location: job.location,
                      salary: job.salary,
                      tags: [job.level, job.workingModel, job.type],
                      image: job.image,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chips(
    String label,
    List<String> items,
    String selected,
    ValueChanged<String> onSelected,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = selected == item;
            return FilterChip(
              label: Text(index == 0 ? label.replaceAll('Job ', '') : item),
              selected: isSelected,
              selectedColor: AppTheme.primary.withValues(alpha: 0.15),
              onSelected: (_) => onSelected(item),
            );
          },
        ),
      ),
    );
  }
}
