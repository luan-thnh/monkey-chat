import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monkey_chat/constants/colors.dart';
import 'package:monkey_chat/utils/show_snackBar.dart';

class AuthService extends ChangeNotifier {
  // instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign in user with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      // add a new document for the user in users collection if it doesn't already exists
      _firestore.collection('users').doc(userCredential.user!.uid).set({'uid': userCredential.user!.uid, 'email': email}, SetOptions(merge: true));

      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // create a new user by email and password
  Future<UserCredential> signUpWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      // after creating the user
      _firestore.collection('users').doc(userCredential.user!.uid).set({'uid': userCredential.user!.uid, 'email': email});

      // if (context.mounted) {
      //   await sendEmailVerification(context);
      // }

      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // send email verification
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _firebaseAuth.currentUser!.sendEmailVerification();

      showSnackBar(context, 'Email verification sent!', true);
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign in user with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Create a GoogleAuthProvider instance
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

      // Set custom parameters if needed
      googleAuthProvider.setCustomParameters({'prompt': 'Monkey Chat\'s', 'login_hint': 'user@example.com'});

      // Sign in with Google
      UserCredential userCredential = await _firebaseAuth.signInWithProvider(googleAuthProvider);

      // Check if the user is new (just signed up)
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Add a new document for the user in the "users" collection
        _firestore.collection('users').doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': userCredential.user!.email,
        }, SetOptions(merge: true));
      }

      return userCredential;
    }

    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign out user
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
