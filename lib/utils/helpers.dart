import 'dart:io';

class Helpers {
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return "$bytes B";
    }

    if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(1)} KB";
    }

    if (bytes < 1024 * 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    }

    return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
  }

  static String getFileName(String path) {
    return path.split('/').last;
  }

  static bool isImage(String path) {
    return path.endsWith(".jpg") ||
        path.endsWith(".jpeg") ||
        path.endsWith(".png") ||
        path.endsWith(".gif") ||
        path.endsWith(".webp");
  }

  static bool isVideo(String path) {
    return path.endsWith(".mp4") ||
        path.endsWith(".mkv") ||
        path.endsWith(".avi") ||
        path.endsWith(".mov");
  }

  static bool isAudio(String path) {
    return path.endsWith(".mp3") ||
        path.endsWith(".wav") ||
        path.endsWith(".aac");
  }

  static bool isDocument(String path) {
    return path.endsWith(".pdf") ||
        path.endsWith(".doc") ||
        path.endsWith(".docx") ||
        path.endsWith(".txt");
  }

  static bool exists(String path) {
    return File(path).existsSync();
  }
}