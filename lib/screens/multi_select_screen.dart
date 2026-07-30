import 'dart:io';

import 'package:flutter/material.dart';

import '../services/file_service.dart';

class MultiSelectScreen extends StatefulWidget {
  final String path;

  const MultiSelectScreen({
    super.key,
    required this.path,
  });

  @override
  State<MultiSelectScreen> createState() =>
      _MultiSelectScreenState();
}

class _MultiSelectScreenState
    extends State<MultiSelectScreen> {
  final FileService _fileService = FileService();

  List<FileSystemEntity> files = [];
  List<FileSystemEntity> selectedFiles = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  Future<void> loadFiles() async {
    files = await _fileService.getFiles(
      widget.path,
    );

    setState(() {
      loading = false;
    });
  }

  bool isSelected(FileSystemEntity file) {
    return selectedFiles.contains(file);
  }

  void toggleSelection(
    FileSystemEntity file,
  ) {
    setState(() {
      if (selectedFiles.contains(file)) {
        selectedFiles.remove(file);
      } else {
        selectedFiles.add(file);
      }
    });
  }

  void selectAll() {
    setState(() {
      selectedFiles = List.from(files);
    });
  }

  void clearSelection() {
    setState(() {
      selectedFiles.clear();
    });
  }
 Future<void> deleteSelected() async {
    for (final file in selectedFiles) {
      await _fileService.delete(file);
    }

    selectedFiles.clear();

    await loadFiles();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Selected files deleted"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),

      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(
          "${selectedFiles.length} Selected",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.select_all),
            onPressed: selectAll,
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: clearSelection,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: selectedFiles.isEmpty
                ? null
                : deleteSelected,
          ),
        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];

                return CheckboxListTile(
                  value: isSelected(file),
                  onChanged: (_) {
                    toggleSelection(file);
                  },
                  title: Text(
                    file.path.split("/").last,
                  ),
                  subtitle: Text(file.path),
                  secondary: Icon(
                    file is Directory
                        ? Icons.folder
                        : Icons.insert_drive_file,
                    color: Colors.green,
                  ),
                );
              },
            ),
    );
  }
}
