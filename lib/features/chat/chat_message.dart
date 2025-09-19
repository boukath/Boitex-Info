// lib/features/chat/chat_message.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String? id;
  final String text;
  final String senderId;
  final String senderName;
  // --- 1. CHANGE Timestamp to dynamic ---
  final dynamic timestamp;

  ChatMessage({
    this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      text: data['text'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? 'Unknown',
      // --- 2. HANDLE both Timestamp and placeholder values ---
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'senderId': senderId,
      'senderName': senderName,
      // --- 3. The timestamp will now be a server value ---
      'timestamp': timestamp,
    };
  }
}