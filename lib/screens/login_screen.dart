import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'user/main_screen.dart';
import 'admin/admin_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 🚀 New Controllers for Registration
  final TextEditingController emailController = TextEditingController();
  final TextEditingController profileNameController = TextEditingController();
  File? _avatarImage;

  bool _isLoading = false;
  bool _isLogin = true;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFFb026ff),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _submitForm() async {
    // 1. Validation Logic
    if (_isLogin &&
        (usernameController.text.isEmpty || passwordController.text.isEmpty)) {
      _showSnackBar("PLEASE ENTER ALL LOGIN CREDENTIALS");
      return;
    }
    if (!_isLogin &&
        (usernameController.text.isEmpty ||
            passwordController.text.isEmpty ||
            emailController.text.isEmpty ||
            profileNameController.text.isEmpty)) {
      _showSnackBar("ALL FIELDS REQUIRED FOR REGISTRATION");
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // --- LOGIN MODE ---
        final responseData = await ApiService.login(
            usernameController.text, passwordController.text);
        if (!mounted) return;

        if (responseData['status'] == 200) {
          String userRole = responseData['data']['role'];
          String username = responseData['data']['username'];
          int userId = int.parse(responseData['data']['id_user'].toString());

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('role', userRole);
          await prefs.setString('username', username);
          await prefs.setInt('id_user', userId);
          await prefs.setBool('isLoggedIn', true);

          if (userRole == 'admin') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AdminMainScreen()));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const MainScreen()));
          }
        } else {
          _showSnackBar(responseData['message']);
        }
      } else {
        // --- REGISTER MODE ---
        final responseData = await ApiService.register(
          usernameController.text,
          passwordController.text,
          emailController.text,
          profileNameController.text,
          _avatarImage, // Send the chosen image!
        );

        if (!mounted) return;

        if (responseData['status'] == 200) {
          _showSnackBar("IDENTITY CREATED. PLEASE LOGIN.", isError: false);
          setState(() {
            _isLogin = true;
            passwordController.clear();
            emailController.clear();
            profileNameController.clear();
            _avatarImage = null;
          });
        } else {
          _showSnackBar(responseData['message']);
        }
      }
    } catch (e) {
      if (mounted) _showSnackBar("CONNECTION FAILED: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF00f0ff)),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF121216),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00f0ff), width: 2)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dynamic Logo / Avatar Picker
              GestureDetector(
                onTap: !_isLogin ? _pickImage : null,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF121216),
                    border: Border.all(
                        color: const Color(0xFF00f0ff).withOpacity(0.5),
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0xFFb026ff).withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 2)
                    ],
                  ),
                  child: ClipOval(
                    child: !_isLogin && _avatarImage != null
                        ? Image.file(_avatarImage!, fit: BoxFit.cover)
                        : _isLogin
                            ? Image.asset('assets/images/Lunera_Logo.png',
                                fit: BoxFit.cover)
                            : const Icon(Icons.add_a_photo,
                                color: Color(0xFF00f0ff), size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (!_isLogin)
                const Text("UPLOAD AVATAR",
                    style: TextStyle(
                        color: Color(0xFF00f0ff),
                        fontSize: 10,
                        letterSpacing: 2)),

              const SizedBox(height: 32),

              Text(
                _isLogin ? "SECURE SYSTEM PORTAL" : "NEW IDENTITY REGISTRATION",
                style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              // Forms
              _buildTextField(
                  usernameController, "IDENTITY CODE (USERNAME)", Icons.badge),
              if (!_isLogin)
                _buildTextField(emailController, "SECURE COMM LINK (EMAIL)",
                    Icons.email_outlined),
              if (!_isLogin)
                _buildTextField(profileNameController,
                    "PUBLIC ALIAS (DISPLAY NAME)", Icons.person_outline),
              _buildTextField(
                  passwordController, "PASSCODE", Icons.lock_outline,
                  isPassword: true),

              const SizedBox(height: 20),

              // Submit Button
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFFF0099).withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF0099),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3))
                      : Text(
                          _isLogin ? "INITIALIZE LOGIN" : "CREATE IDENTITY",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Toggle Button
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                    usernameController.clear();
                    passwordController.clear();
                  });
                },
                child: Text(
                  _isLogin
                      ? "NO ACCESS? CREATE IDENTITY"
                      : "HAVE CREDENTIALS? INITIALIZE LOGIN",
                  style: const TextStyle(
                      color: Color(0xFF00f0ff),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
