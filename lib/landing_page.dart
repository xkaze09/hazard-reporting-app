import 'package:flutter/material.dart';
import 'authentication/sign_in_up_page.dart';
import 'authentication/auth_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            Image.asset('assets/upatrol_logo.png'), // Logo
            const Text('UPATROL',
                style: TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const AuthPage())),
              child: const Text('Get Started'),
            ),
            // Add Quick Report Button here
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
