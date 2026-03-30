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
        content: Text(
          "Identity updated successfully!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFb026ff), // Purple success color
      ),
    );
    Navigator.pop(context); // Go back to the Profile screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "EDIT IDENTITY",
          style: TextStyle(color: Color(0xFF00f0ff), letterSpacing: 2),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar Edit Section
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Color(0xFFb026ff),
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=11',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFF0099),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    onPressed: () {
                      // Logic to pick image from gallery
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Form Fields
            _buildTextField(
              "NEW IDENTITY CODE (USERNAME)",
              _usernameController,
              false,
            ),
            SizedBox(height: 20),
            _buildTextField("NEW PASSCODE", _passwordController, true),

            SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00f0ff), // Cyan button
                  foregroundColor: Colors.black, // Black text for contrast
                ),
                icon: _isLoading ? SizedBox.shrink() : Icon(Icons.save),
                label: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.black),
                      )
                    : Text(
                        "SAVE CHANGES",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
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

  // Custom TextField Builder
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isPassword,
  ) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF00f0ff)), // Cyan focus
        ),
        filled: true,
        fillColor: Color(0xFF121216),
      ),
    );
  }
}
