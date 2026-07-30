import 'dart:io';

import 'package:flutter/material.dart';

import '../services/file_service.dart';

import 'folder_screen.dart';
import 'image_viewer_screen.dart';
import 'music_player_screen.dart';
import 'pdf_viewer_screen.dart';
import 'video_player_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FileService _fileService = FileService();

List<String> favoriteFiles = [];

bool loading = true;
@override
void initState() {
  super.initState();
  loadFavorites();
}

Future<void> loadFavorites() async {
  favoriteFiles =
      await _fileService.getFavorites();

  if (mounted) {
    setState(() {
      loading = false;
    });
  }
}

  Future<void> removeFavorite(int index) async {
  await _fileService.removeFromFavorites(
    favoriteFiles[index],
  );

  await loadFavorites();

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Removed from Favorites"),
    ),
  );
}

bool isImage(String path) {
  final name = path.toLowerCase();

  return name.endsWith(".jpg") ||
      name.endsWith(".jpeg") ||
      name.endsWith(".png") ||
      name.endsWith(".gif") ||
      name.endsWith(".webp");
}

bool isPdf(String path) {
  return path.toLowerCase().endsWith(".pdf");
}

bool isVideo(String path) {
  final name = path.toLowerCase();

  return name.endsWith(".mp4") ||
      name.endsWith(".mkv") ||
      name.endsWith(".avi") ||
      name.endsWith(".mov") ||
      name.endsWith(".3gp");
}

bool isMusic(String path) {
  final name = path.toLowerCase();

  return name.endsWith(".mp3") ||
      name.endsWith(".wav") ||
      name.endsWith(".aac") ||
      name.endsWith(".m4a") ||
      name.endsWith(".ogg");
}

IconData getIcon(String path) {
  if (FileSystemEntity.typeSync(path) ==
    FileSystemEntityType.directory) {
  return Icons.folder;
}

  if (isImage(path)) {
    return Icons.image;
  }

  if (isPdf(path)) {
    return Icons.picture_as_pdf;
  }

  if (isVideo(path)) {
    return Icons.video_library;
  }

  if (isMusic(path)) {
    return Icons.music_note;
  }

  return Icons.insert_drive_file;
}

void openFile(String path) {
  final entity = FileSystemEntity.typeSync(path) ==
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
        title: const Text("Favorites"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: loading
    ? const Center(
        child: CircularProgressIndicator(),
      )

    : favoriteFiles.isEmpty
        ? const Center(
          
              child: Text(
                "No favorite files yet.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )

          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteFiles.length,
              itemBuilder: (context, index) {
                final path = favoriteFiles[index];

//final file = FileSystemEntity.typeSync(path) ==
       // FileSystemEntityType.directory
   // ? Directory(path)
   // : File(path);

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: ListTile(
                    leading: CircleAvatar(
  backgroundColor:
      Colors.green.withValues(alpha: 0.15),
  child: Icon(
    getIcon(path),
    color: Colors.green,
  ),
),

                    title: Text(
  path.split("/").last,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(path),

onTap: () {
  openFile(path);
},

                    trailing: PopupMenuButton(
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: "remove",
                          child: Text("Remove Favorite"),
                        ),
                      ],

                      onSelected: (value) async {
                        if (value == "remove") {
                          await removeFavorite(index);
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
