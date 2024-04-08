import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Import the corresponding pages for navigation
import '../moderator_home_page.dart';
import '../receiver_home_page.dart';
import '../reporter_home_page.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to handle user sign-in using email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return result;
  }

  // Method to handle user sign-up using email and password
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await createUserDocument(result.user!); // Create a user document
    return result;
  }

  // Method to create a user document in Firestore
  Future<void> createUserDocument(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'is_moderator': false,
      'is_receiver': false,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Method to fetch user role based on UID
  Future<String> getUserRole(User user) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      if (userData['is_moderator'] == true) {
        return 'Moderator';
      } else if (userData['is_receiver'] == true) {
        return 'Receiver';
      } else {
        return 'Reporter'; // Default role
      }
    } else {
      throw Exception('User document does not exist in Firestore');
    }
  }

  // Method to handle user sign-out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Getter to retrieve the current user
  User? get currentUser => _auth.currentUser;

  // Stream to listen to the authentication changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Method to navigate to the role-based home page
  Future<void> navigateToRoleBasedHomePage(
      BuildContext context, User user) async {
    final String role = await getUserRole(user);
    switch (role) {
      case 'Moderator':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ModeratorHomePage()),
        );
        break;
      case 'Receiver':
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ReceiverHomePage()),
        );
        break;
      default: // 'Reporter' or any other roles default to Reporter's dashboard
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ReporterHomePage()),
        );
        break;
    }
  }
}
