import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'firebase_options.dart';
import 'package:u_patrol/components/template.dart';

final db = FirebaseFirestore.instance;

CollectionReference usersCollection = db.collection('users');
CollectionReference reportsCollection = db.collection('reports');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAuth.instance.signInAnonymously();

  runApp(const Dashboard());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: SizedBox(
            height: 800,
            width: 720,
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  usersCollection.orderBy('display_name').limit(20).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('$snapshot.error'));
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                var docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Text('${docs[i]['display_name']}'),
                      title: Image.network('${docs[i]['photo_url']}'),
                    );
                  },
                );
              },
            )),
      ),
    ));
  }
}

//Image.asset("assets/images/UPatrol-logo.png")