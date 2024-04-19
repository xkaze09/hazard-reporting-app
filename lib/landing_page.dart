import 'package:flutter/material.dart';
import 'authentication/auth_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: Image.asset(
                      'assets/images/UPatrol-logo.png',
                      width: 600,
                      height: 600,
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AuthPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF29AB84),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20.0),
                            ),
                            minimumSize: const Size(200, 50),
                          ),
                          child: const Text(
                            'Get Started',
                            style: TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                        const SizedBox(height: 15),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: Colors.white),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20.0),
                            ),
                            minimumSize: const Size(200, 50),
                          ),
                          child: const Text(
                            'Quick Report',
                            style: TextStyle(
                                color: Color(0xFF146136),
                                fontSize: 20),
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
      ..quadraticBezierTo(size.width / 2, size.height / 2, size.width,
          size.height * 0.4)
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
