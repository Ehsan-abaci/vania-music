
import 'dart:convert';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/resources/error_handler.dart';
import 'package:vania_music/core/resources/network_info.dart';
import 'package:vania_music/features/music/data/data_source/local/music_cache.dart';
import 'package:vania_music/features/music/data/data_source/remote/music_api_provider.dart';
import 'package:vania_music/features/music/data/model/music_model.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';
import 'package:vania_music/features/music/domain/repository/music_repository.dart';

class MusicRepositoryImpl extends MusicRepository {
  NetworkInfo networkInfo;
  MusicCache musicCache;
  MusicApiProvider apiProvider;
  MusicRepositoryImpl(
    this.networkInfo,
    this.musicCache,
    this.apiProvider,
  );
  @override
  Future<DataState<List<MusicEntity>>> fetchMusics(String api) async {
    final bool isConnected = await networkInfo.isConnected;
    if (await musicCache.isChachedMusics(api) || !isConnected) {
      final res = musicCache.fetchMusicFromCache(api);
      return DataSuccess(res);
    }
    if (isConnected) {
      final response = await apiProvider.fetchMusics(api);
      if (response.statusCode == ResponseCode.SUCCESS) {
        final data = response.body;
        final jsonObject = jsonDecode(data) as Map<String, dynamic>;
        final list = jsonObject['list'] as List<dynamic>;
        await musicCache.cacheMusics(api, list);
        final res = List.generate(
          list.length,
          (i) => MusicModel.fromJson(list[i]),
        );
        return DataSuccess(res);
      }
      return const DataFailed(ResponseMessage.UNKNOWN);
    } else {
      return const DataFailed(ResponseMessage.NO_INTERNET_CONNECTION);
    }
  }
}
