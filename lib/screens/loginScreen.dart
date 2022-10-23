import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quantum_it_assignment/screens/homePage.dart';
import 'package:quantum_it_assignment/screens/signUpScreen.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool showPass = false;
  bool load = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(left: 50.w, right: 50.w, top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("LOGIN",
                      style: TextStyle(
                        fontSize: 100.sp,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(
                    height: 150.h,
                  ),
                  TextFormField(
                    controller: _email,
                    style: TextStyle(fontSize: 48.sp, height: 1.2),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  TextFormField(
                    controller: _pass,
                    style: TextStyle(fontSize: 48.sp, height: 1.2),
                    obscureText: !showPass,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(!showPass
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                        )),
                  ),
                  SizedBox(
                    height: 200.h,
                  ),
                  Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              load = true;
                            });
                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: _email.text, password: _pass.text);

                              clearAndGoto(context, const HomePage());
                            } catch (e) {
                              showToast('Email / password incorrect');
                            }
                            setState(() {
                              load = false;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(vertical: 50.h),
                              width: double.infinity,
                              child: load
                                  ? SizedBox(
                                      height: 70.h,
                                      width: 70.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text('Log in')))),
                  SizedBox(
                    height: 100.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                      gotoScreen(context, const SignUpScreen());
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 30.h),
                      alignment: Alignment.center,
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account?  ",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
