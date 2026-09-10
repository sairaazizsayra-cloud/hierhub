import 'dart:convert';
import 'dart:typed_data';

import 'package:job_seeker/core/constants.dart';
import 'package:job_seeker/domain/entity/applications_entity.dart';
import 'package:job_seeker/domain/entity/job_listing_entity.dart';
import 'package:job_seeker/domain/entity/message_entity.dart';
import 'package:job_seeker/domain/entity/recuiter_profile.dart';
import 'package:job_seeker/domain/entity/room_entity.dart';
import 'package:job_seeker/domain/entity/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// On-device data store used when Firebase is not configured.
class LocalDataStore {
  LocalDataStore._();
  static final LocalDataStore instance = LocalDataStore._();

  static const defaultEmail = 'user@hirehub.com';
  static const defaultPassword = 'hirehub123';

  List<JobListingEntity> jobs = [];
  final Map<String, UserEntity> users = {};
  UserEntity? currentUser;
  List<int> bookmarks = [];
  final List<ApplicationEntity> applications = [];
  final List<RoomEntity> rooms = [];
  final Map<String, List<MessageEntity>> messagesByRoom = {};
  final Map<String, String> resumeUrls = {};
  final Map<String, String> passwords = {};

  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    final prefs = await SharedPreferences.getInstance();

    final usersJson = prefs.getString('hh_users');
    if (usersJson != null) {
      final list = jsonDecode(usersJson) as List;
      for (final u in list) {
        final user = UserEntity.fromJson(Map<String, dynamic>.from(u));
        users[user.email] = user;
      }
    }

    bookmarks =
        (prefs.getStringList('hh_bookmarks') ?? []).map(int.parse).toList();

    _seedJobs();
    _seedDefaultUser();
    _seedApplications();
    _seedRecruiterChat();

    currentUser = users[defaultEmail];
    _ready = true;
  }

  void _seedDefaultUser() {
    passwords[defaultEmail] = defaultPassword;
    if (!users.containsKey(defaultEmail)) {
      users[defaultEmail] = UserEntity(
        id: 'user-001',
        name: 'Alex',
        lastName: 'Johnson',
        email: defaultEmail,
        phoneNo: '+1 555 0100',
        address: 'New York, USA',
        dateOfBirth: '15-06-1998',
        jobProfile: 'Flutter Developer',
        skills: 'Flutter, Dart, Firebase, UI/UX',
        avatar: AppConstants.defaultAvatar,
        resumeUrl: '',
      );
    }
  }

  void _seedJobs() {
    if (jobs.isNotEmpty) return;
    final now = DateTime.now().toIso8601String();
    jobs = [
      _job(1, 'Mobile App Developer', 'Microsoft', 'Hyderabad', '40000-60000',
          'Programmer', 'Full-Time', 'Sr. Dev', 'Remote', now),
      _job(2, 'UI/UX Designer', 'Adobe', 'San Jose', '110000', 'Designer',
          'Full-time', 'Mid', 'Hybrid', now),
      _job(3, 'Flutter Developer', 'Google', 'Mountain View', '120000',
          'Programmer', 'Full-time', 'Mid', 'Remote', now),
      _job(4, 'Senior Mobile Engineer', 'Meta', 'Menlo Park', '145000',
          'Programmer', 'Full-time', 'Senior', 'Hybrid', now),
      _job(5, 'Product Manager', 'Amazon', 'Austin', '130000', 'Management',
          'Full-time', 'Senior', 'Hybrid', now),
      _job(6, 'React Native Developer', 'Netflix', 'Los Gatos', '125000',
          'Programmer', 'Contract', 'Mid', 'Remote', now),
      _job(7, 'Backend Developer', 'Stripe', 'San Francisco', '140000',
          'Programmer', 'Full-time', 'Senior', 'Remote', now),
      _job(8, 'DevOps Engineer', 'Spotify', 'Stockholm', '115000', 'Programmer',
          'Full-time', 'Senior', 'Remote', now),
      _job(9, 'Data Analyst', 'IBM', 'Armonk', '95000', 'Management',
          'Full-time', 'Mid', 'Remote', now),
      _job(10, 'QA Engineer', 'Apple', 'Cupertino', '98000', 'Programmer',
          'Full-time', 'Mid', 'On-site', now),
      _job(11, 'Marketing Specialist', 'Nike', 'Portland', '75000', 'Designer',
          'Full-time', 'Junior', 'Hybrid', now),
      _job(12, 'HR Coordinator', 'Deloitte', 'Chicago', '70000', 'Management',
          'Part-time', 'Junior', 'On-site', now),
    ];
  }

  void _seedApplications() {
    if (applications.isNotEmpty) return;
    applications.addAll([
      ApplicationEntity(
        id: 101,
        jobId: 1,
        status: ApplicationStatus.applied,
        createdAt: '2025-04-15T15:38:00',
        job: JobList(
          jobTitle: 'Mobile App Developer',
          companyName: 'Microsoft',
          image: AppConstants.defaultCompanyLogo,
        ),
      ),
      ApplicationEntity(
        id: 102,
        jobId: 2,
        status: ApplicationStatus.shortlisted,
        createdAt: '2025-04-15T15:39:00',
        job: JobList(
          jobTitle: 'UI/UX Designer',
          companyName: 'Adobe',
          image: AppConstants.defaultCompanyLogo,
        ),
      ),
      ApplicationEntity(
        id: 103,
        jobId: 3,
        status: ApplicationStatus.rejected,
        createdAt: '2025-04-15T15:39:00',
        job: JobList(
          jobTitle: 'Flutter Developer',
          companyName: 'Google',
          image: AppConstants.defaultCompanyLogo,
        ),
      ),
      ApplicationEntity(
        id: 104,
        jobId: 4,
        status: ApplicationStatus.applied,
        createdAt: '2025-04-15T15:40:00',
        job: JobList(
          jobTitle: 'Senior Mobile Engineer',
          companyName: 'Meta',
          image: AppConstants.defaultCompanyLogo,
        ),
      ),
    ]);
  }

  JobListingEntity _job(
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
    return JobListingEntity(
      id: id,
      createdAt: createdAt,
      jobTitle: title,
      jobDesc:
          'We are hiring a $title at $company. You will work with a talented team on iOS, Android, Flutter and modern products.',
      type: type,
      companyName: company,
      location: location,
      profilePic: AppConstants.defaultCompanyLogo,
      salary: salary,
      workingModel: model,
      level: level,
      tags: tags,
      image: AppConstants.defaultCompanyLogo,
    );
  }

  void _seedRecruiterChat() {
    if (rooms.isNotEmpty) return;
    const roomId = 'room-google-1';
    final recruiter = RecuiterProfile(
      id: 'recruiter-google',
      name: 'recruiter',
      email: 'hiring@google.com',
      organisation: 'GOOGLE',
      avatar: AppConstants.defaultAvatar,
      description: 'recruiter',
      location: 'Mountain View',
    );
    rooms.add(RoomEntity(id: roomId, recuiterProfile: recruiter));
    messagesByRoom[roomId] = [
      MessageEntity(
        id: 1,
        senderId: recruiter.id,
        receiverId: 'user-001',
        roomId: roomId,
        content: 'You are hired',
      ),
      MessageEntity(
        id: 2,
        senderId: 'user-001',
        receiverId: recruiter.id,
        roomId: roomId,
        content: 'thank you sir',
      ),
      MessageEntity(
        id: 3,
        senderId: recruiter.id,
        receiverId: 'user-001',
        roomId: roomId,
        content: '70000 CRC',
      ),
      MessageEntity(
        id: 4,
        senderId: 'user-001',
        receiverId: recruiter.id,
        roomId: roomId,
        content: 'sir package',
      ),
    ];
  }

  Future<void> _persistUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final list = users.values.map((u) => u.toJson()).toList();
    await prefs.setString('hh_users', jsonEncode(list));
  }

  Future<void> _persistBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'hh_bookmarks',
      bookmarks.map((e) => e.toString()).toList(),
    );
  }

  Future<UserEntity> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final key = email.trim().toLowerCase();
    final user = users[key];
    if (user == null) throw Exception('No account found. Register first.');
    if (passwords[key] != password) throw Exception('Wrong password');
    currentUser = user;
    return user;
  }

  Future<String> signUp(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final key = email.trim().toLowerCase();
    if (users.containsKey(key)) throw Exception('Account already exists');
    final id = 'user-${DateTime.now().millisecondsSinceEpoch}';
    users[key] = UserEntity(
      id: id,
      name: '',
      lastName: '',
      email: key,
      phoneNo: '',
      address: '',
      dateOfBirth: '',
      jobProfile: '',
      skills: '',
      avatar: '',
      resumeUrl: '',
    );
    passwords[key] = password;
    await _persistUsers();
    currentUser = users[key];
    return id;
  }

  Future<UserEntity> saveProfile(UserEntity profile) async {
    users[profile.email] = profile;
    currentUser = profile;
    await _persistUsers();
    return profile;
  }

  Future<UserEntity?> getCurrentUser() async => currentUser;

  Future<void> signOut() async {
    currentUser = null;
  }

  bool profileComplete(UserEntity? user) {
    if (user == null) return false;
    return user.name.isNotEmpty && user.lastName.isNotEmpty;
  }

  Future<void> addBookmark(int id) async {
    if (!bookmarks.contains(id)) bookmarks.add(id);
    await _persistBookmarks();
  }

  Future<void> removeBookmark(int id) async {
    bookmarks.remove(id);
    await _persistBookmarks();
  }

  Future<void> applyJob(int jobId, String resumeUrl) async {
    final user = currentUser;
    if (user == null) throw Exception('Not logged in');
    final job = jobs.firstWhere((j) => j.id == jobId);
    applications.insert(
      0,
      ApplicationEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        jobId: jobId,
        status: ApplicationStatus.applied,
        createdAt: DateTime.now().toIso8601String(),
        job: JobList(
          jobTitle: job.jobTitle,
          companyName: job.companyName,
          image: job.image,
        ),
      ),
    );
    resumeUrls[user.id] = resumeUrl;
    users[user.email] = user.copyWith(resumeUrl: resumeUrl);
    currentUser = users[user.email];
    await _persistUsers();
  }

  Future<String> uploadResume(String userId, String fileName) async {
    final url = 'https://storage.hirehub.app/resumes/$userId/$fileName';
    resumeUrls[userId] = url;
    if (currentUser != null) {
      final updated = currentUser!.copyWith(resumeUrl: url);
      users[currentUser!.email] = updated;
      currentUser = updated;
      await _persistUsers();
    }
    return url;
  }

  Future<String> uploadAvatar(String userId) async {
    final url = AppConstants.defaultAvatar;
    if (currentUser != null) {
      final updated = currentUser!.copyWith(avatar: url);
      users[currentUser!.email] = updated;
      currentUser = updated;
      await _persistUsers();
    }
    return url;
  }

  void sendMessage(String roomId, String content, String receiverId) {
    final senderId = currentUser?.id ?? '';
    final list = messagesByRoom.putIfAbsent(roomId, () => []);
    list.add(MessageEntity(
      id: list.length + 100,
      senderId: senderId,
      receiverId: receiverId,
      roomId: roomId,
      content: content,
    ));
  }
}

/// Local datasources — same API shape as Firebase datasources.
class LocalUserAuthDataSource {
  final _store = LocalDataStore.instance;

  Future<void> ensureReady() => _store.init();

  Future<String?> signUp(String email, String password) =>
      _store.signUp(email, password);

  Future<UserEntity> ragisterUsrProfile(UserEntity usrParams) async {
    final user = _store.currentUser;
    if (user == null) throw Exception('User not found');
    return _store.saveProfile(
      usrParams.copyWith(id: user.id, email: user.email),
    );
  }

  Future<UserEntity> signIn(String email, String password) =>
      _store.signIn(email, password);

  Future<void> signOut() => _store.signOut();

  Future<UserEntity> updateUserProfile(UserEntity usrParams) =>
      _store.saveProfile(usrParams);

  Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
    final u = _store.currentUser;
    if (u != null) {
      await _store.saveProfile(u.copyWith(avatar: avatarUrl));
    }
  }

  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!_store.users.containsKey(email.trim().toLowerCase())) {
      throw Exception('No account with this email');
    }
  }

  Future<UserEntity?> getCurrentUser() => _store.getCurrentUser();

  bool isAuthenticated() => _store.currentUser != null;

  bool needsProfile() => !_store.profileComplete(_store.currentUser);
}

class LocalJobListingDatasource {
  final _store = LocalDataStore.instance;

  Future<List<JobListingEntity>> fethchALLJobs() async {
    await _store.init();
    return List.from(_store.jobs);
  }

  Future<JobListingEntity> fethchJobById(int id) async {
    await _store.init();
    return _store.jobs.firstWhere((j) => j.id == id);
  }

  Future<void> applyJobs(int jobPostId, String resumeUrl) async {
    await _store.applyJob(jobPostId, resumeUrl);
  }
}

class LocalApplicationDatasource {
  final _store = LocalDataStore.instance;

  Future<List<ApplicationEntity>> fetchApplications() async {
    await _store.init();
    return List.from(_store.applications);
  }

  Stream<List<ApplicationStatusEntity>> subscribeToApplication() async* {
    await _store.init();
    yield _store.applications
        .map((a) => ApplicationStatusEntity(id: a.id, status: a.status))
        .toList();
  }
}

class LocalBookmarksJobsDatasource {
  final _store = LocalDataStore.instance;

  Future<void> addBookmark(int id) => _store.addBookmark(id);

  Future<void> removeBookmark(int id) => _store.removeBookmark(id);

  Future<List<int>> fetchBookmarks() async {
    await _store.init();
    return List.from(_store.bookmarks);
  }
}

class LocalChatDatasource {
  final _store = LocalDataStore.instance;

  Future<List<RoomEntity>> fetchUsersConnection() async {
    await _store.init();
    return List.from(_store.rooms);
  }

  Future<List<MessageEntity>> fetchMessages({required String roomId}) async {
    await _store.init();
    return List.from(_store.messagesByRoom[roomId] ?? []);
  }

  Future<void> sendMessage({
    required String content,
    required String receiverId,
    required String roomId,
  }) async {
    _store.sendMessage(roomId, content, receiverId);
  }

  Stream<MessageEntity> subscribeToMessages(String roomId) async* {
    await _store.init();
    for (final m in _store.messagesByRoom[roomId] ?? []) {
      yield m;
    }
  }
}

class LocalResumeServiceDatasource {
  final _store = LocalDataStore.instance;

  Future<String?> uploadResume({
    required String fileName,
    Uint8List? bytes,
    String? filePath,
  }) async {
    final user = _store.currentUser;
    if (user == null) throw Exception('Not logged in');
    return _store.uploadResume(user.id, fileName);
  }

  Future<String> uploadAvatar(dynamic imageFile) async {
    final user = _store.currentUser;
    if (user == null) throw Exception('Not logged in');
    return _store.uploadAvatar(user.id);
  }

  Future<void> updateResumeUrlProfile(String publicUrl, String userId) async {}

  Future<void> updateAvatarUrl(String userId, String avatarUrl) async {}
}
