import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/authentication/transfer_page.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

final authInstance = FirebaseAuth.instance;

bool isSignedIn = authInstance.currentUser != null;

Future<void> logOut() async {
  await authInstance.signOut();
  checkUserChanges();
}

void signInWithPassword(BuildContext context,
    TextEditingController email, TextEditingController password,
    {bool signUp = false}) async {
  try {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const Dialog(
              child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(),
              Text("Logging In...")
            ]),
          ));
        });
    if (!signUp) {
      await authInstance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } else {
      await authInstance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
    }

    if (authInstance.currentUser != null) {
      checkUserChanges();
      if (context.mounted) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return const Dialog(
                child: Center(
                  child: Text("Logged In"),
                ),
              );
            });
        sleep(const Duration(milliseconds: 500));
        transferPage(context);
      }
    }
  } on FirebaseAuthException catch (e) {
    showSnackBar(e.message ?? "An unknown error has occurred.");
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

void checkUserChanges() {
  authInstance.authStateChanges().listen((User? user) async {
    try {
      if (user != null) {
        currentUser = ReporterRecord.fromFirestore(
            (await usersCollection.doc(user.uid).get())
                as DocumentSnapshot<Map<String, dynamic>>?,
            SnapshotOptions());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  });
}

Stream<QuerySnapshot> getActiveReports({int limit = 20}) {
  var reportStream = reportsCollection
      .limit(limit)
      .where('isResolved', isEqualTo: false)
      .where('category', whereNotIn: categoryFilters)
      .orderBy('timestamp', descending: true);
  return reportStream.snapshots();
}
