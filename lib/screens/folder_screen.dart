import 'dart:io';

import 'package:flutter/material.dart';
import '../services/file_service.dart';

class FolderScreen extends StatefulWidget {
  final String path;

  const FolderScreen({
    super.key,
    required this.path,
  });

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  final FileService _fileService = FileService();

  List<FileSystemEntity> files = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFolder();
  }

  Future<void> loadFolder() async {
  files = await _fileService.getFiles(widget.path);

  if (!mounted) return;

  setState(() {
    loading = false;
  });
}

  IconData getIcon(FileSystemEntity entity) {
    if (entity is Directory) {
      return Icons.folder;
    }

    return Icons.insert_drive_file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.path.split("/").last),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];

                return ListTile(
                  leading: Icon(
                    getIcon(file),
                    color: Colors.green,
                  ),
                  title: Text(
                    file.path.split("/").last,
                  ),
                  subtitle: Text(file.path),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
  if (file is Directory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FolderScreen(
          path: file.path,
        ),
      ),
    );
  }
},
                );
              },
            ),
    );
  }
}
