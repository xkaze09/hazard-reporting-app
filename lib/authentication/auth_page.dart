import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';

class AuthPage extends StatefulWidget {
  final bool showSignUpFirst;

  const AuthPage({super.key, this.showSignUpFirst = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Color myColor;
  bool isSignInSelected = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController =
      TextEditingController();

  Widget _buildSocialButton(String logoPath, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 2.0,
      ),
      onPressed: onTap,
      child: Image.asset(logoPath, height: 30),
    );
  }

  Widget _buildSocialButtonsRow() {
    String text =
        isSignInSelected ? 'or sign in with' : 'or sign up with';

    return Column(
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSocialButton(
              'assets/images/facebook-logo.jpg',
              () {
                // Implement here if facebook is pressed
              },
            ),
            SizedBox(width: 15),
            _buildSocialButton(
              'assets/images/google-logo.jpg',
              () {
                // Implement here if google is pressed
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (widget.showSignUpFirst) {
      isSignInSelected = false;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: height * .3,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        height: height * .7 - 30,
                        decoration: BoxDecoration(
                          color: Color(0xFF146136),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(130),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: height * .3 - (width * .45),
                left: width * .1,
                child: Container(
                  height: width * .5,
                  width: width * .8,
                  child: Image(
                    image:
                        AssetImage("assets/images/UPatrol-logo.png"),
                  ),
                ),
              ),
              Positioned(
                top: height * .3 + (width * .2),
                left: width * .2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSignInSelected = true;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: isSignInSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.6),
                            ),
                          ),
                          if (isSignInSelected)
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 50,
                              height: 2,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 50),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSignInSelected = false;
                        });
                      },
                      child: Column(
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: isSignInSelected
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.white,
                            ),
                          ),
                          if (!isSignInSelected)
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 50,
                              height: 2,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  try {
                    // Call the signInWithEmailAndPassword method and get UserCredential
                    signInWithPassword(
                        context, emailController, passwordController);
                    // Check if we have a User object
                  } on FirebaseAuthException catch (e) {
                    String errorMessage = _getErrorMessage(e.code);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  }
                },
              ),
              if (isSignInSelected) // Sign In
                Positioned(
                  top: height * .5 + 5,
                  left: width * .1,
                  child: Column(
                    children: [
                      Container(
                        width: width * .8,
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.email, color: Colors.grey),
                            hintText: 'Email Address',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: width * .8,
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.grey),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        width: width * 0.3,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Sign In',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF29AB84),
                            textStyle: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ResetPasswordPage()),
                          // );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8)),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildSocialButtonsRow(),
                    ],
                  ),
                ),
              if (!isSignInSelected) // Sign Up
                Positioned(
                  top: height * .5 + 10,
                  left: width * .1,
                  child: Column(
                    children: [
                      Container(
                        width: width * .8,
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.email, color: Colors.grey),
                            hintText: 'Email Address',
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: width * .8,
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.grey),
                            hintText: 'Password',
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: width * .8,
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.grey),
                            hintText: 'Confirm Password',
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: width * 0.3,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Sign Up',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF29AB84),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildSocialButtonsRow(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getErrorMessage(String errorCode) {
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
