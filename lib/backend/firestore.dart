

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:hazard_reporting_app/data_types/latlng.dart' as latlng;
import 'package:hazard_reporting_app/data_types/utils.dart';
import 'package:hazard_reporting_app/pages/map.dart';
import '../data_types/reports.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';


final db = FirebaseFirestore.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;
//final _instance = FirebaseAuth.instance;

CollectionReference usersCollection = db.collection('users');
CollectionReference reportsCollection = db.collection('reports');

dynamic reference(String documentID) {
  final usersRef = usersCollection.doc(documentID).withConverter(
      fromFirestore: ReporterRecord.fromFirestore,
      toFirestore: (ReporterRecord reporter, _) =>
          reporter.toFirestore());
  return usersRef;
}

class ImageStoreMethods {

  Future<String> imageToStorage(Uint8List file) async {
    String id = const Uuid().v1();
    Reference ref =
    _storage.ref().child('reports').child(id);

    UploadTask uploadTask = ref.putData(
        file
    );
    TaskSnapshot snapshot = await uploadTask;
    String imageURL = await snapshot.ref.getDownloadURL();
    return imageURL;
  }

  Future<String> uploadPost(
    String subject,
    String description, 
    String category, 
    String location,
    Uint8List file,
    ) async {
    String res = 'Some Error Occurred';
    LatLng position = await getPosition();
    GeoPoint geoPoint = GeoPoint(position.latitude, position.longitude);

    try {
      String imageUrl = await imageToStorage(file);
      String reportId = const Uuid().v1();
      ReportsRecord report = ReportsRecord(
        Category.fromString(category),
        description,
        reportId,
        null,
        imageUrl,
        false,  //isResolved
        false,  //isVerified,
        geoPoint,   //location
        // (await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get()) as DocumentReference<Object?>,   //reporter
        null,
        Timestamp.fromDate(DateTime.now()),   //timestamp
        subject,
        false   //landscape
      );
      db.collection('reports').doc(reportId).set(report.toFirestore(),);
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}