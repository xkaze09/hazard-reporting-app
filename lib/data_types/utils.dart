import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'globals.dart';
import 'package:image_picker/image_picker.dart';

enum Categories {
  waterHazard(Category('Water Hazard', Colors.blue, 'Water',
      Icon(Icons.water_drop, size: 30))),
  obstruction(Category('Obstruction', Colors.brown, 'Blockage',
      Icon(Icons.fence, size: 30))),
  electrical(Category('Electrical', Colors.yellow, 'PIKA',
      Icon(Icons.bolt, size: 30))),
  fireHazard(Category('Flammable', Colors.red, 'FIYAA',
      Icon(Icons.local_fire_department, size: 30))),
  structural(Category('Structural', Colors.grey, 'Shaky',
      Icon(Icons.business, size: 30))),
  visibility(Category('Visibility', Colors.white, 'Doko',
      Icon(Icons.visibility_off, size: 30))),
  sanitation(Category('Sanitation', Colors.lightGreen, 'Ew',
      Icon(Icons.clean_hands, size: 30))),
  chemical(Category('Chemical', Colors.purple, 'Radioactive',
      Icon(Icons.science, size: 30))),
  vandalism(Category('Vandalism', Colors.black, 'GET REKT',
      Icon(Icons.format_paint, size: 30))),
  miscellaneous(Category('Misc', Colors.orange, 'Misc',
      Icon(Icons.more_horiz, size: 30)));

  const Categories(this.category);

  final Category category;

  factory Categories.fromString(String category) {
    Categories cat = Categories.miscellaneous;
    try {
      cat = Categories.values.byName(category);
    } catch (e) {
      cat = Categories.miscellaneous;
    }
    return cat;
  }
}

class Category {
  final String name;
  final Color color;
  final String description;
  final Icon icon;
  const Category(this.name, this.color, this.description, this.icon);

  factory Category.fromString(String? category) {
    if (category == null) {
      return categoryList[9];
    }

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
      Icon(Icons.fence, size: 30)),
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

abstract class LatLngType {
  @override
  int get hashCode;

  @override
  bool operator ==(other);
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

String getErrorMessage(String errorCode) {
  switch (errorCode) {
    case 'user-not-found':
      return 'No user found for that email.';
    case 'wrong-password':
      return 'Wrong password provided for that user.';
    case 'user-disabled':
      return 'User has been disabled.';
    case 'too-many-requests':
      return 'Too many requests. Try again later.';
    case 'operation-not-allowed':
      return 'Signing in with Email and Password is not enabled.';
    default:
      return 'An unknown error occurred.';
  }
}

Future<String> reverseGeocode(LatLng location) async {
  // Call the geocoding API to get the address of the location
  List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude, location.longitude);

  // Extract the address from the placemark
  Placemark placemark = placemarks[0];
  String address =
      '${placemark.locality}, ${placemark.administrativeArea} , ${placemark.country}';

  return address;
}

Future<Uint8List?> iconToBytes(IconData icon,
    {Color color = Colors.red}) async {
  final pictureRecorder = PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  final textPainter = TextPainter(textDirection: TextDirection.ltr);
  final iconStr = String.fromCharCode(icon.codePoint);

  textPainter.text = TextSpan(
      text: iconStr,
      style: TextStyle(
        letterSpacing: 0.0,
        fontSize: 48.0,
        fontFamily: icon.fontFamily,
        color: color,
      ));
  textPainter.layout();
  textPainter.paint(canvas, const Offset(0.0, 0.0));

  final picture = pictureRecorder.endRecording();
  final image = await picture.toImage(48, 48);
  final bytes = await image.toByteData(format: ImageByteFormat.png);
  return bytes?.buffer.asUint8List();
}

LatLng convertFromGeoPoint(GeoPoint location) {
  return LatLng(location.latitude, location.longitude);
}

void showSnackBar(String text) {
  rootScaffoldMessengerKey.currentState
      ?.showSnackBar(SnackBar(content: Text(text)));
}

dynamic pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920);
  if (file != null) {
    return await file.readAsBytes();
  }
  showSnackBar("No Image Selected");
}

class PasswordField extends StatefulWidget {
  final Icon? icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  const PasswordField(
      {super.key,
      this.icon,
      this.validator,
      required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool isPasswordVisible = false;
  String? Function(String?)? backup = (value) {
    if (value!.length < 8) {
      return "Password must be 8 characters long";
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !isPasswordVisible,
      controller: widget.controller,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          icon: widget.icon ?? const Icon(Icons.lock),
          suffixIcon: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: isPasswordVisible
                  ? const Icon(
                      Icons.visibility,
                      color: Colors.black,
                    )
                  : const Icon(Icons.visibility_off,
                      color: Colors.black))),
      validator: widget.validator ?? backup,
    );
  }
}

Future<LatLng> getPosition() async {
  Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
  LatLng posnew = LatLng(pos.latitude, pos.longitude);
  return posnew;
}

// showSnackBar(String content, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(content),
//     ),
//   );
// }