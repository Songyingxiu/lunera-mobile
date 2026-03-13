import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Added for API requests
import 'dart:convert'; // Added for JSON decoding
import 'user/main_screen.dart';
import 'admin/admin_main_screen.dart';

// Changed from StatelessWidget to StatefulWidget to handle loading states
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false; // Tracks if the app is waiting for the server

  // Helper method to show error messages easily
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  // The updated real API login function
  Future<void> loginUser(BuildContext context) async {
    // 1. Show the loading spinner
    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Send data to your new CI4 API endpoint
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8076/api/auth/login'),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      // 3. Process the response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 200) {
          // Success: Get role from database response
          String userRole = responseData['data']['role'];

          // Navigate based on real database role
          if (userRole == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminMainScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          }
        } else {
          // Server returned an error (e.g., Wrong password)
          _showError(context, responseData['message']);
        }
      } else {
        _showError(context, "Server Error: ${response.statusCode}");
      }
    } catch (e) {
      // Catch network errors (e.g., CI4 server is turned off)
      _showError(context, "Connection failed. Is the CI4 server running?");
    } finally {
      // 4. Hide the loading spinner
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LUNERA",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "IDENTITY CODE", // Removed the mock instruction
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00f0ff)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFb026ff)),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "PASSCODE",
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00f0ff)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFb026ff)),
                ),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF0099),
                ),
                // Disable button if currently loading
                onPressed: _isLoading ? null : () => loginUser(context),
                // Show a loading spinner if _isLoading is true
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "INITIALIZE LOGIN",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
