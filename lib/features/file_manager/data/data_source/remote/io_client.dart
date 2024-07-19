import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vania_music/core/resources/data_state.dart';

class IoClient {
  static Future<DataState<String?>> download({
    required String url,
    required String path,
    required ValueNotifier downloadProgressNotifier,
  }) async {
    try {
      final res = await Dio().downloadUri(Uri.parse(url), path,
          onReceiveProgress: (actualBytes, int totalBytes) {
        downloadProgressNotifier.value =
            (actualBytes / totalBytes * 100).floor();
      });
      if (res.statusCode == 200) {
        return DataSuccess(path);
      } else {
        return DataFailed(res.statusMessage ?? "Failed");
      }
    } on DioException catch (e) {
      return DataFailed('Error occurs while downloading file: $e');
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
