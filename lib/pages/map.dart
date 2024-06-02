import 'package:hazard_reporting_app/components/marker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';
import 'package:hazard_reporting_app/pages/report_info.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding
//       .ensureInitialized(); // Ensure flutter bindings are initialized
//   await Firebase.initializeApp(
//     options:
//         DefaultFirebaseOptions.currentPlatform, // Initialize Firebase
//   );
//   FirebaseAuth.instance.signInAnonymously();
//   runApp(const Template(title: "Dashboard", child: Maps()));
// }

Future<bool> askMapPermission() async {
  PermissionStatus status = await Permission.location.request();
  if (status.isDenied == true) {
    return askMapPermission();
  } else {
    return true;
  }
}

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapState();
}

class _MapState extends State<Maps>
    with AutomaticKeepAliveClientMixin<Maps> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      askMapPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: Future.wait([getPosition(), getMarkers()]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('$snapshot.error'));
          } else if (!snapshot.hasData) {
            return const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          LatLng location = snapshot.data![0] as LatLng;
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 18.0,
            ),
            markers: (snapshot.data![1] as List<Marker>).toSet(),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

Future<List<Marker>> getMarkers() async {
  QuerySnapshot repo = await reportsCollection
      .limit(30)
      .where('isResolved', isEqualTo: false)
      .orderBy('timestamp', descending: true)
      .get();

  Set<ReportsRecord> reports = repo.docs
      .map((DocumentSnapshot document) {
        ReportsRecord report = ReportsRecord.fromFirestore(
            document as DocumentSnapshot<Map<String, dynamic>>?,
            SnapshotOptions());
        return report;
      })
      .toSet()
      .cast();

  var markers = Future.wait(
      reports.map((report) => convertReportToMarker(report)));
  return markers;
}

Future<Marker> convertReportToMarker(ReportsRecord report) async {
  MarkerGenerator marker = MarkerGenerator(40);
  Category? category = report.category;
  return Marker(
    markerId: MarkerId(report.id ?? '0'),
    position: convertFromGeoPoint(
        report.location ?? const GeoPoint(0.0, 0.0)),
    icon: await marker.createBitmapDescriptorFromIconData(
        category?.icon.icon ?? Icons.warning,
        category?.color ?? Colors.black,
        Colors.green,
        Colors.white),
    infoWindow: InfoWindow(
        title: report.title,
        snippet: report.address ?? 'Location Unknown',
        onTap: () {
          navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (_) => ReportInfo(report: report)));
        }),
  );
}
