import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/domain/entity/applications_entity.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/chat/page/chat_page.dart';
import 'package:job_seeker/prsentation/recruiter/page/job_applicants_page.dart';
import 'package:job_seeker/prsentation/recruiter/page/post_job_page.dart';
import 'package:job_seeker/prsentation/recruiter/page/recruiter_jobs_page.dart';
import 'package:job_seeker/prsentation/recruiter/provider/recruiter_jobs_provider.dart';
import 'package:job_seeker/prsentation/user_profile/page/user_profile_page.dart';
import 'package:provider/provider.dart';

class RecruiterHomePage extends StatefulWidget {
  const RecruiterHomePage({super.key});

  @override
  State<RecruiterHomePage> createState() => _RecruiterHomePageState();
}

class _RecruiterHomePageState extends State<RecruiterHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RecruiterJobsProvider>().loadDashboard();
    });
  }

  void _openPostJob() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PostJobPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _dashboard(),
            const RecruiterJobsPage(),
            const JobApplicantsPage(),
            const ChatPage(asRecruiter: true),
            const UserProfilePage(showBackButton: false),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: _openPostJob,
              backgroundColor: AppTheme.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Post Job',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Jobs Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'My Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Applicants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _dashboard() {
    final user = context.watch<AuthProvider>().user;
    final recruiter = context.watch<RecruiterJobsProvider>();
    final company = user?.companyName.isNotEmpty == true
        ? user!.companyName
        : user?.organisation ?? 'your company';

    return RefreshIndicator(
      onRefresh: () => recruiter.loadDashboard(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppTheme.gradientHeader,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${user?.name ?? 'Recruiter'}',
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Hire talent with jobs that stand out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Post jobs for $company and manage every job application in one place.',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard('Open Jobs', '${recruiter.openJobsCount}', Icons.work),
              const SizedBox(width: 10),
              _statCard(
                'Job Applicants',
                '${recruiter.applicants.length}',
                Icons.people,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _statCard(
                'Shortlisted',
                '${recruiter.shortlistedCount}',
                Icons.star_outline,
              ),
              const SizedBox(width: 10),
              _statCard('Hired', '${recruiter.hiredCount}', Icons.emoji_events),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _openPostJob,
            icon: const Icon(Icons.add),
            label: const Text('Post a New Job'),
          ),
          const SizedBox(height: 24),
          const Text(
            'Latest job applications',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (recruiter.isLoading)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (recruiter.applicants.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No job applications yet. Post a job to start receiving applicants.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ...recruiter.applicants.take(5).map(_applicationTile),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _applicationTile(ApplicationEntity application) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(
          application.applicantName.isEmpty
              ? 'Job applicant'
              : application.applicantName,
        ),
        subtitle: Text(
          '${application.job.jobTitle} job • ${application.status.name}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => setState(() => _selectedIndex = 2),
      ),
    );
  }
}
