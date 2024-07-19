import 'dart:io';

import 'package:vania_music/core/utils/formatter.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_storage_manager_repository.dart';

class FileStorageManagerRepositoryImpl extends FileStorageManagerRepository {
  @override
  Future<String> getUniqueFilePath(String url) async {
   
    String res = "/storage/emulated/0/Music/Vania Music";

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

 
}
