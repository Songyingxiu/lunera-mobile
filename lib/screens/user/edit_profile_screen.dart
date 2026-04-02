import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String _currentAvatar = ""; // 🚀 Added to store the database image

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _usernameController.text = prefs.getString('username') ?? '';
      _currentAvatar =
          prefs.getString('avatar') ?? ''; // 🚀 Load existing image
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('id_user');

      if (userId != null) {
        final response = await ApiService.updateProfile(
          userId,
          _usernameController.text,
          _passwordController.text,
          _selectedImage,
        );

        if (!mounted) return;

        if (response['status'] == 200) {
          await prefs.setString('username', _usernameController.text);
          // 🚀 Save image filename to memory so the app doesn't forget it!
          if (response['user'] != null && response['user']['avatar'] != null) {
            await prefs.setString('avatar', response['user']['avatar']);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    response['message'] ?? "Updated successfully",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Color(0xFFb026ff),
              behavior: SnackBarBehavior.floating,
            ),
          );

          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response['message']}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connection Error")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: Color(0xFF050508),
        elevation: 0,
        title: Text(
          "EDIT IDENTITY",
          style: TextStyle(
            color: Color(0xFF00f0ff),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: [
              Shadow(
                  color: Color(0xFF00f0ff).withValues(alpha: 0.5),
                  blurRadius: 10),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color(0xFF00f0ff).withValues(alpha: 0.3),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- GLOWING AVATAR SECTION ---
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF00f0ff), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00f0ff).withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 120, // 2 * radius (60)
                    height: 120,
                    decoration: const BoxDecoration(
                      color: Color(0xFF121216),
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : (_currentAvatar.isNotEmpty
                            ? Image.network(
                                // 🚀 .trim() destroys invisible spaces!
                                "${ApiService.imageUrl}${_currentAvatar.trim()}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print(
                                      "👉 FLUTTER URL: ${ApiService.imageUrl}${_currentAvatar.trim()}");
                                  print("🚨 EDIT IMAGE ERROR: $error");
                                  return const Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.redAccent, size: 40));
                                },
                              )
                            : const Center(
                                child: Icon(
                                  Icons
                                      .person_outline, // Built-in default user icon
                                  color: Color(
                                      0xFF00f0ff), // Matches your neon cyan
                                  size: 50,
                                ),
                              )),
                  ),
                ),
                // Glowing Camera Icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF0099),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF050508), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF0099).withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: _pickImage,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 50),

            // --- SYSTEM LABEL ---
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "USER CREDENTIALS",
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            SizedBox(height: 16),

            // --- FORM FIELDS ---
            _buildTextField(
              label: "NEW IDENTITY CODE",
              controller: _usernameController,
              isPassword: false,
              icon: Icons.badge_outlined,
              glowColor: Color(0xFF00f0ff),
            ),
            SizedBox(height: 20),

            _buildTextField(
              label: "NEW PASSCODE",
              controller: _passwordController,
              isPassword: true,
              icon: Icons.lock_outline,
              glowColor: Color(0xFFb026ff),
            ),

            SizedBox(height: 50),

            // --- GLOWING SAVE BUTTON ---
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF00f0ff).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00f0ff), // Cyan button
                  foregroundColor: Colors.black, // Black text for contrast
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon:
                    _isLoading ? SizedBox.shrink() : Icon(Icons.save, size: 22),
                label: _isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        "SAVE CHANGES",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 16,
                        ),
                      ),
                onPressed: _isLoading ? null : _saveProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom TextField Builder with Icon support
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isPassword,
    required IconData icon,
    required Color glowColor,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: glowColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: glowColor, width: 2),
        ),
        filled: true,
        fillColor: Color(0xFF121216),
      ),
    );
  }
}
