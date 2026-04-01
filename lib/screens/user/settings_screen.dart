import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _dataSaverEnabled = false;

  // --- UPGRADED CYBERPUNK WARNING DIALOG ---
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      barrierColor:
          Colors.black.withValues(alpha: 0.8), // Darkens background heavily
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFF0a0000), // Very dark red background
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                ),
                SizedBox(height: 20),

                // Title
                Text(
                  "SYSTEM OVERRIDE",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    shadows: [Shadow(color: Colors.red, blurRadius: 10)],
                  ),
                ),
                SizedBox(height: 12),

                // Warning Text
                Text(
                  "Are you absolutely sure you want to purge your identity? This action will permanently erase all data, favorites, and history from the mainframe. This cannot be undone.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 30),

                // Action Buttons
                Column(
                  children: [
                    // Safe Action (Abort)
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Color(0xFF00f0ff),
                          ), // Cyan safe border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "ABORT SEQUENCE",
                          style: TextStyle(
                            color: Color(0xFF00f0ff),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Danger Action (Delete)
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withValues(
                            alpha: 0.2,
                          ),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                        child: Text(
                          "INITIATE PURGE",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          navigator.pop(); // Close dialog immediately

                          try {
                            final prefs = await SharedPreferences.getInstance();
                            int? userId = prefs.getInt('id_user');

                            if (userId != null) {
                              await ApiService.deleteAccount(userId);
                            }

                            await prefs.clear();

                            if (mounted) {
                              navigator.pushNamedAndRemoveUntil(
                                '/',
                                (Route<dynamic> route) => false,
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Failed to delete account")));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        elevation: 0,
        title: Text(
          "SYSTEM SETTINGS",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: Color(0xFFb026ff), blurRadius: 10),
            ], // Purple text glow
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            color: Color(0xFFb026ff).withValues(alpha: 0.5),
            height: 1.0,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        children: [
          _buildSectionHeader("PREFERENCES", Color(0xFF00f0ff)),
          _buildSettingsGroup([
            _buildSwitchTile(
              "Push Notifications",
              Icons.notifications_active_outlined,
              _notificationsEnabled,
              (val) {
                setState(() => _notificationsEnabled = val);
              },
            ),
            _buildDivider(),
            _buildSwitchTile(
              "Data Saver Mode",
              Icons.data_usage_outlined,
              _dataSaverEnabled,
              (val) {
                setState(() => _dataSaverEnabled = val);
              },
            ),
          ]),

          SizedBox(height: 24),

          _buildSectionHeader("ACCOUNT", Color(0xFFb026ff)),
          _buildSettingsGroup([
            _buildListTile("Change Language", Icons.language, "English"),
            _buildDivider(),
            _buildListTile(
              "Clear Cache",
              Icons.cleaning_services_outlined,
              "124 MB",
            ),
          ]),

          SizedBox(height: 24),

          _buildSectionHeader("ABOUT", Color(0xFF00f0ff)),
          _buildSettingsGroup([
            _buildListTile("Privacy Policy", Icons.privacy_tip_outlined, ""),
            _buildDivider(),
            _buildListTile("Terms of Service", Icons.description_outlined, ""),
            _buildDivider(),
            _buildListTile("App Version", Icons.info_outline, "v1.0.0 (Cyber)"),
          ]),

          SizedBox(height: 40),

          // --- DANGER ZONE SECTION ---
          _buildSectionHeader("DANGER ZONE", Colors.redAccent),
          Container(
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_forever, color: Colors.redAccent),
              ),
              title: Text(
                "Delete Account",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                "Permanently erase your identity",
                style: TextStyle(
                  color: Colors.redAccent.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.redAccent),
              onTap: _showDeleteConfirmation, // Triggers the popup
            ),
          ),

          SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- HELPER WIDGETS ---

  // Wraps a list of settings in a high-tech border box
  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF121216),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: children),
    );
  }

  // Subtle divider line between grouped items
  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withValues(alpha: 0.05),
      indent: 50,
      endIndent: 16,
    );
  }

  // Glowing left-border section header
  Widget _buildSectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            color: color,
            margin: EdgeInsets.only(right: 8),
          ),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 12,
            ),
          ),
        ],
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
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
      value: currentValue,
      activeThumbColor: Color(0xFFFF0099),
      inactiveThumbColor: Colors.grey,
      inactiveTrackColor: Colors.white12,
      onChanged: onChanged,
    );
  }

  Widget _buildListTile(String title, IconData icon, String trailingText) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 14)),
      trailing: trailingText.isNotEmpty
          ? Text(
              trailingText,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          : Icon(Icons.chevron_right, color: Colors.white24, size: 20),
      onTap: () {},
    );
  }
}
