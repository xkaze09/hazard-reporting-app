import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _userId;
  String? _displayName;
  TextEditingController _displayNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactNumberController =
      TextEditingController();
  File? _profileImage;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      _emailController.text =
          user.email ?? ''; // Set the email from FirebaseAuth
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();
      if (userDoc.exists) {
        setState(() {
          _displayName = userDoc['displayName'];
          _displayNameController.text = userDoc['displayName'];
          _contactNumberController.text = userDoc['contactNumber'];
          _photoUrl = userDoc['photo_url'];
        });
      } else {
        // Create a new user document if it doesn't exist
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .set({
          'displayName': '',
          'email': user.email,
          'contactNumber': '',
          'photo_url': '',
        });
        setState(() {
          _displayName = '';
          _displayNameController.text = '';
          _contactNumberController.text = '';
          _photoUrl = '';
        });
      }
    }
  }

  Future<void> _updateUserDetails() async {
    if (_formKey.currentState!.validate()) {
      if (_userId != null) {
        if (_profileImage != null) {
          // Upload the profile image to Firebase Storage
          String imageUrl = await _uploadProfileImage();
          _photoUrl = imageUrl;
        }
        authInstance.currentUser
            ?.updateDisplayName(_displayNameController.text);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .update({
          'displayName': _displayNameController.text,
          'contactNumber': _contactNumberController.text,
          'photo_url': _photoUrl,
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')));
        setState(() {
          _displayName = _displayNameController.text;
        });
      }
    }
  }

  Future<String> _uploadProfileImage() async {
    final storageReference = FirebaseStorage.instance.ref().child(
        'profile_images/${DateTime.now().millisecondsSinceEpoch.toString()}');

    UploadTask uploadTask = storageReference.putFile(_profileImage!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _deleteAccount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await user.delete();
      Navigator.of(context).pop();
    }
  }

  Future<void> _resetPassword() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: user.email!);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent')));
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select an option'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _pickImage(ImageSource.camera);
                            },
                            child: Text('Camera'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _pickImage(ImageSource.gallery);
                            },
                            child: Text('Gallery'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Center(
                  child: CircleAvatar(
                    radius:
                        75, // Increase the radius to make the CircleAvatar bigger
                    backgroundColor: Colors.grey,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : (_photoUrl != null &&
                                _photoUrl!.isNotEmpty
                            ? NetworkImage(_photoUrl!)
                                as ImageProvider
                            : null),
                    child: _profileImage == null &&
                            (_photoUrl == null ||
                                _photoUrl!.isEmpty)
                        ? Icon(Icons.person,
                            size:
                                75) // Adjust the icon size to match the CircleAvatar
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(_displayName ?? 'Anonymous',
                    style: TextStyle(fontSize: 24)),
              ),
              SizedBox(height: 20),
              _buildTextField('User ID:',
                  initialValue: _userId, readOnly: true),
              SizedBox(height: 10),
              _buildTextField('User Name:',
                  controller: _displayNameController),
              SizedBox(height: 10),
              _buildTextField('Email:',
                  controller: _emailController, readOnly: true),
              SizedBox(height: 10),
              _buildTextField('Contact Number:',
                  controller: _contactNumberController),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('Delete Account', Color(0xFFEF5350),
                      _deleteAccount),
                  SizedBox(width: 10),
                  _buildButton('Confirm', Color(0xFF66BB6A),
                      _updateUserDetails),
                  SizedBox(width: 10),
                  _buildButton('Reset Password', Color(0xFF42A5F5),
                      _resetPassword),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {TextEditingController? controller,
      String? initialValue,
      bool readOnly = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildButton(
      String text, Color color, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}
