class Content {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String type;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.type,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: int.parse(
        json['id_content'].toString(),
      ), // Make sure this matches your CI4 table column name
      title: json['title'] ?? 'Unknown Title',
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      type: json['type'] ?? 'series',
    );
  }
}
