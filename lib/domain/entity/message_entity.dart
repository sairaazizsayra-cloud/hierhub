import 'package:job_seeker/core/firebase/firestore_helpers.dart';

class MessageEntity {
  final int id;
  final String senderId;
  final String receiverId;
  final String roomId;
  final String content;
  MessageEntity({
    required this.id,
    required this.receiverId,
    required this.roomId,
    required this.senderId,
    required this.content,
  });
  factory MessageEntity.fromJson({required json}) {
    final map = json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{};
    return MessageEntity(
      id: parseIntId(map['id']),
      receiverId: (map['reciever_id'] ?? map['receiver_id'] ?? '').toString(),
      roomId: (map['room_id'] ?? '').toString(),
      senderId: (map['sender_id'] ?? '').toString(),
      content: (map['content'] ?? '').toString(),
    );
  }
}
