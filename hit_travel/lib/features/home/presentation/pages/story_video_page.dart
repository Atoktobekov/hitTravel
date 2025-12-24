import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StoryVideoPage extends StatefulWidget {
  final String videoUrl;

  const StoryVideoPage({super.key, required this.videoUrl});

  @override
  State<StoryVideoPage> createState() => _StoryVideoPageState();
}

class _StoryVideoPageState extends State<StoryVideoPage> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        controller.play();
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: controller.value.isInitialized
          ? GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}