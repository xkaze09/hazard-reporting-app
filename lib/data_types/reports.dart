import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import '../data_types/utils.dart';

Image? _getImage(String? url) {
  Image? image;
  if (url != null) {
    image = Image.network(url,
        errorBuilder: (context, error, stacktrace) {
      return Image.asset('assets/images/logo-notext.png');
      // return const Text("Image failed to load");
    });
  }
  return image;
}

class ReportsRecord {
  final Category? category;
  final String? description;
  final String? id;
  final Image? image;
  final String? imageURL;
  final bool? isResolved;
  final bool? isVerified;
  final bool? isPending;
  final GeoPoint? location;
  final String? address;
  final DocumentReference? reporter;
  final Timestamp? timestamp;
  final Timestamp? dateResolving;
  final Timestamp? dateResolved;
  final String? title;
  const ReportsRecord(
    this.category,
    this.description,
    this.id,
    this.image,
    this.imageURL,
    this.isResolved,
    this.isVerified,
    this.isPending,
    this.location,
    this.address,
    this.reporter,
    this.timestamp,
    this.dateResolved,
    this.dateResolving,
    this.title,
  );

  factory ReportsRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>>? snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot?.data();
    return ReportsRecord.fromMap(data);
  }

  factory ReportsRecord.fromMap(
    Map<String, dynamic>? data,
  ) {
    return ReportsRecord(
      Category.fromString(data?['category']),
      data?['description'] ?? "No Description",
      data?['id'] ?? '0',
      _getImage(data?['image_url']),
      data?['image_url'] ?? "",
      data?['isResolved'] ?? false,
      data?['isVerified'] ?? false,
      data?['isPending'] ?? false,
      data?['location'] ?? const GeoPoint(0, 0),
      data?['address'] ?? "Location Unknown",
      data?['reporter'] ??
          usersCollection.doc("paXZUUVoXrXgIkLxg3iw"),
      data?['timestamp'] ?? Timestamp.now(),
      data?['dateResolved'] ??
          Timestamp.fromMicrosecondsSinceEpoch(0),
      data?['dateresolving'] ??
          Timestamp.fromMicrosecondsSinceEpoch(0),
      data?['title'] ?? "Untitled",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (category != null) 'category': category.toString(),
      if (description != null) 'description': description,
      if (id != null) 'id': id,
      if (imageURL != null) 'image_url': imageURL,
      if (isResolved != null) 'isResolved': isResolved,
      if (isVerified != null) 'isVerified': isVerified,
      if (isPending != null) 'isPending': isPending,
      if (location != null) 'location': location,
      if (address != null) 'address': address,
      if (reporter != null) 'reporter': reporter,
      if (timestamp != null) 'timestamp': timestamp,
      if (dateResolving != null) 'dateResolving': dateResolving,
      if (dateResolved != null) 'dateResolved': dateResolved,
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
    if (isModerator == true) {
      return "Moderator";
    } else if (isResponder == true) {
      return "Responder";
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
    Image? image = _getImage(data?['photo_url']);

    return ReporterRecord(
        data?['timestamp'],
        data?['display_name'],
        Email.fromString(data?['email']),
        image,
        data?['photo_url'],
        data?['uid'],
        data?['is_responder'],
        data?['is_moderator']);
  }

  factory ReporterRecord.fromMap(
    Map<String, dynamic> snapshot,
  ) {
    Image? image = _getImage(snapshot['photo_url']);

    return ReporterRecord(
        snapshot['timestamp'],
        snapshot['display_name'],
        Email.fromString(snapshot['email'].toString()),
        image,
        snapshot['photo_url'],
        snapshot['uid'],
        snapshot['is_responder'] ?? false,
        snapshot['is_moderator'] ?? false);
  }

  @override
  String toString() {
    return "{timestamp:$timestamp,display_name:$displayName,email:$email,photo_url:$photoUrl,uid:$uid,isResponder:$isResponder,isModerator:$isModerator}";
  }

  static Future<ReporterRecord> fromReference(
    DocumentReference? reference,
  ) async {
    if (reference == null) {
      throw Error();
    }
    Map<String, dynamic>? data =
        (await reference.get()).data() as Map<String, dynamic>?;
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
