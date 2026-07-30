import 'package:flutter/material.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.bluetooth),
            title: Text("Bluetooth"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.wifi),
            title: Text("Wi-Fi Direct"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.email),
            title: Text("Email"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.message),
            title: Text("Messages"),
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.more_horiz),
            title: Text("More Apps"),
          ),
        ],
      ),
    );
  }
}