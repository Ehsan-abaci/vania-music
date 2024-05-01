import 'package:permission_handler/permission_handler.dart';

abstract class FileStorageManagerRepository {
  static Future<bool> isStoragePermissionGranted() async {
    return await Permission.manageExternalStorage.isGranted;
  }
  static Future<void> requestStoragePermission() async {
    await Permission.manageExternalStorage.request();
  }

  Future<String> getUniqueFilePath(String url);
}
