import 'package:flutter/material.dart';

class Category {
  final String name;
  final Color color;
  final String description;
  const Category(this.name, this.color, this.description);
}

List<Category> categoryList = [
  const Category('Water Hazard', Colors.blue, 'Water'),
  const Category('Obstruction', Colors.brown, 'Blockage'),
  const Category('Electrical', Colors.yellow, 'PIKA'),
  const Category('Flammable', Colors.red, 'FIYAA'),
  const Category('Structural', Colors.grey, 'Shaky'),
  const Category('Visibility', Colors.white, 'Doko'),
  const Category('Sanitation', Colors.lightGreen, 'Ew'),
  const Category('Chemical', Colors.purple, 'Radioactive'),
  const Category('Vandalism', Colors.black, 'GET REKT'),
  const Category('Misc', Colors.orange, 'Misc'),
];

class LatLng {
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

class Email {
  const Email({this.name, this.provider});
  final String? name;
  final String? provider;

  @override
  String toString() {
    return '$name@$provider';
  }

  factory Email.fromString(String email) {
    List<String> sep = email.split('@');
    return Email(name: sep[0], provider: sep[1]);
  }
}
