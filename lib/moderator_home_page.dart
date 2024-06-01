import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';

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
              await logOut();
              if (context.mounted) {
                Navigator.of(context)
                    .popUntil((route) => route.isFirst);
              }
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
