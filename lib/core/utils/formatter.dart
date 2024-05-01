
String getUrlSuffix(String url) {
  StringBuffer _buffer = StringBuffer();
  final urlFormat = Uri.parse(url);
  List<String> paths = urlFormat.path.split('/');
  if (paths.isNotEmpty) {
    for (final p in paths) {
      _buffer.write(p);
    }
    return _buffer.toString();
  }
  return urlFormat.host;
}

String convertString(String input) {
  String decoded = Uri.decodeComponent(input);
  String cleaned =
      decoded.replaceFirst(RegExp(r'^\d+'), '').replaceAll(' - ', ' ');
  return cleaned.trim();
}