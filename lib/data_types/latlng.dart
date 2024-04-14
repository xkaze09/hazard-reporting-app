import '../data_types/utils.dart';

class LatLng implements LatLngType {
  const LatLng(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  @override
  int get hashCode => latitude.hashCode + longitude.hashCode;

  @override
  bool operator ==(other) =>
      other is LatLng &&
      latitude == other.latitude &&
      longitude == other.longitude;
}
