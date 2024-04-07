import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_service.dart';

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
                    // On success, navigate to the home page or dashboard according to assigned role (default: Reporter)
                  } on FirebaseAuthException catch (e) {
                    // Handle errors by showing a message to the user
                  }
                },
                child: Text('Sign In')),
          ],
        ),
      ),
    );
  }
}
