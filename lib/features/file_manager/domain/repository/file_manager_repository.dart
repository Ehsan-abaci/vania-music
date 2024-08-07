import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vania_music/core/resources/data_state.dart';

abstract class FileManagerRepository {
   static const platform = MethodChannel('com.example.vania_music');
  Uint8List? fileContent;
  String? filePath;

  Future<void> saveFile(String url);

  Future<void> setFilePath(String url);

  Future<DataState<String?>> downloadFile({
    required String url,
    required String path,
    required ValueNotifier downloadProgressNotifier,
  });
  bool existedInLocal(String url);
  Future<String?> existedInLocalStream(String url);

  static Future<Directory> openDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final Directory targetDir = Directory('${dir.path}/audio_cache');
    if (!targetDir.existsSync()) {
      targetDir.createSync();
    }
    return targetDir;
  }

  
    


}
