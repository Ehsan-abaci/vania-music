import 'dart:io';

import 'package:vania_music/core/utils/formatter.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_storage_manager_repository.dart';

class FileStorageManagerRepositoryImpl extends FileStorageManagerRepository {
  static Directory vaniaMusicDirectory =
      Directory("/storage/emulated/0/music/Vania Music");

  @override
  Future<String> getUniqueFilePath(String url) async {
    String res = await createDirectory();

    var urlSuffix = convertString(getUrlSuffix(url));
    String filePath = '$res/$urlSuffix';
    int suffix = 1;
    while (await File(filePath).exists()) {
      List<String> lis = convertString(getUrlSuffix(url)).split('.');
      filePath = '$res/${lis[0]}($suffix).${lis[1]}';
      suffix++;
    }
    return filePath.trim();
  }

  static Future<String> createDirectory() async {
    if (await vaniaMusicDirectory.exists()) {
      return vaniaMusicDirectory.path;
    } else {
      Directory appDirectory =
          await vaniaMusicDirectory.create(recursive: true);
      return appDirectory.path;
    }
  }
}
