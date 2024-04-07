import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to handle user sign-in using email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Method to handle user sign-up using email and password
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await createUserDocument(result.user!); // Create a user document
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  // Method to create a user document in Firestore
  Future<void> createUserDocument(User user) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      // Populate as needed
      'is_moderator': false,
      'is_receiver': false,
      'created_at': FieldValue.serverTimestamp(),
    });
  }

  // Method to handle user sign-out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Getter to retrieve the current user
  User? get currentUser => _auth.currentUser;

  // Stream to listen to the authentication changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Method to fetch user role based on UID
  Future<String> getUserRole(User? user) async {
    if (user == null) throw Exception('No user signed in');
    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists) {
      final userData = userDoc.data()!;
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
}
