import "package:flutter/material.dart";
import "package:job_seeker/core/constants.dart";
import "package:job_seeker/core/theme/app_theme.dart";
import "package:job_seeker/prsentation/bookmark/provider/bookmark_jobs_provider.dart";
import "package:job_seeker/prsentation/job_details/page/job_details_page.dart";
import "package:provider/provider.dart";

class JobCard extends StatelessWidget {
  final int id;
  final String company;
  final String jobTitle;
  final String location;
  final String salary;
  final List<String> tags;
  final String image;
  final int? matchPercent;

  const JobCard({
    super.key,
    required this.id,
    required this.company,
    required this.jobTitle,
    required this.location,
    required this.salary,
    required this.tags,
    required this.image,
    this.matchPercent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobDetailsPage(id: id)),
        );
      },
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'JOB OPENING',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (matchPercent != null && matchPercent! > 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    '$matchPercent% job match',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          image.isEmpty
                              ? AppConstants.defaultCompanyLogo
                              : image,
                        ),
                        radius: 20,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jobTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              company,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<BookMarkJobProvider>(
                  builder: (context, bookmarkProvider, child) {
                    final isBookmarked = bookmarkProvider.jobs.contains(id);
                    return IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.purple,
                      ),
                      onPressed: () {
                        bookmarkProvider.toggleBookmark(id);
                      },
                    );
                  },
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 16),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: tags.map((tag) => Chip(label: Text(tag))).toList(),
            ),
            const SizedBox(height: 10),
            Text(
              "Job salary: \$ $salary",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
