import 'package:azkary/presentaion/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Azkary App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF331D2C)),
        useMaterial3: true,
        fontFamily: 'Arial', // تأكد من وجود خط عربي في المشروع لاحقاً
      ),
      home: const LoginScreen(),
    );
  }
}