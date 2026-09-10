import 'package:job_seeker/core/constants.dart';
import 'package:job_seeker/core/firebase/firestore_helpers.dart';

class JobListingEntity {
  final int id;
  final String createdAt;
  final String jobTitle;
  final String jobDesc;
  final String type;
  final String companyName;
  final String location;
  final String profilePic;
  final String salary;
  final String workingModel;
  final String level;
  final String tags;
  final String image;
  final String recruiterId;
  final bool isActive;

  JobListingEntity({
    required this.id,
    required this.createdAt,
    required this.jobTitle,
    required this.jobDesc,
    required this.type,
    required this.companyName,
    required this.location,
    required this.profilePic,
    required this.salary,
    required this.level,
    required this.workingModel,
    required this.tags,
    required this.image,
    this.recruiterId = '',
    this.isActive = true,
  });

  factory JobListingEntity.fromJson(Map<String, dynamic> json) {
    final imageVal = (json['image'] ?? json['profile_pic'] ?? '').toString();
    return JobListingEntity(
      id: parseIntId(json['id']),
      createdAt: formatTimestamp(json['created_at']),
      jobTitle: json['job_title']?.toString() ?? '',
      jobDesc: json['job_desc']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      profilePic: json['profile_pic']?.toString() ?? '',
      salary: json['salary']?.toString() ?? '',
      level: json['level']?.toString() ?? '',
      workingModel: json['working_model']?.toString() ?? '',
      tags: json['tags']?.toString() ?? '',
      image: imageVal.isNotEmpty ? imageVal : AppConstants.defaultCompanyLogo,
      recruiterId: (json['recruiter_id'] ?? '').toString(),
      isActive: json['is_active'] != false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'job_title': jobTitle,
      'job_desc': jobDesc,
      'type': type,
      'company_name': companyName,
      'location': location,
      'profile_pic': profilePic,
      'salary': salary,
      'working_model': workingModel,
      'level': level,
      'tags': tags,
      'image': image,
      'recruiter_id': recruiterId,
      'is_active': isActive,
    };
  }

  JobListingEntity copyWith({
    int? id,
    String? createdAt,
    String? jobTitle,
    String? jobDesc,
    String? type,
    String? companyName,
    String? location,
    String? profilePic,
    String? salary,
    String? workingModel,
    String? level,
    String? tags,
    String? image,
    String? recruiterId,
    bool? isActive,
  }) {
    return JobListingEntity(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      jobTitle: jobTitle ?? this.jobTitle,
      jobDesc: jobDesc ?? this.jobDesc,
      type: type ?? this.type,
      companyName: companyName ?? this.companyName,
      location: location ?? this.location,
      profilePic: profilePic ?? this.profilePic,
      salary: salary ?? this.salary,
      workingModel: workingModel ?? this.workingModel,
      level: level ?? this.level,
      tags: tags ?? this.tags,
      image: image ?? this.image,
      recruiterId: recruiterId ?? this.recruiterId,
      isActive: isActive ?? this.isActive,
    );
  }
}
