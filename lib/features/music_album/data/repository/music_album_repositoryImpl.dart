import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/core/resources/error_handler.dart';
import 'package:vania_music/core/resources/network_info.dart';
import 'package:vania_music/features/music_album/data/data_source/local/music_album_cache.dart';
import 'package:vania_music/features/music_album/data/data_source/remote/music_album_api_provider.dart';
import 'package:vania_music/features/music_album/data/model/music_album_model.dart';
import 'package:vania_music/features/music_album/domain/entities/music_album_entity.dart';
import 'package:vania_music/features/music_album/domain/repository/music_album_repository.dart';

class MusicAlbumRepositoryImpl extends MusicAlbumRepository {
  MusicAlbumApiProvider apiProvider;
  NetworkInfo networkInfo;
  MusicAlbumCache musicAlbumCache;
  MusicAlbumRepositoryImpl(
    this.apiProvider,
    this.networkInfo,
    this.musicAlbumCache,
  );
  @override
  Future<DataState<List<MusicAlbumEntity>>> fetchMusicAlbums() async {
    try {
      if (musicAlbumCache.isChachedMusicAlbums) {
        final res = musicAlbumCache.getMusicAlbumsFromCache();
        return DataSuccess(res);
      }
      if (await networkInfo.isConnected) {
        Response response = await apiProvider.fetchMusicAlbums();
        if (response.statusCode == ResponseCode.SUCCESS) {
          final data = response.body;
          final jsonObject = jsonDecode(data) as Map<String, dynamic>;
          final list = jsonObject['list'] as List<dynamic>;
          await musicAlbumCache.cacheMusicAlbum(list);
          final res = List.generate(
            list.length,
            (i) => MusicAlbumModel.fromJson(list[i]),
          );
          log(res.toString());
          return DataSuccess(res);
        }
        return const DataFailed(ResponseMessage.UNKNOWN);
      } else {
        return const DataFailed(ResponseMessage.NO_INTERNET_CONNECTION);
      }
    } catch (e) {
      return DataFailed(e.toString());
    }
  }
}
