import 'package:azkary/presentaion/screens/tasbeeh_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TasbeehScreen(),));
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset("assets/images/sebha.png",fit: BoxFit.fill,),
    );
  }
}
