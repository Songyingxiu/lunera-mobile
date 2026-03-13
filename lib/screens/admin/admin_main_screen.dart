import 'package:flutter/material.dart';
import 'admin_home_screen.dart';
import 'add_content_screen.dart';
import 'manage_users_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  // The actual screens replacing the text placeholders
  final List<Widget> _adminScreens = [
    AdminHomeScreen(),
    AddContentScreen(),
    ManageUsersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      appBar: AppBar(
        title: Text(
          "LUNERA [ADMIN]",
          style: TextStyle(
            color: Color(0xFFFF0099),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false, // Hides the default back button
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              // Routes the user back to the login screen
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: _adminScreens[_currentIndex], // Displays the selected screen
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xFFFF0099).withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF1a0033), // Dark purple admin theme
          selectedItemColor: Color(0xFFFF0099), // Neon pink for selection
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Updates the UI when a tab is tapped
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.library_add),
              label: "Add Content",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: "Users"),
          ],
        ),
      ),
    );
  }
}
