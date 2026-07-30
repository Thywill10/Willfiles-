import 'package:flutter/material.dart';

class FileOperationsScreen extends StatelessWidget {
  const FileOperationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File Operations"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.copy),
            title: Text("Copy"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.drive_file_move),
            title: Text("Move"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Rename"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.share),
            title: Text("Share"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.delete),
            title: Text("Delete"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Move to Vault"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.star),
            title: Text("Add to Favorites"),
          ),
        ],
      ),
    );
  }
}