import 'package:flutter/material.dart';
import 'package:job_seeker/prsentation/bookmark/provider/bookmark_jobs_provider.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:job_seeker/prsentation/home/widgets/job_card.dart';
import 'package:provider/provider.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({super.key});

  @override
  State<BookMarkPage> createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bookmarks \nJob Posts ",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Consumer2<JobListingProvider, BookMarkJobProvider>(
              builder: (context, jobProvider, bookmarkProvider, child) {
                if (jobProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (jobProvider.error != null) {
                  return Text('Failed to load jobs: ${jobProvider.error}');
                }

                final filteredJobs = jobProvider.jobs
                    .where((job) => bookmarkProvider.jobs.contains(job.id))
                    .toList();

                if (filteredJobs.isEmpty) {
                  return const Center(
                    child: Text('No bookmarked jobs yet.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(left: 10),
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
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
}
