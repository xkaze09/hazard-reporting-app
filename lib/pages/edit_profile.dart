import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/authentication/reset_pass_page.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditProfilePage(),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final TextEditingController _userIDController =
      TextEditingController(text: currentUser?.uid);
  final TextEditingController _usernameController =
      TextEditingController(text: currentUser?.displayName);
  final TextEditingController _emailController =
      TextEditingController(text: currentUser?.email.toString());
  final TextEditingController _phoneController =
      TextEditingController(
          text: authInstance.currentUser?.phoneNumber);

  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
              color: Color(0xFF146136), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                currentUser?.displayName ?? "Anonymous",
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF146136)),
              ),
              const SizedBox(height: 16),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                foregroundImage: currentUser?.photo?.image,
              ),
              const SizedBox(height: 20),
              EditFormField(
                  fieldLabel: "User ID: ",
                  controller: _userIDController),
              EditFormField(
                  fieldLabel: "User Name: ",
                  controller: _usernameController),
              EditFormField(
                  fieldLabel: "Email: ",
                  controller: _emailController),
              EditFormField(
                  fieldLabel: "Contact Number: ",
                  controller: _phoneController),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete Account"),
                              content: const Text(
                                  "Are you sure you want to delete your account?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () async {
                                      await usersCollection
                                          .doc(currentUser?.uid)
                                          .delete();
                                      await logOut();
                                      await authInstance.currentUser
                                          ?.delete();
                                    },
                                    child: const Text("Yes")),
                              ],
                            );
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD95767),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(
                          color: Colors.white, fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_emailController.text.contains("@")) {
                        await usersCollection
                            .doc(currentUser?.uid)
                            .update({
                          "display_name": _usernameController.text,
                          "email": _emailController.text,
                          "phone_number": _phoneController.text,
                        });
                        showSnackBar("Profile Updated");
                      } else {
                        showSnackBar("Profile Updated");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF146136),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                          color: Colors.white, fontSize: 14),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add your reset password logic here
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const ResetPasswordPage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2746AA),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                          color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class EditFormField extends StatelessWidget {
  const EditFormField({
    super.key,
    required TextEditingController controller,
    required this.fieldLabel,
  }) : _userIDController = controller;

  final TextEditingController _userIDController;
  final String fieldLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextFormField(
          controller: _userIDController,
          decoration: InputDecoration(
            prefixIcon: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  fieldLabel,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            hintText: 'User ID',
            hintStyle: const TextStyle(color: Colors.grey),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
