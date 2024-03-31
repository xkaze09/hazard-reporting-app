// Automatic FlutterFlow imports
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
import 'dart:convert';

Future<String?> convertImageFileToBase64(Image imageFile) async {
  List<int>? imageBytes = imageFile.bytes;
  if (imageBytes != null) {
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
