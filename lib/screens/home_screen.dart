import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_chat/constants/colors.dart';
import 'package:monkey_chat/screens/chat_screen.dart';
import 'package:monkey_chat/screens/splash_screen.dart';
import 'package:monkey_chat/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // sign user out
  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Monkey Chat\'s',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout_rounded),
          )
        ],
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(
            strokeWidth: 2.0, // Adjust the thickness of the indicator's stroke
            color: AppColors.black,
          );
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildUserItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text('${data['email']}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(
                duration: 100,
                nextScreen: ChatScreen(
                  receiverUserEmail: data['email'],
                  receiverUserId: data['uid'],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
