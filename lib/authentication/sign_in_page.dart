import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import '../reporter_home_page.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await AuthService().signInWithEmailAndPassword(
                      emailController.text, passwordController.text);
                  // Navigate to appropriate user role's Home page upon successful sign-in
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) =>
                          ReporterHomePage())); // TO DO: Must check user role, then navigate to appropriate page
                } on FirebaseAuthException catch (e) {
                  String errorMessage = _getErrorMessage(e.code);
                  // Show error message
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(errorMessage)));
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'user-disabled':
        return 'User has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Signing in with Email and Password is not enabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
