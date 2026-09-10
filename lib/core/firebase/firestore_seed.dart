import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_seeker/core/constants.dart';

/// Seeds Firestore with sample jobs when JobList is empty.
class FirestoreSeed {
  static Future<void> seedJobsIfEmpty() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('JobList').get();
    final existingIds = snapshot.docs.map((doc) => doc.id).toSet();

    final batch = db.batch();
    var wrote = false;
    for (final job in _sampleJobs()) {
      final id = job['id'].toString();
      if (existingIds.contains(id)) continue;
      batch.set(db.collection('JobList').doc(id), job);
      wrote = true;
    }
    if (wrote) await batch.commit();
  }

  static List<Map<String, dynamic>> _sampleJobs() {
    final now = DateTime.now().toIso8601String();
    return [
      _j(1, 'Mobile App Developer', 'Microsoft', 'Hyderabad', '40000-60000',
          'Programmer', 'Full-Time', 'Sr. Dev', 'Remote', now),
      _j(2, 'UI/UX Designer', 'Adobe', 'San Jose', '110000', 'Designer',
          'Full-time', 'Mid', 'Hybrid', now),
      _j(3, 'Flutter Developer', 'Google', 'Mountain View', '120000',
          'Programmer', 'Full-time', 'Mid', 'Remote', now),
      _j(4, 'Senior Mobile Engineer', 'Meta', 'Menlo Park', '145000',
          'Programmer', 'Full-time', 'Senior', 'Hybrid', now),
      _j(5, 'Product Manager', 'Amazon', 'Austin', '130000', 'Management',
          'Full-time', 'Senior', 'Hybrid', now),
      _j(6, 'React Native Developer', 'Netflix', 'Los Gatos', '125000',
          'Programmer', 'Contract', 'Mid', 'Remote', now),
      _j(7, 'Backend Developer', 'Stripe', 'San Francisco', '140000',
          'Programmer', 'Full-time', 'Senior', 'Remote', now),
      _j(8, 'DevOps Engineer', 'Spotify', 'Stockholm', '115000', 'Programmer',
          'Full-time', 'Senior', 'Remote', now),
      _j(9, 'Data Analyst', 'IBM', 'Armonk', '95000', 'Management', 'Full-time',
          'Mid', 'Remote', now),
      _j(10, 'QA Engineer', 'Apple', 'Cupertino', '98000', 'Programmer',
          'Full-time', 'Mid', 'On-site', now),
      _j(11, 'Marketing Specialist', 'Nike', 'Portland', '75000', 'Designer',
          'Full-time', 'Junior', 'Hybrid', now),
      _j(12, 'HR Coordinator', 'Deloitte', 'Chicago', '70000', 'Management',
          'Part-time', 'Junior', 'On-site', now),
      _j(13, 'Flutter Job Engineer', 'Systems Limited', 'Lahore', '180000',
          'Programmer', 'Full-time', 'Mid', 'Hybrid', now),
      _j(14, 'Android Job Developer', 'Careem', 'Karachi', '220000',
          'Programmer', 'Full-time', 'Senior', 'Hybrid', now),
      _j(15, 'iOS Job Developer', 'Bykea', 'Karachi', '200000', 'Programmer',
          'Full-time', 'Mid', 'On-site', now),
      _j(16, 'Product Job Designer', 'Daraz', 'Karachi', '160000', 'Designer',
          'Full-time', 'Mid', 'Hybrid', now),
      _j(17, 'Digital Marketing Job', 'Foodpanda', 'Lahore', '120000',
          'Marketing', 'Full-time', 'Junior', 'Remote', now),
      _j(18, 'Data Job Analyst', 'Jazz', 'Islamabad', '150000', 'Data',
          'Full-time', 'Mid', 'Hybrid', now),
      _j(19, 'QA Job Engineer', 'Netsol', 'Lahore', '140000', 'QA',
          'Full-time', 'Mid', 'On-site', now),
      _j(20, 'HR Job Specialist', 'Unilever', 'Karachi', '130000', 'HR',
          'Full-time', 'Mid', 'Hybrid', now),
      _j(21, 'Frontend Job Developer', '10Pearls', 'Islamabad', '170000',
          'Programmer', 'Full-time', 'Mid', 'Remote', now),
      _j(22, 'Backend Job Engineer', 'Arbisoft', 'Lahore', '210000',
          'Programmer', 'Full-time', 'Senior', 'Remote', now),
      _j(23, 'Graphic Job Designer', 'Telenor', 'Islamabad', '110000',
          'Designer', 'Contract', 'Junior', 'Remote', now),
      _j(24, 'Sales Job Executive', 'Nestle', 'Lahore', '90000', 'Management',
          'Full-time', 'Junior', 'On-site', now),
    ];
  }

  static Map<String, dynamic> _j(
    int id,
    String title,
    String company,
    String location,
    String salary,
    String tags,
    String type,
    String level,
    String model,
    String createdAt,
  ) {
    return {
      'id': id,
      'job_title': title,
      'job_desc':
          'We are hiring a $title at $company for $location. Work with Flutter, mobile, and modern product teams.',
      'company_name': company,
      'location': location,
      'salary': salary,
      'type': type,
      'level': level,
      'working_model': model,
      'tags': tags,
      'image': AppConstants.companyLogo(company),
      'profile_pic': AppConstants.companyLogo(company),
      'created_at': createdAt,
      'recruiter_id': '',
      'is_active': true,
    };
  }
}
