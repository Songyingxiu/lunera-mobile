import 'package:flutter/material.dart';
import 'dart:async'; // timer
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Creates a 3-second delay, then navigates to the Login Screen
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508), // Lunera dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LOGO
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFb026ff).withOpacity(0.5), // Purple glow
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Color(
                      0xFF00f0ff,
                    ).withOpacity(0.2), // Cyan outer glow
                    blurRadius: 60,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: ClipOval(
                // This calls the image you added to pubspec.yaml
                child: Image.asset(
                  'assets/images/Lunera_Logo.png',
                  fit: BoxFit.cover,
                  // If the image path is wrong, it shows this icon instead of crashing
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),

            SizedBox(height: 50),

            SizedBox(height: 10),

            // 3. Subtitle
            Text(
              "SYSTEM INITIALIZATION...",
              style: TextStyle(
                color: Color(0xFF00f0ff), // Cyan text
                fontSize: 12,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 60),

            // 4. Loading Spinner
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFb026ff),
                ), // Purple spinner
                backgroundColor: Colors.white10,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
