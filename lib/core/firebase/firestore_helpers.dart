import 'package:cloud_firestore/cloud_firestore.dart';

int parseIntId(dynamic value, {String fallback = '0'}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback.hashCode;
  return fallback.hashCode;
}

String formatTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate().toIso8601String();
  }
  if (value is String) return value;
  return DateTime.now().toIso8601String();
}

Map<String, dynamic> withDocId(
  Map<String, dynamic> data,
  String docId, {
  String? idField,
}) {
  final map = Map<String, dynamic>.from(data);
  map[idField ?? 'id'] = map[idField ?? 'id'] ?? parseIntId(docId, fallback: docId);
  if (map['created_at'] != null) {
    map['created_at'] = formatTimestamp(map['created_at']);
  }
  return map;
}
