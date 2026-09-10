import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/home/provider/job_data.dart';
import 'package:job_seeker/prsentation/home/provider/job_list_provider.dart';
import 'package:job_seeker/prsentation/recruiter/provider/recruiter_jobs_provider.dart';
import 'package:provider/provider.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _company = TextEditingController();
  final _location = TextEditingController();
  final _salary = TextEditingController();
  String _type = 'Full-time';
  String _level = 'Mid';
  String _model = 'Remote';
  String _tags = 'Programmer';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _company.text = user?.companyName.isNotEmpty == true
        ? user!.companyName
        : (user?.organisation ?? '');
    _location.text = user?.location ?? '';
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _company.dispose();
    _location.dispose();
    _salary.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_title.text.trim().isEmpty ||
        _desc.text.trim().isEmpty ||
        _company.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Job title, description and company are required');
      return;
    }
    try {
      await context.read<RecruiterJobsProvider>().postJob(
            jobTitle: _title.text.trim(),
            jobDesc: _desc.text.trim(),
            companyName: _company.text.trim(),
            location: _location.text.trim().isEmpty
                ? 'Remote'
                : _location.text.trim(),
            salary: _salary.text.trim().isEmpty ? 'Negotiable' : _salary.text.trim(),
            type: _type,
            level: _level,
            workingModel: _model,
            tags: _tags,
          );
      await context.read<JobListingProvider>().fetchJobs();
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Job posted successfully');
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobData = context.watch<JobData>();
    final saving = context.watch<RecruiterJobsProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: const Text('Post a Job')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Create a job opening so candidates can find and apply to this job.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Job title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _company,
            decoration: const InputDecoration(labelText: 'Company for this job'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _location,
            decoration: const InputDecoration(labelText: 'Job location'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _salary,
            decoration: const InputDecoration(labelText: 'Job salary'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _desc,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Job description',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          _dropdown('Job type', _type, jobData.jobTypes.where((e) => e != 'All').toList(),
              (v) => setState(() => _type = v)),
          _dropdown('Job level', _level, jobData.jobLevels.where((e) => e != 'All').toList(),
              (v) => setState(() => _level = v)),
          _dropdown(
            'Working model',
            _model,
            jobData.workingModels.where((e) => e != 'All').toList(),
            (v) => setState(() => _model = v),
          ),
          _dropdown(
            'Job category',
            _tags,
            jobData.recentJobFilters.where((e) => e != 'All').toList(),
            (v) => setState(() => _tags = v),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: saving ? null : _submit,
            child: saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text('Publish Job'),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String> onChanged,
  ) {
    final selected = items.contains(value) ? value : items.first;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selected,
            isExpanded: true,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    );
  }
}
