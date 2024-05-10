import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vania_music/features/music/data/model/music_model.dart';
import 'package:vania_music/features/music/domain/entities/music_entity.dart';
import 'package:vania_music/locator.dart';

class MusicCache {
  static final _sp = di<SharedPreferences>();

  Future<bool> isChachedMusics(String key) async {
    if (!_sp.containsKey(key)) return false;
    final encodedData = _sp.getString(key);
    final map = jsonDecode(encodedData ?? '{}');
    int expiration = int.parse(map?['expiration'].toString() ?? "0");
    if (!DateTime.now()
        .isBefore(DateTime.fromMillisecondsSinceEpoch(expiration))) {
      // await _sp.remove(key);
      return false;
    }
    return true;
  }

  Future<void> cacheMusics(String key, List<dynamic> musics) async {
    Duration duration = const Duration(days: 1);
    final value = jsonEncode(musics);
    int expiration =
        DateTime.now().millisecondsSinceEpoch + (duration.inMilliseconds);
    Map<String, dynamic> data = {'data': value, 'expiration': expiration};
  
    await _sp.setString(key, jsonEncode(data));
  }

  List<MusicEntity> fetchMusicFromCache(String key) {
    final encodedData = _sp.getString(key);
    final map = jsonDecode(encodedData ?? '{}');
    final List<dynamic> dataList = jsonDecode(map['data'] ?? "[]");
    final List<MusicEntity> musics = dataList
        .map(
          (e) => MusicModel.fromJson(e),
        )
        .toList();
    return musics;
  }
}
