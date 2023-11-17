import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_chat/constants/colors.dart';
import 'package:monkey_chat/services/chat/chat_service.dart';
import 'package:monkey_chat/widgets/chat_bubble.dart';
import 'package:monkey_chat/widgets/input.dart';

class ChatScreen extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserId;

  const ChatScreen({super.key, required this.receiverUserEmail, required this.receiverUserId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserId, _messageController.text.trim());

      // clear the text controller ofter sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverUserEmail),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // message
            Expanded(child: _buildMessageList()),

            // user input
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserId, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: AppColors.black,
            ),
          );
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessgeItem(doc)).toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessgeItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Align the messages to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    Timestamp timestamp = data['timestamp'];
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);

    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);

    // Format the difference in time using intl package
    String formattedTime = _formatDuration(difference);

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(data['senderEmail']),
          ChatBubble(message: data['message']),
          const SizedBox(
            height: 5,
          ),
          Text(
            formattedTime,
            style: const TextStyle(color: AppColors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }

// Function to format duration to a readable string
  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now().subtract(duration));
    } else if (duration.inHours > 0) {
      return "${duration.inHours} hours ago";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }

  // _build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
            child: Input(
          controller: _messageController,
          hintText: 'Enter message',
          borderRadius: 10,
          paddingHorizontal: 12,
          obscureText: false,
        )),

        // send button
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send_rounded,
              size: 32,
            ))
      ],
    );
  }
}
