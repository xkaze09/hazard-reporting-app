import 'package:flutter/material.dart';
import './authentication/auth_service.dart'; // import the AuthService for sign-out functionality

class ModeratorHomePage extends StatelessWidget {
  const ModeratorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moderator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await AuthService().signOut();
              Navigator.of(context)
                  .popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome, Moderator!',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Text('This is your dashboard.',
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
