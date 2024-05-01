import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vania_music/features/music_album/data/model/music_album_model.dart';
import 'package:vania_music/features/music_album/domain/entities/music_album_entity.dart';
import 'package:vania_music/locator.dart';

class MusicAlbumCache {
  static const String _key = 'music_album';
  final _sp = di<SharedPreferences>();

  bool get isChachedMusicAlbums => _sp.containsKey(_key);

  List<MusicAlbumEntity> getMusicAlbumsFromCache() {
    final encodedData = _sp.getString(_key);
    final List<dynamic> dataList = jsonDecode(encodedData ?? "[]");
    final List<MusicAlbumEntity> musicAlbum = dataList
        .map(
          (e) => MusicAlbumModel.fromJson(e),
        )
        .toList();
    return musicAlbum;
  }

  Future<void> cacheMusicAlbum(List<dynamic> musicAlbums) async {
    await _sp.setString(_key, jsonEncode(musicAlbums));
  }
}
