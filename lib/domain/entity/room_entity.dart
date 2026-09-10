import 'package:job_seeker/domain/entity/recuiter_profile.dart';

class RoomEntity {
  final String id;
  final RecuiterProfile recuiterProfile;
  final String seekerId;
  final String seekerName;
  final String jobTitle;
  final int jobPostId;

  RoomEntity({
    required this.id,
    required this.recuiterProfile,
    this.seekerId = '',
    this.seekerName = '',
    this.jobTitle = '',
    this.jobPostId = 0,
  });

  factory RoomEntity.fromJson(Map<String, dynamic> json) {
    final seeker = json['seeker'] is Map
        ? Map<String, dynamic>.from(json['seeker'] as Map)
        : <String, dynamic>{};
    return RoomEntity(
      id: json['id']?.toString() ?? '',
      recuiterProfile: RecuiterProfile.fromJson(
        json: json['recuiters'] ?? json['recruiter'] ?? {},
      ),
      seekerId: (json['user_id'] ?? seeker['id'] ?? '').toString(),
      seekerName: (seeker['name'] ?? json['seeker_name'] ?? '').toString(),
      jobTitle: (json['job_title'] ?? '').toString(),
      jobPostId: int.tryParse('${json['job_post_id'] ?? 0}') ?? 0,
    );
  }

  String peerIdFor(String myId) {
    if (myId == recuiterProfile.id) {
      return seekerId;
    }
    return recuiterProfile.id;
  }
}
