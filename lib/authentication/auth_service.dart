import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle user sign-in using email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors here
      throw e;
    }
  }

  // Method to handle user sign-up using email and password
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase authentication errors here
      throw e;
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
}
