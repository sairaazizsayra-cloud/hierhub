import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_seeker/core/user_role.dart';
import 'package:job_seeker/domain/entity/user_entity.dart';

class UserAuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  UserAuthDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _profiles =>
      _db.collection('profiles');

  Future<String?> signUp(
    String email,
    String password, {
    String role = UserRole.jobSeeker,
  }) async {
    final response = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = response.user?.uid;
    if (uid != null) {
      await _profiles.doc(uid).set({
        'first_name': '',
        'last_name': '',
        'email': email.trim().toLowerCase(),
        'phone_no': '',
        'address': '',
        'date_of_birth': '',
        'job_profile': '',
        'skills': '',
        'avatar': '',
        'resume_url': '',
        'role': role,
        'company_name': '',
        'organisation': '',
        'location': '',
        'description': '',
      }, SetOptions(merge: true));
    }
    return uid;
  }

  Future<UserEntity> ragisterUsrProfile(UserEntity usrParams) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not found');
    }

    final data = usrParams
        .copyWith(id: user.uid, email: user.email ?? usrParams.email)
        .toJson();

    await _profiles.doc(user.uid).set(data, SetOptions(merge: true));
    return _usrEntity(user.uid);
  }

  Future<UserEntity> _usrEntity(String id) async {
    final doc = await _profiles.doc(id).get();
    if (!doc.exists) {
      final authUser = _auth.currentUser;
      return UserEntity(
        id: id,
        name: '',
        lastName: '',
        email: authUser?.email ?? '',
        phoneNo: '',
        address: '',
        dateOfBirth: '',
        jobProfile: '',
        skills: '',
        avatar: '',
        resumeUrl: '',
      );
    }
    return UserEntity.fromJson({'id': id, ...doc.data()!});
  }

  Future<UserEntity> getUserById(String id) => _usrEntity(id);

  Future<UserEntity> signIn(String email, String password) async {
    final response = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _usrEntity(response.user!.uid);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserEntity> updateUserProfile(UserEntity usrParams) async {
    await _profiles.doc(usrParams.id).set({
      'first_name': usrParams.name,
      'last_name': usrParams.lastName,
      'email': usrParams.email,
      'phone_no': usrParams.phoneNo,
      'address': usrParams.address,
      'date_of_birth': usrParams.dateOfBirth,
      'job_profile': usrParams.jobProfile,
      'skills': usrParams.skills,
      'role': usrParams.role,
      'company_name': usrParams.companyName,
      'organisation': usrParams.organisation,
      'location': usrParams.location,
      'description': usrParams.description,
      if (usrParams.avatar.isNotEmpty) 'avatar': usrParams.avatar,
      if (usrParams.resumeUrl.isNotEmpty) 'resume_url': usrParams.resumeUrl,
    }, SetOptions(merge: true));
    return _usrEntity(usrParams.id);
  }

  Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
    await _profiles.doc(userId).set({'avatar': avatarUrl}, SetOptions(merge: true));
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<UserEntity?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _usrEntity(user.uid);
  }

  bool isAuthenticated() => _auth.currentUser != null;

  String? get currentUserId => _auth.currentUser?.uid;
}
