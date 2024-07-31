import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vania_music/config/theme/bloc/theme_bloc.dart';
import 'package:vania_music/core/widgets/material_app.dart';
import 'package:vania_music/features/favorite/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:vania_music/features/music/presentation/bloc/music/music_bloc.dart';
import 'package:vania_music/features/music_album/presentation/bloc/music_album/music_album_bloc.dart';
import 'package:vania_music/features/player/presentation/bloc/player/player_bloc.dart';
import 'package:vania_music/features/player/presentation/bloc/visualiser/visualiser_cubit.dart';
import 'package:vania_music/locator.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        BlocProvider(create: (context) => di<MusicAlbumBloc>()),
        BlocProvider(create: (context) => di<PlayerBloc>()),
        BlocProvider(create: (context) => di<MusicBloc>()),
        BlocProvider(create: (context) => di<FavoriteBloc>()),
        BlocProvider(create: (context) => di<FavoriteBloc>()),
        BlocProvider(create: (context) => di<ThemeBloc>()),
        BlocProvider(create: (context) => di<VisualiserCubit>()),
      ],
      child: const MaterialAppRoot(),
    );
  }
}
