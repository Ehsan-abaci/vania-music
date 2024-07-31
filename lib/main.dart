import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vania_music/core/widgets/main_wrapper.dart';
import 'package:vania_music/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await initAppModule();

  runApp(const MainWrapper());
}
