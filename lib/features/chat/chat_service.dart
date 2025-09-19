// lib/features/chat/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get a stream of messages for a specific intervention
  Stream<List<ChatMessage>> getMessagesStream(String interventionId) {
    return _firestore
        .collection('interventions')
        .doc(interventionId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
    });
  }

  // Send a new message
  Future<void> sendMessage(String interventionId, ChatMessage message) async {
    await _firestore
        .collection('interventions')
        .doc(interventionId)
        .collection('messages')
        .add(message.toFirestore());
  }
}