import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hazard_reporting_app/authentication/auth_service.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Center(
          child: SizedBox(
            width: 500,
            height: 600,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      child: Text('Sign In'),
                    ),
                    Tab(
                      child: Text('Sign Up'),
                    )
                  ],
                ),
                SizedBox(
                  width: 500,
                  height: 500,
                  child: TabBarView(children: [
                    Form(
                        key: _signInFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Username',
                                    hintText:
                                        "Enter Email Address or Username"),
                                controller: _emailController,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Email address required';
                                  }
                                  return null;
                                }),
                            TextFormField(
                                obscureText: isObscure,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    hintText: "Enter password",
                                    suffixIcon: IconButton(
                                      icon: Icon(isObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          isObscure = !isObscure;
                                        });
                                      },
                                    )),
                                controller: _passwordController,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Password required';
                                  }
                                  return null;
                                }),
                            TextButton(
                                onPressed: () async {
                                  if (isSignedIn) {
                                    showSnackBar(
                                        "User is already signed in");
                                  } else {
                                    signInWithPassword(
                                        context,
                                        _emailController,
                                        _passwordController);
                                  }
                                },
                                child: const Text('Sign In')),
                          ],
                        )),
                    Form(
                        key: _signUpFormKey,
                        child: Column(
                          children: [
                            TextFormField(validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email address required';
                              }
                              return null;
                            })
                          ],
                        ))
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
