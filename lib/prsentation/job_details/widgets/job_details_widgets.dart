import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/domain/entity/job_listing_entity.dart';
import 'package:job_seeker/prsentation/auth/page/login_page.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:job_seeker/prsentation/home/widgets/job_card.dart';
import 'package:job_seeker/prsentation/job_details/widgets/bottom_sheet_widget.dart';
import 'package:provider/provider.dart';

class JobDetailsContent extends StatefulWidget {
  final JobListingEntity job;

  const JobDetailsContent({super.key, required this.job});

  @override
  State<JobDetailsContent> createState() => _JobDetailsContentState();
}

class _JobDetailsContentState extends State<JobDetailsContent> {
  int _selectedTab = 0;

  JobListingEntity get job => widget.job;

  void _showApplySheet() {
    final auth = context.read<AuthProvider>();
    if (auth.user == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }
    if (auth.isRecruiter) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: BottomSheetWidget(jobId: job.id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              children: [
                Center(
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400, width: 3),
                      image: DecorationImage(
                        image: NetworkImage(job.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  job.jobTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  job.companyName.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on,
                        color: AppTheme.primary, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      job.location,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _DetailCard(
                        icon: Icons.person_outline,
                        title: 'Salary (Monthly)',
                        value: job.salary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DetailCard(
                        icon: Icons.work_outline,
                        title: 'Job Type',
                        value: job.type,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _DetailCard(
                        icon: Icons.laptop_mac,
                        title: 'Working Model',
                        value: job.workingModel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DetailCard(
                        icon: Icons.leaderboard_outlined,
                        title: 'Level',
                        value: job.level,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _TabLabel(
                      label: 'About',
                      selected: _selectedTab == 0,
                      onTap: () => setState(() => _selectedTab = 0),
                    ),
                    _TabLabel(
                      label: 'Company',
                      selected: _selectedTab == 1,
                      onTap: () => setState(() => _selectedTab = 1),
                    ),
                    _TabLabel(
                      label: 'Review',
                      selected: _selectedTab == 2,
                      onTap: () => setState(() => _selectedTab = 2),
                    ),
                  ],
                ),
                const Divider(height: 1),
                const SizedBox(height: 16),
                ..._tabBody(),
                const SizedBox(height: 20),
                ..._similarJobs(context),
                const SizedBox(height: 12),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: context.watch<AuthProvider>().isRecruiter
                    ? null
                    : _showApplySheet,
                child: Text(
                  context.watch<AuthProvider>().isRecruiter
                      ? 'Recruiters cannot apply to jobs'
                      : context.watch<AuthProvider>().user == null
                          ? 'Log in to apply'
                          : 'Apply for this Job',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _similarJobs(BuildContext context) {
    final similar = context.watch<JobListingProvider>().similarJobs(job);
    if (similar.isEmpty) return const [];
    return [
      const Text(
        'Similar jobs you can apply to',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...similar.map(
        (item) => JobCard(
          id: item.id,
          company: item.companyName,
          jobTitle: item.jobTitle,
          location: item.location,
          salary: item.salary,
          tags: [item.level, item.workingModel, item.type],
          image: item.image,
        ),
      ),
    ];
  }

  List<Widget> _tabBody() {
    switch (_selectedTab) {
      case 1:
        return [
          const Text(
            'About Company',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '${job.companyName} is hiring for ${job.jobTitle} in ${job.location}. '
            'Working model: ${job.workingModel}. Level: ${job.level}.',
            style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.45),
          ),
          const SizedBox(height: 12),
          Text(
            'Tags: ${job.tags}',
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ];
      case 2:
        return [
          const Text(
            'Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _ReviewTile(
            name: 'Ayesha K.',
            rating: 5,
            comment:
                'Great culture at ${job.companyName}. Interview process was smooth.',
          ),
          _ReviewTile(
            name: 'Hamza R.',
            rating: 4,
            comment: 'Good role for ${job.level} developers. Remote friendly.',
          ),
          const _ReviewTile(
            name: 'Sara M.',
            rating: 4,
            comment: 'Clear expectations and supportive hiring team.',
          ),
        ];
      default:
        return [
          const Text(
            'About this Job',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            job.jobDesc,
            style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.45),
          ),
          const SizedBox(height: 16),
          const Text(
            'Job Description',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Type: ${job.type}\n'
            'Salary: ${job.salary}\n'
            'Location: ${job.location}\n'
            'Model: ${job.workingModel}\n\n'
            '${job.jobDesc}',
            style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.45),
          ),
        ];
    }
  }
}

class _TabLabel extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? AppTheme.primary : Colors.grey,
                  ),
                ),
              ),
              Container(
                height: 2.5,
                color: selected ? AppTheme.primary : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;

  const _ReviewTile({
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              ...List.generate(
                5,
                (i) => Icon(
                  i < rating ? Icons.star : Icons.star_border,
                  size: 16,
                  color: Colors.amber.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(comment, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
