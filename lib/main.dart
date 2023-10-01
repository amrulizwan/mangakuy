import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mangakuy/editprofile.dart';
import 'package:mangakuy/home.dart';
import 'package:mangakuy/loginpage.dart';
import 'package:mangakuy/registerpage.dart';
import 'package:mangakuy/splashscreen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

String endPoint = '';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/register': (context) => const RegisterPage(),
        '/editprofile': (context) => const EditProfile()
        // Other routes...
      },
      title: 'Manga Kuy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
