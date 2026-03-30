import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _dataSaverEnabled = false;

  // Function to show the Red Warning Dialog
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF121216), // Dark background for dialog
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red, width: 2), // Red neon border
            borderRadius: BorderRadius.circular(8),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 10),
              Text(
                "CRITICAL WARNING",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to permanently delete your account? This action cannot be undone and all your data will be purged from the database.",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: Text("CANCEL", style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red background
                foregroundColor: Colors.white, // White text
              ),
              child: Text(
                "CONFIRM DELETE",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                // Here you would normally call your API to delete the user in CI4
                // await ApiService.deleteUser(id);

                Navigator.of(context).pop(); // Close dialog

                // Route the user all the way back to the Login Screen
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: Color(0xFF050508),
        title: Text(
          "SYSTEM SETTINGS",
          style: TextStyle(color: Colors.white, letterSpacing: 2),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color(0xFFb026ff).withOpacity(0.5),
            height: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader("PREFERENCES", Color(0xFF00f0ff)),
          _buildSwitchTile(
            "Push Notifications",
            Icons.notifications,
            _notificationsEnabled,
            (val) {
              setState(() => _notificationsEnabled = val);
            },
          ),
          _buildSwitchTile(
            "Data Saver Mode",
            Icons.data_usage,
            _dataSaverEnabled,
            (val) {
              setState(() => _dataSaverEnabled = val);
            },
          ),

          SizedBox(height: 20),
          _buildSectionHeader("ACCOUNT", Color(0xFF00f0ff)),
          _buildListTile("Change Language", Icons.language, "English"),
          _buildListTile("Clear Cache", Icons.cleaning_services, "124 MB"),

          SizedBox(height: 20),
          _buildSectionHeader("ABOUT", Color(0xFF00f0ff)),
          _buildListTile("Privacy Policy", Icons.privacy_tip, ""),
          _buildListTile("Terms of Service", Icons.description, ""),
          _buildListTile("App Version", Icons.info_outline, "v1.0.0 (Cyber)"),

          SizedBox(height: 40),

          // --- NEW DANGER ZONE SECTION ---
          _buildSectionHeader("DANGER ZONE", Colors.red),
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              "Permanently erase your data",
              style: TextStyle(color: Colors.redAccent.withOpacity(0.7)),
            ),
            onTap: _showDeleteConfirmation, // Triggers the popup
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Updated to accept a color parameter so the Danger Zone can be red
  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    IconData icon,
    bool currentValue,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.white70),
      title: Text(title, style: TextStyle(color: Colors.white)),
      value: currentValue,
      activeColor: Color(0xFFFF0099),
      inactiveTrackColor: Colors.white12,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile(String title, IconData icon, String trailingText) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: trailingText.isNotEmpty
          ? Text(trailingText, style: TextStyle(color: Colors.grey))
          : Icon(Icons.chevron_right, color: Colors.white24),
      onTap: () {
        // Action for the tile
      },
    );
  }
}
