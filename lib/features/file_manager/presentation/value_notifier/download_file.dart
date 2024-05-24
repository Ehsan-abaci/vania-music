import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/utils/formatter.dart';
import 'package:vania_music/features/file_manager/domain/repository/file_manager_repository.dart';
import 'package:vania_music/features/music/presentation/bloc/music/music_bloc.dart';
import 'package:vania_music/locator.dart';

enum DownloadStatus {
  initial,
  downloading,
  downloaded,
  error,
}

class DownloadFile {
  final FileManagerRepository _fileManager;
  final SharedPreferences _sp;
  final MusicBloc musicBloc;
  DownloadFile(this._fileManager, this._sp, this.musicBloc);

  ValueNotifier downloadProgressNotifier = ValueNotifier(0);
  ValueNotifier<DownloadStatus> downloadStatus =
      ValueNotifier(DownloadStatus.initial);

  Future<DataState<String?>> _downloadFile(
      {required String url, required String path}) async {
    downloadProgressNotifier.value = 0;

    return _fileManager.downloadFile(
      url: url,
      path: path,
      downloadProgressNotifier: downloadProgressNotifier,
    );
  }

  void saveMusicInStorage({required String url, required String id}) async {
    log("*****Click Save music*****");
    if (!_fileManager.existedInLocal(url)) {
      log("*****doesn't exist music*****");

      /// set url to download
      final dirPath = (await FileManagerRepository.openDir()).path;
      final key = getUrlSuffix(url);

      downloadStatus.value = DownloadStatus.downloading;
      _downloadFile(url: url, path: '$dirPath/$key').then((dataState) async {
        final storedPath = dataState.data;
        if (dataState is DataSuccess) {
          downloadStatus.value = DownloadStatus.downloaded;
          musicBloc.add(ChangeIsDownloadedEvent(id));
        } else if (dataState is DataFailed) {
          downloadStatus.value = DownloadStatus.error;
          return;
        }

        if (storedPath != null) {
          await _sp.setString(url, storedPath);
        }
      });
    }
    String? path = _sp.getString(url);
    log(path ?? "Empty");
    if (path == null) return;
    downloadStatus.value = DownloadStatus.downloaded;
    File file = File(path);
    await _fileManager.saveFile(url);
    final music = await file.readAsBytes();
    await _fileManager.file!
        .writeAsBytes(music, flush: true)
        .then((value) => log("Saved in ${value.path}"));
    musicBloc.add(ChangeIsDownloadedEvent(id));

    // await file.copy(_fileManager.file!.path);
  }
}
