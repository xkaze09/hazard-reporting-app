import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'firebase_options.dart';
import 'landing_page.dart';
import 'pages/dashboard.dart';
import 'components/template.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure flutter bindings are initialized
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // Initialize Firebase
  );
  // await FirebaseAuth.instance.signInAnonymously();
  checkUserChanges();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UPatrol',
      scaffoldMessengerKey: loggedScaffoldMessengerKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => const Template(
                title: "Dashboard", child: Dashboard())));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LandingPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/UPatrolLogo_Animation.gif'),
      ),
    );
  }
}
