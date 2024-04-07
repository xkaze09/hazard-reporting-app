import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
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
                  await AuthService().createUserWithEmailAndPassword(
                      emailController.text, passwordController.text);
                  // Navigate to Sign In page upon successful sign-up
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => SignInPage()));
                } on FirebaseAuthException catch (e) {
                  String errorMessage = _getErrorMessage(e.code);
                  // Show error message
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(errorMessage)));
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'weak-password':
        return 'The password is not strong enough.';
      default:
        return 'An undefined Error happened.';
    }
  }
}
