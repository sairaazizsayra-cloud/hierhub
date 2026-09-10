import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_seeker/core/firebase/firestore_helpers.dart';

class BookmarksJobsDatasource {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  BookmarksJobsDatasource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _bookmarks =>
      _db.collection('bookmarks');

  Future<void> addBookmark(int id) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _bookmarks.add({
      'user_id': user.uid,
      'job_post_id': id,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeBookmark(int id) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final snapshot = await _bookmarks
        .where('user_id', isEqualTo: user.uid)
        .where('job_post_id', isEqualTo: id)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<int>> fetchBookmarks() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final response = await _bookmarks
        .where('user_id', isEqualTo: user.uid)
        .get();

    return response.docs
        .map((e) => parseIntId(e.data()['job_post_id']))
        .toList();
  }
}
