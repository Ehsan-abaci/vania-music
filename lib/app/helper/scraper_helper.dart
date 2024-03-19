import 'package:beautiful_soup_dart/beautiful_soup.dart';

class ScraperHelper {
  ScraperHelper._();

  static List<Map<String, dynamic>> parseData(String html) {
    final List<Map<String, dynamic>> list = [];
    try {
      final soup = BeautifulSoup(html);

      // var musics = soup
      //     .find('div', class_: 'play-list-box')!
      //     .findAll('div', class_: 'js-pl-item');
      // for (var music in musics) {
      //   if (!music.find('h3', class_: 'title')!.text.contains('-')) continue;
      //   final title = music.find('h3', class_: 'title')?.text.split(' - ');
      //   final singer = title?[0];
      //   final name = title?[1];
      //   final musicLink128 =
      //       music.find('a', class_: 'dl-128')?.getAttrValue('href');
      //   final musicLink320 =
      //       music.find('a', class_: 'dl-320')?.getAttrValue('href');
      //   if (title == null) continue;
      //   final map = {
      //     'singer': singer,
      //     'name': name,
      //     'link_128': musicLink128,
      //     'link_320': musicLink320,
      //   };

      //   list.add(map);
      // }
      final musics = soup
          .find('ul', class_: 'srp_list')!
          .findAll('li', class_: 'sr-playlist-item');
      for (var music in musics) {
        final img = music.find('img')?.getAttrValue('src');
        final singer = music.getAttrValue('data-tracktitle')?.split('<').first;
        final name = music.getAttrValue('data-artist');
        final musicLink = music.find('a')?.getAttrValue('href');
        final trackTime = music.getAttrValue('data-tracktime');
        final map = {
          'singer': singer,
          'name': name,
          'music': musicLink,
          'img': img,
          'time': trackTime,
        };
        list.add(map);
      }
      return list;
    } catch (e) {
      print('ScraperHelper : $e');
    }
    return [];
  }
}
