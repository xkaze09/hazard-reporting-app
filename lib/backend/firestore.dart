import 'package:cloud_firestore/cloud_firestore.dart';
import '../data_types/reports.dart';

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
