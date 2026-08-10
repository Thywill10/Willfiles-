import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath;

  const VideoPlayerScreen({
    super.key,
    required this.videoPath,
  });

  @override
  State<VideoPlayerScreen> createState() =>
      _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? controller;

  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  Future<void> initializeVideo() async {
    try {
      final file = File(widget.videoPath);

      if (!await file.exists()) {
        throw Exception("Video file does not exist.");
      }

      await controller?.dispose();
      controller = null;

      final newController = VideoPlayerController.file(file);

      controller = newController;

      await newController.initialize();

      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = null;
      });

      await newController.play();
    } catch (e) {
      if (!mounted) return;

      await controller?.dispose();
      controller = null;

      setState(() {
        loading = false;
        errorMessage = "Unable to play this video.";
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoController = controller;

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          widget.videoPath.split('/').last,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      body: Center(
        child: loading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : errorMessage != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 60,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loading = true;
                            errorMessage = null;
                          });

                          initializeVideo();
                        },
                        child: const Text("Try Again"),
                      ),
                    ],
                  )
                : videoController != null &&
                        videoController.value.isInitialized
                    ? AspectRatio(
                        aspectRatio:
                            videoController.value.aspectRatio,
                        child: VideoPlayer(videoController),
                      )
                    : const SizedBox.shrink(),
      ),

      floatingActionButton:
          !loading &&
                  errorMessage == null &&
                  videoController != null &&
                  videoController.value.isInitialized
              ? FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    setState(() {
                      if (videoController.value.isPlaying) {
                        videoController.pause();
                      } else {
                        videoController.play();
                      }
                    });
                  },
                  child: Icon(
                    videoController.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                )
              : null,
    );
  }
}