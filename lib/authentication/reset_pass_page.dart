// import 'package:flutter/material.dart';
// //import 'landing_page.dart';
// import 'auth_page.dart';

// class ResetPasswordPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     TextEditingController emailController = TextEditingController();
//     bool emailNotFound = false;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Positioned.fill(
//               bottom: -400,
//               child: CustomPaint(
                
//               ),
//             ),
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Center(
//                     child: Transform.scale(
//                       scale: 1.17,
//                       child: Image.asset(
//                         'assets/images/Upatrol-logo.png',
//                         width: 600,
//                         height: 600,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Container(
//                     margin: EdgeInsets.only(top: 20), 
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Container(
//                             width: MediaQuery.of(context).size.width * 0.7,
//                             margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
//                             padding: EdgeInsets.symmetric(horizontal: 20),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: TextField(
//                               controller: emailController,
//                               decoration: InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: 'Email Address',
//                               ),
//                             ),
//                           ),
//                           Visibility(
//                             visible: emailNotFound,
//                             child: Text(
//                               'Email Not Found',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.5,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // Check if email exists 
//                                 String email = emailController.text;
//                               },
//                               style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF29AB84)),
//                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.0),
//                                   ),
//                                 ),
//                                 minimumSize: MaterialStateProperty.all<Size>(Size(120, 40)),
//                               ),
//                               child: Text(
//                                 'Reset Password',
//                                 style: TextStyle(color: Colors.white, fontSize: 16),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 2),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.5,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => AuthenticationSystem(showSignUpFirst: false)),
//                                 );
//                               },
//                               style: ButtonStyle(
//                                 backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                                 shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(20.0),
//                                     side: BorderSide(color: Color(0xFF146136)),
//                                   ),
//                                 ),
//                                 minimumSize: MaterialStateProperty.all<Size>(Size(100, 40)),
//                               ),
//                               child: Text(
//                                 'Back',
//                                 style: TextStyle(color: Color(0xFF146136), fontSize: 16),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 50),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
