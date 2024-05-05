import 'dart:io';
import 'package:flutter/material.dart';
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
  Future<void> saveFile(String url) async {
    if (await FileStorageManagerRepository.isStoragePermissionGranted()) {
      String filePath = await fileStorageManager.getUniqueFilePath(url);
      file = File(filePath);
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
  bool existedInLocal(String url)  {
    return CachedFile.existedInLocal(url: url);
  }
}
