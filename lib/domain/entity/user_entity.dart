import 'package:job_seeker/core/user_role.dart';

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String resumeUrl;
  final String lastName;
  final String phoneNo;
  final String address;
  final String dateOfBirth;
  final String jobProfile;
  final String skills;
  final String role;
  final String companyName;
  final String organisation;
  final String location;
  final String description;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.skills,
    required this.lastName,
    required this.address,
    required this.avatar,
    required this.resumeUrl,
    required this.dateOfBirth,
    required this.jobProfile,
    required this.phoneNo,
    this.role = UserRole.jobSeeker,
    this.companyName = '',
    this.organisation = '',
    this.location = '',
    this.description = '',
  });

  bool get isRecruiter => UserRole.isRecruiter(role);

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: (json['id'] ?? '').toString(),
      name: (json['first_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      skills: (json['skills'] ?? '').toString(),
      jobProfile: (json['job_profile'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      avatar: (json['avatar'] ?? '').toString(),
      dateOfBirth: (json['date_of_birth'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      resumeUrl: (json['resume_url'] ?? '').toString(),
      phoneNo: (json['phone_no'] ?? '').toString(),
      role: (json['role'] ?? UserRole.jobSeeker).toString(),
      companyName: (json['company_name'] ?? '').toString(),
      organisation: (json['organisation'] ?? json['company_name'] ?? '').toString(),
      location: (json['location'] ?? json['address'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": name,
      "email": email,
      "skills": skills,
      "job_profile": jobProfile,
      "address": address,
      "avatar": avatar,
      "date_of_birth": dateOfBirth,
      "last_name": lastName,
      "resume_url": resumeUrl,
      "phone_no": phoneNo,
      "role": role,
      "company_name": companyName,
      "organisation": organisation,
      "location": location,
      "description": description,
    };
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? skills,
    String? jobProfile,
    String? address,
    String? avatar,
    String? dateOfBirth,
    String? lastName,
    String? resumeUrl,
    String? phoneNo,
    String? role,
    String? companyName,
    String? organisation,
    String? location,
    String? description,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      skills: skills ?? this.skills,
      jobProfile: jobProfile ?? this.jobProfile,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      lastName: lastName ?? this.lastName,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      phoneNo: phoneNo ?? this.phoneNo,
      role: role ?? this.role,
      companyName: companyName ?? this.companyName,
      organisation: organisation ?? this.organisation,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }
}
