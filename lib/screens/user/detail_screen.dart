import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Color(0xFF050508),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title, style: TextStyle(color: Colors.white)),
              background: Image.network(coverUrl, fit: BoxFit.cover),
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFb026ff),
                          ),
                          icon: Icon(Icons.play_arrow, color: Colors.white),
                          label: Text(
                            "PLAY",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Color(0xFF00f0ff),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Synopsis goes here...",
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "EPISODES",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  leading: Container(
                    width: 80,
                    height: 50,
                    color: Colors.grey[800],
                    child: Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    "Episode ${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    "24 min",
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: Icon(Icons.download, color: Color(0xFF00f0ff)),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
