import 'package:ai_image_generator/color.dart';
import 'package:ai_image_generator/homescree.dart';
import 'package:ai_image_generator/splashscreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ai Image Generator',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
          fontFamily: 'poppins',
          scaffoldBackgroundColor: bgColor,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent, elevation: 0)),
    );
  }
}
