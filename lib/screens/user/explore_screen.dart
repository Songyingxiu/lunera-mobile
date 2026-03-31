import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // Hardcoded category data to make the grid look beautiful and populated
  final List<Map<String, dynamic>> _categories = [
    {'title': 'CYBERPUNK', 'icon': Icons.memory, 'color': Color(0xFFb026ff)},
    {
      'title': 'SCI-FI',
      'icon': Icons.rocket_launch,
      'color': Color(0xFF00f0ff),
    },
    {'title': 'MECHA', 'icon': Icons.smart_toy, 'color': Color(0xFFFF0099)},
    {
      'title': 'ACTION',
      'icon': Icons.local_fire_department,
      'color': Color(0xFFff3366),
    },
    {
      'title': 'FANTASY',
      'icon': Icons.auto_awesome,
      'color': Color(0xFF00ffcc),
    },
    {'title': 'THRILLER', 'icon': Icons.visibility, 'color': Color(0xFFFF2222)},
  ];

  // Dummy tags for the trending section
  final List<String> _trendingTags = [
    '#dystopian',
    '#ai_rebellion',
    '#space_opera',
    '#time_travel',
    '#post_apocalyptic',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: Color(0xFF050508),
        elevation: 0,
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search database...",
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(Icons.search, color: Color(0xFF00f0ff)),
            suffixIcon: Icon(
              Icons.tune,
              color: Color(0xFFFF0099),
            ), // Filter icon
            filled: true,
            fillColor: Color(0xFF121216),
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF00f0ff), width: 1.5),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16),
        children: [
          // --- TRENDING TAGS SECTION ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "TRENDING PROTOCOLS",
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 35,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _trendingTags.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(
                      0xFF00f0ff,
                    ).withOpacity(0.1), // Faint cyan background
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Color(0xFF00f0ff).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _trendingTags[index],
                    style: TextStyle(
                      color: Color(0xFF00f0ff),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 30),

          // --- CATEGORIES GRID ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.folder_special, color: Color(0xFFFF0099), size: 20),
                SizedBox(width: 8),
                Text(
                  "MASTER CATEGORIES",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics:
                NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio:
                  1.6, // Makes the cards wider, like cinematic tiles
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF121216), // Dark gray top-left
                      category['color'].withOpacity(
                        0.2,
                      ), // Themed color bottom-right
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: category['color'].withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: category['color'].withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Faded background Icon
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(
                        category['icon'],
                        size: 80,
                        color: category['color'].withOpacity(0.1),
                      ),
                    ),
                    // Foreground Text
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            category['title'],
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Container(
                            height: 2,
                            width: 20,
                            color: category['color'],
                            margin: EdgeInsets.only(top: 4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
