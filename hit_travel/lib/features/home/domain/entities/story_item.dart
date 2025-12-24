class StoryItem {
  final String avatarUrl;
  final String videoUrl;
  bool isViewed;

  StoryItem({
    required this.avatarUrl,
    required this.videoUrl,
    this.isViewed = false,
  });
}