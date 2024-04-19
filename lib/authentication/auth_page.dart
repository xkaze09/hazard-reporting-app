import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';
import '../authentication/sign_in_page.dart';

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
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: height * .3,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: height * .7 - 30,
                        decoration: const BoxDecoration(
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
                child: SizedBox(
                  height: width * .5,
                  width: width * .8,
                  child: const Image(
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
                              margin: const EdgeInsets.only(top: 5),
                              width: 50,
                              height: 2,
                              color: Colors.white,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 50),
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
                              margin: const EdgeInsets.only(top: 5),
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
              if (isSignInSelected) // Sign In
                SignUpPage(
                    height: height, width: width, isSignUp: false),
              if (!isSignInSelected) // Sign Up
                SignUpPage(
                  height: height,
                  width: width,
                  isSignUp: true,
                )
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  final double height;
  final double width;
  final bool isSignUp;

  const SignUpPage(
      {super.key,
      required this.height,
      required this.width,
      required this.isSignUp});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
        !widget.isSignUp ? 'or sign in with' : 'or sign up with';

    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildSocialButton(
              'assets/images/facebook-logo.jpg',
              () {
                // Implement here if facebook is pressed
              },
            ),
            const SizedBox(width: 15),
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
    return Positioned(
      top: widget.height * .5 + 10,
      left: widget.width * .1,
      child: Column(
        children: [
          Container(
            width: widget.width * .8,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.email, color: Colors.grey),
                hintText: 'Email Address',
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: widget.width * .8,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                hintText: 'Password',
              ),
            ),
          ),
          const SizedBox(height: 15),
          Visibility(
            visible: widget.isSignUp,
            child: Container(
              width: widget.width * .8,
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.lock, color: Colors.grey),
                  hintText: 'Confirm Password',
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: widget.width * 0.4,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF29AB84),
                textStyle: const TextStyle(fontSize: 17),
              ),
              child: TextButton(
                child: Text(widget.isSignUp ? 'Sign Up' : 'Sign In',
                    style: const TextStyle(
                        fontSize: 17, color: Colors.white)),
                onPressed: () {
                  if (widget.isSignUp) {
                    if (passwordController.value ==
                        confirmPasswordController.value) {
                      signUpWithPassword(context, emailController,
                          passwordController);
                    } else {
                      showSnackBar("Passwords don't match.");
                    }
                  } else if (!widget.isSignUp) {
                    signInWithPassword(
                        context, emailController, passwordController);
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildSocialButtonsRow(),
        ],
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