import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in_page.dart';
import 'main_activity.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{

  late bool isLoggedIn ;
  Future <void> load () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('log_in') ?? false;
  }
  @override
  void initState() {
    super.initState();
    load();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) =>  isLoggedIn ? MainActivity() : LoginPage()),
      );
    });
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, Colors.grey[600]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
        ),
        child:  Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(indent: 10,endIndent: 10, thickness: 5, color: Colors.white,),
              Divider(indent: 30,endIndent: 30, thickness: 5, color: Colors.white,),
              Divider(indent: 50,endIndent: 50, thickness: 5, color: Colors.white,),
              SizedBox(height: 10,),
          DefaultTextStyle(
            style:  TextStyle(
              fontSize: 20.0,
            ),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Note App',
                textStyle: TextStyle(
                  letterSpacing: 5,
                  fontFamily: 'playWrite',
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),),
              ],
              isRepeatingAnimation: true,
            ),
          ),
              SizedBox(height: 25,),
              Divider(indent: 50,endIndent: 50, thickness: 5, color: Colors.white,),
              Divider(indent: 30,endIndent: 30, thickness: 5, color: Colors.white,),
              Divider(indent: 10,endIndent: 10, thickness: 5, color: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }
}
