import 'package:flutter/material.dart';

class FilePreviewScreen extends StatelessWidget {
  final String fileName;

  const FilePreviewScreen({
    super.key,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.insert_drive_file,
              size: 120,
              color: Colors.green,
            ),

            SizedBox(height: 20),

            Text(
              "Preview Coming Soon",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Image, PDF, Audio and Video preview\nwill be available here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}