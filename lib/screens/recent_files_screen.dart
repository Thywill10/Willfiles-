import 'dart:io';

import 'package:flutter/material.dart';

import '../services/file_service.dart';
import 'folder_screen.dart';
import 'image_viewer_screen.dart';
import 'music_player_screen.dart';
import 'pdf_viewer_screen.dart';
import 'video_player_screen.dart';

class RecentFilesScreen extends StatefulWidget {
  const RecentFilesScreen({super.key});

  @override
  State<RecentFilesScreen> createState() =>
      _RecentFilesScreenState();
}

class _RecentFilesScreenState
    extends State<RecentFilesScreen> {
  final FileService _fileService = FileService();

  List<String> recentFiles = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRecent();
  }

  Future<void> loadRecent() async {
    recentFiles =
        await _fileService.getRecentFiles();

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> removeRecent(int index) async {
    await _fileService.removeRecent(
      recentFiles[index],
    );

    await loadRecent();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Removed from Recent"),
      ),
    );
  }

  Future<void> clearRecent() async {
    await _fileService.clearRecent();

    await loadRecent();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Recent Files Cleared"),
      ),
    );
  }

  bool isImage(String path) =>
      path.toLowerCase().endsWith(".jpg") ||
      path.toLowerCase().endsWith(".jpeg") ||
      path.toLowerCase().endsWith(".png") ||
      path.toLowerCase().endsWith(".gif") ||
      path.toLowerCase().endsWith(".webp");

  bool isPdf(String path) =>
      path.toLowerCase().endsWith(".pdf");

  bool isVideo(String path) =>
      path.toLowerCase().endsWith(".mp4") ||
      path.toLowerCase().endsWith(".mkv") ||
      path.toLowerCase().endsWith(".avi") ||
      path.toLowerCase().endsWith(".mov") ||
      path.toLowerCase().endsWith(".3gp");

  bool isMusic(String path) =>
      path.toLowerCase().endsWith(".mp3") ||
      path.toLowerCase().endsWith(".wav") ||
      path.toLowerCase().endsWith(".aac") ||
      path.toLowerCase().endsWith(".m4a") ||
      path.toLowerCase().endsWith(".ogg");

  IconData getIcon(String path) {
    if (FileSystemEntity.typeSync(path) ==
        FileSystemEntityType.directory) {
      return Icons.folder;
    }

    if (isImage(path)) return Icons.image;
    if (isPdf(path)) return Icons.picture_as_pdf;
    if (isVideo(path)) return Icons.video_library;
    if (isMusic(path)) return Icons.music_note;

    return Icons.insert_drive_file;
  }

  void openFile(String path) {
    final entity =
        FileSystemEntity.typeSync(path) ==
                FileSystemEntityType.directory
            ? Directory(path)
            : File(path);

    if (entity is Directory) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FolderScreen(path: path),
        ),
      );
    } else if (isImage(path)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ImageViewerScreen(imagePath: path),
        ),
      );
    } else if (isPdf(path)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              PdfViewerScreen(pdfPath: path),
        ),
      );
    } else if (isVideo(path)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              VideoPlayerScreen(videoPath: path),
        ),
      );
    } else if (isMusic(path)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MusicPlayerScreen(audioPath: path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),

      appBar: AppBar(
        title: const Text("Recent Files"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: clearRecent,
          ),
        ],
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : recentFiles.isEmpty
              ? const Center(
                  child: Text(
                    "No Recent Files",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.all(16),
                  itemCount:
                      recentFiles.length,
                  itemBuilder:
                      (context, index) {
                    final path =
                        recentFiles[index];

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          getIcon(path),
                          color:
                              Colors.green,
                        ),
                        title: Text(
                          path
                              .split("/")
                              .last,
                        ),
                        subtitle:
                            Text(path),
                        onTap: () {
                          openFile(path);
                        },
                        trailing:
                            PopupMenuButton(
                          itemBuilder:
                              (context) =>
                                  const [
                            PopupMenuItem(
                              value:
                                  "remove",
                              child: Text(
                                  "Remove"),
                            ),
                          ],
                          onSelected:
                              (value) async {
                            if (value ==
                                "remove") {
                              await removeRecent(
                                  index);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}