class RecoveryVideo {
  final String id;
  final String title;
  final String url;
  final String? thumbnailUrl;
  final List<String> recommendations;

  RecoveryVideo({
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
    required this.recommendations,
  });
}
