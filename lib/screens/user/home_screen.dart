import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/content.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // --- DATABASE STATE ---
  List<Content> _contents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContents();
  }

  // Fetches the master list from your API
  Future<void> _fetchContents() async {
    try {
      final data = await ApiService.getContents();
      if (mounted) {
        setState(() {
          _contents = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("🚨 Home Data Error: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper to handle TMDB URLs vs Local Server Paths
  String _getImageUrl(String path) {
    if (path.isEmpty) return "https://via.placeholder.com/150";
    if (path.startsWith('http')) return path;
    return "${ApiService.imageUrl}${path.trim()}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      // This makes the image go behind the top app bar for a cinematic look!
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // adds a slight dark gradient behind the app bar text
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),
        title: const Row(
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
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.cast, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00f0ff)))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- CINEMATIC HERO SECTION ---
                  Container(
                    height: 500, // Taller for a more premium feel
                    width: double.infinity,
                    decoration: const BoxDecoration(
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
                            const Color(0xFF050508), // Matches background perfectly
                            const Color(0xFF050508).withOpacity(0.5),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.3, 1.0], // Controls how the fade looks
                        ),
                      ),
                      padding: const EdgeInsets.all(20),
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top #1 Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF0099).withOpacity(0.2),
                              border: Border.all(color: const Color(0xFFFF0099)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "TOP #1 TODAY",
                              style: TextStyle(
                                color: Color(0xFFFF0099),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          const Text(
                            "CHAINSAW MAN",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Metadata Row
                          Row(
                            children: [
                              const Text(
                                "2022",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              _buildDot(),
                              const Text(
                                "ACTION / GORE",
                                style: TextStyle(
                                  color: Color(0xFF00f0ff),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              _buildDot(),
                              const Icon(Icons.star, color: Colors.amber, size: 14),
                              const Text(
                                " 9.8",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Glowing Play Button & Info Button
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFb026ff).withOpacity(0.4),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFb026ff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                                    label: const Text(
                                      "PLAY EPISODE 1",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      // Logic: Find Chainsaw Man in DB to pass correct data
                                      final chainsaw = _contents.firstWhere(
                                        (c) => c.title.toLowerCase().contains("chainsaw"),
                                        orElse: () => _contents.first,
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailScreen(content: chainsaw),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white.withOpacity(0.05),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // --- CONTINUE WATCHING SECTION ---
                  _buildSectionHeader("CONTINUE WATCHING", const Color(0xFF00f0ff)),
                  _buildContinueWatchingList(),

                  const SizedBox(height: 10),

                  // --- NEW ARRIVALS SECTION ---
                  _buildSectionHeader("NEW ARRIVALS", const Color(0xFFFF0099)),
                  _buildStandardList(const Color(0xFFFF0099)),

                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
    );
  }

  // Helper for metadata dots
  Widget _buildDot() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      height: 4,
      width: 4,
      decoration: const BoxDecoration(
        color: Colors.white24,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: borderColor, width: 3)),
            ),
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  // Specialized list for "Continue Watching" with Progress Bars
  Widget _buildContinueWatchingList() {
    // 1. Get Priority Items (Jujutsu & Demon Slayer)
    final priority = _contents.where((c) {
      final t = c.title.toLowerCase();
      return t.contains("jujutsu kaisen") || t.contains("demon slayer");
    }).toList();

    // 2. Get the rest
    final others = _contents.where((c) {
      final t = c.title.toLowerCase();
      return !t.contains("jujutsu kaisen") && !t.contains("demon slayer");
    }).toList();

    // 3. Combine: Priority + 2 from others
    final displayList = [...priority, ...others.take(2)];

    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          final content = displayList[index];
          double progress = 0.4 + (index * 0.15);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailScreen(content: content)),
              );
            },
            child: Container(
              width: 220,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF121216),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
                image: DecorationImage(
                  image: NetworkImage(_getImageUrl(content.thumbnailUrl)),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.play_circle_outline,
                      color: Colors.white70,
                      size: 50,
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Text(
                      content.title,
                      style: const TextStyle(
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
                                color: const Color(0xFF00f0ff).withOpacity(0.5),
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
            ),
          );
        },
      ),
    );
  }

  // Standard vertical poster list for New Arrivals
  Widget _buildStandardList(Color glowColor) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _contents.length,
        itemBuilder: (context, index) {
          final content = _contents[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailScreen(content: content)),
              );
            },
            child: Container(
              width: 130,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF121216),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white10),
                image: DecorationImage(
                  image: NetworkImage(_getImageUrl(content.thumbnailUrl)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.bottomLeft,
                child: Text(
                  content.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}