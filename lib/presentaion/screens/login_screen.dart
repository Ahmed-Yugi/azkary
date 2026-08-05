import 'package:azkary/presentaion/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import '../../logic/core/colors_manager.dart';
import '../../logic/core/txt_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primaryColor,
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              "assets/images/background_slider.png",
              fit: BoxFit.cover,
            ),
          ),
          // المحتوى
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: Image.asset("assets/logos/logo.png"),
                ),
                const SizedBox(height: 40),
                Text(
                  "بالذِّكْرِ وتلاوةِ القرآنِ\n، تَجِدُ القلوبُ سَكِينَتَها، ويَزْدَادُ الإيمانُ قُوَّةً، وتَتَقَرَّبُ الأرواحُ إلى اللهِ.",
                  textAlign: TextAlign.center,
                  style: TxtStyle.font600Size20LightBeige,
                ),
                const SizedBox(height: 60),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const SplashScreen()),
                    );
                  },
                  child: Container(
                    height: 54,
                    width: 250,
                    decoration: BoxDecoration(
                      color: ColorsManager.lightBeige,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "لنبــدأ في عنايــة الله",
                        style: TxtStyle.font600Size20PrimaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                Text("DEVELOPED BY: \nYUGI SOFTWARE DEVELOPER",
                textAlign: TextAlign.center,
                style: TxtStyle.font600Size16LightBeige,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}