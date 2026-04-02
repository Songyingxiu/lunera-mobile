class Content {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String coverUrl;    // 🚀 Added
  final int releaseYear;    // 🚀 Added
  final String type;
  final double rating;      // 🚀 Added

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.coverUrl,
    required this.releaseYear,
    required this.type,
    required this.rating,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      // Maps to 'id_content' in your CI4 database
      id: int.parse(json['id_content'].toString()), 
      
      title: json['title'] ?? 'Unknown Title',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      
      // 🚀 Maps to 'cover_url' in your database
      coverUrl: json['cover_url'] ?? '', 
      
      // 🚀 Maps to 'release_year' - defaulting to 2026 if empty
      releaseYear: int.parse((json['release_year'] ?? 2026).toString()), 
      
      type: json['type'] ?? 'series',
      
      // 🚀 Maps to 'rating' - handles double/int conversion
      rating: double.parse((json['rating'] ?? 0.0).toString()), 
    );
  }
}