import 'package:job_seeker/core/constants.dart';
import 'package:job_seeker/core/firebase/firestore_helpers.dart';

enum ApplicationStatus {
  applied,
  shortlisted,
  interviewed,
  hired,
  rejected,
}

class ApplicationStatusEntity {
  final int id;
  final ApplicationStatus status;
  ApplicationStatusEntity({
    required this.id,
    required this.status,
  });
  factory ApplicationStatusEntity.fromJson(Map<String, dynamic> json) {
    return ApplicationStatusEntity(
      id: parseIntId(json['id']),
      status: _statusFromString(json['status'] as String? ?? 'applied'),
    );
  }
  static ApplicationStatus _statusFromString(String value) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ApplicationStatus.applied,
    );
  }
}

class JobList {
  final String? image;
  final String jobTitle;
  final String? companyName;

  JobList({
    this.image,
    required this.jobTitle,
    required this.companyName,
  });

  factory JobList.fromJson(Map<String, dynamic> json) {
    final imageVal = (json['image'] ?? '').toString();
    return JobList(
      image: imageVal.isNotEmpty ? imageVal : AppConstants.defaultCompanyLogo,
      jobTitle: json['job_title']?.toString() ?? 'Job',
      companyName: json['company_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'job_title': jobTitle,
      'company_name': companyName,
    };
  }
}

class ApplicationEntity {
  final int id;
  final String documentId;
  final int jobId;
  final ApplicationStatus status;
  final JobList job;
  final String createdAt;
  final String applicantId;
  final String recruiterId;
  final String resumeUrl;
  final String applicantName;
  final String applicantEmail;
  final String applicantSkills;
  final String applicantPhone;

  ApplicationEntity({
    required this.id,
    required this.jobId,
    required this.status,
    required this.createdAt,
    required this.job,
    this.documentId = '',
    this.applicantId = '',
    this.recruiterId = '',
    this.resumeUrl = '',
    this.applicantName = '',
    this.applicantEmail = '',
    this.applicantSkills = '',
    this.applicantPhone = '',
  });

  factory ApplicationEntity.fromJson(Map<String, dynamic> json) {
    final JobList job;
    if (json['JobList'] != null && json['JobList'] is Map) {
      job = JobList.fromJson(json['JobList'] as Map<String, dynamic>);
    } else {
      job = JobList(
        image: json['image']?.toString(),
        jobTitle: json['job_title']?.toString() ?? 'Job',
        companyName: json['company_name']?.toString() ?? '',
      );
    }

    return ApplicationEntity(
      id: parseIntId(json['id']),
      documentId: (json['document_id'] ?? json['id'] ?? '').toString(),
      jobId: parseIntId(json['job_post_id']),
      status: _statusFromString(json['status'] as String? ?? 'applied'),
      createdAt: formatTimestamp(json['created_at']),
      job: job,
      applicantId: (json['usr_id'] ?? '').toString(),
      recruiterId: (json['recruiter_id'] ?? '').toString(),
      resumeUrl: (json['resume_url'] ?? '').toString(),
      applicantName: (json['applicant_name'] ?? '').toString(),
      applicantEmail: (json['applicant_email'] ?? '').toString(),
      applicantSkills: (json['applicant_skills'] ?? '').toString(),
      applicantPhone: (json['applicant_phone'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_post_id': jobId,
      'status': status.name,
      'JobList': job.toJson(),
    };
  }

  ApplicationEntity copyWith({
    int? id,
    String? documentId,
    int? jobId,
    ApplicationStatus? status,
    String? createdAt,
    JobList? job,
    String? applicantId,
    String? recruiterId,
    String? resumeUrl,
    String? applicantName,
    String? applicantEmail,
    String? applicantSkills,
    String? applicantPhone,
  }) {
    return ApplicationEntity(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      jobId: jobId ?? this.jobId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      job: job ?? this.job,
      applicantId: applicantId ?? this.applicantId,
      recruiterId: recruiterId ?? this.recruiterId,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      applicantName: applicantName ?? this.applicantName,
      applicantEmail: applicantEmail ?? this.applicantEmail,
      applicantSkills: applicantSkills ?? this.applicantSkills,
      applicantPhone: applicantPhone ?? this.applicantPhone,
    );
  }

  static ApplicationStatus _statusFromString(String value) {
    return ApplicationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ApplicationStatus.applied,
    );
  }
}
