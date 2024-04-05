import 'package:flutter/material.dart';

class Category {
  final String name;
  final Color color;
  final String description;
  final Icon icon;
  const Category(this.name, this.color, this.description, this.icon);

  factory Category.fromString(String category) {
    for (final cat in categoryList) {
      if (cat.name == category) {
        return cat;
      }
    }
    return categoryList[9];
  }

  @override
  String toString() {
    return name;
  }
}

List<Category> categoryList = [
  const Category('Water Hazard', Colors.blue, 'Water',
      Icon(Icons.water_drop, size: 30)),
  const Category('Obstruction', Colors.brown, 'Blockage',
      Icon(Icons.water_drop, size: 30)),
  const Category('Electrical', Colors.yellow, 'PIKA',
      Icon(Icons.bolt, size: 30)),
  const Category('Flammable', Colors.red, 'FIYAA',
      Icon(Icons.local_fire_department, size: 30)),
  const Category('Structural', Colors.grey, 'Shaky',
      Icon(Icons.business, size: 30)),
  const Category('Visibility', Colors.white, 'Doko',
      Icon(Icons.visibility_off, size: 30)),
  const Category('Sanitation', Colors.lightGreen, 'Ew',
      Icon(Icons.clean_hands, size: 30)),
  const Category('Chemical', Colors.purple, 'Radioactive',
      Icon(Icons.science, size: 30)),
  const Category('Vandalism', Colors.black, 'GET REKT',
      Icon(Icons.format_paint, size: 30)),
  const Category('Misc', Colors.orange, 'Misc',
      Icon(Icons.more_horiz, size: 30)),
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
