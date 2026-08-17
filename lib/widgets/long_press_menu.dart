import 'dart:io';

import 'package:flutter/material.dart';

import '../services/file_service.dart';

class LongPressMenu extends StatelessWidget {
  final VoidCallback? onOpen;
  final VoidCallback? onRename;
  final VoidCallback? onCopy;
  final VoidCallback? onCut;
  final VoidCallback? onMove;
  final VoidCallback? onShare;
  final VoidCallback? onFavorite;
  final VoidCallback? onDetails;
  final VoidCallback? onDelete;

  const LongPressMenu({
    super.key,
    this.onOpen,
    this.onRename,
    this.onCopy,
    this.onCut,
    this.onMove,
    this.onShare,
    this.onFavorite,
    this.onDetails,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_open),
              title: const Text("Open"),
              onTap: () {
                Navigator.pop(context);
                onOpen?.call();
              },
            ),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Rename"),
              onTap: () {
                Navigator.pop(context);
                onRename?.call();
              },
            ),

            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text("Copy"),
              onTap: () {
                Navigator.pop(context);
                onCopy?.call();
              },
            ),

            ListTile(
              leading: const Icon(Icons.content_cut),
              title: const Text("Cut"),
              onTap: () {
                Navigator.pop(context);
                onCut?.call();
              },
            ),

            ListTile(
              leading: const Icon(Icons.drive_file_move),
              title: const Text("Move"),
              onTap: () {
                Navigator.pop(context);
                onMove?.call();
              },
            ),

            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share"),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              title: const Text("Add to Favorites"),
              onTap: () {
                Navigator.pop(context);
                onFavorite?.call();
              },
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("Properties"),
              onTap: () {
                Navigator.pop(context);
                onDetails?.call();
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onDelete?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}

void showLongPressMenu(
  BuildContext context,
  FileSystemEntity file,
  FileService fileService,
  VoidCallback refresh,
  VoidCallback onOpenClick,
  VoidCallback onRenameClick,
  VoidCallback onCopyClick,
  VoidCallback onCutClick,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (_) => LongPressMenu(
      onOpen: onOpenClick,
      onRename: onRenameClick,
      onCopy: onCopyClick,
      onCut: onCutClick,

      // Move will be handled by the same clipboard
      // system as Cut for now.
      onMove: onCutClick,

      onShare: () async {
        await fileService.shareFile(file.path);
      },

      onFavorite: () async {
        await fileService.addToFavorites(file.path);

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Added to Favorites"),
          ),
        );
      },

      onDetails: () async {
  try {
    final stat = await file.stat();

    final name = file.path.split('/').last;

    final isFolder = file is Directory;

    String sizeText = "—";
    String itemCountText = "";

    if (file is File) {
      final bytes = stat.size;

      if (bytes < 1024) {
        sizeText = "$bytes B";
      } else if (bytes < 1024 * 1024) {
        sizeText =
            "${(bytes / 1024).toStringAsFixed(2)} KB";
      } else if (bytes < 1024 * 1024 * 1024) {
        sizeText =
            "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
      } else {
        sizeText =
            "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
      }
    }

    if (file is Directory) {
      try {
        final items = file.listSync();
        itemCountText = "Items: ${items.length}";
      } catch (_) {
        itemCountText = "Items: Unable to read";
      }
    }

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          isFolder ? "Folder Properties" : "File Properties",
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(name),

              const SizedBox(height: 12),

              Text(
                "Type",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isFolder
                    ? "Folder"
                    : "File",
              ),

              const SizedBox(height: 12),

              Text(
                "Location",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(file.parent.path),

              const SizedBox(height: 12),

              if (!isFolder) ...[
                Text(
                  "Size",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(sizeText),

                const SizedBox(height: 12),
              ],

              if (isFolder) ...[
                Text(
                  itemCountText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),
              ],

              Text(
                "Modified",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stat.modified.toString(),
              ),

              const SizedBox(height: 12),

              Text(
                "Accessed",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                stat.accessed.toString(),
              ),

              const SizedBox(height: 12),

              Text(
                "Full Path",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(file.path),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  } catch (_) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Could not read file properties.",
        ),
      ),
    );
  }
},

      onDelete: () async {
        await fileService.delete(file);

        if (!context.mounted) return;

        refresh();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${file.path.split('/').last} moved to Recycle Bin.",
            ),
          ),
        );
      },
    ),
  );
}
