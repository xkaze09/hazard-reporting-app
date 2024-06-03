import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _userId;
  String? _display_name;
  TextEditingController _display_nameController =
      TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactNumberController =
      TextEditingController();
  File? _profileImage;
  String? _photo_url;

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
          _display_name = userDoc['display_name'];
          _display_nameController.text = userDoc['display_name'];
          _contactNumberController.text = userDoc['contactNumber'];
          _photo_url = userDoc['photo_url'];
        });
      } else {
        // Create a new user document if it doesn't exist
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .set({
          'display_name': '',
          'email': user.email,
          'contactNumber': '',
          'photo_url': '',
        });
        setState(() {
          _display_name = '';
          _display_nameController.text = '';
          _contactNumberController.text = '';
          _photo_url = '';
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
          _photo_url = imageUrl;
        }
        authInstance.currentUser
            ?.updateDisplayName(_display_nameController.text);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .update({
          'display_name': _display_nameController.text,
          'contactNumber': _contactNumberController.text,
          'photo_url': _photo_url,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Profile updated successfully')));
        setState(() {
          _display_name = _display_nameController.text;
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
        debugPrint('No image selected.');
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
          const SnackBar(content: Text('Password reset email sent')));
    }
  }

  @override
  void dispose() {
    _display_nameController.dispose();
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
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                        title: const Text('Select an option'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _pickImage(ImageSource.camera);
                            },
                            child: const Text('Camera'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _pickImage(ImageSource.gallery);
                            },
                            child: const Text('Gallery'),
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
                        : (_photo_url != null &&
                                _photo_url!.isNotEmpty
                            ? NetworkImage(_photo_url!)
                                as ImageProvider
                            : null),
                    child: _profileImage == null &&
                            (_photo_url == null ||
                                _photo_url!.isEmpty)
                        ? const Icon(Icons.person,
                            size:
                                75) // Adjust the icon size to match the CircleAvatar
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(_display_name ?? 'Anonymous',
                    style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 20),
              _buildTextField('User ID:',
                  initialValue: _userId, readOnly: true),
              const SizedBox(height: 10),
              _buildTextField('User Name:',
                  controller: _display_nameController),
              const SizedBox(height: 10),
              _buildTextField('Email:',
                  controller: _emailController, readOnly: true),
              const SizedBox(height: 10),
              _buildTextField('Contact Number:',
                  controller: _contactNumberController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildButton('Delete Account',
                      const Color(0xFFEF5350), _deleteAccount),
                  const SizedBox(width: 10),
                  _buildButton('Confirm', const Color(0xFF66BB6A),
                      _updateUserDetails),
                  const SizedBox(width: 10),
                  _buildButton('Reset Password',
                      const Color(0xFF42A5F5), _resetPassword),
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
