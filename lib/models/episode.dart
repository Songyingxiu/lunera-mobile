class Episode {
  final int id;
  final int contentId;
  final int episodeNo;
  final String title;
  final String thumbnail;
  final String videoUrl;
  final int duration;

  Episode({
    required this.id,
    required this.contentId,
    required this.episodeNo,
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
    required this.duration,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: int.parse(json['id_episode'].toString()),
      contentId: int.parse(json['id_content'].toString()),
      episodeNo: int.parse(json['episode_no'].toString()),
      title: json['title'] ?? '',
      thumbnail: json['episode_thumb'] ?? '',
      videoUrl: json['video_url'] ?? '',
      duration: int.parse(json['duration'].toString()),
    );
  }
}