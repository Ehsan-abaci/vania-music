
import 'package:vania/vania.dart';
import 'package:nicmusic/app/http/controllers/home_controller.dart';

class ApiRoute implements Route {
  @override
  void register() {
    /// Base RoutePrefix
    Router.basePrefix('api');

    Router.get("/music", homeController.index);
  }
}
