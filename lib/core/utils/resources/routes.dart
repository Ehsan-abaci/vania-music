import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vania_music/features/music/presentation/screens/music_screen.dart';
import 'package:vania_music/features/music_album/presentation/screens/albums_screen.dart';
import 'package:vania_music/features/player/presentation/widget/music_bottom_sheet.dart';
import 'package:vania_music/locator.dart';

import '../../../features/player/domain/repository/player_repository.dart';

class Routes {
  static const String album = '/';
  static const String music = '/music';
  static const String musicControler = '/music_controller';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class RouteGenerator {
  static FutureOr<bool> checkToPop(BuildContext context) {
    if (bottomSheetSizeController != null &&
        bottomSheetSizeController!.status == AnimationStatus.completed) {
      bottomSheetSizeController!.reverse();
      return false;
    } else {
      return true;
    }
  }

  /// The route configuration.
  static final GoRouter router = GoRouter(
    initialLocation: Routes.album,
    navigatorKey: _rootNavigatorKey,
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => Scaffold(
          body: child,
          bottomSheet: StreamBuilder<MediaItem?>(
              stream: di<PlayerRepository>().mediaItem,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return MusicBottomSheet();
                } else {
                  return const SizedBox();
                }
              }),
        ),
        routes: [
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            onExit: checkToPop,
            name: Routes.album,
            path: Routes.album,
            builder: (BuildContext context, GoRouterState state) {
              return const AlbumsScreen();
            },
            routes: [
              GoRoute(
                parentNavigatorKey: _shellNavigatorKey,
                onExit: checkToPop,
                name: Routes.music,
                path: 'music',
                builder: (BuildContext context, GoRouterState state) {
                  return MusicScreen(api: state.extra as String);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
