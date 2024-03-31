import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:u_patrol/data_types/reporter.dart';
import 'package:u_patrol/data_types/utils.dart';

class ReportsRecord {
  final Category? category;
  final String? description;
  final String? id;
  final String? image;
  final bool? isResolved;
  final bool? isVerified;
  final LatLng? location;
  final ReporterRecord? reporter;
  final String? reporterRef;
  final Timestamp? timestamp;
  final String? title;
  const ReportsRecord(
      {this.category,
      this.description,
      this.id,
      this.image,
      this.isResolved,
      this.isVerified,
      this.location,
      this.reporter,
      this.reporterRef,
      this.timestamp,
      this.title});

  factory ReportsRecord.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ReportsRecord(
        category: data?['category'],
        description: data?['description'],
        id: data?['id'],
        image: data?['image'],
        isResolved: data?['isResolved'],
        isVerified: data?['isVerified'],
        location: data?['location'],
        reporter: ReporterRecord.fromFirestore(data?['reporter'], options),
        reporterRef: data?['reporter'],
        timestamp: data?['timestamp'],
        title: data?['title']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (id != null) 'id': id,
      if (image != null) 'image_url': image,
      if (isResolved != null) 'isResolved': isResolved,
      if (isVerified != null) 'isVerified': isVerified,
      if (location != null) 'location': location,
      if (reporterRef != null) 'reporter': reporterRef,
      if (timestamp != null) 'timestamp': timestamp,
      if (title != null) 'title': title,
    };
  }
}
