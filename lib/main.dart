import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(LuneraApp());
}

class LuneraApp extends StatelessWidget {
  const LuneraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lunera',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF050508),
        primaryColor: Color(0xFFb026ff),
      ),
      home: SplashScreen(), // Starts at the login screen
    );
  }
}
