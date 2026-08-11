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
      setState(() {
        loading = true;
        errorMessage = null;
      });

      final file = File(widget.videoPath);

      if (!await file.exists()) {
        throw Exception("Video file does not exist.");
      }

      await controller?.dispose();

      final newController = VideoPlayerController.file(file);

      controller = newController;

      await newController.initialize();

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      await newController.play();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      await controller?.dispose();
      controller = null;

      if (!mounted) return;

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

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    final seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return "$minutes:$seconds";
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

      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Column(
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
                        onPressed: initializeVideo,
                        child: const Text("Try Again"),
                      ),
                    ],
                  ),
                )
              : videoController != null &&
                      videoController.value.isInitialized
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio:
                              videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        ),

                        const SizedBox(height: 15),

                        VideoProgressIndicator(
                          videoController,
                          allowScrubbing: true,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable:
                                    videoController,
                                builder:
                                    (context, value, child) {
                                  return Text(
                                    formatDuration(
                                      value.position,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              ValueListenableBuilder(
                                valueListenable:
                                    videoController,
                                builder:
                                    (context, value, child) {
                                  return Text(
                                    formatDuration(
                                      value.duration,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "Video could not be loaded.",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

      floatingActionButton:
          !loading &&
                  errorMessage == null &&
                  videoController != null &&
                  videoController.value.isInitialized
              ? ValueListenableBuilder(
                  valueListenable: videoController,
                  builder: (context, value, child) {
                    return FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        if (value.isPlaying) {
                          await videoController.pause();
                        } else {
                          await videoController.play();
                        }

                        if (mounted) {
                          setState(() {});
                        }
                      },
                      child: Icon(
                        value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    );
                  },
                )
              : null,
    );
  }
}