import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import '../data_types/utils.dart';

class ReportsRecord {
  final Category? category;
  final String? description;
  final String? id;
  final Image? image;
  final String? imageURL;
  final bool? isResolved;
  final bool? isVerified;
  final GeoPoint? location;
  final String? address;
  final DocumentReference? reporter;
  final Timestamp? timestamp;
  final String? title;
  const ReportsRecord(
      this.category,
      this.description,
      this.id,
      this.image,
      this.imageURL,
      this.isResolved,
      this.isVerified,
      this.location,
      this.address,
      this.reporter,
      this.timestamp,
      this.title);

  factory ReportsRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>>? snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot?.data();
    return ReportsRecord(
        Category.fromString(data?['category']),
        data?['description'] ?? "No Description",
        data?['id'] ?? '0',
        Image.network(data?['image_url']),
        data?['image_url'] ?? "",
        data?['isResolved'] ?? false,
        data?['isVerified'] ?? false,
        data?['location'] ?? const GeoPoint(0, 0),
        data?['address'] ?? "Location Unknown",
        data?['reporter'] ??
            usersCollection.doc("/users/paXZUUVoXrXgIkLxg3iw"),
        data?['timestamp'] ?? Timestamp.now(),
        data?['title'] ?? "Untitled");
  }

  factory ReportsRecord.fromMap(
    Map<String, dynamic> data,
  ) {
    return ReportsRecord(
        Category.fromString(data['category']),
        data['description'] ?? "No Description",
        data['id'] ?? '0',
        Image.network(data['image_url']),
        data['image_url'] ?? "",
        data['isResolved'] ?? false,
        data['isVerified'] ?? false,
        data['location'] ?? const GeoPoint(0, 0),
        data['address'] ?? "Location Unknown",
        data['reporter'] ??
            usersCollection.doc("/users/paXZUUVoXrXgIkLxg3iw"),
        data['timestamp'] ?? Timestamp.now(),
        data['title'] ?? "Untitled");
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (category != null) 'category': category.toString(),
      if (description != null) 'description': description,
      if (id != null) 'id': id,
      if (imageURL != null) 'image_url': imageURL,
      if (isResolved != null) 'isResolved': isResolved,
      if (isVerified != null) 'isVerified': isVerified,
      if (location != null) 'location': location,
      if (address != null) 'address': address,
      if (reporter != null) 'reporter': reporter,
      if (timestamp != null) 'timestamp': timestamp,
      if (title != null) 'title': title,
    };
  }

  @override
  String toString() {
    return "$address,$category,$description,$id,$imageURL,$isResolved,$isVerified,$location,$reporter,$timestamp,$title";
  }
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

  String getRole() {
    if (isModerator != null && isResponder != null) {
      if (isModerator ?? false) {
        return "Moderator";
      } else {
        return "Responder";
      }
    } else {
      return "User";
    }
  }

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
    Image image = Image.network(data?['photo_url'],
        errorBuilder: (context, error, stacktrace) {
      return const Text("Image failed to load");
    });
    return ReporterRecord(
        data?['timestamp'],
        data?['display_name'],
        Email.fromString(data?['email']),
        image,
        data?['photo_url'],
        data?['uid'],
        data?['is_responder'],
        data?['is_receiver']);
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
    DocumentReference? reference,
  ) async {
    if (reference == null) {
      throw Error();
    }
    DocumentSnapshot<Map<String, dynamic>> snapshot = await reference
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    debugPrint(snapshot.data().toString());
    Map<String, dynamic>? data =
        (await reference.get()).data() as Map<String, dynamic>?;
    debugPrint(data.toString());
    return ReporterRecord(
        data?['created_time'],
        data?['display_name'],
        Email.fromString(data?['email']),
        Image.network(data?['photo_url']),
        data?['photo_url'],
        data?['uid'],
        data?['is_responder'],
        data?['is_receiver']);
  }
}
