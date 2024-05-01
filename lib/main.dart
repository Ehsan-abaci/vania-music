import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vania_music/config/theme/bloc/theme_bloc.dart';
import 'package:vania_music/core/widgets/main_wrapper.dart';
import 'package:vania_music/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();

  runApp(const MainWrapper());
}
