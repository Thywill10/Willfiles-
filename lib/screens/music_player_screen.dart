

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String audioPath;

  const MusicPlayerScreen({
    super.key,
    required this.audioPath,
  });

  @override
  State<MusicPlayerScreen> createState() =>
      _MusicPlayerScreenState();
}

class _MusicPlayerScreenState
    extends State<MusicPlayerScreen> {
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.setFilePath(widget.audioPath).then((_) {
  if (!mounted) return;

  setState(() {});
});
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.audioPath.split("/").last;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(
                Icons.music_note,
                size: 120,
                color: Colors.green,
              ),

              const SizedBox(height: 30),

              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () async {
                  if (player.playing) {
                    await player.pause();
                  } else {
                    await player.play();
                  }

                  setState(() {});
                },
                icon: Icon(
                  player.playing
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                label: Text(
                  player.playing
                      ? "Pause"
                      : "Play",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
