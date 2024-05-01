import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vania_music/features/music/data/model/music_model.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';
import 'package:vania_music/locator.dart';

class FavoriteMusicCache {
  static final _sp = di<SharedPreferences>();
  static const _favoriteKey = "favorite_music";

  Future<bool> addFavoriteMusic(MusicEntity music) async {
    try {
      final encodedData = _sp.getString(_favoriteKey);
      List<MusicEntity> musics = [];
      if (encodedData != null) {
        final List<dynamic> dataList = jsonDecode(encodedData);
        musics = dataList
            .map(
              (e) => MusicModel.fromJson(e),
            )
            .toList();
      }
      musics.add(music);
      await _sp.setString(_favoriteKey,jsonEncode(musics) );
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> removeFavoriteMusic(MusicEntity music) async {
    try {
      final encodedData = _sp.getString(_favoriteKey);
      final List<dynamic> dataList = jsonDecode(encodedData ?? "");
      final List<MusicEntity> musics = dataList
          .map(
            (e) => MusicModel.fromJson(e),
          )
          .toList();
      musics.remove(music);
      await _sp.setString(_favoriteKey, jsonEncode(musics));
      return true;
    } catch (e) {
      return false;
    }
  }

  List<dynamic> fetchFavoriteMusic() {
    final encodedData = _sp.getString(_favoriteKey);
    if (encodedData == null) return [];
    final List<dynamic> dataList = jsonDecode(encodedData);
    return dataList;
  }

  Future<void> deleteFavorites() async {
    await _sp.remove(_favoriteKey);
  }
}
