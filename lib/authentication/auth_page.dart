import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/authentication/reset_pass_page.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

class AuthPage extends StatelessWidget {
  final bool showSignUpFirst;

  const AuthPage({super.key, this.showSignUpFirst = false});

  @override
  Widget build(BuildContext context) {
    late Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                  height: size.shortestSide * 0.4,
                  width: size.shortestSide * 0.4,
                  child: Center(
                      child: Hero(
                          tag: "Logo with Text",
                          child:
                              Image.asset("assets/images/UPatrol-logo.png")))),
              Container(
                  height: size.height - (size.shortestSide * 0.4),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xFF146136),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(
                          size.width / 2,
                          size.shortestSide * 0.1,
                        ),
                      )),
                  padding: EdgeInsets.only(
                    top: 20,
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                  ),
                  child: AuthForm(
                    showSignUpFirst: showSignUpFirst,
                  )),
            ],
          ),
        ));
  }
}

class AuthForm extends StatefulWidget {
  final bool showSignUpFirst;

  const AuthForm({super.key, this.showSignUpFirst = false});

  @override
  State<AuthForm> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthForm> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    late Size size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                unselectedLabelColor: Colors.lightGreen,
                unselectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                labelColor: Colors.white,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
                indicatorColor: Colors.white,
                indicatorWeight: 5,
                padding: EdgeInsets.symmetric(horizontal: 40),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                      icon: Text(
                    "Sign In",
                    style: TextStyle(
                        fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                  )),
                  Tab(
                      icon: Text(
                    "Sign Up",
                    style: TextStyle(
                        fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                  )),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SignInForm(),
                    SignInForm(
                      signUp: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");
  bool isPasswordVisible = false;
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPassword2Visible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
          key: formKey,
          child: Column(children: [
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.mail),
                  hintText: "Email Address",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 20),
            PasswordField(
              controller: passwordController,
              hintText: "Password",
            ),
            const SizedBox(height: 20),
            Visibility(
              visible: widget.signUp,
              child: PasswordField(
                controller: confirmPasswordController,
                hintText: "Confirm Password",
                validator: (value) {
                  if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    signInWithPassword(
                        context, emailController, passwordController,
                        signUp: widget.signUp);
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.green[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  minimumSize: const Size(200, 50),
                ),
                child: Text(
                  widget.signUp ? "Sign Up" : "Sign In",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 20),
            Visibility(
              visible: !widget.signUp,
              child: Center(
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage()));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ))),
            )
          ])),
    );
  }
}

// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});

//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }

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
//                   signInWithPassword(
//                       context, emailController, passwordController);
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
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF29AB84),
//                             textStyle: const TextStyle(fontSize: 15),
//                           ),
//                           child: const Text('Sign In',
//                               style: TextStyle(
//                                   fontSize: 17, color: Colors.white)),
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) =>
//                                     const ResetPasswordPage()),
//                           );
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
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF29AB84),
//                             textStyle: const TextStyle(fontSize: 20),
//                           ),
//                           child: const Text('Sign Up',
//                               style: TextStyle(
//                                   fontSize: 17, color: Colors.white)),
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
