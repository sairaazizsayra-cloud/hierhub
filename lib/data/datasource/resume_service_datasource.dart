import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class ResumeServiceDatasource {
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  final FirebaseFirestore _db;

  ResumeServiceDatasource({
    FirebaseAuth? auth,
    FirebaseStorage? storage,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  Future<String?> uploadResume({
    required String fileName,
    Uint8List? bytes,
    String? filePath,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final uniqueValue = DateTime.now().microsecondsSinceEpoch;
    final storagePath = 'resumes/${user.uid}/$uniqueValue$fileName';
    final ref = _storage.ref().child(storagePath);

    if (bytes != null && bytes.isNotEmpty) {
      await ref.putData(bytes);
    } else if (!kIsWeb && filePath != null && filePath.isNotEmpty) {
      // Mobile/desktop path upload via XFile bytes fallback
      final xfile = XFile(filePath);
      final fileBytes = await xfile.readAsBytes();
      await ref.putData(fileBytes);
    } else {
      throw Exception('No file data available. Please choose a resume again.');
    }

    final publicUrl = await ref.getDownloadURL();
    await updateResumeUrlProfile(publicUrl, user.uid);
    return publicUrl;
  }

  Future<String> uploadAvatar(XFile imageFile) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final filePath = 'avatars/${user.uid}/profile.jpg';
    final ref = _storage.ref().child(filePath);
    final bytes = await imageFile.readAsBytes();
    await ref.putData(bytes);
    return ref.getDownloadURL();
  }

  Future<void> updateResumeUrlProfile(String publicUrl, String userId) async {
    await _db.collection('profiles').doc(userId).set({
      'resume_url': publicUrl,
    }, SetOptions(merge: true));
  }

  Future<void> updateAvatarUrl(String userId, String avatarUrl) async {
    await _db.collection('profiles').doc(userId).set({
      'avatar': avatarUrl,
    }, SetOptions(merge: true));
  }
}
