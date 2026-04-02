import 'dart:convert'; // 🚀 ADDED: Required to read the saved history
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
  
  // 🚀 ADDED: List to store your real history data
  List<Map<String, dynamic>> _historyItems = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('id_user');

    // 🚀 ADDED: Fetch the locally saved history
    List<String> historyStrings = prefs.getStringList('watch_history') ?? [];
    setState(() {
      _historyItems = historyStrings
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });

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
          // 🚀 SYNC THE LIVE AVATAR TO DEVICE MEMORY SO THE EDIT SCREEN CAN SEE IT!
          await prefs.setString('avatar', _avatar);
        }
      } catch (e) {
        print("🚨 API FAILED: $e"); // Prints the exact error to your terminal
        setState(() {
          _username = prefs.getString('username') ?? "UNKNOWN_USER";
          _role = prefs.getString('role')?.toUpperCase() ?? "STANDARD";
          _userId = userId.toString();
          _avatar = prefs.getString('avatar') ?? ""; // 🚀 NOW IT REMEMBERS THE IMAGE!
        });
      }
    }
  }

  // 🚀 ADDED: Helper to handle both external and internal images
  String _getImageUrl(String path) {
    if (path.startsWith('http')) return path;
    return "${ApiService.imageUrl}$path";
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
      backgroundColor: const Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050508),
        elevation: 0,
        title: const Text(
          "USER IDENTITY",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 4,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                  color: Color(0xFF00f0ff),
                  blurRadius: 10),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF00f0ff)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00f0ff).withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
              color: const Color(0xFF00f0ff).withOpacity(0.3),
            ),
            height: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00f0ff),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00f0ff).withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Container(
                          width: 100, // 2 * radius (50)
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFF121216),
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: _avatar.isNotEmpty
                              ? Image.network(
                                  // 🚀 .trim() destroys invisible spaces!
                                  "${ApiService.imageUrl}${_avatar.trim()}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // 🚀 This prints a clickable link in your terminal!
                                    print(
                                        "👉 FLUTTER URL: ${ApiService.imageUrl}${_avatar.trim()}");
                                    print("🚨 PROFILE IMAGE ERROR: $error");
                                    return const Center(
                                        child: Icon(Icons.broken_image,
                                            color: Colors.redAccent, size: 40));
                                  },
                                )
                              : const Center(
                                  child: Icon(
                                    Icons.person_outline, // Built-in default user icon
                                    color: Color(
                                        0xFF00f0ff), // Matches your neon cyan
                                    size: 50,
                                  ),
                                ),
                        ),
                      ),
                      // Online Status Indicator
                      Container(
                        height: 20,
                        width: 20,
                        margin: const EdgeInsets.only(bottom: 4, right: 4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF050508),
                            width: 4,
                          ),
                          boxShadow: [
                            const BoxShadow(color: Colors.greenAccent, blurRadius: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _username.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 3,
                      shadows: [
                        Shadow(color: Color(0xFFb026ff), blurRadius: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "ID: #$_userId-SYS  |  Access: $_role",
                    style: const TextStyle(
                      color: Color(0xFF00f0ff),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Glowing Edit Button
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFb026ff).withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF121216),
                        side: const BorderSide(color: Color(0xFFb026ff)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFFb026ff),
                        size: 18,
                      ),
                      label: const Text(
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
                            builder: (context) => const EditProfileScreen(),
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

            const SizedBox(height: 40),

            // --- 2. HUD STATS DASHBOARD ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  "LEVEL",
                  "42",
                  Icons.military_tech,
                  const Color(0xFFFF0099),
                ),
                _buildStatCard(
                  "UPTIME",
                  "14h",
                  Icons.timer_outlined,
                  const Color(0xFF00f0ff),
                ),
                _buildStatCard(
                  "SECURE",
                  "MAX",
                  Icons.shield_outlined,
                  Colors.greenAccent,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- 3. RECENT HISTORY SECTION ---
            _buildSectionHeader("RECENT ACTIVITY", const Color(0xFF00f0ff)),
            const SizedBox(height: 16),
            
            // 🚀 MODIFIED: This now shows your REAL history items
            _historyItems.isEmpty 
              ? const Center(child: Text("NO RECENT LOGS", style: TextStyle(color: Colors.white24)))
              : SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _historyItems.length,
                    itemBuilder: (context, index) {
                      return _buildHistoryCard(_historyItems[index], index);
                    },
                  ),
                ),

            const SizedBox(height: 50),

            // --- 4. DANGEROUS SYSTEM DISCONNECT ---
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF121216),
                  side: const BorderSide(color: Colors.redAccent, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.power_settings_new, color: Colors.redAccent),
                label: const Text(
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

            const SizedBox(height: 20), // Bottom Padding
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS (STAYING EXACTLY THE SAME) ---

  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          color: color,
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: [
              Shadow(color: color.withOpacity(0.5), blurRadius: 10)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF121216),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
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

  // 🚀 MODIFIED: History card now accepts real DATA
  Widget _buildHistoryCard(Map<String, dynamic> data, int index) {
    double progress = 0.4 + (index * 0.15); 

    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF121216),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
        image: DecorationImage(
          // 🚀 USES REAL THUMBNAIL FROM SAVED DATA
          image: NetworkImage(_getImageUrl(data['image'] ?? "")),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white.withOpacity(0.8),
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
                  data['title'] ?? "Decrypted File", // 🚀 USES REAL TITLE
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "Log Timestamp: ${data['timestamp'].toString().substring(11, 19)}",
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
              decoration: const BoxDecoration(
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
                    color: const Color(0xFF00f0ff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00f0ff).withOpacity(0.8),
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