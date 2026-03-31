import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController(
    text: "Kobo Kanaeru",
  );
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _saveProfile() async {
    setState(() => _isLoading = true);

    // Simulate an API call delay
    await Future.delayed(Duration(seconds: 2));

    // Here you would normally do an http.post or http.put to your CI4 backend
    // e.g., await ApiService.updateProfile(_usernameController.text, _passwordController.text);

    setState(() => _isLoading = false);

    // Show success message and go back
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 10),
            Text(
              "Identity updated successfully!",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Color(0xFFb026ff), // Purple success color
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.pop(context); // Go back to the Profile screen
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
              Shadow(color: Color(0xFF00f0ff).withOpacity(0.5), blurRadius: 10),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color(0xFF00f0ff).withOpacity(0.3),
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
                        color: Color(0xFF00f0ff).withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF121216),
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=11',
                    ),
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
                        color: Color(0xFFFF0099).withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      // Logic to pick image from gallery
                    },
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
                    color: Color(0xFF00f0ff).withOpacity(0.3),
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
                icon: _isLoading
                    ? SizedBox.shrink()
                    : Icon(Icons.save, size: 22),
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
