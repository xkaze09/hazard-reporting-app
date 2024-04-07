import 'package:flutter/material.dart';
import 'authentication/sign_in_up_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Image.asset('assets/upatrol_logo.png'), // Logo
          Text('UPATROL',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Spacer(),
          ElevatedButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => SignInUpPage())),
            child: Text('Get Started'),
          ),
          // Add Quick Report Button here
          Spacer(),
        ],
      ),
    );
  }
}
