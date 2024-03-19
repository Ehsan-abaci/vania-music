import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../config/utils.dart';
import '../helper/scraper_helper.dart';

const String _baseUrl =
    'https://pmcmusic.tv/playlist-category/music-player/';

class ApiRepository {
  ApiRepository._();

  static Future<List<Map<String, dynamic>>?> fetch() async {
    print('Calling fetch');
    try {
      var response = await http.get(Uri.parse(_baseUrl), headers: headers);
      if (response.statusCode == 200) {
        return ScraperHelper.parseData(response.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
