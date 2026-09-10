import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_seeker/core/constants.dart';
import 'package:job_seeker/core/firebase/firestore_helpers.dart';
import 'package:job_seeker/core/firebase/firestore_seed.dart';
import 'package:job_seeker/domain/entity/job_listing_entity.dart';

class JobListingDatasource {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  JobListingDatasource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _jobs =>
      _db.collection('JobList');

  String get authUid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not authenticated');
    return uid;
  }

  Future<List<JobListingEntity>> fethchALLJobs({bool activeOnly = true}) async {
    try {
      await FirestoreSeed.seedJobsIfEmpty();
    } catch (_) {
      // Rules or API may still be propagating.
    }
    final snapshot = await _jobs.get();
    final jobs = snapshot.docs.map((doc) {
      return JobListingEntity.fromJson(
        withDocId(doc.data(), doc.id),
      );
    }).toList();
    if (!activeOnly) return jobs;
    return jobs.where((job) => job.isActive).toList();
  }

  Future<List<JobListingEntity>> fetchJobsByRecruiter(String recruiterId) async {
    final snapshot =
        await _jobs.where('recruiter_id', isEqualTo: recruiterId).get();
    final jobs = snapshot.docs.map((doc) {
      return JobListingEntity.fromJson(withDocId(doc.data(), doc.id));
    }).toList();
    jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return jobs;
  }

  Future<JobListingEntity> fethchJobById(int id) async {
    final byField = await _jobs.where('id', isEqualTo: id).limit(1).get();
    if (byField.docs.isNotEmpty) {
      final doc = byField.docs.first;
      return JobListingEntity.fromJson(withDocId(doc.data(), doc.id));
    }

    final byDocId = await _jobs.doc(id.toString()).get();
    if (byDocId.exists) {
      return JobListingEntity.fromJson(
        withDocId(byDocId.data()!, byDocId.id),
      );
    }

    throw Exception('Job not found');
  }

  Future<JobListingEntity> createJob({
    required String jobTitle,
    required String jobDesc,
    required String companyName,
    required String location,
    required String salary,
    required String type,
    required String level,
    required String workingModel,
    required String tags,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final id = DateTime.now().millisecondsSinceEpoch;
    final image = AppConstants.companyLogo(companyName);
    final data = {
      'id': id,
      'job_title': jobTitle,
      'job_desc': jobDesc,
      'company_name': companyName,
      'location': location,
      'salary': salary,
      'type': type,
      'level': level,
      'working_model': workingModel,
      'tags': tags,
      'image': image,
      'profile_pic': image,
      'created_at': FieldValue.serverTimestamp(),
      'recruiter_id': user.uid,
      'is_active': true,
    };
    await _jobs.doc(id.toString()).set(data);
    return fethchJobById(id);
  }

  Future<void> setJobActive(int jobId, bool isActive) async {
    await _jobs.doc(jobId.toString()).set(
      {'is_active': isActive},
      SetOptions(merge: true),
    );
  }

  Future<void> applyJobs(int jobPostId, String resumeUrl) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final job = await fethchJobById(jobPostId);
    if (!job.isActive) {
      throw Exception('This job is no longer accepting applications');
    }

    final existing = await _db
        .collection('applications')
        .where('usr_id', isEqualTo: user.uid)
        .get();
    final alreadyApplied = existing.docs.any((doc) {
      return parseIntId(doc.data()['job_post_id']) == jobPostId;
    });
    if (alreadyApplied) {
      throw Exception('You already applied for this job');
    }

    final profile = await _db.collection('profiles').doc(user.uid).get();
    final profileData = profile.data() ?? <String, dynamic>{};
    final firstName = (profileData['first_name'] ?? '').toString();
    final lastName = (profileData['last_name'] ?? '').toString();
    final applicantName = '$firstName $lastName'.trim();

    final recruiterId = job.recruiterId.isNotEmpty
        ? job.recruiterId
        : 'recruiter-${job.id}';

    await _db.collection('applications').add({
      'usr_id': user.uid,
      'job_post_id': jobPostId,
      'resume_url': resumeUrl,
      'status': 'applied',
      'created_at': FieldValue.serverTimestamp(),
      'job_title': job.jobTitle,
      'company_name': job.companyName,
      'image': job.image,
      'recruiter_id': recruiterId,
      'applicant_name': applicantName.isEmpty ? user.email : applicantName,
      'applicant_email': user.email ?? '',
      'applicant_skills': (profileData['skills'] ?? '').toString(),
      'applicant_phone': (profileData['phone_no'] ?? '').toString(),
    });
    await _ensureRecruiterRoom(job, user.uid, profileData);
  }

  Future<void> _ensureRecruiterRoom(
    JobListingEntity job,
    String userId,
    Map<String, dynamic> profileData,
  ) async {
    final recruiterId = job.recruiterId.isNotEmpty
        ? job.recruiterId
        : 'recruiter-${job.id}';

    final existing = await _db
        .collection('room')
        .where('user_id', isEqualTo: userId)
        .get();
    final alreadyOpen = existing.docs.any((doc) {
      return parseIntId(doc.data()['job_post_id']) == job.id;
    });
    if (alreadyOpen) return;

    final firstName = (profileData['first_name'] ?? '').toString();
    final lastName = (profileData['last_name'] ?? '').toString();
    final seekerName = '$firstName $lastName'.trim();

    String recruiterName = '${job.companyName} Recruiter';
    String recruiterEmail = 'hiring@${_companyDomain(job.companyName)}';
    String recruiterOrg = job.companyName;
    String recruiterLocation = job.location;
    String recruiterDesc = 'Hiring for ${job.jobTitle}';
    String recruiterAvatar = job.image.isNotEmpty
        ? job.image
        : AppConstants.companyLogo(job.companyName);

    if (job.recruiterId.isNotEmpty) {
      final recruiterDoc =
          await _db.collection('profiles').doc(job.recruiterId).get();
      final recruiter = recruiterDoc.data();
      if (recruiter != null) {
        recruiterName =
            '${recruiter['first_name'] ?? ''} ${recruiter['last_name'] ?? ''}'
                .trim();
        if (recruiterName.isEmpty) recruiterName = '${job.companyName} Recruiter';
        recruiterEmail = (recruiter['email'] ?? recruiterEmail).toString();
        recruiterOrg =
            (recruiter['organisation'] ?? recruiter['company_name'] ?? recruiterOrg)
                .toString();
        recruiterLocation = (recruiter['location'] ?? recruiterLocation).toString();
        recruiterDesc = (recruiter['description'] ?? recruiterDesc).toString();
        final avatar = (recruiter['avatar'] ?? '').toString();
        if (avatar.isNotEmpty) recruiterAvatar = avatar;
      }
    }

    final roomRef = await _db.collection('room').add({
      'user_id': userId,
      'recruiter_id': recruiterId,
      'job_post_id': job.id,
      'job_title': job.jobTitle,
      'seeker_name': seekerName,
      'seeker': {
        'id': userId,
        'name': seekerName.isEmpty ? 'Job Seeker' : seekerName,
        'email': _auth.currentUser?.email ?? '',
        'avatar': (profileData['avatar'] ?? '').toString(),
      },
      'recuiters': {
        'id': recruiterId,
        'name': recruiterName,
        'email': recruiterEmail,
        'organisation': recruiterOrg,
        'avatar': recruiterAvatar,
        'location': recruiterLocation,
        'description': recruiterDesc,
      },
    });

    await _db.collection('messages').add({
      'content':
          'Thanks for applying to the ${job.jobTitle} job at ${job.companyName}. We will review your job application shortly.',
      'sender_id': recruiterId,
      'reciever_id': userId,
      'room_id': roomRef.id,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  String _companyDomain(String company) {
    final slug = company.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return '${slug.isEmpty ? 'company' : slug}.com';
  }
}
