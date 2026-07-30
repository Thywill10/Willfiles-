import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.folder),
            title: Text("Manage Files"),
            subtitle: Text(
              "Browse, move, rename and organize your files.",
            ),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.lock),
            title: Text("Secure Vault"),
            subtitle: Text(
              "Protect your private files inside the vault.",
            ),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.star),
            title: Text("Favorites"),
            subtitle: Text(
              "Save frequently used files for quick access.",
            ),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.search),
            title: Text("Search"),
            subtitle: Text(
              "Find files instantly by name.",
            ),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.info),
            title: Text("Support"),
            subtitle: Text(
              "Email: support@willfiles.com",
            ),
          ),
        ],
      ),
    );
  }
}