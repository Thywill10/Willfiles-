import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileService {
  Future<List<FileSystemEntity>> getFiles(String path) async {
    final directory = Directory(path);

    if (!await directory.exists()) {
      return [];
    }

    final files = directory.listSync();

    files.sort((a, b) {
      return a.path.toLowerCase().compareTo(
            b.path.toLowerCase(),
          );
    });

    return files;
  }

  Future<List<FileSystemEntity>> getInternalStorage() async {
    return getFiles("/storage/emulated/0");
  }

  bool isFolder(FileSystemEntity entity) {
    return entity is Directory;
  }

  bool isFile(FileSystemEntity entity) {
    return entity is File;
  }

  String getName(FileSystemEntity entity) {
    return entity.path.split("/").last;
  }

  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);

      if (!await file.exists()) {
        return false;
      }

      await file.delete();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> renameFile(
    String oldPath,
    String newName,
  ) async {
    try {
      final file = File(oldPath);

      if (!await file.exists()) return false;

      final directory = file.parent.path;
      final newPath = "$directory/$newName";

      await file.rename(newPath);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> shareFile(String path) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path)],
      ),
    );
  }

  Future<bool> copyFile(
    String sourcePath,
    String destinationPath,
  ) async {
    try {
      final source = File(sourcePath);

      if (!await source.exists()) {
        return false;
      }

      await source.copy(destinationPath);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> cutFile(
    String sourcePath,
    String destinationPath,
  ) async {
    try {
      final source = File(sourcePath);

      if (!await source.exists()) {
        return false;
      }

      await source.rename(destinationPath);

      return true;
    } catch (_) {
      return false;
    }
  }

Future<bool> moveFile(
  String sourcePath,
  String destinationFolder,
) async {
  try {
    final source = File(sourcePath);

    if (!await source.exists()) {
      return false;
    }

    final fileName =
        source.path.split("/").last;

    final destination =
        "$destinationFolder/$fileName";

    await source.rename(destination);

    return true;
  } catch (_) {
    return false;
  }
}

  Future<bool> pasteFile(
    String sourcePath,
    String destinationFolder,
  ) async {
    try {
      final source = File(sourcePath);

      if (!await source.exists()) {
        return false;
      }

      final fileName = source.path.split("/").last;

      final destination =
          "$destinationFolder/$fileName";

      await source.copy(destination);

      return true;
    } catch (_) {
      return false;
    }
  }

  // ==========================
  // SEARCH FILES
  // ==========================

  Future<List<FileSystemEntity>> searchFiles(
    String folderPath,
    String keyword,
  ) async {
    final directory = Directory(folderPath);

    if (!await directory.exists()) {
      return [];
    }

    final results = <FileSystemEntity>[];

    await for (final entity in directory.list(
      recursive: true,
      followLinks: false,
    )) {
      final name = entity.path
          .split("/")
          .last
          .toLowerCase();

      if (name.contains(keyword.toLowerCase())) {
        results.add(entity);
      }
    }

    return results;
  }

  Future<void> delete(FileSystemEntity entity) async {
  if (entity is File) {
    await moveToRecycleBin(entity.path);
  } else if (entity is Directory) {
    await entity.delete(recursive: true);
  }
}

  Future<void> createFolder(
    String parent,
    String folderName,
  ) async {
    final dir = Directory("$parent/$folderName");

    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
  }

Future<void> addToFavorites(String path) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> favorites =
      prefs.getStringList("favorites") ?? [];

  if (!favorites.contains(path)) {
    favorites.add(path);
  }

  await prefs.setStringList(
    "favorites",
    favorites,
  );
}

Future<List<String>> getFavorites() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getStringList("favorites") ?? [];
}

Future<void> removeFromFavorites(
  String path,
) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> favorites =
      prefs.getStringList("favorites") ?? [];

  favorites.remove(path);

  await prefs.setStringList(
    "favorites",
    favorites,
  );
}

Future<List<String>> getRecentFiles() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getStringList("recent_files") ?? [];
}

Future<void> addToRecent(String path) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> recent =
      prefs.getStringList("recent_files") ?? [];

  recent.remove(path);

  recent.insert(0, path);

  if (recent.length > 30) {
    recent = recent.take(30).toList();
  }

  await prefs.setStringList(
    "recent_files",
    recent,
  );
}

Future<void> removeRecent(String path) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> recent =
      prefs.getStringList("recent_files") ?? [];

  recent.remove(path);

  await prefs.setStringList(
    "recent_files",
    recent,
  );
}

Future<void> clearRecent() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove("recent_files");
}

Future<void> addToRecycleBin(String path) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> recycle =
      prefs.getStringList("recycle_bin") ?? [];

  if (!recycle.contains(path)) {
    recycle.add(path);
  }

  await prefs.setStringList(
    "recycle_bin",
    recycle,
  );
}

Future<List<String>> getRecycleBin() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getStringList("recycle_bin") ?? [];
}

Future<void> removeFromRecycleBin(
  String path,
) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> recycle =
      prefs.getStringList("recycle_bin") ?? [];

  recycle.remove(path);

  await prefs.setStringList(
    "recycle_bin",
    recycle,
  );
}

Future<void> clearRecycleBin() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove("recycle_bin");
}

Future<void> createRecycleBinFolder() async {
  final recycleFolder =
      Directory("/storage/emulated/0/WillFilesRecycleBin");

  if (!await recycleFolder.exists()) {
    await recycleFolder.create(recursive: true);
  }
}

Future<bool> moveToRecycleBin(String sourcePath) async {
  try {
    await createRecycleBinFolder();

    final source = File(sourcePath);

    if (!await source.exists()) {
      return false;
    }

    final fileName = source.path.split("/").last;

    final destination =
        "/storage/emulated/0/WillFilesRecycleBin/$fileName";

    await source.rename(destination);

    return true;
  } catch (_) {
    return false;
  }
}

}
