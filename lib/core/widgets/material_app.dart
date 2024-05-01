import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vania_music/config/theme/bloc/theme_bloc.dart';
import 'package:vania_music/core/utils/resources/routes.dart';

class MaterialAppRoot extends StatelessWidget {
  const MaterialAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        ThemeData? currentTheme;
        if (state is ThemeComplete) currentTheme = state.theme;
        if (state is ThemeInitial) currentTheme = state.theme;
        log("build theme");
        return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: RouteGenerator.router,
            theme: currentTheme);
      },
    );
  }
}
