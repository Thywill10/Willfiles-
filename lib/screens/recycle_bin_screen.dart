import 'package:flutter/material.dart';
import '../services/file_service.dart';

class RecycleBinScreen extends StatefulWidget {
  const RecycleBinScreen({super.key});

  @override
  State<RecycleBinScreen> createState() =>
      _RecycleBinScreenState();
}

class _RecycleBinScreenState
    extends State<RecycleBinScreen> {
  final FileService _fileService = FileService();

  List<String> recycleBin = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadRecycleBin();
  }

  Future<void> loadRecycleBin() async {
    final items = await _fileService.getRecycleBin();

    if (!mounted) return;

    setState(() {
      recycleBin = items;
      loading = false;
    });
  }

  Future<void> restoreFile(String path) async {
    final success =
        await _fileService.restoreFromTrash(path);

    if (!mounted) return;

    if (success) {
      await loadRecycleBin();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${path.split('/').last} restored successfully.",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Could not restore the file.",
          ),
        ),
      );
    }
  }

  Future<void> deleteForever(String path) async {
    final success =
        await _fileService.purgePermanently(path);

    if (!mounted) return;

    if (success) {
      await loadRecycleBin();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${path.split('/').last} permanently deleted.",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Could not delete the file.",
          ),
        ),
      );
    }
  }

  Future<void> emptyRecycleBin() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Empty Recycle Bin?"),
        content: const Text(
          "All files in the Recycle Bin will be permanently deleted. This cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Delete Forever"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Permanently delete every actual file first.
    final items = List<String>.from(recycleBin);

    for (final path in items) {
      await _fileService.purgePermanently(path);
    }

    await loadRecycleBin();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Recycle Bin emptied."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),

      appBar: AppBar(
        title: const Text("Recycle Bin"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

        actions: [
          if (recycleBin.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_forever,
              ),
              tooltip: "Empty Recycle Bin",
              onPressed: emptyRecycleBin,
            ),
        ],
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : recycleBin.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete_outline,
                        size: 100,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Recycle Bin is Empty",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Deleted files will appear here.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: recycleBin.length,
                  itemBuilder: (context, index) {
                    final path = recycleBin[index];

                    final fileName =
                        path.split('/').last;

                    return Card(
                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      child: ListTile(
                        leading: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),

                        title: Text(fileName),

                        subtitle: Text(path),

                        trailing:
                            PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "restore") {
                              restoreFile(path);
                            }

                            if (value == "delete") {
                              deleteForever(path);
                            }
                          },

                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: "restore",
                              child: Text("Restore"),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Text(
                                "Delete Forever",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}