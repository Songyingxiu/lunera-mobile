import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/content.dart';
import '../../models/episode.dart';
import '../../services/api_service.dart';
import 'watch_screen.dart';

class DetailScreen extends StatefulWidget {
  final Content content;

  const DetailScreen({
    super.key,
    required this.content,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorite = false;
  List<Episode> _episodes = [];
  bool _isLoadingEpisodes = true;

  @override
  void initState() {
    super.initState();
    // 🚀 BOOT SYSTEM
    _addToRecentActivity(); // Log to local history
    _checkInitialFavoriteStatus(); // Check heart status from DB
    _fetchEpisodes(); // Pull real episodes from DB
  }

  // --- 1. EPISODE LOGIC (Pulls JJK, Oshi no Ko, etc. from DB) ---
  Future<void> _fetchEpisodes() async {
    try {
      final data = await ApiService.getEpisodes(widget.content.id);
      if (mounted) {
        setState(() {
          _episodes = data;
          _isLoadingEpisodes = false;
        });
      }
    } catch (e) {
      debugPrint("🚨 Episode Fetch Error: $e");
      if (mounted) setState(() => _isLoadingEpisodes = false);
    }
  }

  // --- 2. FAVORITE LOGIC (DB SYNC) ---
  Future<void> _checkInitialFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id_user');
    if (userId != null) {
      try {
        final favorites = await ApiService.getFavorites(userId);
        if (mounted) {
          setState(() {
            _isFavorite = favorites.any((item) => item.id == widget.content.id);
          });
        }
      } catch (e) {
        debugPrint("🚨 Fav Status Check Error: $e");
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id_user');

    if (userId != null) {
      try {
        final response =
            await ApiService.toggleFavorite(userId, widget.content.id);

        if (!mounted) return; // 🚀 Safety check added here!

        if (response['status'] == 200) {
          setState(() {
            _isFavorite = response['is_favorite'];
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'],
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              backgroundColor: _isFavorite
                  ? const Color(0xFFFF0099)
                  : const Color(0xFF121216),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      } catch (e) {
        debugPrint("🚨 Toggle Favorite Error: $e");
      }
    }
  }

  // --- 3. RECENT ACTIVITY LOGIC ---
  Future<void> _addToRecentActivity() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> history = prefs.getStringList('watch_history') ?? [];

      Map<String, dynamic> entry = {
        'id': widget.content.id,
        'title': widget.content.title,
        'image': widget.content.thumbnailUrl,
        'timestamp': DateTime.now().toString(),
      };

      history
          .removeWhere((item) => jsonDecode(item)['id'] == widget.content.id);
      history.insert(0, jsonEncode(entry));
      if (history.length > 10) history = history.sublist(0, 10);
      await prefs.setStringList('watch_history', history);
    } catch (e) {
      debugPrint("🚨 History Save Error: $e");
    }
  }

  // 🚀 RESTORED MISSING FUNCTION
  String _getImageUrl(String path) {
    if (path.isEmpty) return "https://via.placeholder.com/500";
    if (path.startsWith('http')) return path;
    return "${ApiService.imageUrl}${path.trim()}";
  }

  String _getVideoUrl(dynamic path) {
    // 1. If the database returned literally nothing, play the test video
    if (path == null)
      return "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";

    // 2. Convert it to a safe string
    String safePath = path.toString().trim();

    // 3. If the string is empty, play the test video
    if (safePath.isEmpty)
      return "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";

    // 4. If it's a real cloud link, use it!
    if (safePath.startsWith('http')) return safePath;

    // 5. Fallback just in case
    return "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: CustomScrollView(
        slivers: [
          // --- CINEMATIC HEADER ---
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: const Color(0xFF050508),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.content.title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(_getImageUrl(widget.content.coverUrl),
                      fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          const Color(0xFF050508)
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- METADATA TAGS ---
                    Row(
                      children: [
                        _buildTag(widget.content.releaseYear.toString(),
                            const Color(0xFF00f0ff)),
                        const SizedBox(width: 10),
                        _buildTag(widget.content.type.toUpperCase(),
                            const Color(0xFFb026ff)),
                        const SizedBox(width: 10),
                        _buildTag("⭐ ${widget.content.rating}", Colors.amber),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // --- ACTION BUTTONS ---
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFFb026ff)
                                        .withValues(alpha: 0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5))
                              ],
                            ),
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFb026ff),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white, size: 28),
                              label: const Text("PLAY SEQUENCE",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5)),
                              onPressed: () {
                                // 1. IF IT'S A SERIES: Play Episode 1
                                if (_episodes.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WatchScreen(
                                        title:
                                            "EP ${_episodes[0].episodeNo}: ${_episodes[0].title.toUpperCase()}",
                                        videoUrl: _getVideoUrl(
                                            _episodes[0].videoUrl ?? ""),
                                      ),
                                    ),
                                  );
                                }
                                // 2. IF IT'S A MOVIE: Play the Movie directly from the Content Model!
                                else if (widget.content.videoUrl.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WatchScreen(
                                        title:
                                            widget.content.title.toUpperCase(),
                                        videoUrl: _getVideoUrl(
                                            widget.content.videoUrl),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildIconButton(
                          icon: _isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _isFavorite
                              ? const Color(0xFFFF0099)
                              : const Color(0xFF00f0ff),
                          onTap: _toggleFavorite,
                        ),
                        const SizedBox(width: 12),
                        _buildIconButton(
                          icon: Icons.share_outlined,
                          color: Colors.white70,
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    const Text("SYNOPSIS",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2)),
                    const SizedBox(height: 8),
                    Text(widget.content.description,
                        style: const TextStyle(
                            color: Colors.white70, height: 1.6, fontSize: 14)),

                    // 🚀 Only show the EPISODES header if the type is NOT 'movie'
                    if (widget.content.type.toLowerCase() != 'movie') ...[
                      const SizedBox(height: 32),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: Color(0xFF00f0ff), width: 3))),
                        padding: const EdgeInsets.only(left: 10),
                        child: const Text("EPISODES",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5)),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),

              // --- DYNAMIC EPISODES ---
              // 🚀 If it's a movie, completely delete the loading ring, coming soon, and list UI
              if (widget.content.type.trim().toLowerCase() != 'movie')
                _isLoadingEpisodes
                    ? const Center(
                        child: Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator(
                                color: Color(0xFF00f0ff))))
                    : _episodes.isEmpty
                        ? _buildComingSoon()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _episodes.length,
                            itemBuilder: (context, index) {
                              final ep = _episodes[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF121216),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WatchScreen(
                                          title:
                                              "EP ${ep.episodeNo}: ${ep.title.toUpperCase()}",
                                          videoUrl: _getVideoUrl(ep.videoUrl),
                                        ),
                                      ),
                                    );
                                  },
                                  contentPadding: const EdgeInsets.all(8),
                                  leading: Container(
                                    width: 120,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image: NetworkImage(ep.thumbnail),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.play_circle_fill,
                                            color: Colors.white70, size: 30)),
                                  ),
                                  title: Text(
                                    "EP. ${ep.episodeNo}: ${ep.title}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                      "${ep.duration}m • High Fidelity Stream",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 11)),
                                  trailing: const Icon(
                                      Icons.file_download_outlined,
                                      color: Color(0xFF00f0ff)),
                                ),
                              );
                            },
                          ),
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoon() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(Icons.hourglass_empty,
              color: Colors.white.withValues(alpha: 0.1), size: 50),
          const SizedBox(height: 10),
          const Text("DATA_CORE_EMPTY: COMING SOON",
              style: TextStyle(
                  color: Colors.white12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(4)),
      child: Text(text,
          style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1)),
    );
  }

  Widget _buildIconButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.1),
            border: Border.all(color: color.withValues(alpha: 0.5))),
        child: Icon(icon, color: color),
      ),
    );
  }
}
