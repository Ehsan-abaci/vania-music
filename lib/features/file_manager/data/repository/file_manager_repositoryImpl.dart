import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/features/file_manager/data/data_source/local/cached_file.dart';
import 'package:vania_music/features/file_manager/data/data_source/remote/io_client.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_manager_repository.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_storage_manager_repository.dart';

class FileManagerRepositoryImpl extends FileManagerRepository {
  FileStorageManagerRepository fileStorageManager;
  FileManagerRepositoryImpl(this.fileStorageManager);

  @override
  Future<void> setFilePath(String url) async {
    if (await FileStorageManagerRepository.isStoragePermissionGranted()) {
      filePath = await fileStorageManager.getUniqueFilePath(url);
    } else {
      await FileStorageManagerRepository.requestStoragePermission();
    }
  }

  @override
  Future<DataState<String?>> downloadFile({
    required String url,
    required String path,
    required ValueNotifier downloadProgressNotifier,
  }) async {
    return await IoClient.download(
      url: url,
      path: path,
      downloadProgressNotifier: downloadProgressNotifier,
    );
  }

  @override
  bool existedInLocal(String url) {
    return CachedFile.existedInLocal(url: url);
  }

  @override
  Future<String?> existedInLocalStream(String url) async {
    while (true) {
      if (existedInLocal(url)) return CachedFile.filePathInLocal(url: url);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  Future<void> saveFile(String url) async {
    String? path = CachedFile.filePathInLocal(url: url);
    if (path == null) return Future.value();
    File file = File(path);
    fileContent = await file.readAsBytes();

    try {
      await FileManagerRepository.platform.invokeMethod(
        "saveFileToPath",
        {
          "filePath": filePath, //* this is the path of the file
          "fileContent":
              fileContent, //* this is the content of the file in Uint8List format
        },
      );
    } on PlatformException catch (e) {
      log("${e.message}");
    }
  }
}
