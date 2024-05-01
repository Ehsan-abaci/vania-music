import 'package:shared_preferences/shared_preferences.dart';
import 'package:vania_music/locator.dart';

class CachedFile {
  static final _sp = di<SharedPreferences>();

  /// Check if the file corresponds the url exists in local
  static Future<bool> existedInLocal({required String url}) async {
    return _sp.getString(url) != null;
  }
}
