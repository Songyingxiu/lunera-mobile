import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../models/content.dart';
import 'detail_screen.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  // 0 = Favorites, 1 = Downloads
  int _selectedTabIndex = 0;
  
  // --- DATABASE STATE ---
  List<Content> _favoriteContents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  // 🚀 Logic: Pull favorites from DB linked to the logged-in user
  Future<void> _fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id_user');
    
    if (userId != null) {
      try {
        final data = await ApiService.getFavorites(userId);
        if (mounted) {
          setState(() {
            _favoriteContents = data;
            _isLoading = false;
          });
        }
      } catch (e) {
        debugPrint("🚨 Fav Fetch Error: $e");
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Helper to handle image URLs
  String _getImageUrl(String path) {
    if (path.isEmpty) return "https://via.placeholder.com/150";
    if (path.startsWith('http')) return path;
    return "${ApiService.imageUrl}${path.trim()}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.sd_storage, color: Color(0xFF00f0ff)),
            SizedBox(width: 10),
            Text(
              "MY DATA CORE",
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CUSTOM NEON TAB BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _buildTab("FAVORITES", 0),
                const SizedBox(width: 30),
                _buildTab("DOWNLOADS", 1),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // --- GRID VIEW ---
          Expanded(
            child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF00f0ff)))
            : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 posters per row
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65, // Taller posters
                ),
                // Logic: Real count for Favorites, dummy 4 for downloads
                itemCount: _selectedTabIndex == 0 ? _favoriteContents.length : 4,
                itemBuilder: (context, index) {
                  return _buildGridItem(index);
                },
              ),
          ),
        ],
      ),
    );
  }

  // Custom Tab Builder for the Cyberpunk look (Preserved)
  Widget _buildTab(String title, int index) {
    bool isActive = _selectedTabIndex == index;
    Color activeColor = index == 0
        ? const Color(0xFF00f0ff)
        : const Color(0xFFFF0099); // Cyan for Favs, Pink for DLs

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? activeColor : Colors.grey[600],
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 14,
              shadows: isActive
                  ? [Shadow(color: activeColor, blurRadius: 10)]
                  : [],
            ),
          ),
          const SizedBox(height: 6),
          // Glowing underline for active tab
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 3,
            width: isActive ? 40 : 0,
            decoration: BoxDecoration(
              color: activeColor,
              boxShadow: [
                BoxShadow(
                  color: activeColor.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Realistic Poster Card (Preserved Styling, Updated Logic)
  Widget _buildGridItem(int index) {
    Color themeColor = _selectedTabIndex == 0
        ? const Color(0xFF00f0ff)
        : const Color(0xFFFF0099);

    String title;
    String imageUrl;
    VoidCallback? onTap;

    if (_selectedTabIndex == 0) {
      // 🚀 USE REAL DATA FROM DB
      final content = _favoriteContents[index];
      title = content.title;
      imageUrl = _getImageUrl(content.thumbnailUrl);
      onTap = () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(content: content)),
        );
      };
    } else {
      // KEEP DUMMY DATA FOR DOWNLOADS
      title = "Offline Vol.${index + 1}";
      imageUrl = 'https://picsum.photos/id/${400 + index}/200/300';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF121216),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: themeColor.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Dark gradient overlay to make text readable
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Bottom Title
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Top Right Action Icon
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _selectedTabIndex == 0 ? Icons.favorite : Icons.offline_pin,
                    color: themeColor,
                    size: 14,
                  ),
                ),
              ),

              // Size Indicator for Downloads only (Preserved)
              if (_selectedTabIndex == 1)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: themeColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      "340MB",
                      style: TextStyle(
                        color: themeColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}