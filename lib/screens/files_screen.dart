import 'dart:io';

import 'package:flutter/material.dart';

import 'package:open_filex/open_filex.dart';

import '../services/file_service.dart';

import '../widgets/long_press_menu.dart';

import 'package:permission_handler/permission_handler.dart';

import 'favorites_screen.dart';
import 'folder_screen.dart';
import 'image_viewer_screen.dart';
import 'music_player_screen.dart';
import 'pdf_viewer_screen.dart';
import 'recent_files_screen.dart';
import 'recycle_bin_screen.dart';
import 'settings_screen.dart';
import 'storage_analyzer_screen.dart';
import 'video_player_screen.dart';

class FilesScreen extends StatefulWidget {
  final String? initialPath;

  const FilesScreen({
    super.key,
    this.initialPath,
  });

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  final FileService _fileService = FileService();

  List<FileSystemEntity> files = [];
  List<FileSystemEntity> filteredFiles = [];
  List<FileSystemEntity> selectedFiles = [];

  bool loading = true;
  bool selectionMode = false;
  bool sortAscending = true;
  FileSystemEntity? clipboardFile;
  bool isCutOperation = false;

  final TextEditingController searchController =
      TextEditingController();

  @override
void initState() {
  super.initState();
  requestPermissionAndLoad();
}

Future<void> requestPermissionAndLoad() async {
  if (await Permission.manageExternalStorage.isGranted) {
    await loadFiles();
    return;
  }

  if (await Permission.manageExternalStorage.request().isGranted) {
    await loadFiles();
  } else {
    await openAppSettings();

    if (await Permission.manageExternalStorage.isGranted) {
      await loadFiles();
    }
  }
}

  
  Future<void> loadFiles() async {
  await _fileService.createRecycleBinFolder();

  final path = widget.initialPath ?? "/storage/emulated/0";

  files = await _fileService.getFiles(path);

  filterFiles();

  if (mounted) {
    setState(() {
      loading = false;
    });
  }
}

void filterFiles() {
  final query = searchController.text.toLowerCase();

  filteredFiles = files.where((file) {
    return file.path
        .split("/")
        .last
        .toLowerCase()
        .contains(query);
  }).toList();

  filteredFiles.sort((a, b) {
    if (sortAscending) {
      return a.path
          .toLowerCase()
          .compareTo(b.path.toLowerCase());
    } else {
      return b.path
          .toLowerCase()
          .compareTo(a.path.toLowerCase());
    }
  });

  if (mounted) {
    setState(() {});
  }
}

void toggleSelection(FileSystemEntity file) {
  setState(() {
    if (selectedFiles.contains(file)) {
      selectedFiles.remove(file);
    } else {
      selectedFiles.add(file);
    }

    selectionMode = selectedFiles.isNotEmpty;
  });
}

void clearSelection() {
  setState(() {
    selectedFiles.clear();
    selectionMode = false;
  });
}

Future<void> createFolderDialog() async {
  final controller = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Create Folder"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "Folder name",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final folderName = controller.text.trim();

            if (folderName.isEmpty) return;

            await _fileService.createFolder(
              "/storage/emulated/0",
              folderName,
            );

            if (!mounted) return;

            Navigator.pop(context);

            loadFiles();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Folder created successfully",
                ),
              ),
            );
          },
          child: const Text("Create"),
        ),
      ],
    ),
  );
}

Future<void> renameDialog(FileSystemEntity file) async {
  final controller = TextEditingController(
    text: file.path.split("/").last,
  );

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Rename File"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "Enter new name",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final newName = controller.text.trim();

            if (newName.isEmpty) return;

            final success = await _fileService.renameFile(
              file.path,
              newName,
            );

            if (!mounted) return;

            Navigator.pop(context);

            if (success) {
              loadFiles();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("File renamed successfully"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Rename failed"),
                ),
              );
            }
          },
          child: const Text("Rename"),
        ),
      ],
    ),
  );
}

void copyDialog(FileSystemEntity file) {
  setState(() {
    clipboardFile = file;
    isCutOperation = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Copied ${file.path.split('/').last}. Navigate to a folder and press Paste.",
      ),
    ),
  );
}

void cutDialog(FileSystemEntity file) {
  setState(() {
    clipboardFile = file;
    isCutOperation = true;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "Cut ${file.path.split('/').last}. Navigate to a folder and press Paste.",
      ),
    ),
  );
}

Future<void> moveDialog(FileSystemEntity file) async {
  final controller = TextEditingController(
    text: "/storage/emulated/0",
  );

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Move File"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "Destination folder",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            final success =
                await _fileService.moveFile(
              file.path,
              controller.text.trim(),
            );

            if (!mounted) return;

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? "File moved successfully"
                      : "Move failed",
                ),
              ),
            );

            if (success) {
              loadFiles();
            }
          },
          child: const Text("Move"),
        ),
      ],
    ),
  );
}

Future<void> showProperties(FileSystemEntity file) async {
  final stat = await file.stat();

  final size = stat.size;
  final modified = stat.modified;

  if (!mounted) return;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Properties"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Name: ${file.path.split('/').last}"),
          const SizedBox(height: 8),
          Text("Path: ${file.path}"),
          const SizedBox(height: 8),
          Text("Size: $size bytes"),
          const SizedBox(height: 8),
          Text("Modified: $modified"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

IconData getIcon(FileSystemEntity entity) {
  if (entity is Directory) {
    return Icons.folder;
  }

  final name = entity.path.toLowerCase();

  if (isImage(name)) {
    return Icons.image;
  }

  if (isVideo(name)) {
    return Icons.video_library;
  }

  if (isMusic(name)) {
    return Icons.music_note;
  }

  if (isPdf(name)) {
    return Icons.picture_as_pdf;
  }

  if (name.endsWith(".apk")) {
    return Icons.android;
  }

  return Icons.insert_drive_file;
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
      name.endsWith(".3gp") ||
      name.endsWith(".m4v") ||
      name.endsWith(".webm") ||
      name.endsWith(".flv");
}

bool isMusic(String path) {
  final name = path.toLowerCase();

  return name.endsWith(".mp3") ||
      name.endsWith(".wav") ||
      name.endsWith(".aac") ||
      name.endsWith(".m4a") ||
      name.endsWith(".ogg");
}

 /// Opens the restricted Android/data folder using the modern SAF engine
  Future<void> _openAndroidDataDirectory() async {
    // This is the official system path signature link for the Android/data folder
    final Uri dataFolderUri = Uri.parse(
      "content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fdata"
    );

    // 1. Check if the user already clicked "Use this folder" in the past
    final bool? isAlreadyGranted = await open_filex_or_saf_check.isDocumentUri(dataFolderUri);

    if (isAlreadyGranted != true) {
      // 2. If not granted, force open the Android system's native permission panel
      await open_filex_or_saf_check.openDocumentTree(initialUri: dataFolderUri);
    } else {
      // 3. If already granted, you can safely fetch the hidden data folders
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Access to Android/data is already authorized.")),
      );
    }
  }

 Future<void> _handleFileTap(FileSystemEntity entity) async {
    if (entity is Directory) {
      // INTERCEPT ROUTE: Detect if the user is trying to tap into the restricted data folder
      if (entity.path.endsWith("Android/data")) {
        await _openAndroidDataDirectory();
        return;
      }

      // Normal navigation for all standard folders remains unchanged
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilesScreen(initialPath: entity.path),
        ),
      );
      return;
    }

  final String path = entity.path;
  final String extension = path.split('.').last.toLowerCase();

  // Videos
  if (extension == 'mp4' ||
      extension == 'mkv' ||
      extension == 'avi' ||
      extension == 'mov' ||
      extension == '3gp' ||
      extension == 'm4v' ||
      extension == 'webm' ||
      extension == 'flv') {
    final result = await OpenFilex.open(path);

    if (!mounted) return;

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not open video: ${result.message}",
          ),
        ),
      );
    }
    return;
  }

  // Music
  if (extension == 'mp3' ||
      extension == 'wav' ||
      extension == 'aac' ||
      extension == 'm4a' ||
      extension == 'ogg') {
    final result = await OpenFilex.open(path);

    if (!mounted) return;

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Could not open music: ${result.message}",
          ),
        ),
      );
    }
    return;
  }

  // Images
  if (extension == 'jpg' ||
      extension == 'jpeg' ||
      extension == 'png' ||
      extension == 'gif' ||
      extension == 'webp') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageViewerScreen(
          imagePath: path,
        ),
      ),
    );
    return;
  }

  // PDF
  if (extension == 'pdf') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerScreen(
          pdfPath: path,
        ),
      ),
    );
    return;
  }

  // Everything else → Android system opener
  final result = await OpenFilex.open(path);

  if (!mounted) return;

  if (result.type != ResultType.done) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Could not open file: ${result.message}",
        ),
      ),
    );
  }
}

@override
void dispose() {
  searchController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF6FFF6),

       appBar: AppBar(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        selectionMode
            ? "${selectedFiles.length} Selected"
            : "Files",
      ),
      actions: [
        if (clipboardFile != null && !selectionMode)
          IconButton(
            icon: const Icon(
              Icons.assignment_turned_in,
              color: Colors.white,
            ),
            tooltip: "Paste Here",
            onPressed: () async {
              final currentDir = widget.initialPath ?? "/storage/emulated/0";
              final source = clipboardFile!;
              final wasCut = isCutOperation;

              // CRITICAL FIX: Extract the filename and combine it with the folder path
              final String fileName = source.path.split('/').last;
              final String exactDestinationPath = "$currentDir/$fileName";

              bool success;

              if (wasCut) {
                // Fixed: Pass the exact target file path instead of just a folder
                success = await _fileService.cutFile(
                  source.path,
                  exactDestinationPath,
                );
              } else {
                // Fixed: Pass the exact target file path instead of just a folder
                success = await _fileService.copyFile(
                  source.path,
                  exactDestinationPath,
                );
              }

              if (!mounted) return;

              if (success) {
                setState(() {
                  clipboardFile = null;
                  isCutOperation = false;
                });

                await loadFiles();

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      wasCut
                          ? "File moved successfully."
                          : "File copied successfully.",
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Paste failed. The file may already exist or storage access is denied.",
                    ),
                  ),
                );
              }
            },
          ),
        if (!selectionMode)
          IconButton(
            icon: Icon(
              sortAscending
                  ? Icons.sort_by_alpha
                  : Icons.sort,
            ),
            onPressed: () {
              setState(() {
                sortAscending = !sortAscending;
                filterFiles();
              });
            },
          ),
      ], // Closes actions list safely
    ); // Closes AppBar wrapper cleanly

        if (!selectionMode)

          PopupMenuButton<String>(
            onSelected: (value) {

              switch (value) {

                case "favorites":
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const FavoritesScreen(),
                    ),
                  );
                  break;

                case "recent":
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RecentFilesScreen(),
                    ),
                  );
                  break;

                case "storage":
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const StorageAnalyzerScreen(),
                    ),
                  );
                  break;

                case "recycle":
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const RecycleBinScreen(),
                    ),
                  );
                  break;

                case "settings":
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const SettingsScreen(),
                    ),
                  );
                  break;
              }
            },

            itemBuilder: (context) => const [

              PopupMenuItem(
                value: "favorites",
                child: Text("Favorites"),
              ),

              PopupMenuItem(
                value: "recent",
                child: Text("Recent Files"),
              ),

              PopupMenuItem(
                value: "storage",
                child: Text("Storage Analyzer"),
              ),

              PopupMenuItem(
                value: "recycle",
                child: Text("Recycle Bin"),
              ),

              PopupMenuItem(
                value: "settings",
                child: Text("Settings"),
              ),
            ],
          ),

        if (selectionMode)

          IconButton(
            icon: const Icon(Icons.close),
            onPressed: clearSelection,
          ),
      ],
    ),

    floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.green,
      onPressed: createFolderDialog,
      child: const Icon(Icons.create_new_folder),
    ),

    body: loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) {
                    filterFiles();
                  },
                  decoration: InputDecoration(
                    hintText: "Search files...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredFiles.length,
                  itemBuilder: (context, index) {

                    final file = filteredFiles[index];
                    final selected =
                        selectedFiles.contains(file);

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: selected
                          ? Colors.green.withValues(alpha: 0.15)
                          : null,
                      child: ListTile(
                        leading: Icon(
                          getIcon(file),
                          color: Colors.green,
                        ),

                        title: Text(
                          file.path.split("/").last,
                        ),

                        subtitle: Text(file.path),

                        trailing: selectionMode
                            ? Icon(
                                selected
                                    ? Icons.check_circle
                                    : Icons
                                        .radio_button_unchecked,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.chevron_right,
                              ),

                                                                      onTap: () {
                          if (selectionMode) {
                            toggleSelection(file);
                          } else {
                            _handleFileTap(file);
                          }
                        },

                        onLongPress: () {
                          showLongPressMenu(
                            context,
                            file,
                            _fileService,
                            loadFiles,
                            () => _handleFileTap(file),
                            () => renameDialog(file),
                            () => copyDialog(file),
                            () => cutDialog(file),
                          );
                        },
                      ), // Closes ListTile safely
                    ); // Closes Card or row wrapper layout
                  }, // Closes itemBuilder
                ), // Closes ListView.builder
              ), // Closes Expanded/flexible layout
            ], // Closes children: [
          ), // Closes the Column layout wrapper
    ); // Closes Scaffold
  } // Closes Widget build (THIS WAS MISSING A CLOSING BRACE)
} // Closes class _FilesScreenState cleanly


