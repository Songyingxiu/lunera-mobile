import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'explore_screen.dart';
import 'mylist_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Removed the extra placeholder so it perfectly matches the 4 Nav Bar items!
  final List<Widget> _screens = [
    HomeScreen(),
    ExploreScreen(),
    MyListScreen(),
    ProfileScreen(),
  ];

  // Helper method to create glowing active icons
  Widget _buildActiveIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00f0ff).withOpacity(0.5), // Cyan neon glow
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: Color(0xFF00f0ff), size: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF08080c),
          boxShadow: [
            BoxShadow(
              color: Color(
                0xFF00f0ff,
              ).withOpacity(0.1), // Subtle ambient glow upwards
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Color(0xFF00f0ff).withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor:
              Colors.transparent, // Let the Container handle the color
          elevation: 0, // Removes default shadow to use our custom glow
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: Color(0xFF00f0ff),
          unselectedItemColor: Colors.white38, // Dimmed unselected items
          showUnselectedLabels: false, // Hides inactive text for a cleaner look
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 12,
          ),
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: _buildActiveIcon(Icons.home),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: _buildActiveIcon(Icons.explore),
              label: "EXPLORE",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: _buildActiveIcon(Icons.bookmark),
              label: "MY LIST",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: _buildActiveIcon(Icons.person),
              label: "PROFILE",
            ),
          ],
        ),
      ),
    );
  }
}
