import 'package:flutter/material.dart';
import 'package:job_seeker/core/widget/my_custom_icon_button.dart';
import 'package:job_seeker/prsentation/home/provider/filter_jobs_provider.dart';
import 'package:job_seeker/prsentation/home/provider/job_data.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  void _showFilterSheet(BuildContext context) {
    final jobData = context.read<JobData>();
    final filterProvider = context.read<JobFilterProvider>();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: jobData.recentJobFilters.map((filter) {
                  return FilterChip(
                    label: Text(filter),
                    selected: jobData.selectedRecentJobFilter == filter,
                    onSelected: (_) {
                      jobData.setSelectedRecentJobFilter(filter);
                      filterProvider.setSelectedFilter(filter);
                      Navigator.pop(sheetContext);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              onChanged: context.read<JobListingProvider>().setSearchQuery,
              decoration: const InputDecoration(
                hintText: 'Search jobs, companies, locations...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        MyCustomIconButton(
          icon: Icons.tune,
          callback: () => _showFilterSheet(context),
        ),
      ],
    );
  }
}
