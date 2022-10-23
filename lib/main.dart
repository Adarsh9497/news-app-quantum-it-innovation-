import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quantum_it_assignment/screens/homePage.dart';
import 'package:quantum_it_assignment/screens/loginScreen.dart';

import 'constants.dart';
import 'models/userdata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UserData(),
      child: ScreenUtilInit(
        designSize: const Size(1080, 2340),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (BuildContext context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child ?? const SizedBox());
          },
          theme: ThemeData(
            primaryColor: kBackgroundColor,
            scaffoldBackgroundColor: kBackgroundColor,
          ),
          home: (_auth.currentUser == null)
              ? const LoginScreen()
              : const HomePage(),
        ),
      ),
    );
  }
}
