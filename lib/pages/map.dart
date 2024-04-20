import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/firebase_options.dart';

void main() => runApp(const Maps());

Future<LatLng> getPosition() async {
  Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
  LatLng posnew = LatLng(pos.latitude, pos.longitude);
  return posnew;
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
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
        future: getPosition(),
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
          LatLng location = snapshot.data!;
          return GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 11.0,
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

void getMarkers() async {
  Stream reports = getActiveReports(); //Stream<QuerySnapshot>
  List reportsList = await reports.toList(); //List<QuerySnapshot>
  debugPrint(reportsList.runtimeType.toString());
}
