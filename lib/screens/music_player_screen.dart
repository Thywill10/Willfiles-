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

  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initializeAudio();
  }

  Future<void> initializeAudio() async {
    try {
      await player.setFilePath(widget.audioPath);

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage = "Unable to play this audio file.";
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> togglePlay() async {
    if (loading || errorMessage != null) return;

    try {
      if (player.playing) {
        await player.pause();
      } else {
        await player.play();
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = "Unable to play this audio file.";
      });
    }
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

          child: errorMessage != null
              ? Text(
                  errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.red,
                  ),
                )
              : loading
                  ? const CircularProgressIndicator(
                      color: Colors.green,
                    )
                  : Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
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

                        StreamBuilder<PlayerState>(
                          stream: player.playerStateStream,
                          builder: (context, snapshot) {
                            final playing =
                                snapshot.data?.playing ??
                                    player.playing;

                            return ElevatedButton.icon(
                              onPressed: togglePlay,
                              icon: Icon(
                                playing
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              label: Text(
                                playing
                                    ? "Pause"
                                    : "Play",
                              ),
                            );
                          },
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}