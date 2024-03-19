import 'dart:convert';
import 'dart:io';

import 'package:nicmusic/app/repository.dart/api_repository.dart';
import 'package:vania/vania.dart';

class HomeController extends Controller {
  final cache = Cache();
  
  Future<Response> index() async {
    try {
      final listCache = await cache.get('list');
      print("listCache content: $listCache");
      if (listCache != null) {
        print("fetch from cache");
        return Response.json(
          {'message': 'ok', 'list': json.decode(listCache)},
        );
      }
      final list = await ApiRepository.fetch();
      print("list content: $list");
      if (list == null) {
        return Response.json({'message': 'Not found'}, HttpStatus.notFound);
      }
      await cache.put('list', json.encode(list), duration: Duration(days: 1));
      return Response.json(
        {'message': 'ok', 'list': list},
      );
    } catch (e) {
      print(e.toString());
      return Response.json({'message': '$e'}, HttpStatus.badRequest);
    }
  }
}

final HomeController homeController = HomeController();
