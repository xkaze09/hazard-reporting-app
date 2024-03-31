import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'components/template.dart';

void main() => runApp(const Map());

Future<LatLng> getPosition() async {
  Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low);
  LatLng posnew = LatLng(pos.latitude, pos.longitude);
  return posnew;
}

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Template(
        child: FutureBuilder(
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
            }),
      ),
    );
  }
}
