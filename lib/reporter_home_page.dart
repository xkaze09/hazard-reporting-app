import 'package:flutter/material.dart';
import './authentication/auth_service.dart'; // import the AuthService for sign-out functionality

class ReporterHomePage extends StatelessWidget {
  const ReporterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporter Dashboard'),
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
            Text('Welcome, Reporter!',
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
