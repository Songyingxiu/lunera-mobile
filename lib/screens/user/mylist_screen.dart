import 'package:flutter/material.dart';

class MyListScreen extends StatefulWidget {
  const MyListScreen({super.key});

  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  // 0 = Favorites, 1 = Downloads
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _buildTab("FAVORITES", 0),
                SizedBox(width: 30),
                _buildTab("DOWNLOADS", 1),
              ],
            ),
          ),

          SizedBox(height: 10),

          // --- GRID VIEW ---
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 posters per row
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65, // Taller posters
              ),
              // Dummy logic: Show 9 favorites, but only 4 downloads
              itemCount: _selectedTabIndex == 0 ? 9 : 4,
              itemBuilder: (context, index) {
                return _buildGridItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Custom Tab Builder for the Cyberpunk look
  Widget _buildTab(String title, int index) {
    bool isActive = _selectedTabIndex == index;
    Color activeColor = index == 0
        ? Color(0xFF00f0ff)
        : Color(0xFFFF0099); // Cyan for Favs, Pink for DLs

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
          SizedBox(height: 6),
          // Glowing underline for active tab
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
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

  // Realistic Poster Card
  Widget _buildGridItem(int index) {
    Color themeColor = _selectedTabIndex == 0
        ? Color(0xFF00f0ff)
        : Color(0xFFFF0099);

    // Different placeholder images for Favorites vs Downloads to look dynamic
    int imageOffset = _selectedTabIndex == 0 ? 300 : 400;

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF121216),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: themeColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/id/${imageOffset + index}/200/300',
          ),
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
                _selectedTabIndex == 0
                    ? "Saved File ${index + 1}"
                    : "Offline Vol.${index + 1}",
                style: TextStyle(
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
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
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

            // Size Indicator for Downloads only
            if (_selectedTabIndex == 1)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
    );
  }
}
