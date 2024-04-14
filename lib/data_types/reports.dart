import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final DocumentReference? reporter;
  final Timestamp? timestamp;
  final String? title;
  final bool? landscape;
  const ReportsRecord(
      this.category,
      this.description,
      this.id,
      this.image,
      this.imageURL,
      this.isResolved,
      this.isVerified,
      this.location,
      this.reporter,
      this.timestamp,
      this.title,
      this.landscape);

  factory ReportsRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>>? snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot?.data();
    return ReportsRecord(
        Category.fromString(data?['category']),
        data?['description'],
        data?['id'],
        Image.network(data?['image']),
        data?['image'],
        data?['isResolved'],
        data?['isVerified'],
        data?['location'],
        data?['reporter'],
        data?['timestamp'],
        data?['title'],
        checkRatio(Image.network(data?['image'])));
  }

  static Future<ReportsRecord> fromMap(
    Map<String, dynamic> data,
  ) async {
    // debugPrint(data['reporter'].runtimeType.toString());
    return ReportsRecord(
        Category.fromString(data['category']),
        data['description'],
        data['id'],
        Image.network(data['image']),
        data['image'],
        data['isResolved'],
        data['isVerified'],
        data['location'],
        data['reporter'],
        data['timestamp'],
        data['title'],
        checkRatio(Image.network(data['image'])));
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
      if (reporter != null) 'reporter': reporter,
      if (timestamp != null) 'timestamp': timestamp,
      if (title != null) 'title': title,
    };
  }

  static bool checkRatio(Image image) {
    try {
      debugPrint(image.height.toString());
      if (image.height!.ceil() > image.width!.ceil()) return false;
    } catch (e) {
      return true;
    }
    return true;
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
