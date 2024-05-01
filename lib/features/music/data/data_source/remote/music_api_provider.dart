import 'package:http/http.dart' as http;

class MusicApiProvider {
  Future<dynamic> fetchMusics(String api) async {
    final response = await http.get(
      Uri.parse(api),
    );
    return response;
  }

  
}
