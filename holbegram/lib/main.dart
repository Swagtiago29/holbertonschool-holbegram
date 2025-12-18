import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:holbergram/screens/login_screen.dart';
import 'package:holbergram/screens/signup_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUpScreen (
        emailController: TextEditingController(),
        passwordController: TextEditingController(),
        usernameController: TextEditingController(),
        passwordConfirmController: TextEditingController(),
      ),
    );
  }
}
