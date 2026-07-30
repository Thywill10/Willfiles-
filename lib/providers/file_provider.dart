import 'package:flutter/material.dart';
import '../services/file_service.dart';

class FileProvider extends ChangeNotifier {
  final FileService _fileService = FileService();

  List files = [];

  List get allFiles => files;

  Future<void> loadFiles(String path) async {
    files = await _fileService.getFiles(path);
    notifyListeners();
  }

  Future<void> delete(String path) async {
    await _fileService.deleteFile(path);
    notifyListeners();
  }

  Future<void> rename(String oldPath, String newPath) async {
    await _fileService.renameFile(oldPath, newPath);
    notifyListeners();
  }
}