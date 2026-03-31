import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final int contentId;
  final String title;
  final String coverUrl;

  const DetailScreen({
    super.key,
    required this.contentId,
    required this.title,
    required this.coverUrl,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false; // Toggles the neon heart icon

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      body: CustomScrollView(
        slivers: [
          // --- CINEMATIC HEADER ---
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Color(0xFF050508),
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 10),
                  ], // Makes text readable
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(widget.coverUrl, fit: BoxFit.cover),
                  // Gradient to fade the image into the dark background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(
                            0.5,
                          ), // Darkens top for back button
                          Colors.transparent,
                          Color(0xFF050508), // Fades perfectly into background
                        ],
                        stops: [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- CONTENT DETAILS ---
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- METADATA TAGS ---
                    Row(
                      children: [
                        _buildTag("2026", Color(0xFF00f0ff)),
                        SizedBox(width: 10),
                        _buildTag("18+", Colors.redAccent),
                        SizedBox(width: 10),
                        _buildTag("12 EPISODES", Color(0xFFb026ff)),
                      ],
                    ),
                    SizedBox(height: 24),

                    // --- ACTION BUTTONS ROW ---
                    Row(
                      children: [
                        // Glowing Play Button
                        Expanded(
                          child: Container(
                            height: 55,
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 28,
                              ),
                              label: Text(
                                "PLAY SEQUENCE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        SizedBox(width: 16),

                        // Toggleable Favorite Button
                        _buildIconButton(
                          icon: _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isFavorite
                              ? Color(0xFFFF0099)
                              : Color(0xFF00f0ff),
                          onTap: () {
                            setState(() {
                              _isFavorite = !_isFavorite;
                            });
                          },
                        ),
                        SizedBox(width: 12),

                        // Share Button
                        _buildIconButton(
                          icon: Icons.share_outlined,
                          color: Colors.white70,
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: 32),

                    // --- SYNOPSIS ---
                    Text(
                      "SYNOPSIS",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "In a dystopian future where artificial intelligence controls the neon-lit streets, a rogue hacker discovers a hidden code that could rewrite reality itself. Hunted by the megacorporations, they must form unexpected alliances to survive.",
                      style: TextStyle(
                        color: Colors.white70,
                        height: 1.6,
                        fontSize: 14,
                      ),
                    ),

                    SizedBox(height: 32),

                    // --- EPISODES HEADER ---
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Color(0xFF00f0ff), width: 3),
                        ),
                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "EPISODES",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),

              // --- EPISODES LIST ---
              ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF121216),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8),
                      // Styled Episode Thumbnail
                      leading: Container(
                        width: 100,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            // Placeholder images that change per episode
                            image: NetworkImage(
                              'https://picsum.photos/id/${150 + index}/200/100',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white.withOpacity(0.8),
                            size: 30,
                          ),
                        ),
                      ),
                      title: Text(
                        "Episode ${index + 1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "24m • System Logs",
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.file_download_outlined,
                          color: Color(0xFF00f0ff),
                        ),
                        onPressed: () {
                          // Download action
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 40), // Bottom padding
            ]),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Metadata Tags
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // Helper Widget for Circular Action Buttons
  Widget _buildIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
