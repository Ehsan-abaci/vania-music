import 'dart:developer';

import 'package:vania_music/core/resources/data_state.dart';
import 'package:vania_music/features/favorite/data/data_source/local/favorite_music_cache.dart';
import 'package:vania_music/features/favorite/domain/repository/favorite_music_repository.dart';
import 'package:vania_music/features/music/data/model/music_model.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';

class FavoriteMusicRepositoryImpl extends FavoriteMusicRepository {
  FavoriteMusicCache favoriteMusicCache;
  FavoriteMusicRepositoryImpl(
    this.favoriteMusicCache,
  );

  @override
  Future<DataState<List<MusicEntity>>> fetchFavoriteMusics() async {
    try {
      final dataList = favoriteMusicCache.fetchFavoriteMusic();
      final List<MusicEntity> musics =
          dataList.map((e) => MusicModel.fromJson(e)).toList();
      return DataSuccess(musics);
    } catch (e) {
      return DataFailed('Fetch favorite musics : $e');
    }
  }

  @override
  Future<DataState<bool>> addFavoriteMusic(MusicEntity music) async {
    final res = await favoriteMusicCache.addFavoriteMusic(music);
    log(res.toString());
    return res == true
        ? DataSuccess(res)
        : const DataFailed('Adding to favorite failed');
  }

  @override
  Future<DataState<bool>> removeFavoriteMusic(MusicEntity music) async {
    final res = await favoriteMusicCache.removeFavoriteMusic(music);
    return res == true
        ? DataSuccess(res)
        : const DataFailed('Removing from favorite failed');
  }
}
