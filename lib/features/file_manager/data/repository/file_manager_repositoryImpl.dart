import 'dart:io';
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
  Future<String?> downloadFile(
      {required String url, required String path}) async {
    return await IoClient.download(url: url, path: path);
  }

  @override
  Future<bool> existedInLocal(String url) async {
    return await CachedFile.existedInLocal(url: url);
  }
}
