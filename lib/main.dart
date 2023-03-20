import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kronovo_app/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),

      home: AnimatedSplashScreen(
        duration: 3000,
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: Colors.green,
        animationDuration: Duration(seconds: 1),
        splashIconSize: 300,
        splash: Center(
          child: Image.asset(
            'assets/images/kronovo-logo.png',
            height: 500,
            width: 500,
          ),
        ),
        nextScreen: HomePage(),
      ));
  }
}