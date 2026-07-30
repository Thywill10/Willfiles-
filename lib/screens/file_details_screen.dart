import 'package:flutter/material.dart';
import '../services/file_service.dart';
import 'rename_file_screen.dart';

class FileDetailsScreen extends StatelessWidget {
  final String fileName;
  final String filePath;
  final String fileSize;

  FileDetailsScreen({
    super.key,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
  });

  final FileService _fileService = FileService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      appBar: AppBar(
        title: const Text("File Details"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.green.withOpacity(0.15),
                child: const Icon(
                  Icons.insert_drive_file,
                  size: 60,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "File Name",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      fileName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(height: 30),

                    const Text(
                      "Location",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(filePath),

                    const Divider(height: 30),

                    const Text(
                      "Size",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(fileSize),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Share
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await _fileService.shareFile(filePath);
                },
                icon: const Icon(Icons.share),
                label: const Text("Share File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Copy
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final destination = "${filePath}_copy";

                  bool copied = await _fileService.copyFile(
                    filePath,
                    destination,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          copied
                              ? "File copied successfully"
                              : "Copy failed",
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.copy),
                label: const Text("Copy File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Cut
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final destination = "${filePath}_cut";

                  bool moved = await _fileService.cutFile(
                    filePath,
                    destination,
                  );

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          moved
                              ? "File moved successfully"
                              : "Move failed",
                        ),
                      ),
                    );

                    if (moved) {
                      Navigator.pop(context);
                    }
                  }
                },
                icon: const Icon(Icons.content_cut),
                label: const Text("Cut File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Move
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final controller = TextEditingController();

                  final destination = await showDialog<String>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Move File"),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Destination folder path",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              controller.text.trim(),
                            );
                          },
                          child: const Text("Move"),
                        ),
                      ],
                    ),
                  );

                  if (destination != null &&
                      destination.isNotEmpty) {
                    final newPath =
                        "$destination/${filePath.split('/').last}";

                    bool moved = await _fileService.cutFile(
                      filePath,
                      newPath,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            moved
                                ? "File moved successfully"
                                : "Move failed",
                          ),
                        ),
                      );

                      if (moved) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                icon: const Icon(Icons.drive_file_move),
                label: const Text("Move File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Paste
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final controller = TextEditingController();

                  final destination = await showDialog<String>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Paste File"),
                      content: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Destination folder path",
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              controller.text.trim(),
                            );
                          },
                          child: const Text("Paste"),
                        ),
                      ],
                    ),
                  );

                  if (destination != null &&
                      destination.isNotEmpty) {
                    bool pasted = await _fileService.pasteFile(
                      filePath,
                      destination,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            pasted
                                ? "File pasted successfully"
                                : "Paste failed",
                          ),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.content_paste),
                label: const Text("Paste File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Rename
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final newName = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RenameFileScreen(
                        oldName: fileName,
                      ),
                    ),
                  );

                  if (newName != null && newName.isNotEmpty) {
                    bool renamed = await _fileService.renameFile(
                      filePath,
                      newName,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            renamed
                                ? "File renamed successfully"
                                : "Rename failed",
                          ),
                        ),
                      );

                      if (renamed) {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                icon: const Icon(Icons.edit),
                label: const Text("Rename File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Delete
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  bool deleted =
                      await _fileService.deleteFile(filePath);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          deleted
                              ? "File deleted successfully"
                              : "Unable to delete file",
                        ),
                      ),
                    );

                    if (deleted) {
                      Navigator.pop(context);
                    }
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text("Delete File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}