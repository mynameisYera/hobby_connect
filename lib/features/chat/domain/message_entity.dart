import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String messages;
  final String username;
  final int timestamp;

  const MessageEntity({
    required this.username,
    required this.timestamp,
    required this.messages,
  });

  factory MessageEntity.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageEntity(
      timestamp: data['timestamp'] ?? 999999999999999,
      messages: data['messages'] ?? '',
      username: data['username'] ?? '',
    );
  }

  static List<MessageEntity> fromDocumentList(List<DocumentSnapshot> items) {
    return items.map((DocumentSnapshot doc) {
      return MessageEntity.fromDocument(doc);
    }).toList();
  }

  @override
  List<Object?> get props => [messages, username, timestamp];
}
