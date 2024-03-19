

import 'package:vania/vania.dart';
import 'package:nicmusic/route/api_route.dart';
import 'package:nicmusic/route/web.dart';
import 'package:nicmusic/route/web_socket.dart';


class RouteServiceProvider extends ServiceProvider{
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    ApiRoute().register();
  }

}