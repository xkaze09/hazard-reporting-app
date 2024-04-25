import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';
import '../data_types/reports.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';



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

class ImageStoreMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
        false,  //isVerified
        null,   //location
        null,   //reporter
        null,   //timestamp
        subject,
        false   //landscape
      );
      _firestore.collection('reports').doc(reportId).set(report.toFirestore(),);
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}