import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:u_patrol/data_types/utils.dart';

class ReporterRecord {
  final Timestamp? timestamp;
  final String? displayName;
  final Email? email;
  final Image? photo;
  final String? photoUrl;
  final String? uid;

  ReporterRecord(
      {this.timestamp,
      this.displayName,
      this.email,
      this.photo,
      this.photoUrl,
      this.uid});

  Map<String, dynamic> toFirestore() {
    return {
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (timestamp != null) 'timestamp': timestamp,
      if (uid != null) 'uid': uid,
    };
  }

  factory ReporterRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ReporterRecord(
        displayName: data?['display_name'],
        email: Email.fromString(data?['email']),
        photoUrl: data?['photo_url'],
        photo: Image.network(data?['photo_url']),
        uid: data?['uid']);
  }
}
