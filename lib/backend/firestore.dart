import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:u_patrol/data_types/utils.dart';

final db = FirebaseFirestore.instance;

CollectionReference usersCollection = db.collection('users');
CollectionReference reportsCollection = db.collection('reports');

dynamic reference(String documentID) {
  final usersRef = usersCollection.doc(documentID).withConverter(
      fromFirestore: ReporterRecord.fromFirestore,
      toFirestore: (ReporterRecord reporter, _) =>
          reporter.toFirestore());
  return usersRef;
}

class ReporterRecord {
  final Timestamp? timestamp;
  final String? displayName;
  final Email? email;
  final Image? photo;
  final String? photoUrl;
  final String? uid;
  final bool? isResponder;
  final bool? isModerator;

  ReporterRecord(
      this.timestamp,
      this.displayName,
      this.email,
      this.photo,
      this.photoUrl,
      this.uid,
      this.isResponder,
      this.isModerator);

  Map<String, dynamic> toFirestore() {
    return {
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (timestamp != null) 'timestamp': timestamp,
      if (uid != null) 'uid': uid,
      if (isResponder != null) 'is_responder': isResponder,
      if (isModerator != null) 'is_moderator': isModerator,
    };
  }

  factory ReporterRecord.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>>? snapshot,
      SnapshotOptions? options) {
    final data = snapshot?.data();
    return ReporterRecord(
        data?['timestamp'],
        data?['display_name'],
        Email.fromString(data?['email']),
        Image.network(data?['photo_url']),
        data?['photo_url'],
        data?['uid'],
        data?['is_responder'] ?? false,
        data?['is_receiver'] ?? false);
  }

  factory ReporterRecord.fromMap(
    Map<String, dynamic> snapshot,
  ) {
    return ReporterRecord(
        snapshot['timestamp'],
        snapshot['display_name'],
        Email.fromString(snapshot['email'].toString()),
        Image.network(snapshot['photo_url']),
        snapshot['photo_url'],
        snapshot['uid'],
        snapshot['is_responder'] ?? false,
        snapshot['is_receiver'] ?? false);
  }

  static Future<ReporterRecord> fromReference(
    DocumentReference reference,
  ) {
    return reference.get().then((DocumentSnapshot value) {
      var data = value.data() as Map<String, dynamic>;
      return ReporterRecord(
          data['created_time'],
          data['display_name'],
          data['email'],
          data['photo'],
          data['photo_url'],
          data['uid'],
          data['is_responder'] ?? false,
          data['is_receiver'] ?? false);
    });
  }
}
