import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class FileManagerRepository {
  File? file;

  Future<void> saveFile(String url);
  Future<String?> downloadFile({required String url, required String path});
  Future<bool> existedInLocal(String url);

  static Future<Directory> openDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final Directory targetDir = Directory('${dir.path}/audio_cache');
    if (!targetDir.existsSync()) {
      targetDir.createSync();
    }
    return targetDir;
  }
}
