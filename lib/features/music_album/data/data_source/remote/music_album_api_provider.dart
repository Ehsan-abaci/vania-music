import 'package:http/http.dart' as http;
import 'package:vania_music/core/utils/contestants.dart';

class MusicAlbumApiProvider {
  Future<dynamic> fetchMusicAlbums() async {
    final response = await http.get(
      Uri.parse(musicAlbumApi),
    );
    return response;
  }
}
