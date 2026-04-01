import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import 'edit_profile_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = "LOADING...";
  String _role = "LOADING";
  String _userId = "0000";
  String _avatar = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('id_user');

    if (userId != null) {
      try {
        final response = await ApiService.getUserProfile(userId);
        if (response['status'] == 200) {
          setState(() {
            _username = response['data']['user']['username'];
            _role = response['data']['user']['role'].toString().toUpperCase();
            _userId = userId.toString();
            _avatar = response['data']['user']['avatar'] ?? "";
          });
        }
      } catch (e) {
        setState(() {
          _username = prefs.getString('username') ?? "UNKNOWN_USER";
          _role = prefs.getString('role')?.toUpperCase() ?? "STANDARD";
          _userId = userId.toString();
        });
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/');
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
          "USER IDENTITY",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                  color: Color(0xFF00f0ff).withValues(alpha: 0.5),
                  blurRadius: 10),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Color(0xFF00f0ff)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF00f0ff).withValues(alpha: 0.5),
                  blurRadius: 10,
                ),
              ],
              color: Color(0xFF00f0ff).withValues(alpha: 0.3),
            ),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. HOLOGRAPHIC AVATAR & INFO ---
            Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF00f0ff),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF00f0ff).withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFF121216),
                          backgroundImage: _avatar.isNotEmpty
                              ? NetworkImage("${ApiService.imageUrl}$_avatar")
                              : NetworkImage('https://i.pravatar.cc/150?img=11')
                                  as ImageProvider,
                        ),
                      ),
                      // Online Status Indicator
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(bottom: 4, right: 4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF050508),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.greenAccent, blurRadius: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    _username.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(color: Color(0xFFb026ff), blurRadius: 10),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "ID: #$_userId-SYS  |  Access: $_role",
                    style: TextStyle(
                      color: Color(0xFF00f0ff),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Glowing Edit Button
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFb026ff).withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF121216),
                        side: BorderSide(color: Color(0xFFb026ff)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFb026ff),
                        size: 18,
                      ),
                      label: Text(
                        "EDIT IDENTITY",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(),
                          ),
                        );
                        if (result == true) {
                          _loadUserData();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // --- 2. HUD STATS DASHBOARD ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  "LEVEL",
                  "42",
                  Icons.military_tech,
                  Color(0xFFFF0099),
                ),
                _buildStatCard(
                  "UPTIME",
                  "14h",
                  Icons.timer_outlined,
                  Color(0xFF00f0ff),
                ),
                _buildStatCard(
                  "SECURE",
                  "MAX",
                  Icons.shield_outlined,
                  Colors.greenAccent,
                ),
              ],
            ),

            SizedBox(height: 40),

            // --- 3. RECENT HISTORY SECTION ---
            _buildSectionHeader("RECENT ACTIVITY", Color(0xFF00f0ff)),
            SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildHistoryCard(index);
                },
              ),
            ),

            SizedBox(height: 50),

            // --- 4. DANGEROUS SYSTEM DISCONNECT ---
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF121216),
                  side: BorderSide(color: Colors.redAccent, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Icon(Icons.power_settings_new, color: Colors.redAccent),
                label: Text(
                  "SYSTEM DISCONNECT",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                onPressed: _logout,
              ),
            ),

            SizedBox(height: 20), // Bottom Padding
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  // Glowing Section Header
  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          color: color,
          margin: EdgeInsets.only(right: 8),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: [
              Shadow(color: color.withValues(alpha: 0.5), blurRadius: 10)
            ],
          ),
        ),
      ],
    );
  }

  // Mini HUD Stat Cards
  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFF121216),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // High-Tech History Cards with Progress Bars
  Widget _buildHistoryCard(int index) {
    double progress = 0.4 + (index * 0.15); // Fake progress

    return Container(
      width: 240,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Color(0xFF121216),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/id/${250 + index}/400/200',
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white.withValues(alpha: 0.8),
              size: 50,
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Decrypted File 0${index + 1}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Log Timestamp: 0${index + 1}:45:00",
                  style: TextStyle(color: Colors.grey[400], fontSize: 10),
                ),
              ],
            ),
          ),
          // Neon Cyan Progress Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: Colors.white12,
              ),
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: progress > 1.0 ? 1.0 : progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF00f0ff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00f0ff).withValues(alpha: 0.8),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
