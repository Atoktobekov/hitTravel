import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        controller.setLooping(true); // loop video
      });

    // listener for progress bar
    controller.addListener(() {
      if (mounted) setState(() {});
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
        // pause on long press
        onLongPressStart: (_) => controller.pause(),
        onLongPressEnd: (_) => controller.play(),
        // close on tap
        onTapUp: (_) => Navigator.pop(context),
        child: Stack(
          children: [
            // full screen video
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            ),

            // control panel on top
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 1. progress bar
                    _buildProgressBar(),
                    SizedBox(height: 12.h),
                    // 2. close button
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _buildProgressBar() {
    // count percentage of progress
    final double progress = controller.value.duration.inMilliseconds > 0
        ? controller.value.position.inMilliseconds /
        controller.value.duration.inMilliseconds
        : 0.0;

    return Container(
      height: 3.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}