class StoryItem {
  final String thumbnailUrl;
  final String videoUrl;
  bool isViewed;

  StoryItem({
    required this.thumbnailUrl,
    required this.videoUrl,
    this.isViewed = false,
  });
}