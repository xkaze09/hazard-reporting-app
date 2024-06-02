import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';
//import 'landing_page.dart';
import 'auth_page.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    bool emailNotFound = false;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Positioned.fill(
              bottom: -400,
              child: CustomPaint(),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Transform.scale(
                      scale: 1.17,
                      child: Image.asset(
                        'assets/images/Upatrol-logo.png',
                        width: 600,
                        height: 600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width *
                                0.7,
                            margin:
                                const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Email Address',
                              ),
                            ),
                          ),
                          Visibility(
                            visible: emailNotFound,
                            child: const Text(
                              'Email Not Found',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.5,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Check if email exists
                                try {
                                  String email = emailController.text;
                                  await authInstance
                                      .sendPasswordResetEmail(
                                          email: email);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content:
                                              Text('Email sent')));
                                } on FirebaseAuthException catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                          content: Text(
                                              'Email not found.')));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFF29AB84)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0),
                                  ),
                                ),
                                minimumSize:
                                    MaterialStateProperty.all<Size>(
                                        const Size(120, 40)),
                              ),
                              child: const Text(
                                'Reset Password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.5,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AuthPage()),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                        color: Color(0xFF146136)),
                                  ),
                                ),
                                minimumSize:
                                    MaterialStateProperty.all<Size>(
                                        const Size(100, 40)),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                    color: Color(0xFF146136),
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
