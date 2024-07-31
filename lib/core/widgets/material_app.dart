import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:vania_music/config/theme/bloc/theme_bloc.dart';
import 'package:vania_music/core/utils/custom_transition.dart';
import 'package:vania_music/core/utils/resources/color_manager.dart';
import 'package:vania_music/core/utils/resources/route.dart';
import 'package:vania_music/features/favorite/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:vania_music/features/music/presentation/bloc/cubit/appbar_expanded_cubit.dart';
import 'package:vania_music/features/music/presentation/screens/music_screen.dart';
import 'package:vania_music/features/music_album/presentation/bloc/music_album/music_album_bloc.dart';
import 'package:vania_music/features/music_album/presentation/screens/albums_screen.dart';
import 'package:vania_music/features/player/domain/repository/player_repository.dart';
import 'package:vania_music/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:vania_music/features/player/presentation/widget/music_bottom_sheet.dart';
import 'package:vania_music/locator.dart';

class MaterialAppRoot extends StatelessWidget {
  const MaterialAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        ThemeData? currentTheme;
        if (state is ThemeComplete) currentTheme = state.theme;
        if (state is ThemeInitial) currentTheme = state.theme;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => HomeScreen(),
          },
          initialRoute: '/',
          theme: currentTheme?.copyWith(
              pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CustomTransition(),
            },
          )),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  late final StreamSubscription _stream;
  final playerRepository = di<PlayerRepository>();

  @override
  void initState() {
    super.initState();
    context.read<MusicAlbumBloc>().add(FetchMusicAlbumEvent());
    context.read<FavoriteBloc>().add(FetchFavoriteMusics());
    _stream = playerRepository.audioPlayer.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed && event.playing) {
        log('next music in album screen');
        context.read<PlayerBloc>().add(PlayerNext());
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await playerRepository.dispose();
    await _stream.cancel();
  }

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.album:
        return MaterialPageRoute(
          builder: (_) => AlbumsScreen(
            navigatorKey: _navigatorKey,
          ),
        );
      case Routes.music:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AppbarExpandedCubit(),
            child: MusicScreen(
              api: settings.arguments as String,
              navigatorKey: _navigatorKey,
            ),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => AlbumsScreen(
            navigatorKey: _navigatorKey,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (bottomSheetSizeController?.isCompleted ?? false) {
          bottomSheetSizeController?.reverse();
          return;
        } else {
          if (_navigatorKey.currentState?.canPop() ?? false) {
            _navigatorKey.currentState!.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.bg,
        bottomSheet: StreamBuilder<MediaItem?>(
            stream: di<PlayerRepository>().mediaItem,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const MusicBottomSheet();
              } else {
                return const SizedBox();
              }
            }),
        body: Navigator(
          key: _navigatorKey,
          initialRoute: Routes.album,
          onGenerateRoute: onGenerateRoute,
        ),
      ),
    );
  }
}
