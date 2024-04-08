import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:u_patrol/data_types/utils.dart';

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
      if (image.height!.ceil() > image.width!.ceil()) return false;
    } catch (e) {
      return true;
    }
    return true;
  }
}
