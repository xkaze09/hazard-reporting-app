import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

class AuthPage extends StatelessWidget {
  final bool showSignUpFirst;

  const AuthPage({super.key, this.showSignUpFirst = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisSize: MainAxisSize.min, children: [
      Center(
          child: Hero(
              tag: "Logo with Text",
              child: Image.asset("images/UPatrol-logo.png"))),
      Stack(children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40)),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: AuthForm(
              showSignUpFirst: showSignUpFirst,
            ))
      ])
    ]));
  }
}

class AuthForm extends StatefulWidget {
  final bool showSignUpFirst;

  const AuthForm({super.key, this.showSignUpFirst = false});

  @override
  State<AuthForm> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthForm>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Flex(
          direction: Axis.vertical,
          mainAxisSize: MainAxisSize.min,
          children: [
            const TabBar(
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: "Sign In"),
                Tab(text: "Sign Up"),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: const TabBarView(children: [
                SignInForm(),
                SignInForm(
                  signUp: true,
                )
              ]),
            )
          ],
        ));
  }
}

class SignInForm extends StatefulWidget {
  final bool signUp;
  const SignInForm({super.key, this.signUp = false});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController =
      TextEditingController(text: "");
  TextEditingController passwordController =
      TextEditingController(text: "");
  bool isPasswordVisible = false;
  TextEditingController confirmPasswordController =
      TextEditingController();
  bool isPassword2Visible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: formKey,
          child: Column(children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                icon: Icon(Icons.mail),
              ),
            ),
            PasswordField(
              controller: passwordController,
            ),
            Visibility(
              visible: widget.signUp,
              child: PasswordField(
                controller: confirmPasswordController,
                validator: (value) {
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
            ),
            TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    signInWithPassword(
                        context, emailController, passwordController,
                        signUp: widget.signUp);
                  }
                },
                child: Text(widget.signUp ? "Sign Up" : "Sign In"))
          ])),
    );
  }
}

// class _AuthPageState extends State<AuthPage> {
//   late Color myColor;
//   bool isSignInSelected = true;
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController =
//       TextEditingController();

//   Widget _buildSocialButton(String logoPath, VoidCallback onTap) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         elevation: 2.0,
//       ),
//       onPressed: onTap,
//       child: Image.asset(logoPath, height: 30),
//     );
//   }

//   Widget _buildSocialButtonsRow() {
//     String text =
//         isSignInSelected ? 'or sign in with' : 'or sign up with';

//     return Column(
//       children: <Widget>[
//         Text(
//           text,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _buildSocialButton(
//               'assets/images/facebook-logo.jpg',
//               () {
//                 // Implement here if facebook is pressed
//               },
//             ),
//             const SizedBox(width: 15),
//             _buildSocialButton(
//               'assets/images/google-logo.jpg',
//               () {
//                 // Implement here if google is pressed
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     myColor = Theme.of(context).primaryColor;
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;

//     if (widget.showSignUpFirst) {
//       isSignInSelected = false;
//     }

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: SingleChildScrollView(
//         child: SizedBox(
//           height: height,
//           child: Stack(
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: height * .3,
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(top: 30),
//                       child: Container(
//                         height: height * .7 - 30,
//                         decoration: const BoxDecoration(
//                           color: Color(0xFF146136),
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(30),
//                             topRight: Radius.circular(130),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 top: height * .3 - (width * .45),
//                 left: width * .1,
//                 child: SizedBox(
//                   height: width * .5,
//                   width: width * .8,
//                   child: const Image(
//                     image:
//                         AssetImage("assets/images/UPatrol-logo.png"),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: height * .3 + (width * .2),
//                 left: width * .2,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isSignInSelected = true;
//                         });
//                       },
//                       child: Column(
//                         children: [
//                           Text(
//                             "Sign In",
//                             style: TextStyle(
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold,
//                               color: isSignInSelected
//                                   ? Colors.white
//                                   : Colors.white.withOpacity(0.6),
//                             ),
//                           ),
//                           if (isSignInSelected)
//                             Container(
//                               margin: const EdgeInsets.only(top: 5),
//                               width: 50,
//                               height: 2,
//                               color: Colors.white,
//                             ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 50),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isSignInSelected = false;
//                         });
//                       },
//                       child: Column(
//                         children: [
//                           Text(
//                             "Sign Up",
//                             style: TextStyle(
//                               fontSize: 25,
//                               fontWeight: FontWeight.bold,
//                               color: isSignInSelected
//                                   ? Colors.white.withOpacity(0.6)
//                                   : Colors.white,
//                             ),
//                           ),
//                           if (!isSignInSelected)
//                             Container(
//                               margin: const EdgeInsets.only(top: 5),
//                               width: 50,
//                               height: 2,
//                               color: Colors.white,
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () async {
//                   try {
//                     // Call the signInWithEmailAndPassword method and get UserCredential
//                     signInWithPassword(
//                         context, emailController, passwordController);
//                   } on FirebaseAuthException catch (e) {
//                     showSnackBar(
//                         e.message ?? "Unknown Error has occurred");
//                   }
//                 },
//               ),
//               if (isSignInSelected) // Sign In
//                 Positioned(
//                   top: height * .5 + 5,
//                   left: width * .1,
//                   child: Column(
//                     children: [
//                       Container(
//                         width: width * .8,
//                         padding: const EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextField(
//                           controller: emailController,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             prefixIcon:
//                                 Icon(Icons.email, color: Colors.grey),
//                             hintText: 'Email Address',
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       Container(
//                         width: width * .8,
//                         padding: const EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             prefixIcon:
//                                 Icon(Icons.lock, color: Colors.grey),
//                             hintText: 'Password',
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: width * 0.3,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           child: const Text('Sign In',
//                               style: TextStyle(
//                                   fontSize: 17, color: Colors.white)),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF29AB84),
//                             textStyle: const TextStyle(fontSize: 15),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       GestureDetector(
//                         onTap: () {
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(builder: (context) => ResetPasswordPage()),
//                           // );
//                         },
//                         child: Text(
//                           'Forgot Password?',
//                           style: TextStyle(
//                               color: Colors.white.withOpacity(0.8)),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildSocialButtonsRow(),
//                     ],
//                   ),
//                 ),
//               if (!isSignInSelected) // Sign Up
//                 Positioned(
//                   top: height * .5 + 10,
//                   left: width * .1,
//                   child: Column(
//                     children: [
//                       Container(
//                         width: width * .8,
//                         padding: const EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextField(
//                           controller: emailController,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             prefixIcon:
//                                 Icon(Icons.email, color: Colors.grey),
//                             hintText: 'Email Address',
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Container(
//                         width: width * .8,
//                         padding: const EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextField(
//                           controller: passwordController,
//                           obscureText: true,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             prefixIcon:
//                                 Icon(Icons.lock, color: Colors.grey),
//                             hintText: 'Password',
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Container(
//                         width: width * .8,
//                         padding: const EdgeInsets.all(1),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: TextField(
//                           controller: confirmPasswordController,
//                           obscureText: true,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             prefixIcon:
//                                 Icon(Icons.lock, color: Colors.grey),
//                             hintText: 'Confirm Password',
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 25),
//                       SizedBox(
//                         width: width * 0.3,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           child: const Text('Sign Up',
//                               style: TextStyle(
//                                   fontSize: 17, color: Colors.white)),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF29AB84),
//                             textStyle: const TextStyle(fontSize: 20),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _buildSocialButtonsRow(),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
