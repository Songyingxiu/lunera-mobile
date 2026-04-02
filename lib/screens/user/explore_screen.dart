import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/content.dart';
import 'detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // --- STATE VARIABLES ---
  List<dynamic> _categories = [];
  bool _isLoadingCategories = true;

  final TextEditingController _searchController = TextEditingController();
  List<Content> _searchResults = [];
  bool _isSearching = false;
  bool _isLoadingSearch = false;

  final List<String> _trendingTags = [
    '#dystopian',
    '#ai_rebellion',
    '#space_opera',
    '#time_travel',
    '#post_apocalyptic',
  ];

  // Cyberpunk Colors to dynamically assign to database categories
  final List<Color> _neonColors = [
    const Color(0xFFb026ff),
    const Color(0xFF00f0ff),
    const Color(0xFFFF0099),
    const Color(0xFFff3366),
    const Color(0xFF00ffcc),
    const Color(0xFFFF2222),
  ];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // --- FETCH CATEGORIES FROM DB ---
  Future<void> _fetchCategories() async {
    try {
      final categories = await ApiService.getCategories();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      print("🚨 Category Load Error: $e");
      if (mounted) setState(() => _isLoadingCategories = false);
    }
  }

  // --- EXECUTE SEARCH ---
  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _isLoadingSearch = true;
    });

    try {
      final results = await ApiService.searchContents(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isLoadingSearch = false;
        });
      }
    } catch (e) {
      print("🚨 Search Error: $e");
      if (mounted) setState(() => _isLoadingSearch = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: const Color(0xFF050508),
        elevation: 0,
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {}); // Force rebuild to show/hide the X button
            if (value.isEmpty) _onSearch(""); // Reset when cleared
          },
          onSubmitted: _onSearch, // Triggers search on Enter
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Search database...",
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF00f0ff)),
            // Swap filter icon for an 'X' button if typing
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFFFF0099)),
                    onPressed: () {
                      _searchController.clear();
                      _onSearch("");
                    },
                  )
                : const Icon(Icons.tune, color: Color(0xFFFF0099)),
            filled: true,
            fillColor: const Color(0xFF121216),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF00f0ff), width: 1.5),
            ),
          ),
        ),
      ),
      // Switch body based on whether a search is active!
      body: _isSearching ? _buildSearchResults() : _buildExploreView(),
    );
  }

  // --- UI: SEARCH RESULTS ---
  Widget _buildSearchResults() {
    if (_isLoadingSearch) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF00f0ff)));
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.white24, size: 64),
            SizedBox(height: 16),
            Text(
              "NO DATA MATCHES QUERY.",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final content = _searchResults[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF121216),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFF00f0ff).withValues(alpha: 0.3)),
                image: content.thumbnailUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(
                            "${ApiService.imageUrl}${content.thumbnailUrl}"),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: content.thumbnailUrl.isEmpty
                  ? const Icon(Icons.movie, color: Color(0xFF00f0ff), size: 24)
                  : null,
            ),
            title: Text(
              content.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              content.type.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF00f0ff),
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Color(0xFF00f0ff)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    contentId: content.id, // Passes the ID
                    title: content.title, // Passes the title
                    coverUrl: content.thumbnailUrl.isNotEmpty
                        ? "${ApiService.imageUrl}${content.thumbnailUrl}"
                        : "https://wallpapers-clan.com/wp-content/uploads/2024/08/chainsaw-man-denji-devil-gif-desktop-wallpaper-preview.gif", // Fallback if no image
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // --- UI: NORMAL EXPLORE VIEW ---
  Widget _buildExploreView() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
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
        const SizedBox(height: 12),
        SizedBox(
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _trendingTags.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF00f0ff).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF00f0ff).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _trendingTags[index],
                  style: const TextStyle(
                    color: Color(0xFF00f0ff),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
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
        const SizedBox(height: 16),

        // --- DYNAMIC DATABASE CATEGORIES ---
        _isLoadingCategories
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF0099)))
            : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.6,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  // Read name from DB, fallback to 'UNKNOWN'
                  final String catName = (category['category_name'] ??
                          category['name'] ??
                          'UNKNOWN')
                      .toString()
                      .toUpperCase();
                  // Assign a cycling neon color
                  final Color catColor =
                      _neonColors[index % _neonColors.length];

                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF121216),
                          catColor.withValues(alpha: 0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: catColor.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: catColor.withValues(alpha: 0.05),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            Icons.folder_special,
                            size: 80,
                            color: catColor.withValues(alpha: 0.1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                catName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                height: 2,
                                width: 20,
                                color: catColor,
                                margin: const EdgeInsets.only(top: 4),
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
    );
  }
}
