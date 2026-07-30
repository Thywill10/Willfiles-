import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About WillFiles"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            Icon(
              Icons.folder_copy,
              size: 100,
              color: Colors.green,
            ),

            SizedBox(height: 20),

            Text(
              "WillFiles",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Version 1.0.0",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 25),

            Text(
              "WillFiles is a modern file manager built to help you organize, protect and manage your files quickly and securely.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}