import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      // This makes the image go behind the top app bar for a cinematic look!
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Optional: adds a slight dark gradient behind the app bar text so it's readable on light images
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.bedtime, color: Color(0xFF00f0ff)),
            SizedBox(width: 8),
            Text(
              "LUNERA",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.cast, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CINEMATIC HERO SECTION ---
            Container(
              height: 500, // Taller for a more premium feel
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://wallpapers-clan.com/wp-content/uploads/2024/08/chainsaw-man-denji-devil-gif-desktop-wallpaper-preview.gif',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF050508), // Matches background perfectly
                      Color(0xFF050508).withOpacity(0.5),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.3, 1.0], // Controls how the fade looks
                  ),
                ),
                padding: EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top #1 Badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF0099).withOpacity(0.2),
                        border: Border.all(color: Color(0xFFFF0099)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "TOP #1 TODAY",
                        style: TextStyle(
                          color: Color(0xFFFF0099),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    Text(
                      "CHAINSAW MAN",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Metadata Row
                    Row(
                      children: [
                        Text(
                          "2022",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                        _buildDot(),
                        Text(
                          "ACTION / GORE",
                          style: TextStyle(
                            color: Colors.cyan[400],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _buildDot(),
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(
                          " 9.8",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Glowing Play Button & Info Button
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFb026ff).withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFb026ff),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(Icons.play_arrow, color: Colors.white),
                              label: Text(
                                "PLAY EPISODE 1",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      contentId: 1,
                                      title: "Chainsaw Man",
                                      coverUrl:
                                          'https://wallpapers-clan.com/wp-content/uploads/2024/08/chainsaw-man-denji-devil-gif-desktop-wallpaper-preview.gif',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // --- CONTINUE WATCHING SECTION ---
            _buildSectionHeader("CONTINUE WATCHING", Color(0xFF00f0ff)),
            _buildContinueWatchingList(),

            SizedBox(height: 10),

            // --- NEW ARRIVALS SECTION ---
            _buildSectionHeader("NEW ARRIVALS", Color(0xFFFF0099)),
            _buildStandardList(Color(0xFFFF0099)),

            SizedBox(height: 40), // Bottom padding
          ],
        ),
      ),
    );
  }

  // Helper for metadata dots
  Widget _buildDot() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 4,
      width: 4,
      decoration: BoxDecoration(
        color: Colors.grey[600],
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color borderColor) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: borderColor, width: 3)),
            ),
            padding: EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  // Specialized list for "Continue Watching" with Progress Bars
  Widget _buildContinueWatchingList() {
    return SizedBox(
      height: 160, // Slightly shorter and wider for episode thumbs
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        itemBuilder: (context, index) {
          // Dummy data calculation for progress
          double progress = 0.3 + (index * 0.2);

          return Container(
            width: 220, // Wider aspect ratio (16:9 feel)
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Color(0xFF121216),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
              image: DecorationImage(
                image: NetworkImage(
                  'https://picsum.photos/id/${200 + index}/400/200',
                ), // Random placeholder images
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.4),
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
                  child: Text(
                    "EP ${index + 4}: The Awakening",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Neon Progress Bar
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
                          color: Color(0xFF00f0ff), // Cyan progress
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF00f0ff).withOpacity(0.5),
                              blurRadius: 4,
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
        },
      ),
    );
  }

  // Standard vertical poster list
  Widget _buildStandardList(Color glowColor) {
    return SizedBox(
      height: 200, // Taller for movie posters (2:3 ratio)
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            width: 130,
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Color(0xFF121216),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
              image: DecorationImage(
                image: NetworkImage(
                  'https://picsum.photos/id/${100 + index}/200/300',
                ), // Random placeholder images
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              // Gradient to make the title readable
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                ),
              ),
              padding: EdgeInsets.all(8),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Series Title ${index + 1}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        },
      ),
    );
  }
}
