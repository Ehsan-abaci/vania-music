import 'package:shared_preferences/shared_preferences.dart';
import 'package:vania_music/locator.dart';

class CachedFile {
  static final _sp = di<SharedPreferences>();

  /// Check if the file corresponds the url exists in local
  static bool existedInLocal({required String url}) {
    return _sp.getString(url) != null;
  }

  static String? filePathInLocal({required String url}) {
    return _sp.getString(url);
  }
}
