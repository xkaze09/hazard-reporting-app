import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/pages/create_report.dart';
import 'package:hazard_reporting_app/pages/create_report_updated.dart';
import 'authentication/auth_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: -400,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Transform.scale(
                    scale: 1.17,
                    child: Hero(
                      tag: "Logo with Text",
                      child: Image.asset(
                        'assets/images/UPatrol-logo.png',
                        width: 600,
                        height: 520,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(seconds: 1),
                                    pageBuilder: (_, __, ___) =>
                                        const AuthPage())
                                // MaterialPageRoute(
                                //     builder: (context) =>
                                //         const AuthPage()),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 35, 150, 115),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            minimumSize: const Size(200, 50),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signInAnonymously();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const PopScope(
                                      canPop: false,
                                      child: CreateReport(),
                                    )));
                          },
                          style: ElevatedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            backgroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            minimumSize: const Size(200, 50),
                          ),
                          child: const Text(
                            'Quick Report',
                            style: TextStyle(
                                fontFamily: 'Helvetica',
                                color: Color(0xFF146136),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
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
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFF146136);
    Path path = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(
          size.width / 2, size.height / 2, size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
