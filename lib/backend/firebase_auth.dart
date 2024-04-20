import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/authentication/transfer_page.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

final _instance = FirebaseAuth.instance;

bool isSignedIn = _instance.currentUser != null;

Future<void> logOut() async {
  await _instance.signOut();
  checkUserChanges();
}

void signInWithPassword(
    BuildContext context,
    TextEditingController email,
    TextEditingController password) async {
  try {
    await _instance.signInWithEmailAndPassword(
        email: email.value.text, password: password.value.text);

    if (_instance.currentUser != null) {
      checkUserChanges();
      transferPage(context);
    }
  } on FirebaseAuthException catch (e) {
    showSnackBar(getErrorMessage(e.code));
  }
}

void checkUserChanges() {
  _instance.authStateChanges().listen((User? user) async {
    if (user != null) {
      currentUser = ReporterRecord.fromFirestore(
          (await usersCollection.doc(user.uid).get())
              as DocumentSnapshot<Map<String, dynamic>>?,
          SnapshotOptions());
    }
  });
}

Stream<QuerySnapshot> getActiveReports() {
  Stream<QuerySnapshot> reportStream = reportsCollection
      .orderBy('timestamp', descending: true)
      .where('category', whereNotIn: categoryFilters ?? [])
      .where('isResolved', isEqualTo: false)
      .snapshots();

  return reportStream;
}
