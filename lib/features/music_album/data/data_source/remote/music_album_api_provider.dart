import 'package:http/http.dart' as http;

class MusicAlbumApiProvider {
  Future<dynamic> fetchMusicAlbums() async {
    final response = await http.get(
      Uri.parse(
        'https://vania-music.liara.run/api/music_websites',
      ),
    );
    return response;
  }
}
