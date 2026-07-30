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
      child: Wrap(
        children: [

          ListTile(
            leading: const Icon(
              Icons.folder_open,
            ),
            title: const Text("Open"),
            onTap: () {
              Navigator.pop(context);
              onOpen?.call();
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.edit,
            ),
            title: const Text("Rename"),
            onTap: () {
              Navigator.pop(context);
              onRename?.call();
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.copy,
            ),
            title: const Text("Copy"),
            onTap: () {
              Navigator.pop(context);
              onCopy?.call();
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.content_cut,
            ),
            title: const Text("Cut"),
            onTap: () {
              Navigator.pop(context);
              onCut?.call();
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.drive_file_move,
            ),
            title: const Text("Move"),
            onTap: () {
              Navigator.pop(context);
              onMove?.call();
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.share,
            ),
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
            title: const Text(
              "Add to Favorites",
            ),
            onTap: () {
              Navigator.pop(context);
              onFavorite?.call();
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.info_outline,
            ),
            title: const Text(
              "Properties",
            ),
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
    );
  }
}

void showLongPressMenu(
  BuildContext context,
  FileSystemEntity file,
  FileService fileService,
  VoidCallback refresh,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (_) => LongPressMenu(
      onOpen: () {
        // Will be handled by FilesScreen.
      },

      onRename: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Rename will be added soon.",
            ),
          ),
        );
      },

      onCopy: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Copy will be added soon.",
            ),
          ),
        );
      },

      onCut: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Cut will be added soon.",
            ),
          ),
        );
      },

      onMove: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Move will be added soon.",
            ),
          ),
        );
      },

      onShare: () async {
        await fileService.shareFile(file.path);
      },

      onFavorite: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Added to Favorites.",
            ),
          ),
        );
      },

      onDetails: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Properties"),
            content: Text(file.path),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      },

      onDelete: () async {
        await fileService.delete(file);

        refresh();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "File deleted.",
            ),
          ),
        );
      },
    ),
  );
}
