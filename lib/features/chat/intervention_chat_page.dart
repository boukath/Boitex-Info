// lib/features/chat/intervention_chat_page.dart
import 'package:boitex_info/features/chat/chat_message.dart';
import 'package:boitex_info/features/chat/chat_service.dart';
import 'package:boitex_info/features/dashboard/application/dashboard_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InterventionChatPage extends ConsumerStatefulWidget {
  final String interventionId;
  final String interventionCode;

  const InterventionChatPage({
    super.key,
    required this.interventionId,
    required this.interventionCode,
  });

  @override
  ConsumerState<InterventionChatPage> createState() => _InterventionChatPageState();
}

class _InterventionChatPageState extends ConsumerState<InterventionChatPage> {
  final _messageController = TextEditingController();
  final _chatService = ChatService();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final currentUser = ref.read(boitexUserProvider).value;
    if (_messageController.text.trim().isEmpty || currentUser == null) {
      return;
    }

    final message = ChatMessage(
      text: _messageController.text.trim(),
      senderId: currentUser.uid,
      senderName: currentUser.fullName,
      // Using the server's time for accuracy
      timestamp: FieldValue.serverTimestamp(),
    );

    _chatService.sendMessage(widget.interventionId, message);
    _messageController.clear();
    // Unfocus the text field after sending
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(boitexUserProvider).value?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat: ${widget.interventionCode}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: _chatService.getMessagesStream(widget.interventionId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet. Start the conversation!'));
                }
                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message.senderId == currentUserId;
                    return _ChatMessageBubble(message: message, isCurrentUser: isCurrentUser);
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(24)),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
              style: IconButton.styleFrom(
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const _ChatMessageBubble({required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    final alignment = isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isCurrentUser ? Theme.of(context).primaryColor : Colors.grey.shade200;
    final textColor = isCurrentUser ? Colors.white : Colors.black87;
    final borderRadius = isCurrentUser
        ? const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(16),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
      bottomRight: Radius.circular(16),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
            ),
            child: Text(message.text, style: TextStyle(color: textColor, fontSize: 16)),
          ),
          const SizedBox(height: 4),
          Text(
            '${message.senderName} · ${message.timestamp is Timestamp ? DateFormat.jm().format((message.timestamp as Timestamp).toDate()) : ""}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}