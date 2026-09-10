import 'package:flutter/material.dart';
import 'package:job_seeker/core/dependency_injection.dart';
import 'package:job_seeker/core/user_role.dart';
import 'package:job_seeker/data/datasource/user_auth_datasource.dart';
import 'package:job_seeker/domain/entity/user_entity.dart';
import 'package:image_picker/image_picker.dart';

class AuthProvider extends ChangeNotifier {
  final UserAuthDataSource dataSource;
  UserEntity? _userEntity;
  bool isLoading = false;
  String? error;
  bool needsProfileSetup = false;

  UserEntity? get user => _userEntity;
  bool get isAuthenticate => _userEntity != null;
  bool get isRecruiter => _userEntity?.isRecruiter == true;

  AuthProvider({required this.dataSource}) {
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    isLoading = true;
    notifyListeners();
    try {
      final data = await dataSource.getCurrentUser();
      _userEntity = data;
      _updateProfileFlag();
    } catch (e) {
      error = e.toString();
      _userEntity = null;
      needsProfileSetup = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _updateProfileFlag() {
    if (_userEntity == null) {
      needsProfileSetup = false;
      return;
    }
    if (_userEntity!.name.trim().isEmpty) {
      needsProfileSetup = true;
      return;
    }
    if (_userEntity!.isRecruiter &&
        _userEntity!.companyName.trim().isEmpty &&
        _userEntity!.organisation.trim().isEmpty) {
      needsProfileSetup = true;
      return;
    }
    needsProfileSetup = false;
  }

  Future<void> createProfile(UserEntity usrParams) async {
    isLoading = true;
    notifyListeners();
    try {
      final usr = await dataSource.ragisterUsrProfile(usrParams);
      _userEntity = usr;
      needsProfileSetup = false;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sigIn(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final data = await dataSource.signIn(
        email.trim().toLowerCase(),
        password,
      );
      _userEntity = data;
      _updateProfileFlag();
      return true;
    } catch (e) {
      error = _friendlyError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sigUp(
    String email,
    String password, {
    String role = UserRole.jobSeeker,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final id = await dataSource.signUp(
        email.trim().toLowerCase(),
        password,
        role: role,
      );
      if (id == null) throw Exception('Registration failed');

      // New Firebase Auth user — profile form comes next.
      _userEntity = UserEntity(
        id: id,
        name: '',
        lastName: '',
        email: email.trim().toLowerCase(),
        phoneNo: '',
        address: '',
        dateOfBirth: '',
        jobProfile: '',
        skills: '',
        avatar: '',
        resumeUrl: '',
        role: role,
      );
      needsProfileSetup = true;
      return true;
    } catch (e) {
      error = _friendlyError(e);
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> currentSession() async => _initializeSession();

  void setResumeUrl(String url) {
    if (_userEntity == null) return;
    _userEntity = _userEntity!.copyWith(resumeUrl: url);
    notifyListeners();
  }

  Future<void> updateProfile(UserEntity usrParams) async {
    isLoading = true;
    notifyListeners();
    try {
      final usr = await dataSource.updateUserProfile(usrParams);
      _userEntity = usr;
      needsProfileSetup = false;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String> uploadAvatar(XFile imageFile) async {
    isLoading = true;
    notifyListeners();
    try {
      final url = await resumeDs.uploadAvatar(imageFile);
      if (_userEntity != null) {
        await userAuthDs.updateAvatarUrl(_userEntity!.id, url);
        _userEntity = _userEntity!.copyWith(avatar: url);
      }
      return url;
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    isLoading = true;
    notifyListeners();
    try {
      await dataSource.resetPassword(email);
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();
    try {
      await dataSource.signOut();
      _userEntity = null;
      needsProfileSetup = false;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _friendlyError(Object e) {
    final msg = e.toString();
    if (msg.contains('wrong-password') ||
        msg.contains('invalid-credential') ||
        msg.contains('INVALID_LOGIN_CREDENTIALS')) {
      return 'Incorrect email or password';
    }
    if (msg.contains('user-not-found') || msg.contains('No account')) {
      return 'No account found with this email';
    }
    if (msg.contains('email-already-in-use')) {
      return 'Email already registered';
    }
    if (msg.contains('invalid-email')) {
      return 'Invalid email address';
    }
    if (msg.contains('weak-password')) {
      return 'Password is too weak (min 6 characters)';
    }
    if (msg.contains('network-request-failed')) {
      return 'Network error. Check your internet connection';
    }
    if (msg.contains('Profile not found')) {
      return 'Complete your profile to continue';
    }
    return msg.replaceAll('Exception: ', '');
  }
}
