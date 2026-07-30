import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  Future<bool> requestManageStoragePermission() async {
    PermissionStatus status =
        await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  Future<bool> hasStoragePermission() async {
    return await Permission.storage.isGranted ||
        await Permission.manageExternalStorage.isGranted;
  }
}