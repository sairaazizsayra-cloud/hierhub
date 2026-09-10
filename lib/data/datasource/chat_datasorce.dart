import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_seeker/core/firebase/firestore_helpers.dart';
import 'package:job_seeker/domain/entity/message_entity.dart';
import 'package:job_seeker/domain/entity/room_entity.dart';

class ChatDatasource {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  ChatDatasource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<RoomEntity>> fetchUsersConnection({
    bool asRecruiter = false,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final query = asRecruiter
        ? _db.collection('room').where('recruiter_id', isEqualTo: user.uid)
        : _db.collection('room').where('user_id', isEqualTo: user.uid);

    final response = await query.get();

    return response.docs.map((doc) {
      final data = withDocId(doc.data(), doc.id);
      data['id'] = data['id']?.toString() ?? doc.id;
      if (data['id'] is int || (data['id'] is String && data['id'].toString() != doc.id)) {
        data['id'] = doc.id;
      }
      return RoomEntity.fromJson(data);
    }).toList();
  }

  Future<List<MessageEntity>> fetchMessages({required String roomId}) async {
    final response = await _db
        .collection('messages')
        .where('room_id', isEqualTo: roomId)
        .get();

    return response.docs.map((doc) {
      final data = withDocId(doc.data(), doc.id);
      return MessageEntity.fromJson(json: data);
    }).toList();
  }

  Future<void> sendMessage({
    required String content,
    required String receiverId,
    required String roomId,
  }) async {
    final senderId = _auth.currentUser!.uid;
    await _db.collection('messages').add({
      'content': content,
      'sender_id': senderId,
      'reciever_id': receiverId,
      'room_id': roomId,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  Stream<MessageEntity> subscribeToMessages(String roomId) {
    return _db
        .collection('messages')
        .where('room_id', isEqualTo: roomId)
        .snapshots()
        .expand((snapshot) {
      return snapshot.docChanges
          .where((change) => change.type == DocumentChangeType.added)
          .map((change) {
        final data = withDocId(change.doc.data()!, change.doc.id);
        return MessageEntity.fromJson(json: data);
      });
    });
  }
}
