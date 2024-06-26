import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';

import 'globals.dart';
import 'package:image_picker/image_picker.dart';

enum Categories {
  waterHazard(Category('Water Hazard', Colors.blue, 'Water',
      Icon(Icons.water_drop, size: 30))),
  obstruction(Category('Obstruction', Colors.brown, 'Blockage',
      Icon(Icons.water_drop, size: 30))),
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

void showSnackBar(String text) {
  rootScaffoldMessengerKey.currentState
      ?.showSnackBar(SnackBar(content: Text(text)));
}

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  showSnackBar("No Image Selected");
}



// showSnackBar(String content, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(content),
//     ),
//   );
// }