import 'package:flutter/material.dart';

class FileTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String fileName;
  final String fileInfo;
  final VoidCallback? onTap;

  const FileTile({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.fileName,
    required this.fileInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.15),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),

        title: Text(
          fileName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(fileInfo),

        trailing: PopupMenuButton<String>(
          onSelected: (value) {},
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: "open",
              child: Text("Open"),
            ),
            PopupMenuItem(
              value: "rename",
              child: Text("Rename"),
            ),
            PopupMenuItem(
              value: "delete",
              child: Text("Delete"),
            ),
            PopupMenuItem(
              value: "favorite",
              child: Text("Favorite"),
            ),
          ],
        ),
      ),
    );
  }
}