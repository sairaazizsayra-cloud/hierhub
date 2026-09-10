class RecuiterProfile {
  final String id;
  final String name;
  final String email;
  final String organisation;
  final String? avatar;
  final String location;
  final String? description;
  RecuiterProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.organisation,
    required this.avatar,
    required this.description,
    required this.location,
  });
  factory RecuiterProfile.fromJson({required json}) {
    final map = json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};
    return RecuiterProfile(
      id: (map['id'] ?? '').toString(),
      name: (map['name'] ?? 'Recruiter').toString(),
      email: (map['email'] ?? '').toString(),
      organisation: (map['organisation'] ?? '').toString(),
      avatar: (map['avatar'] ?? '').toString(),
      description: (map['description'] ?? '').toString(),
      location: (map['location'] ?? '').toString(),
    );
  }
}
